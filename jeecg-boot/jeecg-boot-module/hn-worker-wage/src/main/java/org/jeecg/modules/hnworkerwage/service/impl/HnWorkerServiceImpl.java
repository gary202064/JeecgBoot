package org.jeecg.modules.hnworkerwage.service.impl;

import org.jeecg.modules.hnworkerwage.entity.HnWorker;
import org.jeecg.modules.hnworkerwage.mapper.HnWorkerMapper;
import org.jeecg.modules.hnworkerwage.service.IHnWorkerService;
import org.jeecg.modules.hnworkerwage.entity.HnWorkerProcessAbility;
import org.jeecg.modules.hnworkerwage.service.IHnWorkerProcessAbilityService;
import org.springframework.beans.factory.annotation.Autowired;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description: 工人表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
@Service
public class HnWorkerServiceImpl extends ServiceImpl<HnWorkerMapper, HnWorker> implements IHnWorkerService {

    @Autowired
    private IHnWorkerProcessAbilityService hnWorkerProcessAbilityService;

    @Override
    public List<HnWorkerProcessAbility> getWorkerProcessAbilities(Long workerId) {
        LambdaQueryWrapper<HnWorkerProcessAbility> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(HnWorkerProcessAbility::getWorkerId, workerId);
        return hnWorkerProcessAbilityService.list(queryWrapper);
    }
}
