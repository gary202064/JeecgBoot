package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnWorker;
import org.jeecg.modules.hnworkerwage.service.IHnWorkerService;

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
 * @Description: 工人表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "工人表")
@RestController
@RequestMapping("/hnworkerwage/hnWorker")
@Slf4j
public class HnWorkerController extends JeecgController<HnWorker, IHnWorkerService> {
	@Autowired
	private IHnWorkerService hnWorkerService;

	/**
	 * 分页列表查询
	 *
	 * @param hnWorker
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "工人表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnWorker>> queryPageList(HnWorker hnWorker,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnWorker> queryWrapper = QueryGenerator.initQueryWrapper(hnWorker, req.getParameterMap());
		Page<HnWorker> page = new Page<HnWorker>(pageNo, pageSize);
		IPage<HnWorker> pageList = hnWorkerService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnWorker
	 * @return
	 */
	@Operation(summary = "工人表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnWorker hnWorker) {
		hnWorkerService.save(hnWorker);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnWorker
	 * @return
	 */
	@Operation(summary = "工人表-编辑")
	@RequestMapping(value = "/edit", method = {RequestMethod.PUT,RequestMethod.POST})
	public Result<String> edit(@RequestBody HnWorker hnWorker) {
		hnWorkerService.updateById(hnWorker);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "工人表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnWorkerService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "工人表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		this.hnWorkerService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "工人表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnWorker> queryById(@RequestParam(name="id",required=true) String id) {
		HnWorker hnWorker = hnWorkerService.getById(id);
		if(hnWorker==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnWorker);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnWorker
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnWorker hnWorker) {
        return super.exportXls(request, hnWorker, HnWorker.class, "工人表");
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
        return super.importExcel(request, response, HnWorker.class);
    }

	@Operation(summary = "工人表-获取工人工序熟练度列表")
	@GetMapping(value = "/getProcessAbilities")
	public Result<java.util.List<org.jeecg.modules.hnworkerwage.entity.HnWorkerProcessAbility>> getProcessAbilities(@RequestParam(name="workerId",required=true) Long workerId) {
		java.util.List<org.jeecg.modules.hnworkerwage.entity.HnWorkerProcessAbility> abilities = hnWorkerService.getWorkerProcessAbilities(workerId);
		return Result.OK(abilities);
	}

}
