# 软件设计说明书：`jeecg-worker-wage` 模块

**版本: 1.0**

**日期: 2026-03-29**

## 1. 引言

### 1.1. 目的

本说明书旨在详细阐述 “工人工资计算” (jeecg-worker-wage) 模块的系统架构、数据库设计、核心功能实现及接口定义。本文档是项目开发、测试和后期维护的详细依据。

### 1.2. 范围

本文档覆盖了从基础数据管理到核心费用计算，再到报表展示的完整业务流程。所有设计均遵循 JeecgBoot 框架的最佳实践，并利用其代码生成能力来确保开发效率和规范性。

## 2. 总体设计

### 2.1. 技术架构

系统严格遵循 JeecgBoot 的技术体系，确保与现有系统无缝集成。

| 层级 | 技术选型 | 备注 |
| :---

## 4. 核心业务流程

### 4.1. 三级定价查询流程

当系统需要为一条加工记录计算单价时，将严格遵循以下优先级顺序进行查找：

**注意**: 熟练度（`skill_level`）从 `hn_worker_process_ability` 表中根据 `worker_id` 和 `process_id` 查询获取。

1.  **查询第三级：设备专属单价 (`hn_equipment_override_price`)**
    - **条件**: `product_id` + `equipment_id` + `process_id` + `skill_level` (+ `material_code_id`)
    - 如果找到匹配的、在有效期内的、状态为启用的单价，则返回该单价，价格来源标记为 `EQUIPMENT`。

2.  **查询第二级：物料覆盖单价 (`hn_material_override_price`)**
    - **条件**: `product_id` + `type_id` + `process_id` + `skill_level` + `material_code_id`
    - 如果找到匹配的、在有效期内的、状态为启用的单价，则返回该单价，价格来源标记为 `MATERIAL`。

3.  **查询第一级：基础单价 (`hn_base_price`)**
    - **条件**: `product_id` + `type_id` + `process_id` + `skill_level`
    - 如果找到匹配的、在有效期内的、状态为启用的单价，则返回该单价，价格来源标记为 `BASE`。

4.  **未找到单价**
    - 如果三级查询均未找到单价，则该记录的计算状态标记为 `NO_PRICE`，价格来源为 `NONE`，等待财务人员后续处理（如手工补录）。

### 4.2. 月度数据导入与异步计算流程

```mermaid
graph TD
    A[财务人员] -->|1. 上传Excel文件| B(HnMonthlyRecordController);
    B -->|2. 调用Service进行数据解析| C{EasyExcel};
    C -->|3. 校验&映射数据| D[HnMonthlyRecordServiceImpl];
    D -->|4. 存储原始记录| E(数据库 hn_monthly_record);
    D -->|5. 记录导入批次| F(数据库 hn_import_batch);
    B -->|6. 立即返回“导入中”提示| A;
    
    subgraph 异步处理
        G[财务人员] -->|7. 点击“开始计算”| H(HnMonthlyRecordController);
        H -->|8. 触发异步任务| I{Async Service (@Async)};
        I -->|9. 遍历记录,执行三级定价查询| I;
        I -->|10. 更新记录状态和金额| E;
        I -->|11. 计算完成/异常| J(任务状态通知);
    end

    subgraph 结果查看
         K[财务/高层] -->|12. 查看报表/复核数据| L(前端页面);
         L -->|13. 查询计算结果| H;
         H -->|14. 从数据库读取| E;
    end
```

1.  **数据导入**: 财务人员通过前端页面上传月度加工记录的 Excel 表。后端控制器接收文件，调用 Service 层使用 EasyExcel 进行解析和基本的数据格式校验。
2.  **数据持久化**: Service 层将解析后的数据逐条存入 `hn_monthly_record` 表，初始计算状态为 `PENDING`。同时，在 `hn_import_batch` 中创建一条批次记录。
3.  **异步计算触发**: 财务人员在数据复核无误后，点击“开始计算”按钮。
4.  **异步任务执行**: 控制器调用一个标记有 `@Async` 的 Service 方法。该方法启动一个后台线程，查询指定月份所有状态为 `PENDING` 的加工记录，并对每一条记录执行 **4.1** 中定义的三级定价查询流程。
5.  **结果更新**: 根据查询结果，更新 `hn_monthly_record` 表中对应记录的 `unit_price`, `total_amount`, `price_source`, `calc_status` 字段。
6.  **状态反馈**: 前端可通过轮询或 WebSocket 机制，向后端查询异步任务的执行状态（如：处理中、已完成、失败），并向用户实时展示进度。

