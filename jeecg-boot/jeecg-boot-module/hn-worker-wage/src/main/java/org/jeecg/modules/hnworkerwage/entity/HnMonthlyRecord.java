package org.jeecg.modules.hnworkerwage.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;
import org.jeecgframework.poi.excel.annotation.Excel;
import io.swagger.v3.oas.annotations.media.Schema;
import org.jeecg.common.aspect.annotation.Dict;

/**
 * @Description: 月度加工记录表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Data
@TableName("hn_monthly_record")
@Schema(name="hn_monthly_record", description="月度加工记录表")
public class HnMonthlyRecord implements Serializable {
    private static final long serialVersionUID = 1L;

    /** 主键 */
    @TableId(type = IdType.AUTO)
    @Schema(description = "主键")
    private Long id;

    /** 导入批次ID */
    @Excel(name = "导入批次ID", width = 15)
    @Schema(description = "导入批次ID")
    private Long importBatchId;

    /** 工人ID */
    @Excel(name = "操作工姓名", width = 15, dictTable = "hn_worker", dicCode = "id", dicText = "name")
    @Schema(description = "工人ID")
    @Dict(dictTable = "hn_worker", dicCode = "id", dicText = "name")
    private Long workerId;

    /** 设备ID */
    @Excel(name = "设备", width = 15, dictTable = "hn_equipment", dicCode = "id", dicText = "equipment_no")
    @Schema(description = "设备ID")
    @Dict(dictTable = "hn_equipment", dicCode = "id", dicText = "equipment_no")
    private Long equipmentId;

    /** 产线（数据字典 equipment_type）*/
    @Excel(name = "订单生产车间", width = 15, dicCode = "equipment_type")
    @Schema(description = "产线（数据字典 equipment_type）")
    @Dict(dicCode = "equipment_type")
    private String equipmentType;

    /** 物料编码ID */
    @Excel(name = "旧物料编码", width = 15, dictTable = "hn_material_code", dicCode = "id", dicText = "code")
    @Schema(description = "物料编码ID")
    @Dict(dictTable = "hn_material_code", dicCode = "id", dicText = "code")
    private Long materialCodeId;

    /** 工序ID */
    @Excel(name = "作业", width = 15, dictTable = "hn_process", dicCode = "id", dicText = "name")
    @Schema(description = "工序ID")
    @Dict(dictTable = "hn_process", dicCode = "id", dicText = "name")
    private Long processId;

    /** 合格数量 */
    @Excel(name = "合格数量", width = 15)
    @Schema(description = "合格数量")
    private Integer quantity;

    /** 生产订单编号 */
    @Excel(name = "生产订单编号", width = 20)
    @Schema(description = "生产订单编号")
    private String productionOrderNo;

    /** 单据日期 */
    @Excel(name = "单据日期", width = 15, format = "yyyy-MM-dd")
    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Schema(description = "单据日期")
    private java.util.Date documentDate;

    /** 批号 */
    @Excel(name = "批号", width = 15)
    @Schema(description = "批号")
    private String batchNo;

    /** 工废数量 */
    @Excel(name = "工废数量", width = 12)
    @Schema(description = "工废数量")
    private Integer scrapQty;

    /** 料费数量 */
    @Excel(name = "料废数量", width = 12)
    @Schema(description = "料费数量")
    private Integer materialWasteQty;

    /** 次品数量 */
    @Excel(name = "次品数量", width = 12)
    @Schema(description = "次品数量")
    private Integer defectQty;

    /** 检验员 */
    @Excel(name = "检验员", width = 15)
    @Schema(description = "检验员")
    private String inspector;

    /** 轮废数量 */
    @Excel(name = "轮废数量", width = 12)
    @Schema(description = "轮废数量")
    private Integer wheelWasteQty;

    /** 杆废 */
    @Excel(name = "杆废数量", width = 12)
    @Schema(description = "杆废")
    private Integer rodWasteQty;

    /** 产品名称 */
    @Excel(name = "产品名称", width = 20)
    @Schema(description = "产品名称")
    private String productName;

    /** 产品编码 */
    @Excel(name = "产品编码", width = 20)
    @Schema(description = "产品编码")
    private String productCode;

    /** 计算使用的单价 */
    @Excel(name = "单价", width = 15)
    @Schema(description = "计算使用的单价")
    private BigDecimal unitPrice;

    /** 总金额 */
    @Excel(name = "总金额", width = 15)
    @Schema(description = "总金额 = quantity × unit_price")
    private BigDecimal totalAmount;

    /** 价格来源 */
    @Excel(name = "价格来源", width = 15)
    @Schema(description = "价格来源")
    @Dict(dicCode = "price_source")
    private String priceSource;

    /** 计算状态 */
    @Excel(name = "计算状态", width = 15)
    @Schema(description = "计算状态")
    @Dict(dicCode = "calc_status")
    private String calcStatus;

    /** 手工补录单价 */
    @Excel(name = "手工补录单价", width = 15)
    @Schema(description = "手工补录单价（calc_status=manual 时使用）")
    private BigDecimal manualPrice;

    /** 创建人 */
    @Schema(description = "创建人")
    private String createBy;

    /** 创建日期 */
    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Schema(description = "创建日期")
    private java.util.Date createTime;

    /** 更新人 */
    @Schema(description = "更新人")
    private String updateBy;

    /** 更新日期 */
    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Schema(description = "更新日期")
    private java.util.Date updateTime;

    /** 所属部门 */
    @Schema(description = "所属部门")
    private String sysOrgCode;
}
