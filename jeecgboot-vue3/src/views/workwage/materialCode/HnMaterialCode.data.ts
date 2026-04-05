import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  {
    title: '物料编码',
    align: 'center',
    dataIndex: 'code',
  },
  {
    title: '关联产品',
    align: 'center',
    dataIndex: 'productName',
  },
  {
    title: '规格描述',
    align: 'center',
    dataIndex: 'specDesc',
  },
  {
    title: '状态',
    align: 'center',
    dataIndex: 'status_dictText',
  },
  {
    title: '创建时间',
    align: 'center',
    dataIndex: 'createTime',
  },
];

export const searchFormSchema: FormSchema[] = [
  {
    label: '物料编码',
    field: 'code',
    component: 'JInput',
    colProps: { span: 6 },
  },
  {
    label: '关联产品',
    field: 'productCode',
    component: 'JSelectSearch',
    componentProps: { dictTable: 'hn_product', dictText: 'name', dictCode: 'code' },
    colProps: { span: 6 },
  },
  {
    label: '状态',
    field: 'status',
    component: 'JDictSelectTag',
    componentProps: { dictCode: 'status' },
    colProps: { span: 6 },
  },
];

export const formSchema: FormSchema[] = [
  {
    label: '',
    field: 'id',
    component: 'Input',
    show: false,
  },
  {
    label: '物料编码',
    field: 'code',
    required: true,
    component: 'Input',
    componentProps: { placeholder: '请输入物料编码' },
  },
  {
    label: '关联产品',
    field: 'productCode',
    required: true,
    component: 'JSelectSearch',
    componentProps: { dictTable: 'hn_product', dictText: 'name', dictCode: 'code', placeholder: '请选择关联产品' },
  },
  {
    label: '规格描述',
    field: 'specDesc',
    component: 'InputTextArea',
    componentProps: { placeholder: '请输入规格描述' },
  },
  {
    label: '状态',
    field: 'status',
    required: true,
    component: 'JDictSelectTag',
    componentProps: { dictCode: 'status', placeholder: '请选择状态' },
  },
];

export const superQuerySchema = {
  code: { title: '物料编码', order: 0, view: 'text' },
  productCode: { title: '关联产品', order: 1, view: 'sel_search', dictTable: 'hn_product', dictText: 'name', dictCode: 'code' },
  status: { title: '状态', order: 2, view: 'list', dictCode: 'status' },
};
