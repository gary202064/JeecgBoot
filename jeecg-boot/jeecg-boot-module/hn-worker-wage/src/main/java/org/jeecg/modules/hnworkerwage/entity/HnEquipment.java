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
import org.jeecg.common.aspect.annotation.Dict;

/**
 * @Description: 设备表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Data
@TableName("hn_equipment")
@Schema(name="hn_equipment", description="设备表")
public class HnEquipment implements Serializable {
    private static final long serialVersionUID = 1L;

	/**主键*/
	@TableId(type = IdType.AUTO)
    @Schema(description = "主键")
	private java.lang.Long id;
	/**设备编号*/
	@Excel(name = "设备编号", width = 15)
    @Schema(description = "设备编号")
	private java.lang.String equipmentNo;
	/**设备类型*/
	@Excel(name = "设备类型", width = 15, dictTable = "sys_dict_item", dicCode = "equipment_type", dicText = "item_text")
    @Schema(description = "设备类型")
    @Dict(dicCode = "equipment_type")
	private java.lang.String typeId;
	/**所属产线*/
	@Excel(name = "所属产线", width = 15, dictTable = "sys_dict_item", dicCode = "production_line", dicText = "item_text")
    @Schema(description = "所属产线")
    @Dict(dicCode = "production_line")
	private java.lang.String lineId;
	/**状态*/
	@Excel(name = "状态", width = 15, dicCode = "status")
    @Schema(description = "状态")
    @Dict(dicCode = "status")
	private java.lang.Integer status;
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