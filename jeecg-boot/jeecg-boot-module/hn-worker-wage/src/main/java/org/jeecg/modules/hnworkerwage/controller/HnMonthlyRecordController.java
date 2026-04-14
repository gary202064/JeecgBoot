package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import java.math.BigDecimal;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnMonthlyRecord;
import org.jeecg.modules.hnworkerwage.service.IHnMonthlyRecordService;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.extern.slf4j.Slf4j;

import org.jeecg.common.system.base.controller.JeecgController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Operation;

 /**
 * @Description: 月度加工记录表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "月度加工记录表")
@RestController
@RequestMapping("/hnworkerwage/hnMonthlyRecord")
@Slf4j
public class HnMonthlyRecordController extends JeecgController<HnMonthlyRecord, IHnMonthlyRecordService> {
	@Autowired
	private IHnMonthlyRecordService hnMonthlyRecordService;

	/**
	 * 分页列表查询
	 *
	 * @param hnMonthlyRecord
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "月度加工记录表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnMonthlyRecord>> queryPageList(HnMonthlyRecord hnMonthlyRecord,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnMonthlyRecord> queryWrapper = QueryGenerator.initQueryWrapper(hnMonthlyRecord, req.getParameterMap());
		Page<HnMonthlyRecord> page = new Page<HnMonthlyRecord>(pageNo, pageSize);
		IPage<HnMonthlyRecord> pageList = hnMonthlyRecordService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnMonthlyRecord
	 * @return
	 */
	@Operation(summary = "月度加工记录表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnMonthlyRecord hnMonthlyRecord) {
		hnMonthlyRecordService.save(hnMonthlyRecord);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnMonthlyRecord
	 * @return
	 */
	@Operation(summary = "月度加工记录表-编辑")
	@RequestMapping(value = "/edit", method = {RequestMethod.PUT,RequestMethod.POST})
	public Result<String> edit(@RequestBody HnMonthlyRecord hnMonthlyRecord) {
		hnMonthlyRecordService.editRecord(hnMonthlyRecord);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "月度加工记录表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnMonthlyRecordService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "月度加工记录表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		this.hnMonthlyRecordService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "月度加工记录表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnMonthlyRecord> queryById(@RequestParam(name="id",required=true) String id) {
		HnMonthlyRecord hnMonthlyRecord = hnMonthlyRecordService.getById(id);
		if(hnMonthlyRecord==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnMonthlyRecord);
	}

    /**
     * 触发单价计算（异步）
     */
    @Operation(summary = "月度加工记录表-触发单价计算")
    @PostMapping(value = "/startCalculation")
    public Result<String> startCalculation(@RequestParam(name = "recordMonth", required = false) String recordMonth) {
        hnMonthlyRecordService.startCalculation(recordMonth);
        return Result.OK("计算任务已异步触发，请稍候刷新页面查看结果");
    }

    /**
     * 手工补录单价
     */
    @Operation(summary = "月度加工记录表-手工补录单价")
    @PutMapping(value = "/manualSetPrice")
    public Result<String> manualSetPrice(
            @RequestParam(name = "id", required = true) Long id,
            @RequestParam(name = "manualPrice", required = true) BigDecimal manualPrice) {
        hnMonthlyRecordService.manualSetPrice(id, manualPrice);
        return Result.OK("手工单价补录成功！");
    }

    /**
     * 导出excel
     *
     * @param request
     * @param hnMonthlyRecord
     */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnMonthlyRecord hnMonthlyRecord) {
        return super.exportXls(request, hnMonthlyRecord, HnMonthlyRecord.class, "月度加工记录表");
    }

    /**
      * 通过excel导入数据
    *
      * @param request
      * @param response
      * @return
      */
    @RequestMapping(value = "/importExcel", method = RequestMethod.POST)
    public Result<?> importExcel(HttpServletRequest request, HttpServletResponse response) {
        return super.importExcel(request, response, HnMonthlyRecord.class);
    }

}
