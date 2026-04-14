import { BasicColumn } from '/@/components/Table';
import { FormSchema } from '/@/components/Table';

export const columns: BasicColumn[] = [
  { title: '生产订单编号', align: 'center', dataIndex: 'productionOrderNo' },
  { title: '单据日期', align: 'center', dataIndex: 'documentDate' },
  { title: '作业', align: 'center', dataIndex: 'processId_dictText' },
  { title: '操作工姓名', align: 'center', dataIndex: 'workerId_dictText' },
  { title: '批号', align: 'center', dataIndex: 'batchNo' },
  { title: '旧物料编码', align: 'center', dataIndex: 'materialCodeId_dictText' },
  { title: '合格数量', align: 'center', dataIndex: 'quantity' },
  { title: '工废数量', align: 'center', dataIndex: 'scrapQty' },
  { title: '轮废数量', align: 'center', dataIndex: 'wheelWasteQty' },
  { title: '杆废数量', align: 'center', dataIndex: 'rodWasteQty' },
  { title: '料废数量', align: 'center', dataIndex: 'materialWasteQty' },
  { title: '次品数量', align: 'center', dataIndex: 'defectQty' },
  { title: '检验员', align: 'center', dataIndex: 'inspector' },
  { title: '产品名称', align: 'center', dataIndex: 'productName' },
  { title: '产品编码', align: 'center', dataIndex: 'productCode' },
  { title: '订单生产车间', align: 'center', dataIndex: 'equipmentType_dictText' },
  { title: '设备', align: 'center', dataIndex: 'equipmentId_dictText' },
  { title: '计算单价', align: 'center', dataIndex: 'unitPrice' },
  { title: '总金额', align: 'center', dataIndex: 'totalAmount' },
  { title: '价格来源', align: 'center', dataIndex: 'priceSource' },
  { title: '计算状态', align: 'center', dataIndex: 'calcStatus_dictText' },
];

export const searchFormSchema: FormSchema[] = [
  { label: '工人', field: 'workerId', component: 'JSearchSelect', componentProps: { dict: 'hn_worker,name,id' }, colProps: { span: 6 } },
  { label: '设备', field: 'equipmentId', component: 'JSearchSelect', componentProps: { dict: 'hn_equipment,equipment_no,id' }, colProps: { span: 6 } },
  { label: '计算状态', field: 'calcStatus', component: 'JDictSelectTag', componentProps: { dictCode: 'calc_status', placeholder: '请选择计算状态' }, colProps: { span: 6 } },
];

export const formSchema: FormSchema[] = [
  { label: '', field: 'id', component: 'Input', show: false },
  { label: '', field: '__editMode', component: 'Input', show: false },
  { label: '生产订单编号', field: 'productionOrderNo', component: 'Input', componentProps: { placeholder: '请输入生产订单编号' } },
  { label: '单据日期', field: 'documentDate', component: 'DatePicker', componentProps: { valueFormat: 'YYYY-MM-DD', placeholder: '请选择单据日期' } },
  { label: '作业', field: 'processId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_process,name,id', placeholder: '请选择作业' } },
  { label: '操作工姓名', field: 'workerId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_worker,name,id', placeholder: '请选择操作工' } },
  { label: '批号', field: 'batchNo', component: 'Input', componentProps: { placeholder: '请输入批号' } },
  { label: '旧物料编码', field: 'materialCodeId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_material_code,code,id', placeholder: '请选择物料编码' } },
  { label: '合格数量', field: 'quantity', required: true, component: 'InputNumber', componentProps: { placeholder: '请输入合格数量', min: 0 } },
  { label: '工废数量', field: 'scrapQty', component: 'InputNumber', componentProps: { placeholder: '请输入工废数量', min: 0 } },
  { label: '轮废数量', field: 'wheelWasteQty', component: 'InputNumber', componentProps: { placeholder: '请输入轮废数量', min: 0 } },
  { label: '杆废数量', field: 'rodWasteQty', component: 'InputNumber', componentProps: { placeholder: '请输入杆废数量', min: 0 } },
  { label: '料废数量', field: 'materialWasteQty', component: 'InputNumber', componentProps: { placeholder: '请输入料废数量', min: 0 } },
  { label: '次品数量', field: 'defectQty', component: 'InputNumber', componentProps: { placeholder: '请输入次品数量', min: 0 } },
  { label: '检验员', field: 'inspector', component: 'Input', componentProps: { placeholder: '请输入检验员' } },
  { label: '产品名称', field: 'productName', component: 'Input', componentProps: { placeholder: '请输入产品名称' } },
  { label: '产品编码', field: 'productCode', component: 'Input', componentProps: { placeholder: '请输入产品编码' } },
  { label: '订单生产车间', field: 'equipmentType', required: true, component: 'JDictSelectTag', componentProps: { dictCode: 'equipment_type', placeholder: '请选择订单生产车间' } },
  { label: '设备', field: 'equipmentId', required: true, component: 'JSearchSelect', componentProps: { dict: 'hn_equipment,equipment_no,id', placeholder: '请选择设备' } },
  {
    label: '计算状态',
    field: 'calcStatus',
    component: 'JDictSelectTag',
    componentProps: { dictCode: 'calc_status', placeholder: '请选择计算状态' },
    dynamicDisabled: ({ values }) => !values.__editMode,
    defaultValue: 'pending',
  },
  {
    label: '手工补录单价',
    field: 'manualPrice',
    component: 'InputNumber',
    componentProps: { placeholder: '请输入手工补录单价', precision: 4, min: 0 },
    dynamicDisabled: ({ values }) => values.calcStatus !== 'manual',
    dynamicRules: ({ values }) => {
      if (values.calcStatus === 'manual') {
        return [{ required: true, message: '计算状态为手工补录时，请输入手工补录单价' }];
      }
      return [];
    },
  },
];

export const superQuerySchema = {
  workerId: { title: '工人', order: 1, view: 'sel_search', dictTable: 'hn_worker', dictText: 'name', dictCode: 'id' },
  equipmentId: { title: '设备', order: 2, view: 'sel_search', dictTable: 'hn_equipment', dictText: 'equipment_no', dictCode: 'id' },
  processId: { title: '工序', order: 3, view: 'sel_search', dictTable: 'hn_process', dictText: 'name', dictCode: 'id' },
  calcStatus: { title: '计算状态', order: 4, view: 'list', dictCode: 'calc_status' },
};
