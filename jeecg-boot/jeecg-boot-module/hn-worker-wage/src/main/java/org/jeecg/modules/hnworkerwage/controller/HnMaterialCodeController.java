package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnMaterialCode;
import org.jeecg.modules.hnworkerwage.entity.HnProduct;
import org.jeecg.modules.hnworkerwage.service.IHnMaterialCodeService;
import org.jeecg.modules.hnworkerwage.service.IHnProductService;

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
 * @Description: 物料编码表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "物料编码表")
@RestController
@RequestMapping("/hnworkerwage/hnMaterialCode")
@Slf4j
public class HnMaterialCodeController extends JeecgController<HnMaterialCode, IHnMaterialCodeService> {

	@Autowired
	private IHnMaterialCodeService hnMaterialCodeService;

	/**
	 * 分页列表查询
	 *
	 * @param hnMaterialCode
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "物料编码表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnMaterialCode>> queryPageList(HnMaterialCode hnMaterialCode,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		Page<HnMaterialCode> page = new Page<HnMaterialCode>(pageNo, pageSize);
		IPage<HnMaterialCode> pageList = hnMaterialCodeService.pageList(page, hnMaterialCode);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnMaterialCode
	 * @return
	 */
	@Operation(summary = "物料编码表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnMaterialCode hnMaterialCode) {
		hnMaterialCodeService.save(hnMaterialCode);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnMaterialCode
	 * @return
	 */
	@Operation(summary = "物料编码表-编辑")
	@PutMapping(value = "/edit")
	public Result<String> edit(@RequestBody HnMaterialCode hnMaterialCode) {
		hnMaterialCodeService.updateById(hnMaterialCode);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "物料编码表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnMaterialCodeService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "物料编码表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		hnMaterialCodeService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "物料编码表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnMaterialCode> queryById(@RequestParam(name="id",required=true) String id) {
		HnMaterialCode hnMaterialCode = hnMaterialCodeService.getById(id);
		if(hnMaterialCode==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnMaterialCode);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnMaterialCode
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnMaterialCode hnMaterialCode) {
        return super.exportXls(request, hnMaterialCode, HnMaterialCode.class, "物料编码表");
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
        return super.importExcel(request, response, HnMaterialCode.class);
    }

}
