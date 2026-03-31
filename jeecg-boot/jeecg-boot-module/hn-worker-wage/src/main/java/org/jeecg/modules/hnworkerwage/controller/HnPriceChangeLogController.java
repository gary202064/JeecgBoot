package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnPriceChangeLog;
import org.jeecg.modules.hnworkerwage.service.IHnPriceChangeLogService;

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
 * @Description: 单价变更日志表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "单价变更日志表")
@RestController
@RequestMapping("/hnworkerwage/hnPriceChangeLog")
@Slf4j
public class HnPriceChangeLogController extends JeecgController<HnPriceChangeLog, IHnPriceChangeLogService> {
	@Autowired
	private IHnPriceChangeLogService hnPriceChangeLogService;

	/**
	 * 分页列表查询
	 *
	 * @param hnPriceChangeLog
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "单价变更日志表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnPriceChangeLog>> queryPageList(HnPriceChangeLog hnPriceChangeLog,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnPriceChangeLog> queryWrapper = QueryGenerator.initQueryWrapper(hnPriceChangeLog, req.getParameterMap());
		Page<HnPriceChangeLog> page = new Page<HnPriceChangeLog>(pageNo, pageSize);
		IPage<HnPriceChangeLog> pageList = hnPriceChangeLogService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnPriceChangeLog
	 * @return
	 */
	@Operation(summary = "单价变更日志表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnPriceChangeLog hnPriceChangeLog) {
		hnPriceChangeLogService.save(hnPriceChangeLog);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnPriceChangeLog
	 * @return
	 */
	@Operation(summary = "单价变更日志表-编辑")
	@RequestMapping(value = "/edit", method = {RequestMethod.PUT,RequestMethod.POST})
	public Result<String> edit(@RequestBody HnPriceChangeLog hnPriceChangeLog) {
		hnPriceChangeLogService.updateById(hnPriceChangeLog);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "单价变更日志表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnPriceChangeLogService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "单价变更日志表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		this.hnPriceChangeLogService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "单价变更日志表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnPriceChangeLog> queryById(@RequestParam(name="id",required=true) String id) {
		HnPriceChangeLog hnPriceChangeLog = hnPriceChangeLogService.getById(id);
		if(hnPriceChangeLog==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnPriceChangeLog);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnPriceChangeLog
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnPriceChangeLog hnPriceChangeLog) {
        return super.exportXls(request, hnPriceChangeLog, HnPriceChangeLog.class, "单价变更日志表");
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
        return super.importExcel(request, response, HnPriceChangeLog.class);
    }

}
