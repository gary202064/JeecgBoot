import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '物料编码', align: 'center', dataIndex: 'materialCodeId_dictText' },
  { title: '尺寸维度名称', align: 'center', dataIndex: 'dimensionName' },
  { title: '尺寸值', align: 'center', dataIndex: 'dimensionValue' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '物料编码', field: 'materialCodeId', component: 'JSearchSelect', componentProps: { dict: 'hn_material_code,code,id' }, colProps: { span: 6 } },
  { label: '尺寸维度名称', field: 'dimensionName', component: 'Input', colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '物料编码', field: 'materialCodeId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_material_code,code,id', placeholder: '请选择物料编码' } },
  { label: '尺寸维度名称', field: 'dimensionName', required: true, component: 'Input', componentProps: { placeholder: '请输入尺寸维度名称' } },
  { label: '尺寸值', field: 'dimensionValue', required: true, component: 'InputNumber', componentProps: { placeholder: '请输入尺寸值', precision: 2, min: 0 } },
];

export const superQuerySchema = {
  materialCodeId: { title: '物料编码', order: 0, view: 'sel_search', dictTable: 'hn_material_code', dictText: 'code', dictCode: 'id' },
  dimensionName: { title: '尺寸维度名称', order: 1, view: 'text' },
  dimensionValue: { title: '尺寸值', order: 2, view: 'number' },
};
