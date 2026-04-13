import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '所属年月', align: 'center', dataIndex: 'recordMonth' },
  { title: '工人', align: 'center', dataIndex: 'workerId_dictText' },
  { title: '设备', align: 'center', dataIndex: 'equipmentId_dictText' },
  { title: '物料编码', align: 'center', dataIndex: 'materialCodeId_dictText' },
  { title: '工序', align: 'center', dataIndex: 'processId_dictText' },
  { title: '总数量', align: 'center', dataIndex: 'totalQuantity' },
  { title: '最终单价', align: 'center', dataIndex: 'unitPrice' },
  { title: '总金额', align: 'center', dataIndex: 'totalAmount' },
  { title: '原始记录数', align: 'center', dataIndex: 'recordCount' },
  { title: '汇总计算时间', align: 'center', dataIndex: 'calcTime' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '所属年月', field: 'recordMonth', component: 'JInput', colProps: { span: 6 } },
  { label: '工人', field: 'workerId', component: 'JSearchSelect', componentProps: { dict: 'hn_worker,name,id' }, colProps: { span: 6 } },
  { label: '设备', field: 'equipmentId', component: 'JSearchSelect', componentProps: { dict: 'hn_equipment,equipment_no,id' }, colProps: { span: 6 } },
  { label: '工序', field: 'processId', component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id' }, colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '所属年月', field: 'recordMonth', required: true, component: 'Input', componentProps: { placeholder: '请输入所属年月' } },
  { label: '工人', field: 'workerId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_worker,name,id', placeholder: '请选择工人' } },
  { label: '设备', field: 'equipmentId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_equipment,equipment_no,id', placeholder: '请选择设备' } },
  { label: '物料编码', field: 'materialCodeId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_material_code,code,id', placeholder: '请选择物料编码' } },
  { label: '工序', field: 'processId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id', placeholder: '请选择工序' } },
  { label: '总数量', field: 'totalQuantity', required: true, component: 'InputNumber', componentProps: { placeholder: '请输入总数量', min: 0 } },
  { label: '最终单价', field: 'unitPrice', component: 'InputNumber', componentProps: { placeholder: '请输入最终单价', precision: 4, min: 0 } },
  { label: '总金额', field: 'totalAmount', component: 'InputNumber', componentProps: { placeholder: '请输入总金额', precision: 2, min: 0 } },
  { label: '原始记录数', field: 'recordCount', component: 'InputNumber', componentProps: { placeholder: '请输入原始记录数', min: 0 } },
];
