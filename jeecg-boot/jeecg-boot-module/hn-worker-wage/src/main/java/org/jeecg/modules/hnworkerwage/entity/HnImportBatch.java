package org.jeecg.modules.hnworkerwage.entity;

import java.io.Serializable;
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
 * @Description: 导入批次表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Data
@TableName("hn_import_batch")
@Schema(name="hn_import_batch", description="导入批次表")
public class HnImportBatch implements Serializable {
    private static final long serialVersionUID = 1L;

	/**主键*/
	@TableId(type = IdType.AUTO)
    @Schema(description = "主键")
	private java.lang.Long id;
	/**文件名*/
	@Excel(name = "文件名", width = 15)
    @Schema(description = "文件名")
	private java.lang.String fileName;
	/**所属年月*/
	@Excel(name = "所属年月", width = 15)
    @Schema(description = "所属年月")
	private java.lang.String yearMonth;
	/**总记录数*/
	@Excel(name = "总记录数", width = 15)
    @Schema(description = "总记录数")
	private java.lang.Integer recordCount;
	/**成功数*/
	@Excel(name = "成功数", width = 15)
    @Schema(description = "成功数")
	private java.lang.Integer successCount;
	/**失败数*/
	@Excel(name = "失败数", width = 15)
    @Schema(description = "失败数")
	private java.lang.Integer failCount;
	/**状态*/
	@Excel(name = "状态", width = 15)
    @Schema(description = "状态")
	private java.lang.String status;
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