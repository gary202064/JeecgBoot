import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';
import { getDimensionNames } from './HnComplexPrice.api';

// 运算符选项
const minOpOptions = [
  { label: '>= （大于等于）', value: '>=' },
  { label: '>  （大于）', value: '>' },
];
const maxOpOptions = [
  { label: '<= （小于等于）', value: '<=' },
  { label: '<  （小于）', value: '<' },
];

export const columns: BasicColumn[] = [
  { title: '工序', align: 'center', dataIndex: 'processId_dictText' },
  { title: '产线', align: 'center', dataIndex: 'equipmentType_dictText' },
  { title: '技能等级', align: 'center', dataIndex: 'skillLevel_dictText' },
  { title: '尺寸维度', align: 'center', dataIndex: 'dimensionName' },
  {
    title: '区间下限',
    align: 'center',
    dataIndex: 'rangeMin',
    customRender: ({ record }) => {
      if (record.rangeMinOp && record.rangeMin != null) return `${record.rangeMinOp} ${record.rangeMin}`;
      return '无下限';
    },
  },
  {
    title: '区间上限',
    align: 'center',
    dataIndex: 'rangeMax',
    customRender: ({ record }) => {
      if (record.rangeMaxOp && record.rangeMax != null) return `${record.rangeMaxOp} ${record.rangeMax}`;
      return '无上限';
    },
  },
  { title: '单价', align: 'center', dataIndex: 'unitPrice' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '工序', field: 'processId', component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id' }, colProps: { span: 6 } },
  { label: '产线', field: 'equipmentType', component: 'JDictSelectTag', componentProps: { dictCode: 'equipment_type' }, colProps: { span: 6 } },
  { label: '技能等级', field: 'skillLevel', component: 'JDictSelectTag', componentProps: { dictCode: 'skill_level' }, colProps: { span: 6 } },
  { label: '尺寸维度', field: 'dimensionName', component: 'Input', colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '工序', field: 'processId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id', placeholder: '请选择工序' } },
  { label: '产线', field: 'equipmentType', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'equipment_type', placeholder: '请选择产线' } },
  { label: '技能等级', field: 'skillLevel', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'skill_level', placeholder: '请选择技能等级' } },
  {
    label: '尺寸维度',
    field: 'dimensionName',
    required: true,
    component: 'ApiSelect',
    componentProps: {
      api: getDimensionNames,
      resultField: 'result',
      labelField: 'label',
      valueField: 'value',
      immediate: true,
      afterFetch: (data: string[]) => data.map((name) => ({ label: name, value: name })),
      placeholder: '请选择尺寸维度名称',
      showSearch: true,
    },
  },
  {
    label: '最小值运算符',
    field: 'rangeMinOp',
    component: 'Select',
    componentProps: { options: minOpOptions, placeholder: '请选择（无选则表示无下限）', allowClear: true },
  },
  {
    label: '区间最小值',
    field: 'rangeMin',
    component: 'InputNumber',
    componentProps: { placeholder: '无选则表示无下限', precision: 2, min: 0 },
  },
  {
    label: '最大值运算符',
    field: 'rangeMaxOp',
    component: 'Select',
    componentProps: { options: maxOpOptions, placeholder: '请选择（无选则表示无上限）', allowClear: true },
  },
  {
    label: '区间最大值',
    field: 'rangeMax',
    component: 'InputNumber',
    componentProps: { placeholder: '无选则表示无上限', precision: 2, min: 0 },
  },
  { label: '单价', field: 'unitPrice', required: true, component: 'InputNumber', componentProps: { placeholder: '请输入单价', precision: 4, min: 0 } },
];

export const superQuerySchema = {
  processId: { title: '工序', order: 0, view: 'sel_search', dictTable: 'hn_process', dictText: 'name', dictCode: 'id' },
  equipmentType: { title: '产线', order: 1, view: 'list', dictCode: 'equipment_type' },
  skillLevel: { title: '技能等级', order: 2, view: 'list', dictCode: 'skill_level' },
  dimensionName: { title: '尺寸维度', order: 3, view: 'text' },
};
