package org.jeecg.modules.hnworkerwage.service;

import org.jeecg.modules.hnworkerwage.entity.HnMonthlyRecord;
import com.baomidou.mybatisplus.extension.service.IService;

import java.math.BigDecimal;

/**
 * @Description: 月度加工记录表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
public interface IHnMonthlyRecordService extends IService<HnMonthlyRecord> {

    /**
     * 触发异步单价计算：对所有 calc_status='pending' 的记录执行单价匹配
     * @param yearMonth 指定年月（格式 YYYY-MM），为 null 时处理全部 pending 记录
     */
    void startCalculation(String yearMonth);

    /**
     * 手工补录单价：将指定记录的 manual_price 写入并将 calc_status 置为 'manual'
     * @param id          记录ID
     * @param manualPrice 手工单价
     */
    void manualSetPrice(Long id, BigDecimal manualPrice);
}
