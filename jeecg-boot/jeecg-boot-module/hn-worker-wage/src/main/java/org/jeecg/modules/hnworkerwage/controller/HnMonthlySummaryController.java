package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnMonthlySummary;
import org.jeecg.modules.hnworkerwage.service.IHnMonthlySummaryService;

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
 * @Description: 月度汇总表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "月度汇总表")
@RestController
@RequestMapping("/hnworkerwage/hnMonthlySummary")
@Slf4j
public class HnMonthlySummaryController extends JeecgController<HnMonthlySummary, IHnMonthlySummaryService> {
	@Autowired
	private IHnMonthlySummaryService hnMonthlySummaryService;

	/**
	 * 分页列表查询
	 *
	 * @param hnMonthlySummary
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "月度汇总表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnMonthlySummary>> queryPageList(HnMonthlySummary hnMonthlySummary,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnMonthlySummary> queryWrapper = QueryGenerator.initQueryWrapper(hnMonthlySummary, req.getParameterMap());
		Page<HnMonthlySummary> page = new Page<HnMonthlySummary>(pageNo, pageSize);
		IPage<HnMonthlySummary> pageList = hnMonthlySummaryService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnMonthlySummary
	 * @return
	 */
	@Operation(summary = "月度汇总表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnMonthlySummary hnMonthlySummary) {
		hnMonthlySummaryService.save(hnMonthlySummary);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnMonthlySummary
	 * @return
	 */
	@Operation(summary = "月度汇总表-编辑")
	@RequestMapping(value = "/edit", method = {RequestMethod.PUT,RequestMethod.POST})
	public Result<String> edit(@RequestBody HnMonthlySummary hnMonthlySummary) {
		hnMonthlySummaryService.updateById(hnMonthlySummary);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "月度汇总表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnMonthlySummaryService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "月度汇总表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		this.hnMonthlySummaryService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "月度汇总表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnMonthlySummary> queryById(@RequestParam(name="id",required=true) String id) {
		HnMonthlySummary hnMonthlySummary = hnMonthlySummaryService.getById(id);
		if(hnMonthlySummary==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnMonthlySummary);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnMonthlySummary
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnMonthlySummary hnMonthlySummary) {
        return super.exportXls(request, hnMonthlySummary, HnMonthlySummary.class, "月度汇总表");
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
        return super.importExcel(request, response, HnMonthlySummary.class);
    }

}
