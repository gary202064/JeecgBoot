package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnEquipment;
import org.jeecg.modules.hnworkerwage.service.IHnEquipmentService;

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
 * @Description: 设备表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "设备表")
@RestController
@RequestMapping("/hnworkerwage/hnEquipment")
@Slf4j
public class HnEquipmentController extends JeecgController<HnEquipment, IHnEquipmentService> {

	private final IHnEquipmentService hnEquipmentService;

	public HnEquipmentController(IHnEquipmentService hnEquipmentService) {
		this.hnEquipmentService = hnEquipmentService;
	}

	/**
	 * 分页列表查询
	 *
	 * @param hnEquipment
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "设备表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnEquipment>> queryPageList(HnEquipment hnEquipment,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnEquipment> queryWrapper = QueryGenerator.initQueryWrapper(hnEquipment, req.getParameterMap());
		queryWrapper.orderByAsc("equipment_no");
		Page<HnEquipment> page = new Page<HnEquipment>(pageNo, pageSize);
		IPage<HnEquipment> pageList = hnEquipmentService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnEquipment
	 * @return
	 */
	@Operation(summary = "设备表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnEquipment hnEquipment) {
		hnEquipmentService.save(hnEquipment);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnEquipment
	 * @return
	 */
	@Operation(summary = "设备表-编辑")
	@PutMapping(value = "/edit")
	public Result<String> edit(@RequestBody HnEquipment hnEquipment) {
		hnEquipmentService.updateById(hnEquipment);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "设备表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnEquipmentService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "设备表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		hnEquipmentService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "设备表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnEquipment> queryById(@RequestParam(name="id",required=true) String id) {
		HnEquipment hnEquipment = hnEquipmentService.getById(id);
		if(hnEquipment==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnEquipment);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnEquipment
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnEquipment hnEquipment) {
        return super.exportXls(request, hnEquipment, HnEquipment.class, "设备表");
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
        return super.importExcel(request, response, HnEquipment.class);
    }

}
