import { defHttp } from '/@/utils/http/axios';
import { useMessage } from '/@/hooks/web/useMessage';

const { createConfirm } = useMessage();

enum Api {
  list = '/hnworkerwage/hnWorkerProcessAbility/list',
  save = '/hnworkerwage/hnWorkerProcessAbility/add',
  edit = '/hnworkerwage/hnWorkerProcessAbility/edit',
  deleteOne = '/hnworkerwage/hnWorkerProcessAbility/delete',
  deleteBatch = '/hnworkerwage/hnWorkerProcessAbility/deleteBatch',
  importExcel = '/hnworkerwage/hnWorkerProcessAbility/importExcel',
  exportXls = '/hnworkerwage/hnWorkerProcessAbility/exportXls',
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
  return isUpdate ? defHttp.put({ url: url, params }) : defHttp.post({ url: url, params });
};
