package org.jeecg.modules.hnworkerwage.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.api.ISysBaseAPI;
import org.jeecg.common.system.vo.DictModel;
import org.jeecg.modules.hnworkerwage.entity.*;
import org.jeecg.modules.hnworkerwage.mapper.*;
import org.jeecg.modules.hnworkerwage.service.IHnMonthlyRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @Description: 月度加工记录表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Slf4j
@Service
public class HnMonthlyRecordServiceImpl extends ServiceImpl<HnMonthlyRecordMapper, HnMonthlyRecord> implements IHnMonthlyRecordService {

    @Autowired
    private HnWorkerProcessAbilityMapper workerProcessAbilityMapper;
    @Autowired
    private HnMaterialCodeMapper materialCodeMapper;
    @Autowired
    private HnMaterialOverridePriceMapper materialOverridePriceMapper;
    @Autowired
    private HnComplexPriceMapper complexPriceMapper;
    @Autowired
    private HnBasePriceMapper basePriceMapper;
    @Autowired
    private HnMaterialDimensionMapper materialDimensionMapper;
    @Autowired
    private HnWorkerMapper workerMapper;
    @Autowired
    private HnEquipmentMapper equipmentMapper;
    @Autowired
    private HnProcessMapper processMapper;
    @Autowired
    private ISysBaseAPI sysBaseAPI;

    // ---- Excel 列标题常量 ----
    private static final String COL_PRODUCTION_ORDER_NO = "生产订单编号";
    private static final String COL_DOCUMENT_DATE       = "单据日期";
    private static final String COL_PROCESS             = "作业";
    private static final String COL_WORKER              = "操作工姓名";
    private static final String COL_BATCH_NO            = "批号";
    private static final String COL_MATERIAL_CODE       = "旧物料编码";
    private static final String COL_QUANTITY            = "合格数量";
    private static final String COL_SCRAP_QTY           = "工废数量";
    private static final String COL_WHEEL_WASTE_QTY     = "轮废数量";
    private static final String COL_ROD_WASTE_QTY       = "杆废数量";
    private static final String COL_MATERIAL_WASTE_QTY  = "料废数量";
    private static final String COL_DEFECT_QTY          = "次品数量";
    private static final String COL_INSPECTOR           = "检验员";
    private static final String COL_PRODUCT_NAME        = "产品名称";
    private static final String COL_PRODUCT_CODE        = "产品编码";
    private static final String COL_EQUIPMENT_TYPE      = "订单生产车间";
    private static final String COL_EQUIPMENT           = "设备";

