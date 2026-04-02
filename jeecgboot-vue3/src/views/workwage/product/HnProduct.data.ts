import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  {
    title: '产品名称',
    align: 'center',
    dataIndex: 'name',
  },
  {
    title: '产品代码',
    align: 'center',
    dataIndex: 'code',
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
    label: '产品名称',
    field: 'name',
    component: 'JInput',
    colProps: { span: 6 },
  },
  {
    label: '产品代码',
    field: 'code',
    component: 'JInput',
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
    label: '产品名称',
    field: 'name',
    required: true,
    component: 'Input',
    componentProps: { placeholder: '请输入产品名称' },
  },
  {
    label: '产品代码',
    field: 'code',
    component: 'Input',
    componentProps: { placeholder: '请输入产品代码' },
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
  name: { title: '产品名称', order: 0, view: 'text' },
  code: { title: '产品代码', order: 1, view: 'text' },
  status: { title: '状态', order: 2, view: 'list', dictCode: 'status' },
};
