-- =============================================================================
-- hn-worker-wage 模块 — 全量业务表建表 SQL
-- 所有业务表以 hn_ 前缀开头
-- 生成日期: 2026-04-09
-- 共 15 张业务表
-- =============================================================================

-- 1. 设备表
CREATE TABLE IF NOT EXISTS `hn_equipment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `equipment_no` varchar(50) NOT NULL COMMENT '设备编号',
  `type_id` varchar(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `line_id` varchar(100) NOT NULL COMMENT '所属产线 (数据字典 production_line)',
  `status` tinyint DEFAULT '1' COMMENT '状态 (1-正常, 0-停用)',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_equipment_no` (`equipment_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='设备表';

-- 2. 产品表
CREATE TABLE IF NOT EXISTS `hn_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) NOT NULL COMMENT '产品名称',
  `code` varchar(50) NOT NULL COMMENT '产品代码',
  `product_level` varchar(50) DEFAULT NULL COMMENT '产品等级',
  `level_description` varchar(200) DEFAULT NULL COMMENT '等级描述',
  `status` tinyint DEFAULT '1' COMMENT '状态 (1-正常, 0-停用)',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='产品表';

-- 3. 物料编码表
CREATE TABLE IF NOT EXISTS `hn_material_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(100) NOT NULL COMMENT '物料编码',
  `product_id` bigint NOT NULL COMMENT '关联产品ID',
  `spec` varchar(200) DEFAULT NULL COMMENT '规格型号',
  `description` varchar(200) DEFAULT NULL COMMENT '物料描述',
  `status` tinyint DEFAULT '1' COMMENT '状态 (1-正常, 0-停用)',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='物料编码表';

-- 4. 工序表
CREATE TABLE IF NOT EXISTS `hn_process` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) NOT NULL COMMENT '工序名称',
  `code` varchar(50) DEFAULT NULL COMMENT '工序代码',
  `status` tinyint DEFAULT '1' COMMENT '状态 (1-正常, 0-停用)',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序表';

-- 5. 工人表
CREATE TABLE IF NOT EXISTS `hn_worker` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) NOT NULL COMMENT '工人姓名',
  `employee_no` varchar(50) NOT NULL COMMENT '工号',
  `status` tinyint DEFAULT '1' COMMENT '状态 (1-在职, 0-离职)',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_employee_no` (`employee_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工人表';

-- 6. 基础单价表 (第3级定价)
CREATE TABLE IF NOT EXISTS `hn_base_price` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `process_id` bigint NOT NULL COMMENT '工序ID',
  `skill_level` varchar(100) NOT NULL COMMENT '熟练度 (数据字典 skill_level)',
  `unit_price` decimal(10,4) NOT NULL COMMENT '单价',
  `effective_date` date NOT NULL COMMENT '生效日期',
  `status` tinyint DEFAULT '1' COMMENT '状态 (1-启用, 0-禁用)',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='基础单价表 (第3级)';

-- 7. 物料覆盖单价表 (第1级定价 - 最高优先)
CREATE TABLE IF NOT EXISTS `hn_material_override_price` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `process_id` bigint NOT NULL COMMENT '工序ID',
  `skill_level` varchar(100) NOT NULL COMMENT '熟练度 (数据字典 skill_level)',
  `material_code_id` bigint NOT NULL COMMENT '物料编码ID',
  `unit_price` decimal(10,4) NOT NULL COMMENT '单价',
  `effective_date` date NOT NULL COMMENT '生效日期',
  `status` tinyint DEFAULT '1' COMMENT '状态 (1-启用, 0-禁用)',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='物料覆盖单价表 (第1级)';

-- 8. 物料尺寸定义表
CREATE TABLE IF NOT EXISTS `hn_material_dimension` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_code_id` bigint NOT NULL COMMENT '关联的物料编码ID',
  `dimension_name` varchar(50) NOT NULL COMMENT '尺寸维度名称',
  `dimension_value` decimal(10,2) NOT NULL COMMENT '该物料的具体尺寸值',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_dimension` (`material_code_id`, `dimension_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='物料尺寸定义表';

-- 9. 复合定价表 (第2级定价)
CREATE TABLE IF NOT EXISTS `hn_complex_price` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `process_id` bigint NOT NULL COMMENT '关联的工序ID',
  `equipment_type` varchar(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `skill_level` varchar(100) NOT NULL COMMENT '技能等级 (数据字典 skill_level)',
  `dimension_name` varchar(50) NOT NULL COMMENT '尺寸维度名称',
  `range_min` decimal(10,2) NOT NULL COMMENT '尺寸区间的最小值（包含）',
  `range_max` decimal(10,2) NOT NULL COMMENT '尺寸区间的最大值（不包含）',
  `unit_price` decimal(10,4) NOT NULL COMMENT '在此组合下的加工单价',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='复合定价表 (第2级)';

-- 10. 导入批次表
CREATE TABLE IF NOT EXISTS `hn_import_batch` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `file_name` varchar(200) DEFAULT NULL COMMENT '文件名',
  `record_month` varchar(7) DEFAULT NULL COMMENT '所属年月',
  `record_count` int DEFAULT NULL COMMENT '总记录数',
  `success_count` int DEFAULT NULL COMMENT '成功数',
  `fail_count` int DEFAULT NULL COMMENT '失败数',
  `status` enum('SUCCESS','PARTIAL','FAILED') DEFAULT NULL COMMENT '状态',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='导入批次表';

-- 11. 月度加工记录表
CREATE TABLE IF NOT EXISTS `hn_monthly_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `record_month` varchar(7) NOT NULL COMMENT '所属年月',
  `import_batch_id` bigint DEFAULT NULL COMMENT '导入批次ID',
  `worker_id` bigint NOT NULL COMMENT '工人ID',
  `equipment_id` bigint NOT NULL COMMENT '设备ID',
  `line_id` varchar(100) NOT NULL COMMENT '产线 (数据字典 production_line)',
  `material_code_id` bigint NOT NULL COMMENT '物料编码ID',
  `process_id` bigint NOT NULL COMMENT '工序ID',
  `quantity` int NOT NULL COMMENT '合格数量',
  `unit_price` decimal(10,4) DEFAULT NULL COMMENT '计算单价',
  `total_amount` decimal(12,2) DEFAULT NULL COMMENT '总金额',
  `price_source` enum('EQUIPMENT','MATERIAL','BASE','NONE') DEFAULT NULL COMMENT '价格来源',
  `calc_status` enum('CALCULATED','NO_PRICE','SKIPPED','MANUAL') DEFAULT NULL COMMENT '计算状态',
  `manual_price` decimal(10,4) DEFAULT NULL COMMENT '手工补录单价',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='月度加工记录表';

-- 12. 工人-工序能力表
CREATE TABLE IF NOT EXISTS `hn_worker_process_ability` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `worker_id` bigint NOT NULL COMMENT '工人ID',
  `process_id` bigint NOT NULL COMMENT '工序ID',
  `can_full_work` tinyint DEFAULT '1' COMMENT '能力状态 (1-完全掌握, 0-部分受限)',
  `skill_level` varchar(32) DEFAULT NULL COMMENT '熟练度 (数据字典 skill_level)',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_worker_process` (`worker_id`,`process_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工人-工序能力表';

-- 13. 单价变更日志表
CREATE TABLE IF NOT EXISTS `hn_price_change_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_name` varchar(50) DEFAULT NULL COMMENT '来源表 (hn_base_price, etc.)',
  `record_id` bigint DEFAULT NULL COMMENT '来源记录ID',
  `old_price` decimal(10,4) DEFAULT NULL COMMENT '旧单价',
  `new_price` decimal(10,4) DEFAULT NULL COMMENT '新单价',
  `effective_date` date DEFAULT NULL COMMENT '生效日期',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='单价变更日志表';

-- 14. 月度汇总表
CREATE TABLE IF NOT EXISTS `hn_monthly_summary` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `record_month` varchar(7) NOT NULL COMMENT '所属年月',
  `worker_id` bigint NOT NULL COMMENT '工人ID',
  `equipment_id` bigint NOT NULL COMMENT '设备ID',
  `material_code_id` bigint NOT NULL COMMENT '物料编码ID',
  `process_id` bigint NOT NULL COMMENT '工序ID',
  `total_quantity` int NOT NULL COMMENT '总数量',
  `unit_price` decimal(10,4) DEFAULT NULL COMMENT '最终单价',
  `total_amount` decimal(12,2) DEFAULT NULL COMMENT '总金额',
  `record_count` int DEFAULT NULL COMMENT '原始记录数',
  `calc_time` datetime DEFAULT NULL COMMENT '汇总计算时间',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='月度汇总表';

-- 15. 设备类型-工序关联表
CREATE TABLE IF NOT EXISTS `hn_type_process` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type_id` varchar(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `process_id` bigint NOT NULL COMMENT '工序ID',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_type_process` (`type_id`,`process_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='设备类型-工序关联表';
