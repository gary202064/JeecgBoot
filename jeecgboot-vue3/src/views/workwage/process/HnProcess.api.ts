import { defHttp } from '/@/utils/http/axios';
import { useMessage } from '/@/hooks/web/useMessage';

const { createConfirm } = useMessage();

enum Api {
  list = '/hnworkerwage/hnProcess/list',
  save = '/hnworkerwage/hnProcess/add',
  edit = '/hnworkerwage/hnProcess/edit',
  deleteOne = '/hnworkerwage/hnProcess/delete',
  deleteBatch = '/hnworkerwage/hnProcess/deleteBatch',
  importExcel = '/hnworkerwage/hnProcess/importExcel',
  exportXls = '/hnworkerwage/hnProcess/exportXls',
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
