package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnWorkerProcessAbility;
import org.jeecg.modules.hnworkerwage.service.IHnWorkerProcessAbilityService;

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
 * @Description: 工人-工序能力表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "工人-工序能力表")
@RestController
@RequestMapping("/hnworkerwage/hnWorkerProcessAbility")
@Slf4j
public class HnWorkerProcessAbilityController extends JeecgController<HnWorkerProcessAbility, IHnWorkerProcessAbilityService> {

	private final IHnWorkerProcessAbilityService hnWorkerProcessAbilityService;

	public HnWorkerProcessAbilityController(IHnWorkerProcessAbilityService hnWorkerProcessAbilityService) {
		this.hnWorkerProcessAbilityService = hnWorkerProcessAbilityService;
	}

	/**
	 * 分页列表查询
	 *
	 * @param hnWorkerProcessAbility
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "工人-工序能力表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnWorkerProcessAbility>> queryPageList(HnWorkerProcessAbility hnWorkerProcessAbility,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnWorkerProcessAbility> queryWrapper = QueryGenerator.initQueryWrapper(hnWorkerProcessAbility, req.getParameterMap());
		Page<HnWorkerProcessAbility> page = new Page<HnWorkerProcessAbility>(pageNo, pageSize);
		IPage<HnWorkerProcessAbility> pageList = hnWorkerProcessAbilityService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnWorkerProcessAbility
	 * @return
	 */
	@Operation(summary = "工人-工序能力表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnWorkerProcessAbility hnWorkerProcessAbility) {
		hnWorkerProcessAbilityService.save(hnWorkerProcessAbility);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnWorkerProcessAbility
	 * @return
	 */
	@Operation(summary = "工人-工序能力表-编辑")
	@PutMapping(value = "/edit")
	public Result<String> edit(@RequestBody HnWorkerProcessAbility hnWorkerProcessAbility) {
		hnWorkerProcessAbilityService.updateById(hnWorkerProcessAbility);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "工人-工序能力表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnWorkerProcessAbilityService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "工人-工序能力表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		hnWorkerProcessAbilityService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "工人-工序能力表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnWorkerProcessAbility> queryById(@RequestParam(name="id",required=true) String id) {
		HnWorkerProcessAbility hnWorkerProcessAbility = hnWorkerProcessAbilityService.getById(id);
		if(hnWorkerProcessAbility==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnWorkerProcessAbility);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnWorkerProcessAbility
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnWorkerProcessAbility hnWorkerProcessAbility) {
        return super.exportXls(request, hnWorkerProcessAbility, HnWorkerProcessAbility.class, "工人-工序能力表");
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
        return super.importExcel(request, response, HnWorkerProcessAbility.class);
    }

}
