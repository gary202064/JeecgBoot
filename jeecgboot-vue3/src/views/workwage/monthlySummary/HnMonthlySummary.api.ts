import { defHttp } from '/@/utils/http/axios';
import { useMessage } from '/@/hooks/web/useMessage';

const { createConfirm } = useMessage();

enum Api {
  list = '/hnworkerwage/hnMonthlySummary/list',
  save = '/hnworkerwage/hnMonthlySummary/add',
  edit = '/hnworkerwage/hnMonthlySummary/edit',
  deleteOne = '/hnworkerwage/hnMonthlySummary/delete',
  deleteBatch = '/hnworkerwage/hnMonthlySummary/deleteBatch',
  importExcel = '/hnworkerwage/hnMonthlySummary/importExcel',
  exportXls = '/hnworkerwage/hnMonthlySummary/exportXls',
}

export const getExportUrl = Api.exportXls;
export const getImportUrl = Api.importExcel;
export const list = (params) => defHttp.get({ url: Api.list, params });
export const deleteOne = (params, handleSuccess) => {
  return defHttp.delete({ url: Api.deleteOne, params }, { joinParamsToUrl: true }).then(() => { handleSuccess(); });
};
export const batchDelete = (params, handleSuccess) => {
  createConfirm({
    iconType: 'warning', title: '确认删除', content: '是否删除选中数据', okText: '确认', cancelText: '取消',
    onOk: () => { return defHttp.delete({ url: Api.deleteBatch, data: params }, { joinParamsToUrl: true }).then(() => { handleSuccess(); }); },
  });
};
export const saveOrUpdate = (params, isUpdate) => {
  let url = isUpdate ? Api.edit : Api.save;
  return defHttp.post({ url: url, params });
};
