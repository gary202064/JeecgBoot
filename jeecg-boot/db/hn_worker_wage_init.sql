-- =============================================================================
-- hn-worker-wage 模块 一键初始化 SQL
-- 版本: v2.0 | 生成日期: 2026-04-10
-- 内容:
--   Part1: 15张业务表建表 DDL（CREATE TABLE IF NOT EXISTS，幂等）
--   Part2: 9个数据字典初始化（幂等 INSERT）
--   Part3: 菜单权限（主菜单 + 16个子菜单 + 角色绑定，幂等 INSERT）
-- 说明: 所有语句均幂等，可在已有数据库上重复执行，不会重复插入
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================================
-- Part1: 业务表 DDL（15张表）
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 表1: hn_product（产品表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_product` (
  `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`         varchar(100) NOT NULL COMMENT '产品名称',
  `code`         varchar(50)  NOT NULL COMMENT '产品代码',
  `product_level` varchar(50) DEFAULT NULL COMMENT '产品原材料类型 (数据字典 material_type，如：毛胚、半成品、成品)',
  `status`       tinyint      DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`    varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time`  datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`    varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time`  datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64)  DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='产品表';

-- ---------------------------------------------------------------------------
-- 表2: hn_process（工序表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_process` (
  `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`         varchar(100) NOT NULL COMMENT '工序名称',
  `code`         varchar(50)  DEFAULT NULL COMMENT '工序代码',
  `status`       tinyint      DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`    varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time`  datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`    varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time`  datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64)  DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_process_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序表';

-- ---------------------------------------------------------------------------
-- 表3: hn_equipment（设备表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_equipment` (
  `id`               bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `equipment_name`   varchar(100) NOT NULL COMMENT '设备名称',
  `equipment_no`     varchar(50)  NOT NULL COMMENT '设备编号',
  `equipment_type`   varchar(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `production_line`  varchar(100) NOT NULL COMMENT '所属产线 (数据字典 production_line)',
  `status`          tinyint      DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`       varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time`     datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`       varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time`     datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`    varchar(64)  DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_equipment_no` (`equipment_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='设备表';

-- ---------------------------------------------------------------------------
-- 表4: hn_worker（工人表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_worker` (
  `id`           bigint      NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`         varchar(50) NOT NULL COMMENT '工人姓名',
  `employee_no`  varchar(50) NOT NULL COMMENT '工号',
  `status`       tinyint     DEFAULT '1' COMMENT '在职状态 (数据字典 work_status，1-在职/0-离职)',
  `create_by`    varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time`  datetime    DEFAULT NULL COMMENT '创建日期',
  `update_by`    varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time`  datetime    DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_employee_no` (`employee_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工人表';

