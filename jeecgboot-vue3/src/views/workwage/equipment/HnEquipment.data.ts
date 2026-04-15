import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';
import { rules } from '/@/utils/helper/validator';
import { render } from '/@/utils/common/renderUtils';

// 列表列定义
export const columns: BasicColumn[] = [
  {
    title: '设备名称',
    align: 'center',
    dataIndex: 'equipmentName',
  },
  {
    title: '设备编号',
    align: 'center',
    dataIndex: 'equipmentNo',
  },
  {
    title: '产线',
    align: 'center',
    dataIndex: 'equipmentType_dictText',
  },
  {
    title: '状态',
    align: 'center',
    dataIndex: 'status_dictText',
  },
  {
    title: '创建时间',
    align: 'center',
    dataIndex: 'createTime',
  },
];

// 查询表单 Schema
export const searchFormSchema: FormSchema[] = [
  {
    label: '设备名称',
    field: 'equipmentName',
    component: 'JInput',
    colProps: { span: 6 },
  },
  {
    label: '设备编号',
    field: 'equipmentNo',
    component: 'JInput',
    colProps: { span: 6 },
  },
  {
    label: '产线',
    field: 'equipmentType',
    component: 'JDictSelectTag',
    componentProps: { dictCode: 'equipment_type' },
    colProps: { span: 6 },
  },
  {
    label: '状态',
    field: 'status',
    component: 'JDictSelectTag',
    componentProps: { dictCode: 'status' },
    colProps: { span: 6 },
  },
];

// 编辑表单 Schema
export const formSchema: FormSchema[] = [
  {
    label: '',
    field: 'id',
    component: 'Input',
    show: false,
  },
  {
    label: '设备名称',
    field: 'equipmentName',
    required: true,
    component: 'Input',
    componentProps: { placeholder: '请输入设备名称' },
  },
  {
    label: '设备编号',
    field: 'equipmentNo',
    required: true,
    component: 'Input',
    componentProps: { placeholder: '请输入设备编号' },
  },
  {
    label: '产线',
    field: 'equipmentType',
    required: true,
    component: 'JDictSelectTag',
    componentProps: { dictCode: 'equipment_type', placeholder: '请选择产线' },
  },
  {
    label: '状态',
    field: 'status',
    required: true,
    component: 'JDictSelectTag',
    componentProps: { dictCode: 'status', placeholder: '请选择状态' },
  },
];

// 高级查询配置
export const superQuerySchema = {
  equipmentName: { title: '设备名称', order: 0, view: 'text' },
  equipmentNo: { title: '设备编号', order: 1, view: 'text' },
  equipmentType: { title: '产线', order: 2, view: 'list', dictCode: 'equipment_type' },
  status: { title: '状态', order: 4, view: 'list', dictCode: 'status' },
};
