package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnProcess;
import org.jeecg.modules.hnworkerwage.service.IHnProcessService;

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
 * @Description: 工序表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "工序表")
@RestController
@RequestMapping("/hnworkerwage/hnProcess")
@Slf4j
public class HnProcessController extends JeecgController<HnProcess, IHnProcessService> {
	@Autowired
	private IHnProcessService hnProcessService;

	/**
	 * 分页列表查询
	 *
	 * @param hnProcess
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "工序表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnProcess>> queryPageList(HnProcess hnProcess,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnProcess> queryWrapper = QueryGenerator.initQueryWrapper(hnProcess, req.getParameterMap());
		Page<HnProcess> page = new Page<HnProcess>(pageNo, pageSize);
		IPage<HnProcess> pageList = hnProcessService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnProcess
	 * @return
	 */
	@Operation(summary = "工序表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnProcess hnProcess) {
		hnProcessService.save(hnProcess);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnProcess
	 * @return
	 */
	@Operation(summary = "工序表-编辑")
	@RequestMapping(value = "/edit", method = {RequestMethod.PUT,RequestMethod.POST})
	public Result<String> edit(@RequestBody HnProcess hnProcess) {
		hnProcessService.updateById(hnProcess);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "工序表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnProcessService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "工序表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		this.hnProcessService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "工序表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnProcess> queryById(@RequestParam(name="id",required=true) String id) {
		HnProcess hnProcess = hnProcessService.getById(id);
		if(hnProcess==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnProcess);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnProcess
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnProcess hnProcess) {
        return super.exportXls(request, hnProcess, HnProcess.class, "工序表");
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
        return super.importExcel(request, response, HnProcess.class);
    }

}
