import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '工人姓名', align: 'center', dataIndex: 'name' },
  { title: '工号', align: 'center', dataIndex: 'employeeNo' },

  { title: '状态', align: 'center', dataIndex: 'status_dictText' },
  { title: '创建时间', align: 'center', dataIndex: 'createTime' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '工人姓名', field: 'name', component: 'JInput', colProps: { span: 6 } },
  { label: '工号', field: 'employeeNo', component: 'JInput', colProps: { span: 6 } },

  { label: '状态', field: 'status', component: 'JDictSelectTag', componentProps: { dictCode: 'work_status' }, colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '工人姓名', field: 'name', required: true, component: 'Input', componentProps: { placeholder: '请输入工人姓名' } },
  { label: '工号', field: 'employeeNo', required: true, component: 'Input', componentProps: { placeholder: '请输入工号' } },

  { label: '状态', field: 'status', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'work_status', placeholder: '请选择状态' } },
];

export const superQuerySchema = {
  name: { title: '工人姓名', order: 0, view: 'text' },
  employeeNo: { title: '工号', order: 1, view: 'text' },

  status: { title: '状态', order: 3, view: 'list', dictCode: 'work_status' },
};
