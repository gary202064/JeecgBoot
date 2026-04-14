import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '所属年月', align: 'center', dataIndex: 'recordMonth' },
  { title: '工人', align: 'center', dataIndex: 'workerId_dictText' },
  { title: '设备', align: 'center', dataIndex: 'equipmentId_dictText' },
  { title: '产线', align: 'center', dataIndex: 'equipmentType_dictText' },
  { title: '物料编码', align: 'center', dataIndex: 'materialCodeId_dictText' },
  { title: '工序', align: 'center', dataIndex: 'processId_dictText' },
  { title: '合格数量', align: 'center', dataIndex: 'quantity' },
  { title: '计算单价', align: 'center', dataIndex: 'unitPrice' },
  { title: '总金额', align: 'center', dataIndex: 'totalAmount' },
  { title: '价格来源', align: 'center', dataIndex: 'priceSource' },
  { title: '计算状态', align: 'center', dataIndex: 'calcStatus_dictText' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '所属年月', field: 'recordMonth', component: 'JInput', colProps: { span: 6 } },
  { label: '工人', field: 'workerId', component: 'JSearchSelect', componentProps: { dict: 'hn_worker,name,id' }, colProps: { span: 6 } },
  { label: '设备', field: 'equipmentId', component: 'JSearchSelect', componentProps: { dict: 'hn_equipment,equipment_no,id' }, colProps: { span: 6 } },
  { label: '计算状态', field: 'calcStatus', component: 'JDictSelectTag', componentProps: { dictCode: 'calc_status', placeholder: '请选择计算状态' }, colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '所属年月', field: 'recordMonth', required: true, component: 'Input', componentProps: { placeholder: '请输入所属年月，如：2026-03' } },
  { label: '工人', field: 'workerId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_worker,name,id', placeholder: '请选择工人' } },
  { label: '设备', field: 'equipmentId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_equipment,equipment_no,id', placeholder: '请选择设备' } },
  { label: '产线', field: 'equipmentType', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'equipment_type', placeholder: '请选择产线' } },
  { label: '物料编码', field: 'materialCodeId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_material_code,code,id', placeholder: '请选择物料编码' } },
  { label: '工序', field: 'processId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id', placeholder: '请选择工序' } },
  { label: '合格数量', field: 'quantity', required: true, component: 'InputNumber', componentProps: { placeholder: '请输入合格数量', min: 0 } },
  {
    label: '计算状态',
    field: 'calcStatus',
    component: 'JDictSelectTag',
    componentProps: { dictCode: 'calc_status', placeholder: '请选择计算状态' },
    dynamicDisabled: ({ values }) => !values.__editMode,
    defaultValue: 'pending',
  },
  { label: '手工补录单价', field: 'manualPrice', component: 'InputNumber', componentProps: { placeholder: '请输入手工补录单价', precision: 4, min: 0 } },
];

export const superQuerySchema = {
  recordMonth: { title: '所属年月', order: 0, view: 'text' },
  workerId: { title: '工人', order: 1, view: 'sel_search', dictTable: 'hn_worker', dictText: 'name', dictCode: 'id' },
  equipmentId: { title: '设备', order: 2, view: 'sel_search', dictTable: 'hn_equipment', dictText: 'equipment_no', dictCode: 'id' },
  processId: { title: '工序', order: 3, view: 'sel_search', dictTable: 'hn_process', dictText: 'name', dictCode: 'id' },
  calcStatus: { title: '计算状态', order: 4, view: 'list', dictCode: 'calc_status' },
};
