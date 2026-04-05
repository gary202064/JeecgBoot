package org.jeecg.modules.hnworkerwage.mapper;

import org.jeecg.modules.hnworkerwage.entity.HnMaterialCode;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

/**
 * @Description: 物料编码表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
public interface HnMaterialCodeMapper extends BaseMapper<HnMaterialCode> {

    IPage<HnMaterialCode> pageList(Page<HnMaterialCode> page, @Param("materialCode") HnMaterialCode materialCode);
}
