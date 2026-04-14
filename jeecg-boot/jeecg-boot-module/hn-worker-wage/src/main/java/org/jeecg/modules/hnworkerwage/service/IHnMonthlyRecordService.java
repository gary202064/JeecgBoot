package org.jeecg.modules.hnworkerwage.service;

import org.jeecg.modules.hnworkerwage.entity.HnMonthlyRecord;
import com.baomidou.mybatisplus.extension.service.IService;
import org.jeecg.common.api.vo.Result;
import org.springframework.web.multipart.MultipartFile;

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
     * @param docMonth 按单据日期年月过滤（格式 YYYY-MM），为 null 时处理全部 pending 记录
     */
    void startCalculation(String docMonth);

    /**
     * 手工补录单价：将指定记录的 manual_price 写入并将 calc_status 置为 'manual'
     * @param id          记录ID
     * @param manualPrice 手工单价
     */
    void manualSetPrice(Long id, BigDecimal manualPrice);

    /**
     * 编辑月度加工记录：
     * 若 calcStatus 为 'pending'，则同时清空 unitPrice、totalAmount、priceSource
     * @param record 待更新的记录对象
     */
    void editRecord(HnMonthlyRecord record);

    /**
     * 自定义导入月度加工记录：按列标题解析Excel，逐行进行字典反查转换。
     * 对无法转换的行收集错误信息（行号+关键字段值），导入结束后统一返回。
     * 若存在无法转换的行，本次导入整体失败，不写入任何数据。
     * @param file 上传的Excel文件
     * @return 操作结果（成功数量或详细错误信息）
     */
    Result<?> importMonthlyRecords(MultipartFile file);
}
