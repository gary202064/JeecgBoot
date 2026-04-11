package org.jeecg.modules.hnworkerwage.controller;

import java.math.BigDecimal;
import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnBasePrice;
import org.jeecg.modules.hnworkerwage.service.IHnBasePriceService;

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
 * @Description: 基础单价表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "基础单价表")
@RestController
@RequestMapping("/hnworkerwage/hnBasePrice")
@Slf4j
public class HnBasePriceController extends JeecgController<HnBasePrice, IHnBasePriceService> {

	private final IHnBasePriceService hnBasePriceService;

	public HnBasePriceController(IHnBasePriceService hnBasePriceService) {
		this.hnBasePriceService = hnBasePriceService;
	}

	/**
	 * 分页列表查询
	 *
	 * @param hnBasePrice
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "基础单价表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnBasePrice>> queryPageList(HnBasePrice hnBasePrice,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   @RequestParam(name="minPrice", required=false) BigDecimal minPrice,
								   @RequestParam(name="maxPrice", required=false) BigDecimal maxPrice,
								   HttpServletRequest req) {
		QueryWrapper<HnBasePrice> queryWrapper = QueryGenerator.initQueryWrapper(hnBasePrice, req.getParameterMap());
		if (minPrice != null) {
			queryWrapper.ge("unit_price", minPrice);
		}
		if (maxPrice != null) {
			queryWrapper.le("unit_price", maxPrice);
		}
		Page<HnBasePrice> page = new Page<HnBasePrice>(pageNo, pageSize);
		IPage<HnBasePrice> pageList = hnBasePriceService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnBasePrice
	 * @return
	 */
	@Operation(summary = "基础单价表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnBasePrice hnBasePrice) {
		hnBasePriceService.save(hnBasePrice);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnBasePrice
	 * @return
	 */
	@Operation(summary = "基础单价表-编辑")
	@PutMapping(value = "/edit")
	public Result<String> edit(@RequestBody HnBasePrice hnBasePrice) {
		hnBasePriceService.updateById(hnBasePrice);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "基础单价表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnBasePriceService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "基础单价表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		hnBasePriceService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "基础单价表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnBasePrice> queryById(@RequestParam(name="id",required=true) String id) {
		HnBasePrice hnBasePrice = hnBasePriceService.getById(id);
		if(hnBasePrice==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnBasePrice);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnBasePrice
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnBasePrice hnBasePrice) {
        return super.exportXls(request, hnBasePrice, HnBasePrice.class, "基础单价表");
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
        return super.importExcel(request, response, HnBasePrice.class);
    }

}
