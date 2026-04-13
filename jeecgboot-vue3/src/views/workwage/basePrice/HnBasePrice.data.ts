import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '产品', align: 'center', dataIndex: 'productId_dictText' },
  { title: '设备类型', align: 'center', dataIndex: 'equipmentType_dictText' },
  { title: '工序', align: 'center', dataIndex: 'processId_dictText' },
  { title: '熟练度', align: 'center', dataIndex: 'skillLevel_dictText' },
  { title: '单价', align: 'center', dataIndex: 'unitPrice' },
  { title: '状态', align: 'center', dataIndex: 'status_dictText' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '产品', field: 'productId', component: 'JSearchSelect', componentProps: { dict: 'hn_product,name,id' }, colProps: { span: 6 } },
  { label: '设备类型', field: 'equipmentType', component: 'JDictSelectTag', componentProps: { dictCode: 'equipment_type' }, colProps: { span: 6 } },
  { label: '最低单价', field: 'minPrice', component: 'InputNumber', componentProps: { placeholder: '请输入最低单价', precision: 4, min: 0 }, colProps: { span: 6 } },
  { label: '最高单价', field: 'maxPrice', component: 'InputNumber', componentProps: { placeholder: '请输入最高单价', precision: 4, min: 0 }, colProps: { span: 6 } },
  { label: '工序', field: 'processId', component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id' }, colProps: { span: 6 } },
  { label: '状态', field: 'status', component: 'JDictSelectTag', componentProps: { dictCode: 'status' }, colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '产品', field: 'productId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_product,name,id', placeholder: '请选择产品' } },
  { label: '设备类型', field: 'equipmentType', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'equipment_type', placeholder: '请选择设备类型' } },
  { label: '工序', field: 'processId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id', placeholder: '请选择工序' } },
  { label: '熟练度', field: 'skillLevel', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'skill_level', placeholder: '请选择熟练度' } },
  { label: '单价', field: 'unitPrice', required: true, component: 'InputNumber', componentProps: { placeholder: '请输入单价', precision: 4, min: 0 } },
  { label: '状态', field: 'status', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'status', placeholder: '请选择状态' } },
];

export const superQuerySchema = {
  productId: { title: '产品', order: 0, view: 'sel_search', dictTable: 'hn_product', dictText: 'name', dictCode: 'id' },
  equipmentType: { title: '设备类型', order: 1, view: 'list', dictCode: 'equipment_type' },
  processId: { title: '工序', order: 2, view: 'sel_search', dictTable: 'hn_process', dictText: 'name', dictCode: 'id' },
  skillLevel: { title: '熟练度', order: 3, view: 'list', dictCode: 'skill_level' },
  status: { title: '状态', order: 4, view: 'list', dictCode: 'status' },
};
