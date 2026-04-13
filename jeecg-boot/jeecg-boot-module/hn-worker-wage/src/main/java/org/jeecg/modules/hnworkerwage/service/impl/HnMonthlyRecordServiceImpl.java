package org.jeecg.modules.hnworkerwage.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.jeecg.modules.hnworkerwage.entity.*;
import org.jeecg.modules.hnworkerwage.mapper.*;
import org.jeecg.modules.hnworkerwage.service.IHnMonthlyRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
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

    @Override
    @Async
    @Transactional(rollbackFor = Exception.class)
    public void startCalculation(String recordMonth) {
        // 查询待计算记录
        LambdaQueryWrapper<HnMonthlyRecord> qw = new LambdaQueryWrapper<>();
        qw.eq(HnMonthlyRecord::getCalcStatus, "pending");
        if (StringUtils.hasText(recordMonth)) {
            qw.eq(HnMonthlyRecord::getRecordMonth, recordMonth);
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
        log.info("单价计算完成， recordMonth={}, 处理记录数={}", recordMonth, count);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void manualSetPrice(Long id, BigDecimal manualPrice) {
        HnMonthlyRecord record = this.getById(id);
        if (record == null) {
            throw new RuntimeException("记录不存在, id=" + id);
        }
        HnMonthlyRecord update = new HnMonthlyRecord();
        update.setId(id);
        update.setManualPrice(manualPrice);
        update.setUnitPrice(manualPrice);
        update.setTotalAmount(manualPrice.multiply(new BigDecimal(record.getQuantity() == null ? 0 : record.getQuantity())));
        update.setPriceSource("manual");
        update.setCalcStatus("manual");
        this.updateById(update);
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
