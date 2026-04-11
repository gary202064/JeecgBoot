package org.jeecg.modules.hnworkerwage.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
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
 * @Description: 物料覆盖单价表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Data
@TableName("hn_material_override_price")
@Schema(name="hn_material_override_price", description="物料覆盖单价表")
public class HnMaterialOverridePrice implements Serializable {
    private static final long serialVersionUID = 1L;

	/**主键*/
	@TableId(type = IdType.AUTO)
    @Schema(description = "主键")
	private java.lang.Long id;
	/**产品ID*/
	@Excel(name = "产品ID", width = 15, dictTable = "hn_product", dicCode = "id", dicText = "name")
    @Schema(description = "产品ID")
    @Dict(dictTable = "hn_product", dicCode = "id", dicText = "name")
	private java.lang.Long productId;
	/**设备类型*/
	@Excel(name = "设备类型", width = 15, dicCode = "equipment_type")
    @Schema(description = "设备类型")
    @Dict(dicCode = "equipment_type")
	@TableField("equipment_type")
	private java.lang.String equipmentType;
	/**工序ID*/
	@Excel(name = "工序ID", width = 15, dictTable = "hn_process", dicCode = "id", dicText = "name")
    @Schema(description = "工序ID")
    @Dict(dictTable = "hn_process", dicCode = "id", dicText = "name")
	private java.lang.Long processId;
	/**熟练度*/
	@Excel(name = "熟练度", width = 15, dictTable = "sys_dict_item", dicCode = "skill_level", dicText = "item_text")
    @Schema(description = "熟练度")
    @Dict(dicCode = "skill_level")
	private java.lang.String skillLevel;
	/**物料编码ID*/
	@Excel(name = "物料编码ID", width = 15, dictTable = "hn_material_code", dicCode = "id", dicText = "code")
    @Schema(description = "物料编码ID")
    @Dict(dictTable = "hn_material_code", dicCode = "id", dicText = "code")
	private java.lang.Long materialCodeId;
	/**单价*/
	@Excel(name = "单价", width = 15)
    @Schema(description = "单价")
	private java.math.BigDecimal unitPrice;
	/**生效日期*/
	@Excel(name = "生效日期", width = 15, format = "yyyy-MM-dd")
	@JsonFormat(timezone = "GMT+8",pattern = "yyyy-MM-dd")
    @DateTimeFormat(pattern="yyyy-MM-dd")
    @Schema(description = "生效日期")
	private java.util.Date effectiveDate;
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