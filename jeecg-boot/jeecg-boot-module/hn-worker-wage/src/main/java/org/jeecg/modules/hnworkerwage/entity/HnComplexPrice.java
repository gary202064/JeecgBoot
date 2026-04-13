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
 * @Description: 复合定价表
 * @Author: jeecg-boot
 * @Date:   2026-04-09
 * @Version: V1.0
 */
@Data
@TableName("hn_complex_price")
@Schema(name="hn_complex_price", description="复合定价表")
public class HnComplexPrice implements Serializable {
    private static final long serialVersionUID = 1L;

	/**主键*/
	@TableId(type = IdType.AUTO)
    @Schema(description = "主键")
	private java.lang.Long id;
	/**关联的工序ID*/
	@Excel(name = "工序", width = 15, dictTable = "hn_process", dicCode = "id", dicText = "name")
    @Schema(description = "关联的工序ID")
    @Dict(dictTable = "hn_process", dicCode = "id", dicText = "name")
	private java.lang.Long processId;
	/**设备类型*/
	@Excel(name = "产线", width = 15, dicCode = "equipment_type")
    @Schema(description = "产线 (数据字典)")
    @Dict(dicCode = "equipment_type")
	private java.lang.String equipmentType;
	/**技能等级*/
	@Excel(name = "技能等级", width = 15, dicCode = "skill_level")
    @Schema(description = "技能等级 (数据字典)")
    @Dict(dicCode = "skill_level")
	private java.lang.String skillLevel;
	/**尺寸维度名称（来源：hn_material_dimension.dimension_name）*/
	@Excel(name = "尺寸维度", width = 15, dictTable = "hn_material_dimension", dicCode = "dimension_name", dicText = "dimension_name")
    @Schema(description = "尺寸维度（来源：物料尺寸定义表）")
    @Dict(dictTable = "hn_material_dimension", dicCode = "dimension_name", dicText = "dimension_name")
	private java.lang.String dimensionName;
	/**最小值运算符*/
	@Excel(name = "最小值运算符", width = 10)
    @Schema(description = "最小值运算符 (>=, >)，NULL表示无下限")
	private java.lang.String rangeMinOp;
	/**尺寸区间最小值*/
	@Excel(name = "区间最小值", width = 15)
    @Schema(description = "尺寸区间最小值，NULL表示无下限")
	private java.math.BigDecimal rangeMin;
	/**最大值运算符*/
	@Excel(name = "最大值运算符", width = 10)
    @Schema(description = "最大值运算符 (<=, <)，NULL表示无上限")
	private java.lang.String rangeMaxOp;
	/**尺寸区间最大值*/
	@Excel(name = "区间最大值", width = 15)
    @Schema(description = "尺寸区间最大值，NULL表示无上限")
	private java.math.BigDecimal rangeMax;
	/**在此组合下的加工单价*/
	@Excel(name = "单价", width = 15)
    @Schema(description = "在此组合下的加工单价")
	private java.math.BigDecimal unitPrice;
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
