import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '来源表', align: 'center', dataIndex: 'tableName' },
  { title: '来源记录ID', align: 'center', dataIndex: 'recordId' },
  { title: '旧单价', align: 'center', dataIndex: 'oldPrice' },
  { title: '新单价', align: 'center', dataIndex: 'newPrice' },
  { title: '生效日期', align: 'center', dataIndex: 'effectiveDate' },
  { title: '创建人', align: 'center', dataIndex: 'createBy' },
  { title: '创建时间', align: 'center', dataIndex: 'createTime' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '来源表', field: 'tableName', component: 'JInput', colProps: { span: 6 } },
  { label: '来源记录ID', field: 'recordId', component: 'JInput', colProps: { span: 6 } },
  { label: '生效日期', field: 'effectiveDate', component: 'DatePicker', componentProps: { valueFormat: 'YYYY-MM-DD' }, colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '来源表', field: 'tableName', component: 'Input', componentProps: { placeholder: '请输入来源表' } },
  { label: '来源记录ID', field: 'recordId', component: 'InputNumber', componentProps: { placeholder: '请输入来源记录ID' } },
  { label: '旧单价', field: 'oldPrice', component: 'InputNumber', componentProps: { placeholder: '请输入旧单价', precision: 4, min: 0 } },
  { label: '新单价', field: 'newPrice', component: 'InputNumber', componentProps: { placeholder: '请输入新单价', precision: 4, min: 0 } },
  { label: '生效日期', field: 'effectiveDate', component: 'DatePicker', componentProps: { valueFormat: 'YYYY-MM-DD', placeholder: '请选择生效日期' } },
];
