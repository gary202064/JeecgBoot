import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '工人', align: 'center', dataIndex: 'workerId_dictText' },
  { title: '工序', align: 'center', dataIndex: 'processId_dictText' },
  { title: '能力状态', align: 'center', dataIndex: 'canFullWork_dictText' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '工人', field: 'workerId', component: 'JSearchSelect', componentProps: { dict: 'hn_worker,name,id' }, colProps: { span: 6 } },
  { label: '工序', field: 'processId', component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id' }, colProps: { span: 6 } },
  { label: '能力状态', field: 'canFullWork', component: 'JDictSelectTag', componentProps: { dictCode: 'ability_status' }, colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '工人', field: 'workerId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_worker,name,id', placeholder: '请选择工人' } },
  { label: '工序', field: 'processId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id', placeholder: '请选择工序' } },
  { label: '能力状态', field: 'canFullWork', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'ability_status', placeholder: '请选择能力状态' } },
];
