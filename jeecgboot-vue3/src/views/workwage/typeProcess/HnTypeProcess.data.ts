import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '设备类型', align: 'center', dataIndex: 'typeId_dictText' },
  { title: '工序', align: 'center', dataIndex: 'processId_dictText' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '设备类型', field: 'typeId', component: 'JDictSelectTag', componentProps: { dictCode: 'equipment_type' }, colProps: { span: 6 } },
  { label: '工序', field: 'processId', component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id' }, colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '设备类型', field: 'typeId', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'equipment_type', placeholder: '请选择设备类型' } },
  { label: '工序', field: 'processId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id', placeholder: '请选择工序' } },
];
