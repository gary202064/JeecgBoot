-- =============================================================================
-- hn-worker-wage 模块菜单和权限 SQL
-- 生成日期: 2026-04-01
-- =============================================================================

-- 先检查菜单是否已存在，避免重复插入

-- 主菜单: 工人工资管理
INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029501', NULL, '工人工资管理', '/workwage', 'layouts/default/index', NULL, '/workwage/equipment', 0, NULL, '1', 1.00, 0, 'ant-design:account-book-outlined', 1, 0, 0, 0, 0, '工人工资计算模块', '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029501');

-- 1. 设备管理 (hn_equipment)

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

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950209', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029502', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950209');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950211', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950202', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950211');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950212', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950203', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950212');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950213', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950204', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950213');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950214', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950205', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950214');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950215', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950206', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950215');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950216', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950207', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950216');


-- 2. 产品管理 (hn_product)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029503', '177502397029501', '产品管理', '/workwage/hnProductList', 'workwage/product/HnProductList', NULL, NULL, 0, NULL, '1', 2.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029503');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950302', '177502397029503', '添加产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950302');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950303', '177502397029503', '编辑产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950303');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950304', '177502397029503', '删除产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950304');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950305', '177502397029503', '批量删除产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950305');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950306', '177502397029503', '导出excel产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950306');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950307', '177502397029503', '导入excel产品管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_product:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950307');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950309', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029503', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950309');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950311', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950302', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950311');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950312', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950303', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950312');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950313', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950304', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950313');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950314', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950305', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950314');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950315', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950306', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950315');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950316', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950307', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950316');


-- 3. 物料编码管理 (hn_material_code)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029504', '177502397029501', '物料编码管理', '/workwage/hnMaterialCodeList', 'workwage/materialCode/HnMaterialCodeList', NULL, NULL, 0, NULL, '1', 3.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029504');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950402', '177502397029504', '添加物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950402');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950403', '177502397029504', '编辑物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950403');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950404', '177502397029504', '删除物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950404');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950405', '177502397029504', '批量删除物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950405');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950406', '177502397029504', '导出excel物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950406');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950407', '177502397029504', '导入excel物料编码管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_code:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950407');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950409', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029504', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950409');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950411', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950402', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950411');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950412', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950403', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950412');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950413', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950404', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950413');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950414', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950405', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950414');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950415', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950406', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950415');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950416', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950407', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950416');


-- 4. 工序管理 (hn_process)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029505', '177502397029501', '工序管理', '/workwage/hnProcessList', 'workwage/process/HnProcessList', NULL, NULL, 0, NULL, '1', 4.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029505');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950502', '177502397029505', '添加工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950502');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950503', '177502397029505', '编辑工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950503');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950504', '177502397029505', '删除工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950504');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950505', '177502397029505', '批量删除工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950505');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950506', '177502397029505', '导出excel工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950506');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950507', '177502397029505', '导入excel工序管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_process:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950507');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950509', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029505', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950509');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950511', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950502', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950511');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950512', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950503', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950512');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950513', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950504', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950513');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950514', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950505', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950514');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950515', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950506', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950515');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950516', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950507', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950516');


-- 5. 工人管理 (hn_worker)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029506', '177502397029501', '工人管理', '/workwage/hnWorkerList', 'workwage/worker/HnWorkerList', NULL, NULL, 0, NULL, '1', 5.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029506');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950602', '177502397029506', '添加工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950602');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950603', '177502397029506', '编辑工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950603');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950604', '177502397029506', '删除工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950604');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950605', '177502397029506', '批量删除工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950605');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950606', '177502397029506', '导出excel工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950606');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950607', '177502397029506', '导入excel工人管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950607');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950609', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029506', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950609');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950611', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950602', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950611');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950612', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950603', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950612');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950613', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950604', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950613');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950614', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950605', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950614');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950615', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950606', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950615');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950616', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950607', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950616');


-- 6. 基础单价管理 (hn_base_price)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029507', '177502397029501', '基础单价管理', '/workwage/hnBasePriceList', 'workwage/basePrice/HnBasePriceList', NULL, NULL, 0, NULL, '1', 6.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029507');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950702', '177502397029507', '添加基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950702');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950703', '177502397029507', '编辑基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950703');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950704', '177502397029507', '删除基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950704');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950705', '177502397029507', '批量删除基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950705');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950706', '177502397029507', '导出excel基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950706');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950707', '177502397029507', '导入excel基础单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_base_price:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950707');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950709', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029507', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950709');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950711', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950702', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950711');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950712', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950703', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950712');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950713', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950704', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950713');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950714', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950705', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950714');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950715', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950706', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950715');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950716', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950707', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950716');


-- 7. 物料覆盖单价管理 (hn_material_override_price)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029508', '177502397029501', '物料覆盖单价管理', '/workwage/hnMaterialOverridePriceList', 'workwage/materialOverridePrice/HnMaterialOverridePriceList', NULL, NULL, 0, NULL, '1', 7.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029508');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950802', '177502397029508', '添加物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950802');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950803', '177502397029508', '编辑物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950803');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950804', '177502397029508', '删除物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950804');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950805', '177502397029508', '批量删除物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950805');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950806', '177502397029508', '导出excel物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950806');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702950807', '177502397029508', '导入excel物料覆盖单价管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_material_override_price:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702950807');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950809', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029508', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950809');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950811', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950802', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950811');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950812', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950803', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950812');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950813', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950804', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950813');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950814', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950805', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950814');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950815', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950806', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950815');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702950816', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702950807', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702950816');



