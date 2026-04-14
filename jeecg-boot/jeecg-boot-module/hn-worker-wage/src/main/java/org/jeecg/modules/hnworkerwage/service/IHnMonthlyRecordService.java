package org.jeecg.modules.hnworkerwage.service;

import org.jeecg.modules.hnworkerwage.entity.HnMonthlyRecord;
import com.baomidou.mybatisplus.extension.service.IService;
import org.jeecg.common.api.vo.Result;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpServletResponse;

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
     * 若 calcStatus 为 'pending'，则同时清空 unitPrice、totalAmount、priceSource；
     * 若 calcStatus 为 'manual'，则将 manualPrice 同步到 unitPrice，按数量计算 totalAmount，并将 priceSource 置为 'manua'
     * @param record 待更新的记录对象
     */
    void editRecord(HnMonthlyRecord record);

    /**
     * 自定义导入月度加工记录：按列标题解析Excel，逐行进行字典反查转换。
     * - 若全部行转换成功，写入数据库，返回成功结果。
     * - 若存在无法转换的行，在原始Excel末尾追加「错误原因」列，将错误报告Excel
     *   写入 HttpServletResponse（Content-Disposition: attachment），
     *   同时返回 Result.error 告知前端有错误（前端收到非200或特定标志后触发下载）。
     * @param file     上传的Excel文件
     * @param response HttpServletResponse，用于输出错误报告Excel
     * @return 操作结果
     */
    Result<?> importMonthlyRecords(MultipartFile file, HttpServletResponse response);
}
