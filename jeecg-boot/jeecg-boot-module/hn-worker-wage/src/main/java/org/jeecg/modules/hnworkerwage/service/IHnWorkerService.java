package org.jeecg.modules.hnworkerwage.service;

import org.jeecg.modules.hnworkerwage.entity.HnWorker;
import com.baomidou.mybatisplus.extension.service.IService;

import org.jeecg.modules.hnworkerwage.entity.HnWorkerProcessAbility;

import java.util.List;

/**
 * @Description: 工人表
 * @Author: jeecg-boot
 * @Date:   2026-03-30
 * @Version: V1.0
 */
public interface IHnWorkerService extends IService<HnWorker> {

    List<HnWorkerProcessAbility> getWorkerProcessAbilities(Long workerId);
}
