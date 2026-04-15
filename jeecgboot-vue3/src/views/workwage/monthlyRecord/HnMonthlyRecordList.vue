<template>
  <div>
    <BasicTable @register="registerTable" :rowSelection="rowSelection">
      <template #tableTitle>
        <a-button type="primary" v-auth="'hnworkerwage:hn_monthly_record:add'" @click="handleAdd" preIcon="ant-design:plus-outlined"> 新增</a-button>
        <a-button type="primary" v-auth="'hnworkerwage:hn_monthly_record:exportXls'" preIcon="ant-design:export-outlined" @click="onExportXls"> 导出</a-button>
        <a-upload
          v-auth="'hnworkerwage:hn_monthly_record:importExcel'"
          :showUploadList="false"
          :accept="'.xls,.xlsx'"
          :before-upload="handleImportXls"
        >
          <a-button type="primary" preIcon="ant-design:import-outlined" :loading="importLoading">导入</a-button>
        </a-upload>
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
  import { getToken } from '/@/utils/auth';
  import { getAppEnvConfig } from '/@/utils/env';

  const queryParam = reactive<any>({});
  const [registerModal, { openModal }] = useModal();
  const { createConfirm, createMessage } = useMessage();
  const importLoading = ref(false);

  const { prefixCls, tableContext, onExportXls } = useListPage({
    tableProps: {
      title: '工序汇报记录',
      api: list,
      columns,
      canResize: true,
      formConfig: {
        schemas: searchFormSchema,
        autoSubmitOnEnter: true,
        showAdvancedButton: true,
        fieldMapToTime: [['documentDateRange', ['documentDate_begin', 'documentDate_end'], 'YYYY-MM-DD']],
      },
      actionColumn: { width: 120, fixed: 'right' },
      beforeFetch: (params) => Object.assign(params, queryParam),
    },
    exportConfig: { name: '工序汇报记录', url: getExportUrl, params: queryParam },
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
   * 自定义导入：支持错误时自动下载带错误列的Excel报告
   */
  async function handleImportXls(file: File) {
    importLoading.value = true;
    try {
      const formData = new FormData();
      formData.append('file', file);

      const token = getToken();
      const { VITE_GLOB_API_URL } = getAppEnvConfig();
      const uploadUrl = (VITE_GLOB_API_URL || '') + getImportUrl;
      const res = await fetch(uploadUrl, {
        method: 'POST',
        headers: { 'X-Access-Token': token || '' },
        body: formData,
      });

      const contentType = res.headers.get('Content-Type') || '';
      if (contentType.includes('application/vnd.openxmlformats') || contentType.includes('application/octet-stream')) {
        // 后端返回Excel错误报告文件 → 触发浏览器下载
        const blob = await res.blob();
        const disposition = res.headers.get('Content-Disposition') || '';
        let downloadName = '导入错误报告.xlsx';
        const match = disposition.match(/filename\*?=(?:UTF-8'')?([^;]+)/i);
        if (match) {
          try { downloadName = decodeURIComponent(match[1]); } catch (e) { downloadName = match[1]; }
        }
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = downloadName;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        createMessage.warning('导入存在错误，已下载错误报告，请修正后重新导入');
      } else {
        // 后端返回JSON
        const json = await res.json();
        if (json.success) {
          createMessage.success(json.message || '导入成功');
          handleSuccess();
        } else {
          createMessage.error(json.message || '导入失败');
        }
      }
    } catch (e: any) {
      createMessage.error('导入请求失败: ' + (e?.message || e));
    } finally {
      importLoading.value = false;
    }
    // 返回 false 阻止 antd Upload 组件默认上传行为
    return false;
  }

  /**
   * 开始计算
   */
  function handleCalculation() {
    createConfirm({
      iconType: 'info',
      title: '确认计算',
      content: '确定要开始计算当前查询条件下的工序汇报费用吗？此操作可能需要一些时间。',
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
