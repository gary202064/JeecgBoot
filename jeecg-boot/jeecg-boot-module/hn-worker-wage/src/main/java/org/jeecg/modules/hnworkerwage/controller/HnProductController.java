package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnProduct;
import org.jeecg.modules.hnworkerwage.service.IHnProductService;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
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
 * @Description: 产品表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "产品表")
@RestController
@RequestMapping("/hnworkerwage/hnProduct")
@Slf4j
public class HnProductController extends JeecgController<HnProduct, IHnProductService> {
	@Autowired
	private IHnProductService hnProductService;

	/**
	 * 分页列表查询
	 *
	 * @param hnProduct
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "产品表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnProduct>> queryPageList(HnProduct hnProduct,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnProduct> queryWrapper = QueryGenerator.initQueryWrapper(hnProduct, req.getParameterMap());
		Page<HnProduct> page = new Page<HnProduct>(pageNo, pageSize);
		IPage<HnProduct> pageList = hnProductService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnProduct
	 * @return
	 */
	@Operation(summary = "产品表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnProduct hnProduct) {
		LambdaQueryWrapper<HnProduct> queryWrapper = new LambdaQueryWrapper<>();
		queryWrapper.eq(HnProduct::getCode, hnProduct.getCode());
		if (hnProductService.count(queryWrapper) > 0) {
			return Result.error("产品代码已存在，请重新输入！");
		}
		hnProductService.save(hnProduct);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnProduct
	 * @return
	 */
	@Operation(summary = "产品表-编辑")
	@RequestMapping(value = "/edit", method = {RequestMethod.PUT,RequestMethod.POST})
	public Result<String> edit(@RequestBody HnProduct hnProduct) {
		LambdaQueryWrapper<HnProduct> queryWrapper = new LambdaQueryWrapper<>();
		queryWrapper.eq(HnProduct::getCode, hnProduct.getCode());
		queryWrapper.ne(HnProduct::getId, hnProduct.getId());
		if (hnProductService.count(queryWrapper) > 0) {
			return Result.error("产品代码已存在，请重新输入！");
		}
		hnProductService.updateById(hnProduct);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "产品表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnProductService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "产品表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		this.hnProductService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "产品表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnProduct> queryById(@RequestParam(name="id",required=true) String id) {
		HnProduct hnProduct = hnProductService.getById(id);
		if(hnProduct==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnProduct);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnProduct
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnProduct hnProduct) {
        return super.exportXls(request, hnProduct, HnProduct.class, "产品表");
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
        return super.importExcel(request, response, HnProduct.class);
    }

}
