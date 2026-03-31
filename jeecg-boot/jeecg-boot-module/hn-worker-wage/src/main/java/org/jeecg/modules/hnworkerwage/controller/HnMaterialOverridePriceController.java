package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnMaterialOverridePrice;
import org.jeecg.modules.hnworkerwage.service.IHnMaterialOverridePriceService;

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
 * @Description: 物料覆盖单价表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "物料覆盖单价表")
@RestController
@RequestMapping("/hnworkerwage/hnMaterialOverridePrice")
@Slf4j
public class HnMaterialOverridePriceController extends JeecgController<HnMaterialOverridePrice, IHnMaterialOverridePriceService> {

	private final IHnMaterialOverridePriceService hnMaterialOverridePriceService;

	public HnMaterialOverridePriceController(IHnMaterialOverridePriceService hnMaterialOverridePriceService) {
		this.hnMaterialOverridePriceService = hnMaterialOverridePriceService;
	}

	/**
	 * 分页列表查询
	 *
	 * @param hnMaterialOverridePrice
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "物料覆盖单价表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnMaterialOverridePrice>> queryPageList(HnMaterialOverridePrice hnMaterialOverridePrice,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnMaterialOverridePrice> queryWrapper = QueryGenerator.initQueryWrapper(hnMaterialOverridePrice, req.getParameterMap());
		Page<HnMaterialOverridePrice> page = new Page<HnMaterialOverridePrice>(pageNo, pageSize);
		IPage<HnMaterialOverridePrice> pageList = hnMaterialOverridePriceService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnMaterialOverridePrice
	 * @return
	 */
	@Operation(summary = "物料覆盖单价表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnMaterialOverridePrice hnMaterialOverridePrice) {
		hnMaterialOverridePriceService.save(hnMaterialOverridePrice);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnMaterialOverridePrice
	 * @return
	 */
	@Operation(summary = "物料覆盖单价表-编辑")
	@PutMapping(value = "/edit")
	public Result<String> edit(@RequestBody HnMaterialOverridePrice hnMaterialOverridePrice) {
		hnMaterialOverridePriceService.updateById(hnMaterialOverridePrice);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "物料覆盖单价表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnMaterialOverridePriceService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "物料覆盖单价表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		hnMaterialOverridePriceService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "物料覆盖单价表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnMaterialOverridePrice> queryById(@RequestParam(name="id",required=true) String id) {
		HnMaterialOverridePrice hnMaterialOverridePrice = hnMaterialOverridePriceService.getById(id);
		if(hnMaterialOverridePrice==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnMaterialOverridePrice);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnMaterialOverridePrice
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnMaterialOverridePrice hnMaterialOverridePrice) {
        return super.exportXls(request, hnMaterialOverridePrice, HnMaterialOverridePrice.class, "物料覆盖单价表");
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
        return super.importExcel(request, response, HnMaterialOverridePrice.class);
    }

}
