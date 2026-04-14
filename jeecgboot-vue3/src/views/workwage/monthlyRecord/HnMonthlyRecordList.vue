<template>
  <div>
    <BasicTable @register="registerTable" :rowSelection="rowSelection">
      <template #tableTitle>
        <a-button type="primary" v-auth="'hnworkerwage:hn_monthly_record:add'" @click="handleAdd" preIcon="ant-design:plus-outlined"> 新增</a-button>
        <a-button type="primary" v-auth="'hnworkerwage:hn_monthly_record:exportXls'" preIcon="ant-design:export-outlined" @click="onExportXls"> 导出</a-button>
        <j-upload-button type="primary" v-auth="'hnworkerwage:hn_monthly_record:importExcel'" preIcon="ant-design:import-outlined" @click="onImportXls">导入</j-upload-button>
        <a-button type="primary" preIcon="ant-design:calculator-outlined" @click="handleCalculation"> 开始计算</a-button>
        <a-dropdown v-if="selectedRowKeys.length > 0">
          <template #overlay>
            <a-menu><a-menu-item key="1" @click="batchHandleDelete"><Icon icon="ant-design:delete-outlined" /> 删除</a-menu-item></a-menu>
          </template>
          <a-button v-auth="'hnworkerwage:hn_monthly_record:deleteBatch'">批量操作<Icon icon="mdi:chevron-down" /></a-button>
        </a-dropdown>
        <super-query :config="superQueryConfig" @search="handleSuperQuery" />
      </template>
      <template #action="{ record }">
        <TableAction :actions="getTableAction(record)" :dropDownActions="getDropDownAction(record)" />
      </template>
    </BasicTable>
    <HnMonthlyRecordModal @register="registerModal" @success="handleSuccess" />
  </div>
</template>

<script lang="ts" name="workwage-hnMonthlyRecord" setup>
  import { ref, reactive } from 'vue';
  import { BasicTable, useTable, TableAction } from '/@/components/Table';
  import { useModal } from '/@/components/Modal';
  import { useListPage } from '/@/hooks/system/useListPage';
  import { useMessage } from '/@/hooks/web/useMessage';
  import HnMonthlyRecordModal from './components/HnMonthlyRecordModal.vue';
  import { columns, searchFormSchema, superQuerySchema } from './HnMonthlyRecord.data';
  import { list, deleteOne, batchDelete, getImportUrl, getExportUrl, startCalculation } from './HnMonthlyRecord.api';

  const queryParam = reactive<any>({});
  const [registerModal, { openModal }] = useModal();
  const { createConfirm, createMessage } = useMessage();
  const { prefixCls, tableContext, onExportXls, onImportXls } = useListPage({
    tableProps: { title: '月度加工记录', api: list, columns, canResize: true, formConfig: { schemas: searchFormSchema, autoSubmitOnEnter: true, showAdvancedButton: true }, actionColumn: { width: 120, fixed: 'right' }, beforeFetch: (params) => Object.assign(params, queryParam) },
    exportConfig: { name: '月度加工记录', url: getExportUrl, params: queryParam },
    importConfig: { url: getImportUrl, success: handleSuccess },
  });

  const [registerTable, { reload }, { rowSelection, selectedRowKeys }] = tableContext;
  const superQueryConfig = reactive(superQuerySchema);

  function handleSuperQuery(params) { Object.keys(params).map((k) => { queryParam[k] = params[k]; }); reload(); }
  function handleAdd() { openModal(true, { isUpdate: false, showFooter: true }); }
  function handleEdit(record: Recordable) { openModal(true, { record, isUpdate: true, showFooter: true }); }
  function handleDetail(record: Recordable) { openModal(true, { record, isUpdate: true, showFooter: false }); }
  async function handleDelete(record) { await deleteOne({ id: record.id }, handleSuccess); }
  async function batchHandleDelete() { await batchDelete({ ids: selectedRowKeys.value }, handleSuccess); }
  function handleSuccess() { (selectedRowKeys.value = []) && reload(); }

  /**
   * 开始计算
   */
  function handleCalculation() {
    createConfirm({
      iconType: 'info',
      title: '确认计算',
      content: '确定要开始计算当前查询条件下的月度加工费用吗？此操作可能需要一些时间。',
      okText: '确认',
      cancelText: '取消',
      onOk: async () => {
        try {
          const res = await startCalculation({});
          if (res.success) {
            createMessage.success('计费任务已启动，请稍后查看结果。');
          }
        } catch (e) {
          createMessage.error('启动计算失败');
        }
      },
    });
  }

  function getTableAction(record) { return [{ label: '编辑', onClick: handleEdit.bind(null, record), auth: 'hnworkerwage:hn_monthly_record:edit' }]; }
  function getDropDownAction(record) {
    return [
      { label: '详情', onClick: handleDetail.bind(null, record) },
      { label: '删除', popConfirm: { title: '是否确认删除', confirm: handleDelete.bind(null, record), placement: 'topLeft' }, auth: 'hnworkerwage:hn_monthly_record:delete' },
    ];
  }
</script>