    @Override
    @Async
    @Transactional(rollbackFor = Exception.class)
    public void startCalculation(String docMonth) {
        // 查询待计算记录
        LambdaQueryWrapper<HnMonthlyRecord> qw = new LambdaQueryWrapper<>();
        qw.eq(HnMonthlyRecord::getCalcStatus, "pending");
        if (StringUtils.hasText(docMonth)) {
            qw.apply("DATE_FORMAT(document_date, '%Y-%m') = {0}", docMonth);
        }
        List<HnMonthlyRecord> records = this.list(qw);
        if (records.isEmpty()) {
            return;
        }

        int count = 0;
        for (HnMonthlyRecord record : records) {
            try {
                // 直接从月度记录获取产线和设备ID
                String equipmentType = record.getEquipmentType();
                Long equipmentId = record.getEquipmentId();

                // 获取工人技能等级
                String skillLevel = getWorkerSkillLevel(record.getWorkerId(), record.getProcessId());

                // 获取物料对应的产品ID
                Long productId = getProductId(record.getMaterialCodeId());

                // 按优先级匹配单价
                BigDecimal unitPrice = null;
                String priceSource = null;

                // 优先级1：物料覆盖单价
                if (productId != null && equipmentType != null && skillLevel != null) {
                    unitPrice = findOverridePrice(record.getMaterialCodeId(), productId, equipmentType, record.getProcessId(), skillLevel);
                    if (unitPrice != null) {
                        priceSource = "override";
                    }
                }

                // 优先级2：复合定价
                if (unitPrice == null && skillLevel != null) {
                    unitPrice = findComplexPrice(record.getMaterialCodeId(), record.getProcessId(), equipmentId, equipmentType, skillLevel);
                    if (unitPrice != null) {
                        priceSource = "complex";
                    }
                }

                // 优先级3：基础单价
                if (unitPrice == null && productId != null && equipmentType != null && skillLevel != null) {
                    unitPrice = findBasePrice(productId, equipmentType, record.getProcessId(), skillLevel);
                    if (unitPrice != null) {
                        priceSource = "base";
                    }
                }

                // 更新记录
                HnMonthlyRecord update = new HnMonthlyRecord();
                update.setId(record.getId());
                if (unitPrice != null) {
                    update.setUnitPrice(unitPrice);
                    update.setTotalAmount(unitPrice.multiply(new BigDecimal(record.getQuantity() == null ? 0 : record.getQuantity())));
                    update.setPriceSource(priceSource);
                    update.setCalcStatus("calculated");
                } else {
                    // 无匹配，保持 pending，等待手工补录
                    update.setCalcStatus("pending");
                }
                this.updateById(update);
                count++;
            } catch (Exception e) {
                log.error("月度记录单价计算失败, recordId={}", record.getId(), e);
            }
        }
        log.info("单价计算完成， docMonth={}, 处理记录数={}", docMonth, count);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void manualSetPrice(Long id, BigDecimal manualPrice) {
        HnMonthlyRecord record = this.getById(id);
        if (record == null) {
            throw new RuntimeException("记录不存在, id=" + id);
        }
        BigDecimal totalAmount = manualPrice == null
            ? null
            : manualPrice.multiply(new BigDecimal(record.getQuantity() == null ? 0 : record.getQuantity()));
        HnMonthlyRecord update = new HnMonthlyRecord();
        update.setId(id);
        update.setManualPrice(manualPrice);
        update.setUnitPrice(manualPrice);
        update.setTotalAmount(totalAmount);
        update.setPriceSource("manua");
        update.setCalcStatus("manual");
        this.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void editRecord(HnMonthlyRecord record) {
        if ("pending".equals(record.getCalcStatus())) {
            // 状态改回待计算，用 UpdateWrapper 显式将相关字段置为 NULL
            LambdaUpdateWrapper<HnMonthlyRecord> uw = new LambdaUpdateWrapper<>();
            uw.eq(HnMonthlyRecord::getId, record.getId())
              .set(HnMonthlyRecord::getCalcStatus, record.getCalcStatus())
              .set(HnMonthlyRecord::getWorkerId, record.getWorkerId())
              .set(HnMonthlyRecord::getEquipmentId, record.getEquipmentId())
              .set(HnMonthlyRecord::getEquipmentType, record.getEquipmentType())
              .set(HnMonthlyRecord::getMaterialCodeId, record.getMaterialCodeId())
              .set(HnMonthlyRecord::getProcessId, record.getProcessId())
              .set(HnMonthlyRecord::getQuantity, record.getQuantity())
              .set(HnMonthlyRecord::getManualPrice, record.getManualPrice())
              .set(HnMonthlyRecord::getUnitPrice, null)
              .set(HnMonthlyRecord::getTotalAmount, null)
              .set(HnMonthlyRecord::getPriceSource, null);
            this.update(uw);
            return;
        }
        if ("manual".equals(record.getCalcStatus())) {
            // 状态改为手工补录时，按合格数量与手工补录单价计算金额，并同步价格来源
            BigDecimal totalAmount = record.getManualPrice() == null
                ? null
                : record.getManualPrice().multiply(new BigDecimal(record.getQuantity() == null ? 0 : record.getQuantity()));
            LambdaUpdateWrapper<HnMonthlyRecord> uw = new LambdaUpdateWrapper<>();
            uw.eq(HnMonthlyRecord::getId, record.getId())
              .set(HnMonthlyRecord::getCalcStatus, record.getCalcStatus())
              .set(HnMonthlyRecord::getWorkerId, record.getWorkerId())
              .set(HnMonthlyRecord::getEquipmentId, record.getEquipmentId())
              .set(HnMonthlyRecord::getEquipmentType, record.getEquipmentType())
              .set(HnMonthlyRecord::getMaterialCodeId, record.getMaterialCodeId())
              .set(HnMonthlyRecord::getProcessId, record.getProcessId())
              .set(HnMonthlyRecord::getQuantity, record.getQuantity())
              .set(HnMonthlyRecord::getManualPrice, record.getManualPrice())
              .set(HnMonthlyRecord::getUnitPrice, record.getManualPrice())
              .set(HnMonthlyRecord::getTotalAmount, totalAmount)
              .set(HnMonthlyRecord::getPriceSource, "manua");
            this.update(uw);
            return;
        }
        this.updateById(record);
    }

    // ============ 私有辅助方法 ============

    // ---- Excel 列标题常量 ----

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> importMonthlyRecords(MultipartFile file, HttpServletResponse response) {
        if (file == null || file.isEmpty()) {
            return Result.error("上传文件为空");
        }
        String filename = file.getOriginalFilename();
        // 将文件内容读入内存 Workbook（需要在出错时重新使用）
        Workbook workbook;
        try {
            workbook = openWorkbook(file, filename);
        } catch (Exception e) {
            log.error("Excel文件解析失败", e);
            return Result.error("Excel文件解析失败: " + e.getMessage());
        }

        try {
            Sheet sheet = workbook.getSheetAt(0);
            // 解析标题行，建立 列标题 -> 列索引 映射
            Row headerRow = sheet.getRow(0);
            if (headerRow == null) {
                workbook.close();
                return Result.error("Excel文件无标题行");
            }
            Map<String, Integer> colIndex = new HashMap<>();
            int maxOriginalColIdx = 0;
            for (int c = 0; c < headerRow.getLastCellNum(); c++) {
                Cell cell = headerRow.getCell(c);
                if (cell != null) {
                    String title = cell.getStringCellValue().trim();
                    colIndex.put(title, c);
                    maxOriginalColIdx = c;
                }
            }
            // 错误列将追加在所有原始列之后
            int errorColIdx = maxOriginalColIdx + 1;

            // 预加载字典（name->id）以减少数据库查询次数
            Map<String, Long> workerNameToId   = loadWorkerMap();
            Map<String, Long> equipmentNoToId  = loadEquipmentMap();
            Map<String, Long> materialCodeToId = loadMaterialCodeMap();
            Map<String, Long> processNameToId  = loadProcessMap();
            Map<String, String> equipmentTypeTextToValue = loadEquipmentTypeDictMap();

            // 记录每行的错误（key=行号0-based，value=错误描述）
            Map<Integer, String> rowErrorMap = new LinkedHashMap<>();
            List<HnMonthlyRecord> records = new ArrayList<>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            int lastRow = sheet.getLastRowNum();
            for (int r = 1; r <= lastRow; r++) {
                Row row = sheet.getRow(r);
                if (row == null || isRowEmpty(row)) {
                    continue;
                }
                int excelRowNo = r + 1; // Excel 行号（从1起，第1行为标题）

                // 读取关键字段原始文本
                String workerName    = getStrCell(row, colIndex, COL_WORKER);
                String equipmentNo   = getStrCell(row, colIndex, COL_EQUIPMENT);
                String materialCode  = getStrCell(row, colIndex, COL_MATERIAL_CODE);
                String processName   = getStrCell(row, colIndex, COL_PROCESS);
                String equipmentTypeText = getStrCell(row, colIndex, COL_EQUIPMENT_TYPE);

                List<String> rowErrors = new ArrayList<>();

                // 字典反查
                Long workerId = workerNameToId.get(workerName);
                if (workerId == null) {
                    rowErrors.add(String.format("操作工[%s]在工人表中不存在", workerName));
                }
                Long equipmentId = equipmentNoToId.get(equipmentNo);
                if (equipmentId == null) {
                    rowErrors.add(String.format("设备编号[%s]在设备表中不存在", equipmentNo));
                }
                Long materialCodeId = materialCodeToId.get(materialCode);
                if (materialCodeId == null) {
                    rowErrors.add(String.format("物料编码[%s]在物料编码表中不存在", materialCode));
                }
                Long processId = processNameToId.get(processName);
                if (processId == null) {
                    rowErrors.add(String.format("作业[%s]在工序表中不存在", processName));
                }
                String equipmentType = null;
                if (StringUtils.hasText(equipmentTypeText)) {
                    equipmentType = equipmentTypeTextToValue.get(equipmentTypeText.trim());
                    if (!StringUtils.hasText(equipmentType)) {
                        rowErrors.add(String.format("订单生产车间[%s]在数据字典[equipment_type]中不存在", equipmentTypeText));
                    }
                }

                if (!rowErrors.isEmpty()) {
                    rowErrorMap.put(r, String.join("; ", rowErrors));
                    continue;
                }

                // 构建记录对象
                HnMonthlyRecord record = new HnMonthlyRecord();
                record.setWorkerId(workerId);
                record.setEquipmentId(equipmentId);
                record.setMaterialCodeId(materialCodeId);
                record.setProcessId(processId);

                // 优先使用Excel中的订单生产车间；未提供时回退为设备类型
                HnEquipment eq = equipmentMapper.selectById(equipmentId);
                if (!StringUtils.hasText(equipmentType) && eq != null) {
                    equipmentType = eq.getEquipmentType();
                }
                record.setEquipmentType(equipmentType);

                record.setProductionOrderNo(getStrCell(row, colIndex, COL_PRODUCTION_ORDER_NO));
                record.setBatchNo(getStrCell(row, colIndex, COL_BATCH_NO));
                record.setQuantity(getIntCell(row, colIndex, COL_QUANTITY));
                record.setScrapQty(getIntCell(row, colIndex, COL_SCRAP_QTY));
                record.setWheelWasteQty(getIntCell(row, colIndex, COL_WHEEL_WASTE_QTY));
                record.setRodWasteQty(getIntCell(row, colIndex, COL_ROD_WASTE_QTY));
                record.setMaterialWasteQty(getIntCell(row, colIndex, COL_MATERIAL_WASTE_QTY));
                record.setDefectQty(getIntCell(row, colIndex, COL_DEFECT_QTY));
                record.setInspector(getStrCell(row, colIndex, COL_INSPECTOR));
                record.setProductName(getStrCell(row, colIndex, COL_PRODUCT_NAME));
                record.setProductCode(getStrCell(row, colIndex, COL_PRODUCT_CODE));
                record.setCalcStatus("pending");

                // 解析单据日期
                String docDateStr = getStrCell(row, colIndex, COL_DOCUMENT_DATE);
                if (StringUtils.hasText(docDateStr)) {
                    try {
                        record.setDocumentDate(sdf.parse(docDateStr));
                    } catch (Exception e) {
                        try {
                            record.setDocumentDate(new SimpleDateFormat("yyyy/M/d").parse(docDateStr));
                        } catch (Exception ex) {
                            log.warn("第{}行单据日期解析失败: {}", excelRowNo, docDateStr);
                        }
                    }
                }

                records.add(record);
            }

            // -------- 有错误行：生成带错误列的Excel输出到response --------
            if (!rowErrorMap.isEmpty()) {
                writeErrorReportToResponse(workbook, sheet, headerRow, errorColIdx, rowErrorMap, filename, response);
                workbook.close();
                return Result.error("导入失败，共" + rowErrorMap.size() + "行数据无法识别，请下载错误报告并完善基础数据后重新导入");
            }

            workbook.close();

            if (records.isEmpty()) {
                return Result.error("Excel中无有效数据行");
            }

            this.saveBatch(records);
            return Result.OK("成功导入" + records.size() + "条记录");

        } catch (Exception e) {
            log.error("月度加工记录导入异常", e);
            try { workbook.close(); } catch (Exception ignored) {}
            return Result.error("导入失败: " + e.getMessage());
        }
    }

    /**
     * 在原始 Sheet 末尾添加「导入错误原因」列，将有问题的行标红并写入错误信息，
     * 然后将整个 Workbook 写入 response 供用户下载。
     */
    private void writeErrorReportToResponse(Workbook workbook, Sheet sheet, Row headerRow,
                                             int errorColIdx, Map<Integer, String> rowErrorMap,
                                             String originalFilename, HttpServletResponse response) throws Exception {
        // 写标题行的错误列标题
        Cell headerErrorCell = headerRow.createCell(errorColIdx);
        headerErrorCell.setCellValue("导入错误原因");
        CellStyle headerStyle = createHeaderErrorStyle(workbook);
        headerErrorCell.setCellStyle(headerStyle);

        // 为错误行写入错误信息并设置背景色
        CellStyle errorStyle = createRowErrorStyle(workbook);
        for (Map.Entry<Integer, String> entry : rowErrorMap.entrySet()) {
            int rowIdx = entry.getKey();
            String errorMsg = entry.getValue();
            Row row = sheet.getRow(rowIdx);
            if (row == null) row = sheet.createRow(rowIdx);
            Cell errorCell = row.createCell(errorColIdx);
            errorCell.setCellValue(errorMsg);
            errorCell.setCellStyle(errorStyle);
        }

        // 自动调整错误列宽度（近似值，POI单位为1/256字符宽）
        sheet.setColumnWidth(errorColIdx, 15000);

        // 设置response头，触发浏览器下载
        String reportFilename = "导入错误报告_" +
                new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition",
                "attachment; filename*=UTF-8''" + URLEncoder.encode(reportFilename, StandardCharsets.UTF_8));
        response.setHeader("Access-Control-Expose-Headers", "Content-Disposition");

        try (OutputStream out = response.getOutputStream()) {
            // 统一以 xlsx 格式输出（确保兼容性）
            if (workbook instanceof HSSFWorkbook) {
                // xls 转 xlsx：重新创建 XSSFWorkbook 输出
                XSSFWorkbook xssfWb = convertToXssf((HSSFWorkbook) workbook);
                xssfWb.write(out);
                xssfWb.close();
            } else {
                workbook.write(out);
            }
            out.flush();
        }
    }

    /** 创建错误列标题样式（橙色背景加粗） */
    private CellStyle createHeaderErrorStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setWrapText(true);
        return style;
    }

