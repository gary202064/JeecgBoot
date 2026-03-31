package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.hnworkerwage.entity.HnImportBatch;
import org.jeecg.modules.hnworkerwage.service.IHnImportBatchService;

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
 * @Description: 导入批次表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name = "导入批次表")
@RestController
@RequestMapping("/hnworkerwage/hnImportBatch")
@Slf4j
public class HnImportBatchController extends JeecgController<HnImportBatch, IHnImportBatchService> {

	private final IHnImportBatchService hnImportBatchService;

	public HnImportBatchController(IHnImportBatchService hnImportBatchService) {
		this.hnImportBatchService = hnImportBatchService;
	}

	/**
	 * 分页列表查询
	 *
	 * @param hnImportBatch
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary = "导入批次表-分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnImportBatch>> queryPageList(HnImportBatch hnImportBatch,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnImportBatch> queryWrapper = QueryGenerator.initQueryWrapper(hnImportBatch, req.getParameterMap());
		Page<HnImportBatch> page = new Page<HnImportBatch>(pageNo, pageSize);
		IPage<HnImportBatch> pageList = hnImportBatchService.page(page, queryWrapper);
		return Result.OK(pageList);
	}

	/**
	 *   添加
	 *
	 * @param hnImportBatch
	 * @return
	 */
	@Operation(summary = "导入批次表-添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnImportBatch hnImportBatch) {
		hnImportBatchService.save(hnImportBatch);
		return Result.OK("添加成功！");
	}

	/**
	 *  编辑
	 *
	 * @param hnImportBatch
	 * @return
	 */
	@Operation(summary = "导入批次表-编辑")
	@PutMapping(value = "/edit")
	public Result<String> edit(@RequestBody HnImportBatch hnImportBatch) {
		hnImportBatchService.updateById(hnImportBatch);
		return Result.OK("编辑成功!");
	}

	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "导入批次表-通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnImportBatchService.removeById(id);
		return Result.OK("删除成功!");
	}

	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary = "导入批次表-批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		hnImportBatchService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}

	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "导入批次表-通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnImportBatch> queryById(@RequestParam(name="id",required=true) String id) {
		HnImportBatch hnImportBatch = hnImportBatchService.getById(id);
		if(hnImportBatch==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnImportBatch);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnImportBatch
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnImportBatch hnImportBatch) {
        return super.exportXls(request, hnImportBatch, HnImportBatch.class, "导入批次表");
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
        return super.importExcel(request, response, HnImportBatch.class);
    }

}
