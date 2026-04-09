package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnComplexPrice;
import org.jeecg.modules.hnworkerwage.service.IHnComplexPriceService;

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
 * @Description: 复合定价表
 * @Author: jeecg-boot
 * @Date:   2026-04-09
 * @Version: V1.0
 */
@Tag(name = "复合定价表")
@RestController
@RequestMapping("/hnworkerwage/hnComplexPrice")
@Slf4j
public class HnComplexPriceController extends JeecgController<HnComplexPrice, IHnComplexPriceService> {

	private final IHnComplexPriceService hnComplexPriceService;

	public HnComplexPriceController(IHnComplexPriceService hnComplexPriceService) {
		this.hnComplexPriceService = hnComplexPriceService;
	}

	/**
	 * 分页列表查询
	 *
	 * @param hnComplexPrice
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "复合定价表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnComplexPrice>> queryPageList(HnComplexPrice hnComplexPrice,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnComplexPrice> queryWrapper = QueryGenerator.initQueryWrapper(hnComplexPrice, req.getParameterMap());
		Page<HnComplexPrice> page = new Page<HnComplexPrice>(pageNo, pageSize);
		IPage<HnComplexPrice> pageList = hnComplexPriceService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnComplexPrice
	 * @return
	 */
	@Operation(summary = "复合定价表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnComplexPrice hnComplexPrice) {
		hnComplexPriceService.save(hnComplexPrice);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnComplexPrice
	 * @return
	 */
	@Operation(summary = "复合定价表-编辑")
	@PutMapping(value = "/edit")
	public Result<String> edit(@RequestBody HnComplexPrice hnComplexPrice) {
		hnComplexPriceService.updateById(hnComplexPrice);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "复合定价表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnComplexPriceService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "复合定价表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		hnComplexPriceService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "复合定价表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnComplexPrice> queryById(@RequestParam(name="id",required=true) String id) {
		HnComplexPrice hnComplexPrice = hnComplexPriceService.getById(id);
		if(hnComplexPrice==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnComplexPrice);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnComplexPrice
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnComplexPrice hnComplexPrice) {
        return super.exportXls(request, hnComplexPrice, HnComplexPrice.class, "复合定价表");
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
        return super.importExcel(request, response, HnComplexPrice.class);
    }

}
