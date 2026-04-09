package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnMaterialDimension;
import org.jeecg.modules.hnworkerwage.service.IHnMaterialDimensionService;

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
 * @Description: 物料尺寸定义表
 * @Author: jeecg-boot
 * @Date:   2026-04-09
 * @Version: V1.0
 */
@Tag(name = "物料尺寸定义表")
@RestController
@RequestMapping("/hnworkerwage/hnMaterialDimension")
@Slf4j
public class HnMaterialDimensionController extends JeecgController<HnMaterialDimension, IHnMaterialDimensionService> {

	private final IHnMaterialDimensionService hnMaterialDimensionService;

	public HnMaterialDimensionController(IHnMaterialDimensionService hnMaterialDimensionService) {
		this.hnMaterialDimensionService = hnMaterialDimensionService;
	}

	/**
	 * 分页列表查询
	 *
	 * @param hnMaterialDimension
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "物料尺寸定义表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnMaterialDimension>> queryPageList(HnMaterialDimension hnMaterialDimension,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnMaterialDimension> queryWrapper = QueryGenerator.initQueryWrapper(hnMaterialDimension, req.getParameterMap());
		Page<HnMaterialDimension> page = new Page<HnMaterialDimension>(pageNo, pageSize);
		IPage<HnMaterialDimension> pageList = hnMaterialDimensionService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnMaterialDimension
	 * @return
	 */
	@Operation(summary = "物料尺寸定义表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnMaterialDimension hnMaterialDimension) {
		hnMaterialDimensionService.save(hnMaterialDimension);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnMaterialDimension
	 * @return
	 */
	@Operation(summary = "物料尺寸定义表-编辑")
	@PutMapping(value = "/edit")
	public Result<String> edit(@RequestBody HnMaterialDimension hnMaterialDimension) {
		hnMaterialDimensionService.updateById(hnMaterialDimension);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "物料尺寸定义表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnMaterialDimensionService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "物料尺寸定义表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		hnMaterialDimensionService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "物料尺寸定义表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnMaterialDimension> queryById(@RequestParam(name="id",required=true) String id) {
		HnMaterialDimension hnMaterialDimension = hnMaterialDimensionService.getById(id);
		if(hnMaterialDimension==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnMaterialDimension);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnMaterialDimension
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnMaterialDimension hnMaterialDimension) {
        return super.exportXls(request, hnMaterialDimension, HnMaterialDimension.class, "物料尺寸定义表");
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
        return super.importExcel(request, response, HnMaterialDimension.class);
    }

}