    /** 创建错误行单元格样式（浅红色背景） */
    private CellStyle createRowErrorStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setFillForegroundColor(IndexedColors.ROSE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setWrapText(true);
        style.setVerticalAlignment(VerticalAlignment.TOP);
        return style;
    }

    /**
     * 将 HSSFWorkbook (xls) 转换为 XSSFWorkbook (xlsx) 的简单实现：
     * 直接复制所有单元格文本值（不保留原格式）。
     */
    private XSSFWorkbook convertToXssf(HSSFWorkbook hssfWb) {
        XSSFWorkbook xssfWb = new XSSFWorkbook();
        for (int si = 0; si < hssfWb.getNumberOfSheets(); si++) {
            org.apache.poi.ss.usermodel.Sheet srcSheet = hssfWb.getSheetAt(si);
            org.apache.poi.ss.usermodel.Sheet dstSheet = xssfWb.createSheet(srcSheet.getSheetName());
            for (int r = 0; r <= srcSheet.getLastRowNum(); r++) {
                Row srcRow = srcSheet.getRow(r);
                if (srcRow == null) continue;
                Row dstRow = dstSheet.createRow(r);
                for (int c = srcRow.getFirstCellNum(); c < srcRow.getLastCellNum(); c++) {
                    Cell srcCell = srcRow.getCell(c);
                    if (srcCell == null) continue;
                    Cell dstCell = dstRow.createCell(c);
                    dstCell.setCellValue(getCellStringValue(srcCell));
                }
            }
        }
        return xssfWb;
    }