## 5. 接口设计 (API)

所有接口均遵循 JeecgBoot 的标准 RESTful 风格，并集成其权限校验机制。

### 5.1. 基础数据模块

将为所有基础数据实体（`HnEquipment`, `HnProduct`, `HnWorker` 等）生成标准的 CRUD 接口。

- **URL 示例**: `/worker-wage/hnProduct/list`, `/worker-wage/hnProduct/add`, `/worker-wage/hnProduct/edit`
- **通用功能**: 支持分页查询、新增、编辑、删除、批量删除以及 Excel 导入/导出。

#### 工人管理扩展接口

##### 获取工人工序熟练度列表
- **URL**: `/worker-wage/hnWorker/getProcessAbilities`
- **Method**: `GET`
- **Query Params**: `workerId={workerId}`
- **Success Response (`200 OK`)**:
  ```json
  {
    "success": true,
    "message": "操作成功！",
    "code": 200,
    "result": [
      {
        "id": 1,
        "workerId": 1,
        "processId": 1,
        "canFullWork": 1,
        "skillLevel": "高级",
        "createTime": "2026-04-03 10:00:00",
        "updateTime": "2026-04-03 10:00:00"
      }
    ]
  }
  ```
- **说明**: 根据工人ID查询该工人掌握的所有工序及其熟练度等级。

##### 工人-工序能力管理接口
- **分页列表查询**: `GET /worker-wage/hnWorkerProcessAbility/list`
- **添加**: `POST /worker-wage/hnWorkerProcessAbility/add`
- **编辑**: `PUT /worker-wage/hnWorkerProcessAbility/edit`
- **删除**: `DELETE /worker-wage/hnWorkerProcessAbility/delete`
- **批量删除**: `DELETE /worker-wage/hnWorkerProcessAbility/deleteBatch`
- **通过ID查询**: `GET /worker-wage/hnWorkerProcessAbility/queryById`

### 5.2. 单价管理模块

同样为三级单价表（`HnBasePrice`, `HnMaterialOverridePrice`, `HnEquipmentOverridePrice`）生成标准的 CRUD 接口。

- **URL 示例**: `/worker-wage/hnBasePrice/list`
- **特殊功能**: 在新增/编辑单价时，需要在 Service 层记录变更历史到 `hn_price_change_log` 表。

### 5.3. 核心业务接口

#### 1. 月度数据导入

- **URL**: `/worker-wage/hnMonthlyRecord/importExcel`
- **Method**: `POST`
- **ContentType**: `multipart/form-data`
- **说明**: 用于上传月度加工记录的 Excel 文件。后端通过 `JeecgController` 中的 `importExcel` 方法统一处理。

#### 2. 触发异步费用计算

- **URL**: `/worker-wage/hnMonthlyRecord/startCalculation`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "yearMonth": "2026-03"
  }
  ```
- **Success Response (`200 OK`)**:
  ```json
  {
    "success": true,
    "message": "计费任务已启动，请稍后在任务中心查看结果。",
    "result": {
        "taskId": "task-uuid-12345"
    }
  }
  ```
- **说明**: 触发对指定月份的加工数据进行异步计费。返回一个任务ID用于前端轮询状态。

#### 3. 查询异步任务状态

- **URL**: `/sys/asyncTask/query`
- **Method**: `GET`
- **Query Params**: `taskId={taskId}`
- **Success Response (`200 OK`)**:
  ```json
  {
      "success": true,
      "result": {
          "status": "PROCESSING | COMPLETED | FAILED",
          "progress": 85.5,
          "message": "已处理 8550 / 10000 条记录..."
      }
  }
  ```
- **说明**: （可复用或新建）一个通用接口，用于根据任务 ID 查询异步任务的当前状态和进度。

#### 4. 手工补录单价

- **URL**: `/worker-wage/hnMonthlyRecord/manualSetPrice`
- **Method**: `PUT`
- **Request Body**:
  ```json
  {
    "recordId": 123,
    "manualPrice": 15.75
  }
  ```
- **说明**: 为计费失败的某条记录手工指定一个单价，并将其状态更新为 `MANUAL`。 | :--- | :--- |
| **前端** | Vue 3 + Ant Design Vue + Vite | JeecgBoot 官方推荐，提供丰富的组件和高效的开发体验。 |
| **后端** | Spring Boot 3 + MyBatis-Plus | 成熟稳定的企业级 Java 开发框架。 |
| **数据库** | MySQL 8.0 | 广泛使用的高性能关系型数据库。 |
| **认证** | Spring Security + JWT | 沿用 JeecgBoot 的标准安全认证机制。 |
| **缓存** | Redis | 用于缓存热点基础数据，提升系统性能。 |
| **Excel处理** | EasyExcel | 高效处理 Excel 导入导出，避免内存溢出。 |
| **异步任务** | Spring Boot `@Async` | 利用内置线程池处理耗时的费用计算任务，避免接口长时间阻塞。 |

### 2.2. 模块设计

将在 JeecgBoot 项目中建立一个独立的 Maven 模块 `jeecg-worker-wage`，用于存放所有与该业务相关的代码，实现与主项目及其他业务模块的物理隔离，便于独立维护和部署。

## 3. 数据库设计

数据库设计遵循 JeecgBoot 的规范，所有业务表均以 `hn_` 为前缀，并包含标准审计字段（`create_by`, `create_time`, `update_by`, `update_time`, `sys_org_code`）。

### 3.1. 数据字典规划

为提高系统的灵活性和可维护性，以下实体将通过 **系统管理 -> 数据字典** 功能进行维护，不再创建独立的物理表：

| 业务实体 | 数据字典编码 (Code) |
| :--- | :--- |
| 产线 | `production_line` |
| 设备类型 | `equipment_type` |
| 工人熟练度 | `skill_level` |

### 3.2. 业务表结构 (SQL)

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
  `code` varchar(50) DEFAULT NULL COMMENT '产品代码',
  `status` tinyint DEFAULT '1' COMMENT '状态 (1-正常, 0-停用)',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='产品表';
```

