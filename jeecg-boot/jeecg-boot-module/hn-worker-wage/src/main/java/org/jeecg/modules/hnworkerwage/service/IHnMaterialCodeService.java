package org.jeecg.modules.hnworkerwage.service;

import org.jeecg.modules.hnworkerwage.entity.HnMaterialCode;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * @Description: 物料编码表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
public interface IHnMaterialCodeService extends IService<HnMaterialCode> {

    IPage<HnMaterialCode> pageList(Page<HnMaterialCode> page, HnMaterialCode materialCode);
}