-- ---------------------------------------------------------------------------
-- 表5: hn_material_code（物料编码表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_material_code` (
  `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code`         varchar(100) NOT NULL COMMENT '物料编码',
  `product_id`   bigint       NOT NULL COMMENT '关联产品ID (hn_product.id)',
  `spec`         varchar(200) DEFAULT NULL COMMENT '规格型号',
  `description`  varchar(200) DEFAULT NULL COMMENT '物料描述',
  `status`       tinyint      DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`    varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time`  datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`    varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time`  datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64)  DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='物料编码表';

-- ---------------------------------------------------------------------------
-- 表6: hn_material_dimension（物料尺寸定义表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_material_dimension` (
  `id`               bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_code_id` bigint        NOT NULL COMMENT '关联物料编码ID (hn_material_code.id)',
  `dimension_name`   varchar(100)  NOT NULL COMMENT '尺寸维度名称（如：长度、宽度、厚度）',
  `dimension_value`  decimal(10,2) NOT NULL COMMENT '该物料的具体尺寸值',
  `create_by`        varchar(50)   DEFAULT NULL COMMENT '创建人',
  `create_time`      datetime      DEFAULT NULL COMMENT '创建日期',
  `update_by`        varchar(50)   DEFAULT NULL COMMENT '更新人',
  `update_time`      datetime      DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`     varchar(64)   DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_dimension` (`material_code_id`, `dimension_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='物料尺寸定义表';

-- ---------------------------------------------------------------------------
-- 表7: hn_type_process（设备类型-工序关联表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_type_process` (
  `id`             bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `equipment_type` varchar(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `process_id`     bigint       NOT NULL COMMENT '关联工序ID (hn_process.id)',
  `create_by`      varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time`    datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`      varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time`    datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`   varchar(64)  DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_type_process` (`equipment_type`, `process_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='设备类型-工序关联表';

-- ---------------------------------------------------------------------------
-- 表8: hn_worker_process_ability（工人-工序能力表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_worker_process_ability` (
  `id`            bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `worker_id`     bigint       NOT NULL COMMENT '工人ID (hn_worker.id)',
  `process_id`    bigint       NOT NULL COMMENT '工序ID (hn_process.id)',
  `can_full_work` tinyint      DEFAULT '0' COMMENT '能力状态 (数据字典 ability_status，1-可全工/0-不可)',
  `skill_level`   varchar(100) DEFAULT NULL COMMENT '该工人在此工序的熟练度 (数据字典 skill_level)',
  `create_by`     varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time`   datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`     varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time`   datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`  varchar(64)  DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_worker_process` (`worker_id`, `process_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工人-工序能力表';

-- ---------------------------------------------------------------------------
-- 表9: hn_base_price（基础单价表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_base_price` (
  `id`             bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id`     bigint        NOT NULL COMMENT '关联产品ID (hn_product.id)',
  `equipment_type` varchar(100)  NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `process_id`     bigint        NOT NULL COMMENT '关联工序ID (hn_process.id)',
  `skill_level`    varchar(100)  DEFAULT NULL COMMENT '工人熟练度 (数据字典 skill_level)',
  `unit_price`     decimal(10,4) NOT NULL COMMENT '单价',
  `effective_date` date          DEFAULT NULL COMMENT '生效日期',
  `status`         tinyint       DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`      varchar(50)   DEFAULT NULL COMMENT '创建人',
  `create_time`    datetime      DEFAULT NULL COMMENT '创建日期',
  `update_by`      varchar(50)   DEFAULT NULL COMMENT '更新人',
  `update_time`    datetime      DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`   varchar(64)   DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_price` (`product_id`, `equipment_type`, `process_id`, `skill_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='基础单价表';

-- ---------------------------------------------------------------------------
-- 表10: hn_complex_price（复合定价表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_complex_price` (
  `id`             bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `process_id`     bigint        NOT NULL COMMENT '关联工序ID (hn_process.id)',
  `equipment_type` varchar(100)  NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `skill_level`    varchar(100)  DEFAULT NULL COMMENT '技能等级 (数据字典 skill_level)',
  `dimension_name` varchar(100)  NOT NULL COMMENT '参与定价的尺寸维度名称（如：长度）',
  `range_min_op`   varchar(2)    DEFAULT NULL COMMENT '最小值运算符 (>=, >)，NULL表示无下限',
  `range_min`      decimal(10,2) DEFAULT NULL COMMENT '尺寸区间最小值，NULL表示无下限',
  `range_max_op`   varchar(2)    DEFAULT NULL COMMENT '最大值运算符 (<=, <)，NULL表示无上限',
  `range_max`      decimal(10,2) DEFAULT NULL COMMENT '尺寸区间最大值，NULL表示无上限',
  `unit_price`     decimal(10,4) NOT NULL COMMENT '此组合下的加工单价',
  `create_by`      varchar(50)   DEFAULT NULL COMMENT '创建人',
  `create_time`    datetime      DEFAULT NULL COMMENT '创建日期',
  `update_by`      varchar(50)   DEFAULT NULL COMMENT '更新人',
  `update_time`    datetime      DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`   varchar(64)   DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_complex_price` (`process_id`, `equipment_type`, `skill_level`, `dimension_name`, `range_min`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='复合定价表';

-- ---------------------------------------------------------------------------
-- 表11: hn_material_override_price（物料覆盖单价表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_material_override_price` (
  `id`               bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id`       bigint        NOT NULL COMMENT '关联产品ID (hn_product.id)',
  `equipment_type`   varchar(100)  NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `process_id`       bigint        NOT NULL COMMENT '关联工序ID (hn_process.id)',
  `skill_level`      varchar(100)  DEFAULT NULL COMMENT '熟练度 (数据字典 skill_level)',
  `material_code_id` bigint        NOT NULL COMMENT '关联物料编码ID (hn_material_code.id)',
  `unit_price`       decimal(10,4) NOT NULL COMMENT '覆盖单价',
  `effective_date`   date          DEFAULT NULL COMMENT '生效日期',
  `status`           tinyint       DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`        varchar(50)   DEFAULT NULL COMMENT '创建人',
  `create_time`      datetime      DEFAULT NULL COMMENT '创建日期',
  `update_by`        varchar(50)   DEFAULT NULL COMMENT '更新人',
  `update_time`      datetime      DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`     varchar(64)   DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_override_price` (`material_code_id`, `product_id`, `equipment_type`, `process_id`, `skill_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='物料覆盖单价表';

-- ---------------------------------------------------------------------------
-- 表12: hn_price_change_log（单价变更日志表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_price_change_log` (
  `id`             bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_name`     varchar(100)  NOT NULL COMMENT '来源表名（如：hn_base_price、hn_complex_price）',
  `record_id`      bigint        NOT NULL COMMENT '来源记录ID',
  `old_price`      decimal(10,4) DEFAULT NULL COMMENT '变更前单价',
  `new_price`      decimal(10,4) NOT NULL COMMENT '变更后单价',
  `effective_date` date          DEFAULT NULL COMMENT '新单价生效日期',
  `create_by`      varchar(50)   DEFAULT NULL COMMENT '创建人（操作人）',
  `create_time`    datetime      DEFAULT NULL COMMENT '变更时间',
  `update_by`      varchar(50)   DEFAULT NULL COMMENT '更新人',
  `update_time`    datetime      DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`   varchar(64)   DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='单价变更日志表';

-- ---------------------------------------------------------------------------
-- 表13: hn_import_batch（导入批次表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_import_batch` (
  `id`            bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `file_name`     varchar(200) NOT NULL COMMENT '上传的原始文件名',
  `year_month`    varchar(7)   NOT NULL COMMENT '所属年月（格式：YYYY-MM）',
  `record_count`  int          DEFAULT '0' COMMENT '总记录数',
  `success_count` int          DEFAULT '0' COMMENT '成功导入数',
  `fail_count`    int          DEFAULT '0' COMMENT '失败记录数',
  `status`        varchar(50)  DEFAULT 'processing' COMMENT '批次状态（processing-处理中/success-成功/partial-部分成功/failed-失败）',
  `create_by`     varchar(50)  DEFAULT NULL COMMENT '创建人（导入操作人）',
  `create_time`   datetime     DEFAULT NULL COMMENT '导入时间',
  `update_by`     varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time`   datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`  varchar(64)  DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='导入批次表';

-- ---------------------------------------------------------------------------
-- 表14: hn_monthly_record（月度加工记录表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_monthly_record` (
  `id`               bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `year_month`       varchar(7)    NOT NULL COMMENT '所属年月（格式：YYYY-MM）',
  `import_batch_id`  bigint        DEFAULT NULL COMMENT '导入批次ID (hn_import_batch.id)',
  `worker_id`        bigint        NOT NULL COMMENT '工人ID (hn_worker.id)',
  `equipment_id`     bigint        NOT NULL COMMENT '设备ID (hn_equipment.id)',
  `line_id`          varchar(100)  DEFAULT NULL COMMENT '产线 (数据字典 production_line，从设备冗余)',
  `material_code_id` bigint        NOT NULL COMMENT '物料编码ID (hn_material_code.id)',
  `process_id`       bigint        NOT NULL COMMENT '工序ID (hn_process.id)',
  `quantity`         int           NOT NULL COMMENT '合格数量',
  `unit_price`       decimal(10,4) DEFAULT NULL COMMENT '计算使用的单价',
  `total_amount`     decimal(12,4) DEFAULT NULL COMMENT '总金额 = quantity × unit_price',
  `price_source`     varchar(50)   DEFAULT NULL COMMENT '价格来源 (数据字典 price_source)',
  `calc_status`      varchar(50)   DEFAULT 'pending' COMMENT '计算状态 (数据字典 calc_status)',
  `manual_price`     decimal(10,4) DEFAULT NULL COMMENT '手工补录单价（calc_status=manual 时使用）',
  `create_by`        varchar(50)   DEFAULT NULL COMMENT '创建人',
  `create_time`      datetime      DEFAULT NULL COMMENT '创建日期',
  `update_by`        varchar(50)   DEFAULT NULL COMMENT '更新人',
  `update_time`      datetime      DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`     varchar(64)   DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='月度加工记录表';

-- ---------------------------------------------------------------------------
-- 表15: hn_monthly_summary（月度汇总表）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hn_monthly_summary` (
  `id`               bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `year_month`       varchar(7)    NOT NULL COMMENT '所属年月（格式：YYYY-MM）',
  `worker_id`        bigint        NOT NULL COMMENT '工人ID (hn_worker.id)',
  `equipment_id`     bigint        DEFAULT NULL COMMENT '设备ID (hn_equipment.id)',
  `material_code_id` bigint        NOT NULL COMMENT '物料编码ID (hn_material_code.id)',
  `process_id`       bigint        NOT NULL COMMENT '工序ID (hn_process.id)',
  `total_quantity`   int           NOT NULL COMMENT '该维度下的总合格数量',
  `unit_price`       decimal(10,4) DEFAULT NULL COMMENT '最终结算单价',
  `total_amount`     decimal(12,4) DEFAULT NULL COMMENT '该维度总金额',
  `record_count`     int           DEFAULT '0' COMMENT '原始记录条数',
  `calc_time`        datetime      DEFAULT NULL COMMENT '汇总计算时间',
  `create_by`        varchar(50)   DEFAULT NULL COMMENT '创建人',
  `create_time`      datetime      DEFAULT NULL COMMENT '创建日期',
  `update_by`        varchar(50)   DEFAULT NULL COMMENT '更新人',
  `update_time`      datetime      DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`     varchar(64)   DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='月度汇总表';


-- =============================================================================
-- Part2: 数据字典初始化（9个字典，幂等 INSERT）
-- =============================================================================

-- -------------------------
-- 字典1: production_line（产线）
-- -------------------------
INSERT IGNORE INTO sys_dict (id, dict_code, dict_name, description, del_flag, create_by, create_time, update_by, update_time, type)
SELECT '20260410_dict_production_line', 'production_line', '产线', '工厂生产产线', 0, 'admin', NOW(), NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_dict WHERE dict_code = 'production_line');

-- -------------------------
-- 字典2: equipment_type（设备类型）
-- -------------------------
INSERT IGNORE INTO sys_dict (id, dict_code, dict_name, description, del_flag, create_by, create_time, update_by, update_time, type)
SELECT '20260410_dict_equipment_type', 'equipment_type', '设备类型', '生产设备类型', 0, 'admin', NOW(), NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_dict WHERE dict_code = 'equipment_type');

-- -------------------------
-- 字典3: skill_level（工人熟练度）
-- -------------------------
INSERT IGNORE INTO sys_dict (id, dict_code, dict_name, description, del_flag, create_by, create_time, update_by, update_time, type)
SELECT '20260410_dict_skill_level', 'skill_level', '工人熟练度', '工人加工技能等级', 0, 'admin', NOW(), NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_dict WHERE dict_code = 'skill_level');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_skill_level_01', '20260410_dict_skill_level', '初级', 'junior', '初级工人', 1, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_skill_level' AND item_value = 'junior');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_skill_level_02', '20260410_dict_skill_level', '中级', 'middle', '中级工人', 2, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_skill_level' AND item_value = 'middle');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_skill_level_03', '20260410_dict_skill_level', '高级', 'senior', '高级工人', 3, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_skill_level' AND item_value = 'senior');

-- -------------------------
-- 字典4: work_status（工人在职状态）
-- -------------------------
INSERT IGNORE INTO sys_dict (id, dict_code, dict_name, description, del_flag, create_by, create_time, update_by, update_time, type)
SELECT '20260410_dict_work_status', 'work_status', '工人在职状态', '工人在职/离职状态', 0, 'admin', NOW(), NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_dict WHERE dict_code = 'work_status');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_work_status_01', '20260410_dict_work_status', '在职', '1', '工人在职', 1, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_work_status' AND item_value = '1');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_work_status_02', '20260410_dict_work_status', '离职', '0', '工人离职', 2, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_work_status' AND item_value = '0');

-- -------------------------
-- 字典5: material_type（产品原材料类型）
-- -------------------------
INSERT IGNORE INTO sys_dict (id, dict_code, dict_name, description, del_flag, create_by, create_time, update_by, update_time, type)
SELECT '20260410_dict_material_type', 'material_type', '产品原材料类型', '产品所使用的原材料加工状态（毛胚/半成品/成品）', 0, 'admin', NOW(), NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_dict WHERE dict_code = 'material_type');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_material_type_01', '20260410_dict_material_type', '毛胚', 'blank', '原材料毛胚', 1, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_material_type' AND item_value = 'blank');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_material_type_02', '20260410_dict_material_type', '半成品', 'semi', '原材料半成品', 2, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_material_type' AND item_value = 'semi');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_material_type_03', '20260410_dict_material_type', '成品', 'finished', '原材料成品', 3, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_material_type' AND item_value = 'finished');

-- -------------------------
-- 字典6: calc_status（月度记录计算状态）
-- -------------------------
INSERT IGNORE INTO sys_dict (id, dict_code, dict_name, description, del_flag, create_by, create_time, update_by, update_time, type)
SELECT '20260410_dict_calc_status', 'calc_status', '月度记录计算状态', '月度加工记录的单价计算状态', 0, 'admin', NOW(), NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_dict WHERE dict_code = 'calc_status');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_calc_status_01', '20260410_dict_calc_status', '待计算', 'pending', '尚未匹配到单价', 1, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_calc_status' AND item_value = 'pending');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_calc_status_02', '20260410_dict_calc_status', '已计算', 'calculated', '已自动匹配到单价', 2, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_calc_status' AND item_value = 'calculated');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_calc_status_03', '20260410_dict_calc_status', '手工补录', 'manual', '人工录入单价', 3, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_calc_status' AND item_value = 'manual');

-- -------------------------
-- 字典7: price_source（价格来源）
-- -------------------------
INSERT IGNORE INTO sys_dict (id, dict_code, dict_name, description, del_flag, create_by, create_time, update_by, update_time, type)
SELECT '20260410_dict_price_source', 'price_source', '价格来源', '月度加工记录中单价的来源', 0, 'admin', NOW(), NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_dict WHERE dict_code = 'price_source');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_price_source_01', '20260410_dict_price_source', '基础单价', 'base', '来源于 hn_base_price', 1, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_price_source' AND item_value = 'base');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_price_source_02', '20260410_dict_price_source', '复合定价', 'complex', '来源于 hn_complex_price', 2, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_price_source' AND item_value = 'complex');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_price_source_03', '20260410_dict_price_source', '物料覆盖', 'override', '来源于 hn_material_override_price', 3, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_price_source' AND item_value = 'override');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_price_source_04', '20260410_dict_price_source', '手工录入', 'manual', '人工补录单价', 4, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_price_source' AND item_value = 'manual');

-- -------------------------
-- 字典8: ability_status（工人工序能力状态）
-- -------------------------
INSERT IGNORE INTO sys_dict (id, dict_code, dict_name, description, del_flag, create_by, create_time, update_by, update_time, type)
SELECT '20260410_dict_ability_status', 'ability_status', '工人工序能力状态', '工人是否可进行该工序的全工作业', 0, 'admin', NOW(), NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_dict WHERE dict_code = 'ability_status');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_ability_status_01', '20260410_dict_ability_status', '可全工', '1', '工人可进行该工序全工操作', 1, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_ability_status' AND item_value = '1');

INSERT INTO sys_dict_item (id, dict_id, item_text, item_value, description, sort_order, status, create_by, create_time, update_by, update_time)
SELECT '20260410_ability_status_02', '20260410_dict_ability_status', '不可操作', '0', '工人不可进行该工序操作', 2, 1, 'admin', NOW(), NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_item WHERE dict_id = '20260410_dict_ability_status' AND item_value = '0');

-- -------------------------
-- 字典9: status（通用状态，如已存在则跳过）
-- -------------------------
INSERT IGNORE INTO sys_dict (id, dict_code, dict_name, description, del_flag, create_by, create_time, update_by, update_time, type)
SELECT '20260410_dict_status', 'status', '通用状态', '通用启用/停用状态', 0, 'admin', NOW(), NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_dict WHERE dict_code = 'status');

-- =============================================================================
-- Part3: 菜单权限（主菜单 + 16个子菜单 + 角色绑定，幂等 INSERT）
-- 角色ID: f6817f48af4fb3af11b9e8bf182f618b (admin角色)
-- =============================================================================

-- 主菜单: 工人工资管理
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029501', NULL, '工人工资管理', '/workwage', 'layouts/default/index', NULL, '/workwage/equipment', 0, NULL, '1', 1.00, 0, 'ant-design:account-book-outlined', 1, 0, 0, 0, 0, '工人工资计算模块', '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029501');

-- 主菜单角色绑定
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '177502397029501_role', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029501', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '177502397029501_role');

-- =============================================================================
-- 1. 设备管理 (hn_equipment)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029502', '177502397029501', '设备管理', '/workwage/hnEquipmentList', 'workwage/equipment/HnEquipmentList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029502');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950202', '177502397029502', '添加设备管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_equipment:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950202');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950203', '177502397029502', '编辑设备管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_equipment:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950203');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950204', '177502397029502', '删除设备管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_equipment:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950204');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950205', '177502397029502', '批量删除设备管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_equipment:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950205');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950206', '177502397029502', '导出excel设备管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_equipment:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950206');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950207', '177502397029502', '导入excel设备管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_equipment:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950207');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950209', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029502', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950209');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950211', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950202', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950211');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950212', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950203', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950212');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950213', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950204', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950213');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950214', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950205', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950214');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950215', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950206', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950215');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950216', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950207', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950216');

-- =============================================================================
-- 2. 产品管理 (hn_product)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029503', '177502397029501', '产品管理', '/workwage/hnProductList', 'workwage/product/HnProductList', NULL, NULL, 0, NULL, '1', 2.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029503');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950302', '177502397029503', '添加产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950302');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950303', '177502397029503', '编辑产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950303');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950304', '177502397029503', '删除产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950304');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950305', '177502397029503', '批量删除产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950305');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950306', '177502397029503', '导出excel产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950306');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950307', '177502397029503', '导入excel产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950307');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950309', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029503', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950309');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950311', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950302', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950311');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950312', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950303', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950312');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950313', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950304', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950313');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950314', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950305', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950314');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950315', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950306', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950315');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950316', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950307', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950316');

-- =============================================================================
-- 3. 物料编码管理 (hn_material_code)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029504', '177502397029501', '物料编码管理', '/workwage/hnMaterialCodeList', 'workwage/materialCode/HnMaterialCodeList', NULL, NULL, 0, NULL, '1', 3.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029504');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950402', '177502397029504', '添加物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950402');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950403', '177502397029504', '编辑物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950403');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950404', '177502397029504', '删除物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950404');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950405', '177502397029504', '批量删除物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950405');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950406', '177502397029504', '导出excel物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950406');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950407', '177502397029504', '导入excel物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950407');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950409', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029504', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950409');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950411', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950402', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950411');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950412', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950403', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950412');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950413', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950404', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950413');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950414', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950405', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950414');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950415', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950406', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950415');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950416', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950407', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950416');

-- =============================================================================
-- 4. 工序管理 (hn_process)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029505', '177502397029501', '工序管理', '/workwage/hnProcessList', 'workwage/process/HnProcessList', NULL, NULL, 0, NULL, '1', 4.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029505');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950502', '177502397029505', '添加工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950502');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950503', '177502397029505', '编辑工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950503');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950504', '177502397029505', '删除工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950504');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950505', '177502397029505', '批量删除工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950505');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950506', '177502397029505', '导出excel工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950506');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950507', '177502397029505', '导入excel工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950507');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950509', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029505', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950509');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950511', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950502', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950511');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950512', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950503', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950512');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950513', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950504', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950513');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950514', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950505', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950514');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950515', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950506', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950515');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950516', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950507', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950516');

-- =============================================================================
-- 5. 工人管理 (hn_worker)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029506', '177502397029501', '工人管理', '/workwage/hnWorkerList', 'workwage/worker/HnWorkerList', NULL, NULL, 0, NULL, '1', 5.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029506');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950602', '177502397029506', '添加工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950602');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950603', '177502397029506', '编辑工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950603');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950604', '177502397029506', '删除工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950604');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950605', '177502397029506', '批量删除工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950605');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950606', '177502397029506', '导出excel工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950606');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950607', '177502397029506', '导入excel工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950607');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950609', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029506', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950609');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950611', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950602', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950611');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950612', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950603', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950612');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950613', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950604', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950613');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950614', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950605', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950614');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950615', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950606', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950615');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950616', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950607', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950616');

-- =============================================================================
-- 6. 基础单价管理 (hn_base_price)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029507', '177502397029501', '基础单价管理', '/workwage/hnBasePriceList', 'workwage/basePrice/HnBasePriceList', NULL, NULL, 0, NULL, '1', 6.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029507');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950702', '177502397029507', '添加基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950702');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950703', '177502397029507', '编辑基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950703');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950704', '177502397029507', '删除基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950704');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950705', '177502397029507', '批量删除基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950705');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950706', '177502397029507', '导出excel基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950706');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950707', '177502397029507', '导入excel基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950707');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950709', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029507', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950709');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950711', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950702', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950711');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950712', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950703', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950712');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950713', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950704', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950713');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950714', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950705', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950714');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950715', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950706', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950715');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950716', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950707', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950716');

-- =============================================================================
-- 7. 物料覆盖单价管理 (hn_material_override_price)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029508', '177502397029501', '物料覆盖单价管理', '/workwage/hnMaterialOverridePriceList', 'workwage/materialOverridePrice/HnMaterialOverridePriceList', NULL, NULL, 0, NULL, '1', 7.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029508');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950802', '177502397029508', '添加物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950802');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950803', '177502397029508', '编辑物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950803');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950804', '177502397029508', '删除物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950804');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950805', '177502397029508', '批量删除物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950805');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950806', '177502397029508', '导出excel物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950806');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702950807', '177502397029508', '导入excel物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950807');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950809', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029508', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950809');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950811', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950802', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950811');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950812', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950803', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950812');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950813', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950804', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950813');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950814', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950805', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950814');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950815', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950806', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950815');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702950816', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950807', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950816');
-- =============================================================================
-- 9. 导入批次管理 (hn_import_batch)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029510', '177502397029501', '导入批次管理', '/workwage/hnImportBatchList', 'workwage/importBatch/HnImportBatchList', NULL, NULL, 0, NULL, '1', 9.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029510');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951002', '177502397029510', '添加导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951002');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951003', '177502397029510', '编辑导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951003');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951004', '177502397029510', '删除导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951004');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951005', '177502397029510', '批量删除导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951005');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951006', '177502397029510', '导出excel导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951006');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951007', '177502397029510', '导入excel导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951007');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951009', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029510', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951009');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951011', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951002', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951011');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951012', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951003', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951012');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951013', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951004', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951013');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951014', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951005', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951014');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951015', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951006', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951015');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951016', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951007', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951016');

-- =============================================================================
-- 10. 月度加工记录管理 (hn_monthly_record)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029511', '177502397029501', '月度加工记录管理', '/workwage/hnMonthlyRecordList', 'workwage/monthlyRecord/HnMonthlyRecordList', NULL, NULL, 0, NULL, '1', 10.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029511');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951102', '177502397029511', '添加月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951102');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951103', '177502397029511', '编辑月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951103');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951104', '177502397029511', '删除月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951104');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951105', '177502397029511', '批量删除月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951105');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951106', '177502397029511', '导出excel月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951106');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951107', '177502397029511', '导入excel月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951107');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951109', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029511', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951109');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951111', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951102', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951111');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951112', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951103', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951112');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951113', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951104', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951113');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951114', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951105', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951114');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951115', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951106', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951115');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951116', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951107', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951116');

-- =============================================================================
-- 11. 月度汇总管理 (hn_monthly_summary)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029512', '177502397029501', '月度汇总管理', '/workwage/hnMonthlySummaryList', 'workwage/monthlySummary/HnMonthlySummaryList', NULL, NULL, 0, NULL, '1', 11.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029512');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951202', '177502397029512', '添加月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951202');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951203', '177502397029512', '编辑月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951203');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951204', '177502397029512', '删除月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951204');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951205', '177502397029512', '批量删除月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951205');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951206', '177502397029512', '导出excel月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951206');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951207', '177502397029512', '导入excel月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951207');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951209', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029512', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951209');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951211', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951202', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951211');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951212', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951203', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951212');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951213', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951204', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951213');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951214', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951205', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951214');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951215', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951206', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951215');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951216', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951207', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951216');

-- =============================================================================
-- 12. 工人工序能力管理 (hn_worker_process_ability)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029513', '177502397029501', '工人工序能力管理', '/workwage/hnWorkerProcessAbilityList', 'workwage/workerProcessAbility/HnWorkerProcessAbilityList', NULL, NULL, 0, NULL, '1', 12.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029513');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951302', '177502397029513', '添加工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951302');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951303', '177502397029513', '编辑工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951303');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951304', '177502397029513', '删除工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951304');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951305', '177502397029513', '批量删除工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951305');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951306', '177502397029513', '导出excel工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951306');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951307', '177502397029513', '导入excel工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951307');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951309', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029513', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951309');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951311', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951302', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951311');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951312', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951303', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951312');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951313', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951304', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951313');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951314', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951305', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951314');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951315', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951306', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951315');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951316', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951307', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951316');

-- =============================================================================
-- 13. 单价变更日志管理 (hn_price_change_log)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029514', '177502397029501', '单价变更日志管理', '/workwage/hnPriceChangeLogList', 'workwage/priceChangeLog/HnPriceChangeLogList', NULL, NULL, 0, NULL, '1', 13.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029514');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951402', '177502397029514', '添加单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951402');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951403', '177502397029514', '编辑单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951403');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951404', '177502397029514', '删除单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951404');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951405', '177502397029514', '批量删除单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951405');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951406', '177502397029514', '导出excel单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951406');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951407', '177502397029514', '导入excel单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951407');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951409', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029514', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951409');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951411', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951402', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951411');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951412', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951403', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951412');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951413', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951404', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951413');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951414', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951405', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951414');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951415', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951406', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951415');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951416', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951407', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951416');

-- =============================================================================
-- 14. 设备类型工序关联管理 (hn_type_process)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029515', '177502397029501', '设备类型工序关联管理', '/workwage/hnTypeProcessList', 'workwage/typeProcess/HnTypeProcessList', NULL, NULL, 0, NULL, '1', 14.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029515');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951502', '177502397029515', '添加设备类型工序关联管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_type_process:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951502');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951503', '177502397029515', '编辑设备类型工序关联管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_type_process:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951503');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951504', '177502397029515', '删除设备类型工序关联管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_type_process:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951504');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951505', '177502397029515', '批量删除设备类型工序关联管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_type_process:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951505');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951506', '177502397029515', '导出excel设备类型工序关联管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_type_process:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951506');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17750239702951507', '177502397029515', '导入excel设备类型工序关联管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_type_process:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951507');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951509', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029515', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951509');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951511', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951502', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951511');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951512', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951503', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951512');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951513', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951504', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951513');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951514', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951505', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951514');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951515', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951506', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951515');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17750239702951516', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951507', NULL, '2026-04-01 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951516');

-- =============================================================================
-- 15. 物料尺寸定义管理 (hn_material_dimension)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177572961011801', '177502397029501', '物料尺寸定义', '/workwage/hnMaterialDimensionList', 'workwage/materialDimension/HnMaterialDimensionList', NULL, NULL, 0, NULL, '1', 15.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177572961011801');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180102', '177572961011801', '添加物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180102');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180103', '177572961011801', '编辑物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180103');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180104', '177572961011801', '删除物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180104');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180105', '177572961011801', '批量删除物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180105');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180106', '177572961011801', '导出excel物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180106');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180107', '177572961011801', '导入excel物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180107');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180109', 'f6817f48af4fb3af11b9e8bf182f618b', '177572961011801', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180109');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180111', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180102', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180111');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180112', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180103', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180112');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180113', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180104', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180113');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180114', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180105', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180114');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180115', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180106', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180115');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180116', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180107', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180116');

-- =============================================================================
-- 16. 复合定价管理 (hn_complex_price)
-- =============================================================================
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177572961011802', '177502397029501', '复合定价管理', '/workwage/hnComplexPriceList', 'workwage/complexPrice/HnComplexPriceList', NULL, NULL, 0, NULL, '1', 16.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177572961011802');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180202', '177572961011802', '添加复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180202');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180203', '177572961011802', '编辑复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180203');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180204', '177572961011802', '删除复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180204');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180205', '177572961011802', '批量删除复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180205');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180206', '177572961011802', '导出excel复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180206');
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external) SELECT '17757296101180207', '177572961011802', '导入excel复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0 WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180207');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180209', 'f6817f48af4fb3af11b9e8bf182f618b', '177572961011802', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180209');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180211', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180202', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180211');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180212', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180203', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180212');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180213', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180204', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180213');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180214', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180205', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180214');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180215', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180206', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180215');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip) SELECT '17757296101180216', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180207', NULL, '2026-04-09 00:00:00', '127.0.0.1' WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180216');

-- =============================================================================
-- 收尾
-- =============================================================================

-- -------------------------
-- 字典: dimension_name（尺寸维度）
-- -------------------------
INSERT IGNORE INTO sys_dict (id, dict_code, dict_name, description, del_flag, create_by, create_time, update_by, update_time, type)
SELECT '20260413_dict_dimension_name', 'dimension_name', '尺寸维度', '物料尺寸维度名称，用于复合定价与物料尺寸定义', 0, 'admin', NOW(), NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_dict WHERE dict_code = 'dimension_name');

SET FOREIGN_KEY_CHECKS = 1;
-- End of hn_worker_wage_init.sql
