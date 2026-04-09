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
 * @Description: 物料尺寸定义表
 * @Author: jeecg-boot
 * @Date:   2026-04-09
 * @Version: V1.0
 */
@Data
@TableName("hn_material_dimension")
@Schema(name="hn_material_dimension", description="物料尺寸定义表")
public class HnMaterialDimension implements Serializable {
    private static final long serialVersionUID = 1L;

	/**主键*/
	@TableId(type = IdType.AUTO)
    @Schema(description = "主键")
	private java.lang.Long id;
	/**关联的物料编码ID*/
	@Excel(name = "物料编码", width = 15, dictTable = "hn_material_code", dicCode = "id", dicText = "code")
    @Schema(description = "关联的物料编码ID")
    @Dict(dictTable = "hn_material_code", dicCode = "id", dicText = "code")
	private java.lang.Long materialCodeId;
	/**尺寸维度名称*/
	@Excel(name = "尺寸维度名称", width = 15)
    @Schema(description = "尺寸维度名称")
	private java.lang.String dimensionName;
	/**该物料的具体尺寸值*/
	@Excel(name = "尺寸值", width = 15)
    @Schema(description = "该物料的具体尺寸值")
	private java.math.BigDecimal dimensionValue;
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
