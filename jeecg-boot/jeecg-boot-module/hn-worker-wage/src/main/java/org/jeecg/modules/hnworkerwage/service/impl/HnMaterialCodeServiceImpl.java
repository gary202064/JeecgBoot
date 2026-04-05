package org.jeecg.modules.hnworkerwage.service.impl;

import org.jeecg.modules.hnworkerwage.entity.HnMaterialCode;
import org.jeecg.modules.hnworkerwage.mapper.HnMaterialCodeMapper;
import org.jeecg.modules.hnworkerwage.service.IHnMaterialCodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

/**
 * @Description: 物料编码表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Service
public class HnMaterialCodeServiceImpl extends ServiceImpl<HnMaterialCodeMapper, HnMaterialCode> implements IHnMaterialCodeService {

    @Autowired
    private HnMaterialCodeMapper hnMaterialCodeMapper;

    @Override
    public IPage<HnMaterialCode> pageList(Page<HnMaterialCode> page, HnMaterialCode materialCode) {
        return hnMaterialCodeMapper.pageList(page, materialCode);
    }
}
