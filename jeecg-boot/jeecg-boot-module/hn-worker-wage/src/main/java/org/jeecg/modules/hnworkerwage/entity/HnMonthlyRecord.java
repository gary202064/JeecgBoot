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
import java.util.Date;
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

	/**主键*/
	@TableId(type = IdType.AUTO)
    @Schema(description = "主键")
	private java.lang.Long id;
	/**所属年月*/
	@Excel(name = "所属年月", width = 15)
    @Schema(description = "所属年月")
	@TableField("`year_month`")
	private java.lang.String yearMonth;
	/**导入批次ID*/
	@Excel(name = "导入批次ID", width = 15, dictTable = "hn_import_batch", dicCode = "id", dicText = "file_name")
    @Schema(description = "导入批次ID")
    @Dict(dictTable = "hn_import_batch", dicCode = "id", dicText = "file_name")
	private java.lang.Long importBatchId;
	/**工人ID*/
	@Excel(name = "工人ID", width = 15, dictTable = "hn_worker", dicCode = "id", dicText = "name")
    @Schema(description = "工人ID")
    @Dict(dictTable = "hn_worker", dicCode = "id", dicText = "name")
	private java.lang.Long workerId;
	/**设备ID*/
	@Excel(name = "设备ID", width = 15, dictTable = "hn_equipment", dicCode = "id", dicText = "equipment_no")
    @Schema(description = "设备ID")
    @Dict(dictTable = "hn_equipment", dicCode = "id", dicText = "equipment_no")
	private java.lang.Long equipmentId;
	/**产线*/
	@Excel(name = "产线", width = 15, dictTable = "sys_dict_item", dicCode = "production_line", dicText = "item_text")
    @Schema(description = "产线")
    @Dict(dicCode = "production_line")
	private java.lang.String lineId;
	/**物料编码ID*/
	@Excel(name = "物料编码ID", width = 15, dictTable = "hn_material_code", dicCode = "id", dicText = "code")
    @Schema(description = "物料编码ID")
    @Dict(dictTable = "hn_material_code", dicCode = "id", dicText = "code")
	private java.lang.Long materialCodeId;
	/**工序ID*/
	@Excel(name = "工序ID", width = 15, dictTable = "hn_process", dicCode = "id", dicText = "name")
    @Schema(description = "工序ID")
    @Dict(dictTable = "hn_process", dicCode = "id", dicText = "name")
	private java.lang.Long processId;
	/**合格数量*/
	@Excel(name = "合格数量", width = 15)
    @Schema(description = "合格数量")
	private java.lang.Integer quantity;
	/**计算单价*/
	@Excel(name = "计算单价", width = 15)
    @Schema(description = "计算单价")
	private java.math.BigDecimal unitPrice;
	/**总金额*/
	@Excel(name = "总金额", width = 15)
    @Schema(description = "总金额")
	private java.math.BigDecimal totalAmount;
	/**价格来源*/
	@Excel(name = "价格来源", width = 15)
    @Schema(description = "价格来源")
	private java.lang.String priceSource;
	/**计算状态*/
	@Excel(name = "计算状态", width = 15)
    @Schema(description = "计算状态")
	private java.lang.String calcStatus;
	/**手工补录单价*/
	@Excel(name = "手工补录单价", width = 15)
    @Schema(description = "手工补录单价")
	private java.math.BigDecimal manualPrice;
	/**创建人*/
    @Schema(description = "创建人")
	private java.lang.String createBy;
	/**创建日期*/
	@JsonFormat(timezone = "GMT+8",pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    @Schema(description = "创建日期")
	private java.util.Date createTime;
	/**更新人*/
    @Schema(description = "更新人")
	private java.lang.String updateBy;
	/**更新日期*/
	@JsonFormat(timezone = "GMT+8",pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    @Schema(description = "更新日期")
	private java.util.Date updateTime;
	/**所属部门*/
    @Schema(description = "所属部门")
	private java.lang.String sysOrgCode;
}