#### 4. 物料编码表 (`hn_material_code`)
```sql
CREATE TABLE `hn_material_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(100) NOT NULL COMMENT '物料编码',
  `product_id` bigint NOT NULL COMMENT '关联产品ID',
  `spec_desc` varchar(200) DEFAULT NULL COMMENT '规格描述',
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

#### 7. 基础单价表 (`hn_base_price`)
```sql
CREATE TABLE `hn_base_price` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `type_id` varchar(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='基础单价表 (第1级)';
```

#### 8. 物料覆盖单价表 (`hn_material_override_price`)
```sql
CREATE TABLE `hn_material_override_price` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `type_id` varchar(100) NOT NULL COMMENT '设备类型 (数据字典 equipment_type)',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='物料覆盖单价表 (第2级)';
```

#### 9. 设备专属单价表 (`hn_equipment_override_price`)
```sql
CREATE TABLE `hn_equipment_override_price` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `equipment_id` bigint NOT NULL COMMENT '设备ID',
  `process_id` bigint NOT NULL COMMENT '工序ID',
  `skill_level` varchar(100) NOT NULL COMMENT '熟练度 (数据字典 skill_level)',
  `material_code_id` bigint DEFAULT NULL COMMENT '物料编码ID (可选)',
  `unit_price` decimal(10,4) NOT NULL COMMENT '单价',
  `effective_date` date NOT NULL COMMENT '生效日期',
  `status` tinyint DEFAULT '1' COMMENT '状态 (1-启用, 0-禁用)',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='设备专属单价表 (第3级)';
```

#### 10. 导入批次表 (`hn_import_batch`)
```sql
CREATE TABLE `hn_import_batch` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `file_name` varchar(200) DEFAULT NULL COMMENT '文件名',
  `year_month` varchar(7) DEFAULT NULL COMMENT '所属年月',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='导入批次表';
```

#### 11. 月度加工记录表 (`hn_monthly_record`)
```sql
CREATE TABLE `hn_monthly_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `year_month` varchar(7) NOT NULL COMMENT '所属年月',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='月度加工记录表';
```

#### 12. 工人-工序能力表 (`hn_worker_process_ability`)
```sql
CREATE TABLE `hn_worker_process_ability` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工人-工序能力表';
```

#### 13. 单价变更日志表 (`hn_price_change_log`)
```sql
CREATE TABLE `hn_price_change_log` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='单价变更日志表';
```

#### 14. 月度汇总表 (`hn_monthly_summary`)
```sql
CREATE TABLE `hn_monthly_summary` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `year_month` varchar(7) NOT NULL COMMENT '所属年月',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='月度汇总表';
```

#### 15. 设备类型-工序关联表 (`hn_type_process`)
```sql
CREATE TABLE `hn_type_process` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='设备类型-工序关联表';
```

---
