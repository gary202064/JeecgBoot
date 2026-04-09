import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '工序', align: 'center', dataIndex: 'processId_dictText' },
  { title: '设备类型', align: 'center', dataIndex: 'equipmentType_dictText' },
  { title: '技能等级', align: 'center', dataIndex: 'skillLevel_dictText' },
  { title: '尺寸维度', align: 'center', dataIndex: 'dimensionName' },
  { title: '区间最小值', align: 'center', dataIndex: 'rangeMin' },
  { title: '区间最大值', align: 'center', dataIndex: 'rangeMax' },
  { title: '单价', align: 'center', dataIndex: 'unitPrice' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '工序', field: 'processId', component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id' }, colProps: { span: 6 } },
  { label: '设备类型', field: 'equipmentType', component: 'JDictSelectTag', componentProps: { dictCode: 'equipment_type' }, colProps: { span: 6 } },
  { label: '技能等级', field: 'skillLevel', component: 'JDictSelectTag', componentProps: { dictCode: 'skill_level' }, colProps: { span: 6 } },
  { label: '尺寸维度', field: 'dimensionName', component: 'Input', colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '工序', field: 'processId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id', placeholder: '请选择工序' } },
  { label: '设备类型', field: 'equipmentType', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'equipment_type', placeholder: '请选择设备类型' } },
  { label: '技能等级', field: 'skillLevel', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'skill_level', placeholder: '请选择技能等级' } },
  { label: '尺寸维度', field: 'dimensionName', required: true, component: 'Input', componentProps: { placeholder: '请输入尺寸维度名称' } },
  { label: '区间最小值', field: 'rangeMin', required: true, component: 'InputNumber', componentProps: { placeholder: '请输入区间最小值（包含）', precision: 2, min: 0 } },
  { label: '区间最大值', field: 'rangeMax', required: true, component: 'InputNumber', componentProps: { placeholder: '请输入区间最大值（不包含）', precision: 2, min: 0 } },
  { label: '单价', field: 'unitPrice', required: true, component: 'InputNumber', componentProps: { placeholder: '请输入单价', precision: 4, min: 0 } },
];

export const superQuerySchema = {
  processId: { title: '工序', order: 0, view: 'sel_search', dictTable: 'hn_process', dictText: 'name', dictCode: 'id' },
  equipmentType: { title: '设备类型', order: 1, view: 'list', dictCode: 'equipment_type' },
  skillLevel: { title: '技能等级', order: 2, view: 'list', dictCode: 'skill_level' },
  dimensionName: { title: '尺寸维度', order: 3, view: 'text' },
};
