-- =============================================================================
-- hn-worker-wage 模块 — 新增 hn_material_dimension 和 hn_complex_price
-- 包含: 建表DDL + 菜单权限SQL
-- 生成日期: 2026-04-09
-- =============================================================================

-- ================================
-- 第一部分: 建表 DDL
-- ================================

-- 物料尺寸定义表
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

-- 复合定价表
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='复合定价表';


-- ================================
-- 第二部分: 菜单权限 SQL
-- ================================

-- 15. 物料尺寸定义管理 (hn_material_dimension)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177572961011801', '177502397029501', '物料尺寸定义', '/workwage/hnMaterialDimensionList', 'workwage/materialDimension/HnMaterialDimensionList', NULL, NULL, 0, NULL, '1', 15.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177572961011801');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180102', '177572961011801', '添加物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180102');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180103', '177572961011801', '编辑物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180103');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180104', '177572961011801', '删除物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180104');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180105', '177572961011801', '批量删除物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180105');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180106', '177572961011801', '导出excel物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180106');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180107', '177572961011801', '导入excel物料尺寸定义', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_dimension:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180107');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180109', 'f6817f48af4fb3af11b9e8bf182f618b', '177572961011801', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180109');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180111', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180102', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180111');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180112', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180103', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180112');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180113', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180104', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180113');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180114', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180105', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180114');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180115', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180106', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180115');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180116', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180107', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180116');


-- 16. 复合定价管理 (hn_complex_price)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177572961011802', '177502397029501', '复合定价管理', '/workwage/hnComplexPriceList', 'workwage/complexPrice/HnComplexPriceList', NULL, NULL, 0, NULL, '1', 16.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177572961011802');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180202', '177572961011802', '添加复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180202');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180203', '177572961011802', '编辑复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180203');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180204', '177572961011802', '删除复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180204');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180205', '177572961011802', '批量删除复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180205');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180206', '177572961011802', '导出excel复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180206');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17757296101180207', '177572961011802', '导入excel复合定价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_complex_price:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-09 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17757296101180207');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180209', 'f6817f48af4fb3af11b9e8bf182f618b', '177572961011802', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180209');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180211', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180202', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180211');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180212', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180203', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180212');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180213', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180204', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180213');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180214', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180205', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180214');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180215', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180206', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180215');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17757296101180216', 'f6817f48af4fb3af11b9e8bf182f618b', '17757296101180207', NULL, '2026-04-09 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17757296101180216');
