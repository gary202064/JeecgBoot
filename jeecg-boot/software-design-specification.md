# 软件设计说明书：`hn-worker-wage` 模块

**版本: 2.0**

**日期: 2026-04-10**

---

## 1. 引言

### 1.1. 目的

本说明书旨在详细阐述"工人工资计算"（`hn-worker-wage`）模块的系统架构、数据库设计、核心业务逻辑及接口定义。本文档是项目开发、测试和后期维护的权威依据，所有代码实现均应与本文档保持一致。

### 1.2. 范围

本文档覆盖从基础数据管理（产品、工序、设备、工人、物料编码、定价）到核心费用计算（月度加工记录、汇总），再到辅助功能（导入批次管理、单价变更日志）的完整业务链路，共 15 张业务表。

### 1.3. 版本历史

| 版本  | 日期       | 说明                                                                           |
| :---- | :--------- | :----------------------------------------------------------------------------- |
| 1.0   | 2026-03-30 | 初始版本                                                                       |
| 1.1   | 2026-04-05 | `hn_material_code` 关联字段从 `product_code (varchar)` 改为 `product_id (bigint)` |
| 1.2   | 2026-04-10 | 补充 `HnMaterialCode` 前端交互说明，`specDesc` 拆分为 `spec`+`description`    |
| 1.3   | 2026-04-10 | `hn_base_price.type_id` 重命名为 `equipment_type`，补充 DDL，新增单价范围搜索 |
| **2.0** | **2026-04-10** | **全面重写：统一字段命名规范（所有 `typeId`→`equipmentType`，`lineId`→`productionLine`），补全所有业务表 DDL，完善数据字典规划、唯一约束、精度设计及业务流程说明** |

---

## 2. 总体设计

### 2.1. 技术架构

| 层级          | 技术选型                          | 备注                                                         |
| :------------ | :-------------------------------- | :----------------------------------------------------------- |
| **前端**      | Vue 3 + Ant Design Vue + Vite     | JeecgBoot 官方推荐，`JSearchSelect`、`JDictSelectTag` 等核心组件 |
| **后端**      | Spring Boot 3 + MyBatis-Plus      | 成熟稳定的企业级 Java 开发框架                               |
| **数据库**    | MySQL 8.0                         | 字符集统一 `utf8mb4`，排序规则统一 `utf8mb4_0900_ai_ci`      |
| **认证**      | Spring Security + JWT             | 沿用 JeecgBoot 的标准安全认证机制                            |
| **缓存**      | Redis                             | 用于缓存热点基础数据，提升系统性能                           |
| **Excel 处理** | EasyExcel                        | 高效处理 Excel 导入导出，避免内存溢出                        |
| **异步任务**  | Spring Boot `@Async`              | 处理耗时的费用计算任务，避免接口长时间阻塞                   |

### 2.2. 模块结构

独立 Maven 模块 `hn-worker-wage`，包路径 `org.jeecg.modules.hnworkerwage`，前端页面挂载在「工人工资管理」菜单下。

```
hn-worker-wage/
└── src/main/java/org/jeecg/modules/hnworkerwage/
    ├── controller/   # REST 控制器（15 个）
    ├── entity/       # 实体类（15 个）
    ├── mapper/       # MyBatis Mapper 接口
    └── service/      # 业务逻辑层
```

---

## 3. 数据字典规划

以下业务实体通过**系统管理 → 数据字典**维护，不创建独立物理表。

