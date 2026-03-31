package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnEquipmentOverridePrice;
import org.jeecg.modules.hnworkerwage.service.IHnEquipmentOverridePriceService;

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
 * @Description: 设备专属单价表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "设备专属单价表")
@RestController
@RequestMapping("/hnworkerwage/hnEquipmentOverridePrice")
@Slf4j
public class HnEquipmentOverridePriceController extends JeecgController<HnEquipmentOverridePrice, IHnEquipmentOverridePriceService> {

	private final IHnEquipmentOverridePriceService hnEquipmentOverridePriceService;

	public HnEquipmentOverridePriceController(IHnEquipmentOverridePriceService hnEquipmentOverridePriceService) {
		this.hnEquipmentOverridePriceService = hnEquipmentOverridePriceService;
	}

	/**
	 * 分页列表查询
	 *
	 * @param hnEquipmentOverridePrice
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "设备专属单价表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnEquipmentOverridePrice>> queryPageList(HnEquipmentOverridePrice hnEquipmentOverridePrice,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnEquipmentOverridePrice> queryWrapper = QueryGenerator.initQueryWrapper(hnEquipmentOverridePrice, req.getParameterMap());
		Page<HnEquipmentOverridePrice> page = new Page<HnEquipmentOverridePrice>(pageNo, pageSize);
		IPage<HnEquipmentOverridePrice> pageList = hnEquipmentOverridePriceService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnEquipmentOverridePrice
	 * @return
	 */
	@Operation(summary = "设备专属单价表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnEquipmentOverridePrice hnEquipmentOverridePrice) {
		hnEquipmentOverridePriceService.save(hnEquipmentOverridePrice);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnEquipmentOverridePrice
	 * @return
	 */
	@Operation(summary = "设备专属单价表-编辑")
	@PutMapping(value = "/edit")
	public Result<String> edit(@RequestBody HnEquipmentOverridePrice hnEquipmentOverridePrice) {
		hnEquipmentOverridePriceService.updateById(hnEquipmentOverridePrice);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "设备专属单价表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnEquipmentOverridePriceService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "设备专属单价表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		hnEquipmentOverridePriceService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "设备专属单价表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnEquipmentOverridePrice> queryById(@RequestParam(name="id",required=true) String id) {
		HnEquipmentOverridePrice hnEquipmentOverridePrice = hnEquipmentOverridePriceService.getById(id);
		if(hnEquipmentOverridePrice==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnEquipmentOverridePrice);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnEquipmentOverridePrice
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnEquipmentOverridePrice hnEquipmentOverridePrice) {
        return super.exportXls(request, hnEquipmentOverridePrice, HnEquipmentOverridePrice.class, "设备专属单价表");
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
        return super.importExcel(request, response, HnEquipmentOverridePrice.class);
    }

}