-- 9. 导入批次管理 (hn_import_batch)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029510', '177502397029501', '导入批次管理', '/workwage/hnImportBatchList', 'workwage/importBatch/HnImportBatchList', NULL, NULL, 0, NULL, '1', 9.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029510');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951002', '177502397029510', '添加导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951002');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951003', '177502397029510', '编辑导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951003');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951004', '177502397029510', '删除导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951004');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951005', '177502397029510', '批量删除导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951005');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951006', '177502397029510', '导出excel导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951006');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951007', '177502397029510', '导入excel导入批次管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_import_batch:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951007');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951009', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029510', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951009');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951011', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951002', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951011');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951012', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951003', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951012');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951013', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951004', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951013');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951014', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951005', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951014');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951015', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951006', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951015');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951016', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951007', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951016');


-- 10. 月度加工记录管理 (hn_monthly_record)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029511', '177502397029501', '月度加工记录管理', '/workwage/hnMonthlyRecordList', 'workwage/monthlyRecord/HnMonthlyRecordList', NULL, NULL, 0, NULL, '1', 10.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029511');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951102', '177502397029511', '添加月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951102');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951103', '177502397029511', '编辑月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951103');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951104', '177502397029511', '删除月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951104');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951105', '177502397029511', '批量删除月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951105');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951106', '177502397029511', '导出excel月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951106');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951107', '177502397029511', '导入excel月度加工记录管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_record:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951107');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951109', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029511', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951109');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951111', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951102', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951111');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951112', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951103', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951112');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951113', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951104', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951113');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951114', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951105', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951114');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951115', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951106', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951115');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951116', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951107', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951116');


-- 11. 月度汇总管理 (hn_monthly_summary)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029512', '177502397029501', '月度汇总管理', '/workwage/hnMonthlySummaryList', 'workwage/monthlySummary/HnMonthlySummaryList', NULL, NULL, 0, NULL, '1', 11.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029512');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951202', '177502397029512', '添加月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951202');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951203', '177502397029512', '编辑月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951203');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951204', '177502397029512', '删除月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951204');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951205', '177502397029512', '批量删除月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951205');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951206', '177502397029512', '导出excel月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951206');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951207', '177502397029512', '导入excel月度汇总管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_monthly_summary:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951207');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951209', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029512', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951209');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951211', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951202', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951211');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951212', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951203', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951212');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951213', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951204', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951213');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951214', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951205', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951214');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951215', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951206', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951215');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951216', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951207', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951216');


-- 12. 工人工序能力管理 (hn_worker_process_ability)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029513', '177502397029501', '工人工序能力管理', '/workwage/hnWorkerProcessAbilityList', 'workwage/workerProcessAbility/HnWorkerProcessAbilityList', NULL, NULL, 0, NULL, '1', 12.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029513');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951302', '177502397029513', '添加工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951302');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951303', '177502397029513', '编辑工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951303');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951304', '177502397029513', '删除工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951304');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951305', '177502397029513', '批量删除工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951305');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951306', '177502397029513', '导出excel工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951306');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951307', '177502397029513', '导入excel工人工序能力管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_worker_process_ability:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951307');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951309', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029513', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951309');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951311', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951302', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951311');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951312', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951303', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951312');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951313', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951304', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951313');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951314', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951305', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951314');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951315', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951306', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951315');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951316', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951307', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951316');


-- 13. 单价变更日志管理 (hn_price_change_log)

INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external)
SELECT '177502397029514', '177502397029501', '单价变更日志管理', '/workwage/hnPriceChangeLogList', 'workwage/priceChangeLog/HnPriceChangeLogList', NULL, NULL, 0, NULL, '1', 13.00, 0, NULL, 1, 1, 1, 0, 0, NULL, '1', 0, 0, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '177502397029514');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951402', '177502397029514', '添加单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951402');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951403', '177502397029514', '编辑单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951403');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951404', '177502397029514', '删除单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951404');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951405', '177502397029514', '批量删除单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951405');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951406', '177502397029514', '导出excel单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951406');

INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
SELECT '17750239702951407', '177502397029514', '导入excel单价变更日志管理', NULL, NULL, 0, NULL, NULL, 2, 'hnworkerwage:hn_price_change_log:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2026-04-01 00:00:00', NULL, NULL, 0, 0, '1', 0
WHERE NOT EXISTS (SELECT 1 FROM sys_permission WHERE id = '17750239702951407');

INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951409', 'f6817f48af4fb3af11b9e8bf182f618b', '177502397029514', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951409');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951411', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951402', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951411');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951412', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951403', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951412');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951413', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951404', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951413');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951414', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951405', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951414');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951415', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951406', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951415');
INSERT INTO sys_role_permission (id, role_id, permission_id, data_rule_ids, operate_date, operate_ip)
SELECT '17750239702951416', 'f6817f48af4fb3af11b9e8bf182f618b', '17750239702951407', NULL, '2026-04-01 00:00:00', '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM sys_role_permission WHERE id = '17750239702951416');

