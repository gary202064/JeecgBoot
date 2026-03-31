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

/**
 * @Description: 单价变更日志表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Data
@TableName("hn_price_change_log")
@Schema(name="hn_price_change_log", description="单价变更日志表")
public class HnPriceChangeLog implements Serializable {
    private static final long serialVersionUID = 1L;

	/**主键*/
	@TableId(type = IdType.AUTO)
    @Schema(description = "主键")
	private java.lang.Long id;
	/**来源表*/
	@Excel(name = "来源表", width = 15)
    @Schema(description = "来源表")
	private java.lang.String tableName;
	/**来源记录ID*/
	@Excel(name = "来源记录ID", width = 15)
    @Schema(description = "来源记录ID")
	private java.lang.Long recordId;
	/**旧单价*/
	@Excel(name = "旧单价", width = 15)
    @Schema(description = "旧单价")
	private java.math.BigDecimal oldPrice;
	/**新单价*/
	@Excel(name = "新单价", width = 15)
    @Schema(description = "新单价")
	private java.math.BigDecimal newPrice;
	/**生效日期*/
	@Excel(name = "生效日期", width = 15, format = "yyyy-MM-dd")
	@JsonFormat(timezone = "GMT+8",pattern = "yyyy-MM-dd")
    @DateTimeFormat(pattern="yyyy-MM-dd")
    @Schema(description = "生效日期")
	private java.util.Date effectiveDate;
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