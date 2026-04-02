<template>
  <div>
    <BasicTable @register="registerTable" :rowSelection="rowSelection">
      <template #tableTitle>
        <a-button type="primary" v-auth="'hnworkerwage:hn_price_change_log:exportXls'" preIcon="ant-design:export-outlined" @click="onExportXls"> 导出</a-button>
        <a-dropdown v-if="selectedRowKeys.length > 0">
          <template #overlay>
            <a-menu><a-menu-item key="1" @click="batchHandleDelete"><Icon icon="ant-design:delete-outlined" /> 删除</a-menu-item></a-menu>
          </template>
          <a-button v-auth="'hnworkerwage:hn_price_change_log:deleteBatch'">批量操作<Icon icon="mdi:chevron-down" /></a-button>
        </a-dropdown>
      </template>
      <template #action="{ record }">
        <TableAction :actions="getTableAction(record)" :dropDownActions="getDropDownAction(record)" />
      </template>
    </BasicTable>
    <HnPriceChangeLogModal @register="registerModal" @success="handleSuccess" />
  </div>
</template>

<script lang="ts" name="workwage-hnPriceChangeLog" setup>
  import { ref, reactive } from 'vue';
  import { BasicTable, useTable, TableAction } from '/@/components/Table';
  import { useModal } from '/@/components/Modal';
  import { useListPage } from '/@/hooks/system/useListPage';
  import HnPriceChangeLogModal from './components/HnPriceChangeLogModal.vue';
  import { columns, searchFormSchema } from './HnPriceChangeLog.data';
  import { list, deleteOne, batchDelete, getExportUrl } from './HnPriceChangeLog.api';

  const queryParam = reactive<any>({});
  const [registerModal, { openModal }] = useModal();
  const { prefixCls, tableContext, onExportXls } = useListPage({
    tableProps: { title: '单价变更日志', api: list, columns, canResize: true, formConfig: { schemas: searchFormSchema, autoSubmitOnEnter: true, showAdvancedButton: true }, actionColumn: { width: 120, fixed: 'right' }, beforeFetch: (params) => Object.assign(params, queryParam) },
    exportConfig: { name: '单价变更日志', url: getExportUrl, params: queryParam },
  });

  const [registerTable, { reload }, { rowSelection, selectedRowKeys }] = tableContext;

  function handleDetail(record: Recordable) { openModal(true, { record, isUpdate: true, showFooter: false }); }
  async function handleDelete(record) { await deleteOne({ id: record.id }, handleSuccess); }
  async function batchHandleDelete() { await batchDelete({ ids: selectedRowKeys.value }, handleSuccess); }
  function handleSuccess() { (selectedRowKeys.value = []) && reload(); }

  function getTableAction(record) { return [{ label: '详情', onClick: handleDetail.bind(null, record) }]; }
  function getDropDownAction(record) {
    return [{ label: '删除', popConfirm: { title: '是否确认删除', confirm: handleDelete.bind(null, record), placement: 'topLeft' }, auth: 'hnworkerwage:hn_price_change_log:delete' }];
  }
</script>