    /** 根据文件名判断 xlsx/xls 并返回对应 Workbook */
    private Workbook openWorkbook(MultipartFile file, String filename) throws Exception {
        if (filename != null && filename.endsWith(".xls")) {
            return new HSSFWorkbook(file.getInputStream());
        }
        return new XSSFWorkbook(file.getInputStream());
    }

    /** 判断某行是否为空行（所有单元格均为空） */
    private boolean isRowEmpty(Row row) {
        for (int c = row.getFirstCellNum(); c < row.getLastCellNum(); c++) {
            Cell cell = row.getCell(c);
            if (cell != null && cell.getCellType() != CellType.BLANK) {
                String val = getCellStringValue(cell);
                if (StringUtils.hasText(val)) return false;
            }
        }
        return true;
    }

    /** 从行中按列标题获取字符串值 */
    private String getStrCell(Row row, Map<String, Integer> colIndex, String colName) {
        Integer idx = colIndex.get(colName);
        if (idx == null) return null;
        Cell cell = row.getCell(idx);
        if (cell == null) return null;
        return getCellStringValue(cell);
    }

    /** 从行中按列标题获取整型值 */
    private Integer getIntCell(Row row, Map<String, Integer> colIndex, String colName) {
        Integer idx = colIndex.get(colName);
        if (idx == null) return null;
        Cell cell = row.getCell(idx);
        if (cell == null) return null;
        if (cell.getCellType() == CellType.NUMERIC) {
            return (int) cell.getNumericCellValue();
        }
        String str = getCellStringValue(cell);
        if (!StringUtils.hasText(str)) return null;
        try { return Integer.parseInt(str.trim()); } catch (NumberFormatException e) { return null; }
    }

