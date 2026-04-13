import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '文件名', align: 'center', dataIndex: 'fileName' },
  { title: '所属年月', align: 'center', dataIndex: 'recordMonth' },
  { title: '总记录数', align: 'center', dataIndex: 'recordCount' },
  { title: '成功数', align: 'center', dataIndex: 'successCount' },
  { title: '失败数', align: 'center', dataIndex: 'failCount' },
  { title: '状态', align: 'center', dataIndex: 'status' },
  { title: '创建时间', align: 'center', dataIndex: 'createTime' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '文件名', field: 'fileName', component: 'JInput', colProps: { span: 6 } },
  { label: '所属年月', field: 'recordMonth', component: 'JInput', colProps: { span: 6 } },
  { label: '状态', field: 'status', component: 'JInput', colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '文件名', field: 'fileName', component: 'Input', componentProps: { placeholder: '请输入文件名' } },
  { label: '所属年月', field: 'recordMonth', component: 'Input', componentProps: { placeholder: '请输入所属年月' } },
  { label: '总记录数', field: 'recordCount', component: 'InputNumber', componentProps: { placeholder: '请输入总记录数', min: 0 } },
  { label: '成功数', field: 'successCount', component: 'InputNumber', componentProps: { placeholder: '请输入成功数', min: 0 } },
  { label: '失败数', field: 'failCount', component: 'InputNumber', componentProps: { placeholder: '请输入失败数', min: 0 } },
  { label: '状态', field: 'status', component: 'Input', componentProps: { placeholder: '请输入状态' } },
];