| 字典编码            | 业务含义           | 示例值                                    |
| :------------------ | :----------------- | :---------------------------------------- |
| `production_line`   | 产线               | L1产线、L2产线                            |
| `equipment_type`    | 设备类型           | 冲击机、精密机                            |
| `skill_level`       | 工人熟练度         | junior-初级、middle-中级、senior-高级     |
| `status`            | 通用状态           | 1-正常、0-停用                            |
| `work_status`       | 工人在职状态       | 1-在职、0-离职                            |
| `material_type`     | 产品原材料类型     | blank-毛胚、semi-半成品、finished-成品    |
| `calc_status`       | 月度记录计算状态   | pending-待计算、calculated-已计算、manual-手工补录 |
| `price_source`      | 价格来源           | base-基础单价、complex-复合定价、override-物料覆盖、manual-手工录入 |
| `ability_status`    | 工人工序能力状态   | 1-可全工、0-不可操作                      |

---

## 4. 数据库设计

### 4.1. 设计规范

- 所有业务表以 `hn_` 为前缀
- 字符集：`utf8mb4`，排序规则：`utf8mb4_0900_ai_ci`
- 所有主键类型：`bigint NOT NULL AUTO_INCREMENT`
- 所有业务表包含标准审计字段：`create_by`、`create_time`、`update_by`、`update_time`、`sys_org_code`
- 字段命名规范：设备类型统一用 `equipment_type`，产线统一用 `production_line`
- 单价精度：`DECIMAL(10,4)`；尺寸精度：`DECIMAL(10,2)`；总金额：`DECIMAL(12,4)`

### 4.2. 实体关系概览

```
hn_product (产品)
    └── hn_material_code (物料编码) [product_id → hn_product.id]
            └── hn_material_dimension (物料尺寸) [material_code_id → hn_material_code.id]
            └── hn_material_override_price (物料覆盖单价) [material_code_id → hn_material_code.id]

hn_process (工序)
    └── hn_base_price (基础单价) [process_id → hn_process.id]
    └── hn_complex_price (复合定价) [process_id → hn_process.id]
    └── hn_worker_process_ability (工人工序能力) [process_id → hn_process.id]

hn_worker (工人)
    └── hn_worker_process_ability (工人工序能力) [worker_id → hn_worker.id]
    └── hn_monthly_record (月度加工记录) [worker_id → hn_worker.id]
    └── hn_monthly_summary (月度汇总) [worker_id → hn_worker.id]

hn_equipment (设备)
    └── hn_monthly_record (月度加工记录) [equipment_id → hn_equipment.id]
    └── hn_monthly_summary (月度汇总) [equipment_id → hn_equipment.id]

hn_import_batch (导入批次)
    └── hn_monthly_record (月度加工记录) [import_batch_id → hn_import_batch.id]
```

### 4.3. 业务表 DDL

---

#### 表1：产品表 (`hn_product`)

```sql
CREATE TABLE `hn_product` (
  `id`          bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`        varchar(100) NOT NULL COMMENT '产品名称',
  `code`        varchar(50)  NOT NULL COMMENT '产品代码',
  `product_level` varchar(50) DEFAULT NULL COMMENT '产品原材料类型 (数据字典 material_type，如：毛胚、半成品、成品)',
  `status`      tinyint      DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`   varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time` datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`   varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time` datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='产品表';
