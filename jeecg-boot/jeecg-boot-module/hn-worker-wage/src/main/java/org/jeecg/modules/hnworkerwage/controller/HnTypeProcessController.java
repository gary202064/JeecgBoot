package org.jeecg.modules.hnworkerwage.controller;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.common.util.oConvertUtils;
import org.jeecg.modules.hnworkerwage.entity.HnTypeProcess;
import org.jeecg.modules.hnworkerwage.service.IHnTypeProcessService;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.extern.slf4j.Slf4j;

import org.jeecgframework.poi.excel.ExcelImportUtil;
import org.jeecgframework.poi.excel.def.NormalExcelConstants;
import org.jeecgframework.poi.excel.entity.ExportParams;
import org.jeecgframework.poi.excel.entity.ImportParams;
import org.jeecgframework.poi.excel.view.JeecgEntityExcelView;
import org.jeecg.common.system.base.controller.JeecgController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import com.alibaba.fastjson.JSON;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

 /**
 * @Description: 设备类型-工序关联表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Tag(name="设备类型-工序关联表")
@RestController
@RequestMapping("/hnworkerwage/hnTypeProcess")
@Slf4j
public class HnTypeProcessController extends JeecgController<HnTypeProcess, IHnTypeProcessService> {
	@Autowired
	private IHnTypeProcessService hnTypeProcessService;
	
	/**
	 * 分页列表查询
	 *
	 * @param hnTypeProcess
	 * @param pageNo
	 * @param pageSize
	 * @param req
	 * @return
	 */
	@Operation(summary="分页列表查询")
	@GetMapping(value = "/list")
	public Result<IPage<HnTypeProcess>> queryPageList(HnTypeProcess hnTypeProcess,
								   @RequestParam(name="pageNo", defaultValue="1") Integer pageNo,
								   @RequestParam(name="pageSize", defaultValue="10") Integer pageSize,
								   HttpServletRequest req) {
		QueryWrapper<HnTypeProcess> queryWrapper = QueryGenerator.initQueryWrapper(hnTypeProcess, req.getParameterMap());
		Page<HnTypeProcess> page = new Page<HnTypeProcess>(pageNo, pageSize);
		IPage<HnTypeProcess> pageList = hnTypeProcessService.page(page, queryWrapper);
		return Result.OK(pageList);
	}
	
	/**
	 *   添加
	 *
	 * @param hnTypeProcess
	 * @return
	 */
	@Operation(summary="添加")
	@PostMapping(value = "/add")
	public Result<String> add(@RequestBody HnTypeProcess hnTypeProcess) {
		hnTypeProcessService.save(hnTypeProcess);
		return Result.OK("添加成功！");
	}
	
	/**
	 *  编辑
	 *
	 * @param hnTypeProcess
	 * @return
	 */
	@Operation(summary="编辑")
	@RequestMapping(value = "/edit", method = {RequestMethod.PUT,RequestMethod.POST})
	public Result<String> edit(@RequestBody HnTypeProcess hnTypeProcess) {
		hnTypeProcessService.updateById(hnTypeProcess);
		return Result.OK("编辑成功!");
	}
	
	/**
	 *   通过id删除
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary="通过id删除")
	@DeleteMapping(value = "/delete")
	public Result<String> delete(@RequestParam(name="id",required=true) String id) {
		hnTypeProcessService.removeById(id);
		return Result.OK("删除成功!");
	}
	
	/**
	 *  批量删除
	 *
	 * @param ids
	 * @return
	 */
	@Operation(summary="批量删除")
	@DeleteMapping(value = "/deleteBatch")
	public Result<String> deleteBatch(@RequestParam(name="ids",required=true) String ids) {
		this.hnTypeProcessService.removeByIds(Arrays.asList(ids.split(",")));
		return Result.OK("批量删除成功!");
	}
	
	/**
	 * 通过id查询
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary="通过id查询")
	@GetMapping(value = "/queryById")
	public Result<HnTypeProcess> queryById(@RequestParam(name="id",required=true) String id) {
		HnTypeProcess hnTypeProcess = hnTypeProcessService.getById(id);
		if(hnTypeProcess==null) {
			return Result.error("未找到对应数据");
		}
		return Result.OK(hnTypeProcess);
	}

    /**
    * 导出excel
    *
    * @param request
    * @param hnTypeProcess
    */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, HnTypeProcess hnTypeProcess) {
        return super.exportXls(request, hnTypeProcess, HnTypeProcess.class, "设备类型-工序关联表");
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
        return super.importExcel(request, response, HnTypeProcess.class);
    }

}
