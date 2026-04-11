# 软件设计说明书：`hn-worker-wage` 模块

**版本: 1.2**

**日期: 2026-04-10**

## 1. 引言

### 1.1. 目的

本说明书旨在详细阐述 “工人工资计算” (hn-worker-wage) 模块的系统架构、数据库设计、核心功能实现及接口定义。本文档是项目开发、测试和后期维护的详细依据。

### 1.2. 范围

本文档覆盖了从基础数据管理到核心费用计算，再到报表展示的完整业务流程。所有设计均遵循 JeecgBoot 框架的最佳实践，并利用其代码生成能力来确保开发效率和规范性。

## 2. 总体设计

### 2.1. 技术架构

系统严格遵循 JeecgBoot 的技术体系，确保与现有系统无缝集成。

| 层级 | 技术选型 | 备注 |
| :--- | :--- | :--- |
| **前端** | Vue 3 + Ant Design Vue + Vite | JeecgBoot 官方推荐，提供丰富的组件和高效的开发体验。 |
| **后端** | Spring Boot 3 + MyBatis-Plus | 成熟稳定的企业级 Java 开发框架。 |
| **数据库** | MySQL 8.0 | 广泛使用的高性能关系型数据库。 |
| **认证** | Spring Security + JWT | 沿用 JeecgBoot 的标准安全认证机制。 |
| **缓存** | Redis | 用于缓存热点基础数据，提升系统性能。 |
| **Excel处理** | EasyExcel | 高效处理 Excel 导入导出，避免内存溢出。 |
| **异步任务** | Spring Boot `@Async` | 利用内置线程池处理耗时的费用计算任务，避免接口长时间阻塞。 |

### 2.2. 模块设计

将在 JeecgBoot 项目中建立一个独立的 Maven 模块 `hn-worker-wage`，用于存放所有与该业务相关的代码，实现与主项目及其他业务模块的物理隔离，便于独立维护和部署。

## 3. 数据库设计

数据库设计遵循 JeecgBoot 的规范，所有业务表均以 `hn_` 为前缀，并包含标准审计字段（`create_by`, `create_time`, `update_by`, `update_time`, `sys_org_code`）。

### 3.1. 数据模型变更 (Version 1.1)

#### 3.1.1. `hn_material_code` 表关联方式优化

为了提升系统的稳定性和数据一致性，对 `hn_material_code`（物料编码表）与 `hn_product`（产品表）的关联方式进行了优化。

*   **变更前**:
    *   `hn_material_code` 表中存在 `product_code` 字段 (类型为 `varchar`)。
    *   该字段直接存储 `hn_product` 表中的业务编码 `code`。
    *   **缺点**: 当产品编码因业务需求发生变更时，需要手动同步所有关联的物料数据，存在数据不一致的风险，且使用字符串关联性能稍差。

*   **变更后 (当前方案)**:
    *   移除了 `product_code` 字段。
    *   新增 `product_id` 字段 (类型为 `bigint`)。
    *   该字段存储 `hn_product` 表的**主键 `id`** 作为外键。
    *   **优点**:
        1.  **数据关系稳定**: 主键 `id` 唯一且永不改变，即使产品编码、名称等业务信息变更，也不会破坏数据关联的完整性。
        2.  **查询性能更佳**: 使用整数类型 (`bigint`) 进行表连接（JOIN）比使用字符串 (`varchar`) 更高效。
        3.  **符合设计规范**: 采用主键作为外键是关系型数据库设计的最佳实践。

*   **对数据导入的影响**:
    *   在导入包含“旧物料编码”和“产品名称”的外部数据（如工序汇报表）时，系统将采用“**外部用编码，内部用ID**”的策略。
    *   导入程序会使用外部系统提供的“产品名称”或“产品编码”作为查询条件，在 `hn_product` 表中找到对应的记录，然后将其**主键 `id`** 存入 `hn_material_code` 表的 `product_id` 字段中，完成数据的高效、准确映射。

### 3.2. 数据字典规划

为提高系统的灵活性和可维护性，以下实体将通过 **系统管理 -> 数据字典** 功能进行维护，不再创建独立的物理表：

| 业务实体 | 数据字典编码 (Code) |
| :--- | :--- |
| 产线 | `production_line` |
| 设备类型 | `equipment_type` |
| 工人熟练度 | `skill_level` |

### 3.3. 业务表结构 (SQL)

---

#### 1. 用户表 (`sys_user`)
- JeecgBoot 自带，通过 `role` 和 `worker_id` 关联业务。

#### 2. 设备表 (`hn_equipment`)
```sql
CREATE TABLE `hn_equipment` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='设备表';
```

#### 3. 产品表 (`hn_product`)
```sql
CREATE TABLE `hn_product` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='产品表';
```

#### 4. 物料编码表 (`hn_material_code`)
```sql
-- Version 1.1: 将 product_code (varchar) 修改为 product_id (bigint)
CREATE TABLE `hn_material_code` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='物料编码表';
```

#### 5. 工序表 (`hn_process`)
```sql
CREATE TABLE `hn_process` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工序表';
```

#### 6. 工人表 (`hn_worker`)
```sql
CREATE TABLE `hn_worker` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工人表';
```
---

## 4. 核心业务流程
(内容省略...)

## 5. 接口与前端交互变更

### 5.1. `HnMaterialCode` 模块前端交互变更 (Version 1.2)

为了配合后端数据模型的优化，并提供流畅的用户体验，`HnMaterialCode`（物料编码）模块在新增和编辑时，关联产品的选择方式最终确定为**可搜索下拉框**。

*   **最终方案**: “关联产品”字段采用 JeecgBoot 的 `JSearchSelect` 组件。
*   **交互**: 用户可以直接在表单的下拉框中输入产品名称的关键字，组件会实时从后端异步加载并筛选匹配的产品列表，供用户选择。
*   **数据绑定**: 该组件被配置为：显示产品的 `name` 字段，但实际提交和存储的是产品的 `id` 字段，这与后端 `productId` 的设计完全吻合。
*   **优点**: 此方案兼顾了操作的便捷性和数据关联的准确性，在产品数据量不是超大规模（如百万级）的情况下，是最佳的交互选择。它避免了弹窗带来的额外操作步骤，让表单填写过程更加一体化。

## 6. 接口设计 (API)
(内容省略...)