```

> **说明**：`product_level` 映射数据字典 `material_type`，用于区分该产品所使用的原材料加工状态（毛胚、半成品、成品），影响生产成本计算逻辑。

---

#### 表2：工序表 (`hn_process`)

```sql
CREATE TABLE `hn_process` (
  `id`          bigint      NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`        varchar(100) NOT NULL COMMENT '工序名称',
  `code`        varchar(50)  DEFAULT NULL COMMENT '工序代码',
  `status`      tinyint      DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`   varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time` datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`   varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time` datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_process_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工序表';
```

---

#### 表3：设备表 (`hn_equipment`)

```sql
CREATE TABLE `hn_equipment` (
  `id`               bigint      NOT NULL AUTO_INCREMENT COMMENT '主键',
  `equipment_no`     varchar(50) NOT NULL COMMENT '设备编号',
  `equipment_type`   varchar(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `production_line`  varchar(100) NOT NULL COMMENT '所属产线 (数据字典 production_line)',
  `status`           tinyint      DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`        varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time`      datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`        varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time`      datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`     varchar(64)  DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_equipment_no` (`equipment_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='设备表';
```

> **字段变更说明（v2.0）**：
> - `type_id` → `equipment_type`（与数据字典编码保持一致）
> - `line_id` → `production_line`（与数据字典编码保持一致）
> - DDL 变更语句：
>   ```sql
>   ALTER TABLE `hn_equipment`
>     CHANGE COLUMN `type_id` `equipment_type` VARCHAR(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
>     CHANGE COLUMN `line_id` `production_line` VARCHAR(100) NOT NULL COMMENT '所属产线 (数据字典 production_line)';
>   ```

---

#### 表4：工人表 (`hn_worker`)

```sql
CREATE TABLE `hn_worker` (
  `id`          bigint      NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`        varchar(50) NOT NULL COMMENT '工人姓名',
  `employee_no` varchar(50) NOT NULL COMMENT '工号',
  `status`      tinyint     DEFAULT '1' COMMENT '在职状态 (数据字典 work_status，1-在职/0-离职)',
  `create_by`   varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime    DEFAULT NULL COMMENT '创建日期',
  `update_by`   varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime    DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_employee_no` (`employee_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工人表';
```

> **说明**：`status` 字段映射数据字典 `work_status`（区别于其他表使用的通用 `status` 字典），语义为"在职/离职"。

---

#### 表5：物料编码表 (`hn_material_code`)

```sql
CREATE TABLE `hn_material_code` (
  `id`          bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code`        varchar(100) NOT NULL COMMENT '物料编码',
  `product_id`  bigint       NOT NULL COMMENT '关联产品ID (hn_product.id)',
  `spec`        varchar(200) DEFAULT NULL COMMENT '规格型号',
  `description` varchar(200) DEFAULT NULL COMMENT '物料描述',
  `status`      tinyint      DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`   varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time` datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`   varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time` datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='物料编码表';
```

> **关联方式说明（v1.1）**：通过 `product_id (bigint)` 外键关联 `hn_product.id`，替代了旧版本的 `product_code (varchar)` 字符串关联，提升数据一致性和查询性能。

---

#### 表6：物料尺寸定义表 (`hn_material_dimension`)

```sql
CREATE TABLE `hn_material_dimension` (
  `id`               bigint         NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_code_id` bigint         NOT NULL COMMENT '关联物料编码ID (hn_material_code.id)',
  `dimension_name`   varchar(100)   NOT NULL COMMENT '尺寸维度名称（如：长度、宽度、厚度）',
  `dimension_value`  decimal(10,2)  NOT NULL COMMENT '该物料的具体尺寸值',
  `create_by`        varchar(50)    DEFAULT NULL COMMENT '创建人',
  `create_time`      datetime       DEFAULT NULL COMMENT '创建日期',
  `update_by`        varchar(50)    DEFAULT NULL COMMENT '更新人',
  `update_time`      datetime       DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`     varchar(64)    DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_dimension` (`material_code_id`, `dimension_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='物料尺寸定义表';
```

> **说明**：为每个物料编码定义其多维度尺寸（如长、宽、厚），与复合定价表配合使用，用于确定物料加工时命中哪个尺寸区间的单价。

---

#### 表7：工人-工序能力表 (`hn_worker_process_ability`)

```sql
CREATE TABLE `hn_worker_process_ability` (
  `id`           bigint  NOT NULL AUTO_INCREMENT COMMENT '主键',
  `worker_id`    bigint  NOT NULL COMMENT '工人ID (hn_worker.id)',
  `process_id`   bigint  NOT NULL COMMENT '工序ID (hn_process.id)',
  `can_full_work` tinyint DEFAULT '0' COMMENT '能力状态 (数据字典 ability_status，1-可全工/0-不可)',
  `skill_level`  varchar(100) DEFAULT NULL COMMENT '该工人在此工序的熟练度 (数据字典 skill_level)',
  `create_by`    varchar(50)  DEFAULT NULL COMMENT '创建人',
  `create_time`  datetime     DEFAULT NULL COMMENT '创建日期',
  `update_by`    varchar(50)  DEFAULT NULL COMMENT '更新人',
  `update_time`  datetime     DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64)  DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_worker_process` (`worker_id`, `process_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工人-工序能力表';
```

---

#### 表9：基础单价表 (`hn_base_price`)

```sql
CREATE TABLE `hn_base_price` (
  `id`             bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id`     bigint        NOT NULL COMMENT '关联产品ID (hn_product.id)',
  `equipment_type` varchar(100)  NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `process_id`     bigint        NOT NULL COMMENT '关联工序ID (hn_process.id)',
  `skill_level`    varchar(100)  DEFAULT NULL COMMENT '工人熟练度 (数据字典 skill_level)',
  `unit_price`     decimal(10,4) NOT NULL COMMENT '单价',
  `status`         tinyint       DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`      varchar(50)   DEFAULT NULL COMMENT '创建人',
  `create_time`    datetime      DEFAULT NULL COMMENT '创建日期',
  `update_by`      varchar(50)   DEFAULT NULL COMMENT '更新人',
  `update_time`    datetime      DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`   varchar(64)   DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_price` (`product_id`, `equipment_type`, `process_id`, `skill_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='基础单价表';
```

> **字段变更说明（v1.3）**：`type_id` → `equipment_type`，DDL：
> ```sql
> ALTER TABLE `hn_base_price` CHANGE COLUMN `type_id` `equipment_type` VARCHAR(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)';
> ```

---

#### 表10：复合定价表 (`hn_complex_price`)

```sql
CREATE TABLE `hn_complex_price` (
  `id`             bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `process_id`     bigint        NOT NULL COMMENT '关联工序ID (hn_process.id)',
  `equipment_id`   bigint        DEFAULT NULL COMMENT '关联设备ID (hn_equipment.id)，与equipment_type二选一，有值时优先匹配',
  `equipment_type` varchar(100)  DEFAULT NULL COMMENT '设备类型 (数据字典 equipment_type)，equipment_id为NULL时使用',
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
  UNIQUE KEY `uk_complex_price` (`process_id`, `equipment_id`, `equipment_type`, `skill_level`, `dimension_name`, `range_min`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='复合定价表';
```

> **业务说明**：当某物料在某工序下的尺寸（由 `hn_material_dimension` 定义）满足区间条件时，使用该行定义的单价，优先级高于 `hn_base_price`。
>
> **设备/产线匹配优先级**：
> - `equipment_id` 不为 NULL 时：优先按设备匹配候选项；设备匹配到候选项且尺寸区间匹配则取单价，如设备匹配候选集为空则降级到产线匹配。
> - `equipment_id` 为 NULL 时：按 `equipment_type` 匹配（仅匹配 `equipment_id IS NULL` 的定价行）。
>
> 区间条件由 `range_min_op`、`range_min`、`range_max_op`、`range_max` 四个字段共同定义，支持以下灵活组合：
> 
> | 表达式示例 | range_min_op | range_min | range_max_op | range_max |
> |---|---|---|---|---|
> | x < 76.5 | NULL | NULL | `<` | 76.5 |
> | 76.5 <= x <= 90 | `>=` | 76.5 | `<=` | 90 |
> | 170 < x <= 200 | `>` | 170 | `<=` | 200 |
> | x > 200 | `>` | 200 | NULL | NULL |
> 
> 运算符字段为 NULL 时表示该侧无界（无下限或无上限）。

---

#### 表11：物料覆盖单价表 (`hn_material_override_price`)

```sql
CREATE TABLE `hn_material_override_price` (
  `id`             bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id`     bigint        NOT NULL COMMENT '关联产品ID (hn_product.id)',
  `equipment_type` varchar(100)  NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  `process_id`     bigint        NOT NULL COMMENT '关联工序ID (hn_process.id)',
  `skill_level`    varchar(100)  DEFAULT NULL COMMENT '熟练度 (数据字典 skill_level)',
  `material_code_id` bigint      NOT NULL COMMENT '关联物料编码ID (hn_material_code.id)',
  `unit_price`     decimal(10,4) NOT NULL COMMENT '覆盖单价',
  `status`         tinyint       DEFAULT '1' COMMENT '状态 (数据字典 status，1-正常/0-停用)',
  `create_by`      varchar(50)   DEFAULT NULL COMMENT '创建人',
  `create_time`    datetime      DEFAULT NULL COMMENT '创建日期',
  `update_by`      varchar(50)   DEFAULT NULL COMMENT '更新人',
  `update_time`    datetime      DEFAULT NULL COMMENT '更新日期',
  `sys_org_code`   varchar(64)   DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_override_price` (`material_code_id`, `product_id`, `equipment_type`, `process_id`, `skill_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='物料覆盖单价表';
```

> **字段变更说明（v2.0）**：`type_id` → `equipment_type`，DDL：
> ```sql
> ALTER TABLE `hn_material_override_price` CHANGE COLUMN `type_id` `equipment_type` VARCHAR(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)';
> ```
>
> **业务说明**：针对特定物料编码的最高优先级单价覆盖，优先级高于复合定价和基础单价。

---

#### 表12：单价变更日志表 (`hn_price_change_log`)

```sql
CREATE TABLE `hn_price_change_log` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='单价变更日志表';
```

---

#### 表13：导入批次表 (`hn_import_batch`)

```sql
CREATE TABLE `hn_import_batch` (
  `id`            bigint      NOT NULL AUTO_INCREMENT COMMENT '主键',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='导入批次表';
```

---

#### 表14：月度加工记录表 (`hn_monthly_record`)

```sql
CREATE TABLE `hn_monthly_record` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='月度加工记录表';
```

---

#### 表15：月度汇总表 (`hn_monthly_summary`)

```sql
CREATE TABLE `hn_monthly_summary` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='月度汇总表';
```

---

## 5. 核心业务流程

### 5.1. 单价查找优先级

在计算月度加工记录的单价时，系统按以下优先级依次匹配：

```
优先级 1（最高）：物料覆盖单价 (hn_material_override_price)
    匹配条件：material_code_id + product_id + equipment_type + process_id + skill_level

优先级 2：复合定价 (hn_complex_price)
    匹配条件：process_id + skill_level + dimension_name
    设备/产线优先级：equipment_id 不为 NULL 时优先按设备匹配候选项；
                    设备候选集为空时降级按 equipment_type 匹配（仅 equipment_id IS NULL 的行）
    尺寸命中条件：由 range_min_op/range_min/range_max_op/range_max 共同定义区间
                  支持 >=、>、<=、< 四种运算符，运算符为 NULL 时表示该侧无界

优先级 3（最低）：基础单价 (hn_base_price)
    匹配条件：product_id + equipment_type + process_id + skill_level

无匹配：calc_status = 'pending'，需人工补录 manual_price
```

### 5.2. 数据导入流程

```
1. 上传 Excel 文件 → 创建 hn_import_batch 记录（status=processing）
2. 逐行解析 Excel：
   - 通过"工号"在 hn_worker 中查找 worker_id
   - 通过"设备编号"在 hn_equipment 中查找 equipment_id（同时获取 line_id）
   - 通过"物料编码"在 hn_material_code 中查找 material_code_id
   - 通过"工序代码"在 hn_process 中查找 process_id
3. 写入 hn_monthly_record（calc_status='pending'）
4. 更新 hn_import_batch（success_count/fail_count/status）
5. 异步触发单价计算任务
```

### 5.3. 月度汇总计算流程

```
1. 按 (year_month, worker_id, material_code_id, process_id) 分组汇总 hn_monthly_record
2. 查找每组对应的最终单价（按 5.1 优先级）
3. 计算 total_amount = total_quantity × unit_price
4. 写入 hn_monthly_summary
```

---

## 6. 接口设计（API）

### 6.1. 通用接口规范

所有 CRUD 接口均遵循 JeecgBoot 标准规范：

| 操作   | 方法   | 路径                            |
| :----- | :----- | :------------------------------ |
| 分页查询 | GET  | `/hnXxx/list`                  |
| 新增   | POST   | `/hnXxx/add`                   |
| 编辑   | PUT    | `/hnXxx/edit`                  |
| 删除   | DELETE | `/hnXxx/delete?id={id}`         |
| 批量删除 | DELETE | `/hnXxx/deleteBatch?ids={ids}` |
| Excel 导出 | GET | `/hnXxx/exportXls`           |
| Excel 导入 | POST | `/hnXxx/importExcel`         |

### 6.2. 特殊接口：基础单价分页查询

`GET /hnBasePrice/list` 额外支持单价范围搜索参数：

| 参数       | 类型          | 说明       |
| :--------- | :------------ | :--------- |
| `minPrice` | BigDecimal    | 最低单价（可选） |
| `maxPrice` | BigDecimal    | 最高单价（可选） |

后端实现：`QueryWrapper.ge("unit_price", minPrice)` / `.le("unit_price", maxPrice)`

### 6.3. 特殊接口：物料编码分页查询

`GET /hnMaterialCode/list` 支持按产品 ID（`productId`）筛选，通过自定义 Mapper XML（`pageList` 方法）实现 LEFT JOIN 查询：

```sql
LEFT JOIN hn_product hp ON hmc.product_id = hp.id
```

---

## 7. 前端交互说明

### 7.1. 关联字段使用 `JSearchSelect` 组件

以下字段在新增/编辑表单中使用可搜索下拉框（`JSearchSelect`），实现"显示名称，存储 ID"的交互：

| 字段             | 组件配置                              |
| :--------------- | :------------------------------------ |
| 物料编码.productId | `dict: 'hn_product,name,id'`        |
| 加工记录.workerId | `dict: 'hn_worker,name,id'`         |
| 加工记录.equipmentId | `dict: 'hn_equipment,equipment_no,id'` |
| 加工记录.materialCodeId | `dict: 'hn_material_code,code,id'` |
| 加工记录.processId | `dict: 'hn_process,name,id'`       |

### 7.2. 数据字典字段使用 `JDictSelectTag` 组件

| 字段                   | 字典编码          |
| :--------------------- | :---------------- |
| 设备类型相关字段       | `equipment_type`  |
| 产线相关字段           | `production_line` |
| 熟练度相关字段         | `skill_level`     |
| 通用状态字段           | `status`          |
| 工人在职状态           | `work_status`     |
| 产品原材料类型         | `material_type`   |
| 月度记录计算状态       | `calc_status`     |
| 价格来源               | `price_source`    |
| 工人工序能力状态       | `ability_status`  |

---

## 8. 待办事项（数据库变更）

以下 DDL 语句为代码已更新、数据库需同步执行的变更：

```sql
-- 设备表：字段重命名
ALTER TABLE `hn_equipment`
  CHANGE COLUMN `type_id` `equipment_type` VARCHAR(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
  CHANGE COLUMN `line_id` `production_line` VARCHAR(100) NOT NULL COMMENT '所属产线 (数据字典 production_line)';

-- 基础单价表：字段重命名
ALTER TABLE `hn_base_price`
  CHANGE COLUMN `type_id` `equipment_type` VARCHAR(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)';

-- 物料覆盖单价表：字段重命名
ALTER TABLE `hn_material_override_price`
  CHANGE COLUMN `type_id` `equipment_type` VARCHAR(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)';
```