    /** 统一将单元格值转为字符串（处理数值型、字符串型、日期型） */
    private String getCellStringValue(Cell cell) {
        if (cell == null) return null;
        switch (cell.getCellType()) {
            case STRING:  return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    Date d = cell.getDateCellValue();
                    return new SimpleDateFormat("yyyy-MM-dd").format(d);
                }
                // 避免科学计数法
                double v = cell.getNumericCellValue();
                if (v == (long) v) return String.valueOf((long) v);
                return String.valueOf(v);
            case BOOLEAN: return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                try { return cell.getStringCellValue().trim(); }
                catch (Exception e) { return String.valueOf(cell.getNumericCellValue()); }
            default: return null;
        }
    }

    /** 预加载工人姓名 -> id 映射 */
    private Map<String, Long> loadWorkerMap() {
        LambdaQueryWrapper<HnWorker> qw = new LambdaQueryWrapper<>();
        qw.select(HnWorker::getId, HnWorker::getName);
        List<HnWorker> list = workerMapper.selectList(qw);
        return list.stream().filter(w -> StringUtils.hasText(w.getName()))
                .collect(Collectors.toMap(HnWorker::getName, HnWorker::getId, (a, b) -> a));
    }

    /** 预加载设备编号 -> id 映射 */
    private Map<String, Long> loadEquipmentMap() {
        LambdaQueryWrapper<HnEquipment> qw = new LambdaQueryWrapper<>();
        qw.select(HnEquipment::getId, HnEquipment::getEquipmentNo);
        List<HnEquipment> list = equipmentMapper.selectList(qw);
        return list.stream().filter(e -> StringUtils.hasText(e.getEquipmentNo()))
                .collect(Collectors.toMap(HnEquipment::getEquipmentNo, HnEquipment::getId, (a, b) -> a));
    }

    /** 预加载物料编码 code -> id 映射 */
    private Map<String, Long> loadMaterialCodeMap() {
        LambdaQueryWrapper<HnMaterialCode> qw = new LambdaQueryWrapper<>();
        qw.select(HnMaterialCode::getId, HnMaterialCode::getCode);
        List<HnMaterialCode> list = materialCodeMapper.selectList(qw);
        return list.stream().filter(m -> StringUtils.hasText(m.getCode()))
                .collect(Collectors.toMap(HnMaterialCode::getCode, HnMaterialCode::getId, (a, b) -> a));
    }

    /** 预加载工序名称 -> id 映射 */
    private Map<String, Long> loadProcessMap() {
        LambdaQueryWrapper<HnProcess> qw = new LambdaQueryWrapper<>();
        qw.select(HnProcess::getId, HnProcess::getName);
        List<HnProcess> list = processMapper.selectList(qw);
        return list.stream().filter(p -> StringUtils.hasText(p.getName()))
                .collect(Collectors.toMap(HnProcess::getName, HnProcess::getId, (a, b) -> a));
    }

    /** 预加载订单生产车间字典文本/值 -> 字典值 映射 */
    private Map<String, String> loadEquipmentTypeDictMap() {
        List<DictModel> list = sysBaseAPI.getDictItems("equipment_type");
        if (list == null || list.isEmpty()) {
            return Collections.emptyMap();
        }
        Map<String, String> map = new HashMap<>();
        for (DictModel item : list) {
            if (item == null || !StringUtils.hasText(item.getValue())) {
                continue;
            }
            String value = item.getValue().trim();
            map.put(value, value);
            if (StringUtils.hasText(item.getText())) {
                map.put(item.getText().trim(), value);
            }
        }
        return map;
    }

    // ============ 私有辅助方法 ============

    /**
     * 获取工人对某工序的技能等级
     */
    private String getWorkerSkillLevel(Long workerId, Long processId) {
        if (workerId == null || processId == null) return null;
        LambdaQueryWrapper<HnWorkerProcessAbility> qw = new LambdaQueryWrapper<>();
        qw.eq(HnWorkerProcessAbility::getWorkerId, workerId)
          .eq(HnWorkerProcessAbility::getProcessId, processId)
          .last("LIMIT 1");
        HnWorkerProcessAbility ability = workerProcessAbilityMapper.selectOne(qw);
        return ability != null ? ability.getSkillLevel() : null;
    }

    /**
     * 获取物料编码对应的产品ID
     */
    private Long getProductId(Long materialCodeId) {
        if (materialCodeId == null) return null;
        HnMaterialCode mc = materialCodeMapper.selectById(materialCodeId);
        return mc != null ? mc.getProductId() : null;
    }

    /**
     * 查找物料覆盖单价（优先级1）
     */
    private BigDecimal findOverridePrice(Long materialCodeId, Long productId, String equipmentType, Long processId, String skillLevel) {
        LambdaQueryWrapper<HnMaterialOverridePrice> qw = new LambdaQueryWrapper<>();
        qw.eq(HnMaterialOverridePrice::getMaterialCodeId, materialCodeId)
          .eq(HnMaterialOverridePrice::getProductId, productId)
          .eq(HnMaterialOverridePrice::getEquipmentType, equipmentType)
          .eq(HnMaterialOverridePrice::getProcessId, processId)
          .eq(HnMaterialOverridePrice::getSkillLevel, skillLevel)
          .eq(HnMaterialOverridePrice::getStatus, 1)
          .last("LIMIT 1");
        HnMaterialOverridePrice price = materialOverridePriceMapper.selectOne(qw);
        return price != null ? price.getUnitPrice() : null;
    }

    /**
     * 查找复合定价（优先级2）——设备匹配优先，无命中则降级为产线匹配，再按尺寸区间命中
     */
    private BigDecimal findComplexPrice(Long materialCodeId, Long processId, Long equipmentId, String equipmentType, String skillLevel) {
        // 获取物料各尺寸维度对应尺寸値，构建 Map<dimensionName, dimensionValue>
        LambdaQueryWrapper<HnMaterialDimension> dqw = new LambdaQueryWrapper<>();
        dqw.eq(HnMaterialDimension::getMaterialCodeId, materialCodeId);
        List<HnMaterialDimension> dimensions = materialDimensionMapper.selectList(dqw);
        Map<String, BigDecimal> dimMap = dimensions.stream()
                .collect(Collectors.toMap(HnMaterialDimension::getDimensionName, HnMaterialDimension::getDimensionValue,
                        (a, b) -> a));
        if (dimMap.isEmpty()) return null;

        // Step 3A：优先按设备匹配候选项
        if (equipmentId != null) {
            LambdaQueryWrapper<HnComplexPrice> qw = new LambdaQueryWrapper<>();
            qw.eq(HnComplexPrice::getProcessId, processId)
              .eq(HnComplexPrice::getEquipmentId, equipmentId)
              .eq(HnComplexPrice::getSkillLevel, skillLevel);
            List<HnComplexPrice> candidates = complexPriceMapper.selectList(qw);
            if (!candidates.isEmpty()) {
                // 设备匹配到候选项，在此基础上做尺寸区间匹配，不再退化到产线
                for (HnComplexPrice cp : candidates) {
                    BigDecimal dimValue = dimMap.get(cp.getDimensionName());
                    if (dimValue == null) continue;
                    if (matchesRange(dimValue, cp.getRangeMinOp(), cp.getRangeMin(), cp.getRangeMaxOp(), cp.getRangeMax())) {
                        return cp.getUnitPrice();
                    }
                }
                return null; // 设备匹配到但尺寸区间未命中，不再尝试产线
            }
            // 设备匹配候选集为空，降级到 Step 3B 产线匹配
        }

        // Step 3B：产线匹配（equipmentId 为 null 或设备匹配候选集为空）
        if (equipmentType == null) return null;
        LambdaQueryWrapper<HnComplexPrice> qw = new LambdaQueryWrapper<>();
        qw.eq(HnComplexPrice::getProcessId, processId)
          .eq(HnComplexPrice::getEquipmentType, equipmentType)
          .eq(HnComplexPrice::getSkillLevel, skillLevel)
          .isNull(HnComplexPrice::getEquipmentId); // 确保只匹配产线类型的定价行
        List<HnComplexPrice> candidates = complexPriceMapper.selectList(qw);
        for (HnComplexPrice cp : candidates) {
            BigDecimal dimValue = dimMap.get(cp.getDimensionName());
            if (dimValue == null) continue;
            if (matchesRange(dimValue, cp.getRangeMinOp(), cp.getRangeMin(), cp.getRangeMaxOp(), cp.getRangeMax())) {
                return cp.getUnitPrice();
            }
        }
        return null;
    }

    /**
     * 判断尺寸値是否命中复合定价区间
     */
    private boolean matchesRange(BigDecimal value, String minOp, BigDecimal minVal, String maxOp, BigDecimal maxVal) {
        // 检查下限
        if (minOp != null && minVal != null) {
            int cmp = value.compareTo(minVal);
            if (">=".equals(minOp) && cmp < 0) return false;
            if (">".equals(minOp) && cmp <= 0) return false;
        }
        // 检查上限
        if (maxOp != null && maxVal != null) {
            int cmp = value.compareTo(maxVal);
            if ("<=".equals(maxOp) && cmp > 0) return false;
            if ("<".equals(maxOp) && cmp >= 0) return false;
        }
        return true;
    }

    /**
     * 查找基础单价（优先级3）
     */
    private BigDecimal findBasePrice(Long productId, String equipmentType, Long processId, String skillLevel) {
        LambdaQueryWrapper<HnBasePrice> qw = new LambdaQueryWrapper<>();
        qw.eq(HnBasePrice::getProductId, productId)
          .eq(HnBasePrice::getEquipmentType, equipmentType)
          .eq(HnBasePrice::getProcessId, processId)
          .eq(HnBasePrice::getSkillLevel, skillLevel)
          .eq(HnBasePrice::getStatus, 1)
          .last("LIMIT 1");
        HnBasePrice price = basePriceMapper.selectOne(qw);
        return price != null ? price.getUnitPrice() : null;
    }
}
