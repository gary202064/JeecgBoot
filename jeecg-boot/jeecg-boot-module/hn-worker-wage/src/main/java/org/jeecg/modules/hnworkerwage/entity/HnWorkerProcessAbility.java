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
 * @Description: 工人-工序能力表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Data
@TableName("hn_worker_process_ability")
@Schema(name="hn_worker_process_ability", description="工人-工序能力表")
public class HnWorkerProcessAbility implements Serializable {
    private static final long serialVersionUID = 1L;

	/**主键*/
	@TableId(type = IdType.AUTO)
    @Schema(description = "主键")
	private java.lang.Long id;
	/**工人ID*/
	@Excel(name = "工人ID", width = 15, dictTable = "hn_worker", dicCode = "id", dicText = "name")
    @Schema(description = "工人ID")
    @Dict(dictTable = "hn_worker", dicCode = "id", dicText = "name")
	private java.lang.Long workerId;
	/**工序ID*/
	@Excel(name = "工序ID", width = 15, dictTable = "hn_process", dicCode = "id", dicText = "name")
    @Schema(description = "工序ID")
    @Dict(dictTable = "hn_process", dicCode = "id", dicText = "name")
	private java.lang.Long processId;
	/**能力状态*/
	@Excel(name = "能力状态", width = 15, dicCode = "ability_status")
    @Schema(description = "能力状态")
    @Dict(dicCode = "ability_status")
	private java.lang.Integer canFullWork;
	/**熟练度*/
	@Excel(name = "熟练度", width = 15, dicCode = "skill_level")
	@Schema(description = "熟练度")
	@Dict(dicCode = "skill_level")
	private java.lang.String skillLevel;
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