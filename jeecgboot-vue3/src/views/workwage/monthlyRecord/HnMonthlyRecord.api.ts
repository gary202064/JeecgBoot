import { defHttp } from '/@/utils/http/axios';
import { useMessage } from '/@/hooks/web/useMessage';

const { createConfirm } = useMessage();

enum Api {
  list = '/hnworkerwage/hnMonthlyRecord/list',
  save = '/hnworkerwage/hnMonthlyRecord/add',
  edit = '/hnworkerwage/hnMonthlyRecord/edit',
  deleteOne = '/hnworkerwage/hnMonthlyRecord/delete',
  deleteBatch = '/hnworkerwage/hnMonthlyRecord/deleteBatch',
  importExcel = '/hnworkerwage/hnMonthlyRecord/importExcel',
  exportXls = '/hnworkerwage/hnMonthlyRecord/exportXls',
  startCalculation = '/hnworkerwage/hnMonthlyRecord/startCalculation',
  manualSetPrice = '/hnworkerwage/hnMonthlyRecord/manualSetPrice',
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

/**
 * 触发异步费用计算
 */
export const startCalculation = (params) => defHttp.post({ url: Api.startCalculation, params });

/**
 * 手工补录单价
 */
export const manualSetPrice = (params) => defHttp.put({ url: Api.manualSetPrice, params });
