<template>
  <BasicModal v-bind="$attrs" @register="registerModal" destroyOnClose :title="title" :width="800" @ok="handleSubmit">
    <BasicForm @register="registerForm" name="HnMonthlyRecordForm" />
  </BasicModal>
</template>

<script lang="ts" setup>
  import { ref, computed, unref } from 'vue';
  import { BasicModal, useModalInner } from '/@/components/Modal';
  import { BasicForm, useForm } from '/@/components/Form/index';
  import { formSchema } from '../HnMonthlyRecord.data';
  import { saveOrUpdate } from '../HnMonthlyRecord.api';

  const emit = defineEmits(['register', 'success']);
  const isUpdate = ref(true);
  const isDetail = ref(false);

  const [registerForm, { setProps, resetFields, setFieldsValue, validate, scrollToField }] = useForm({
    labelWidth: 150, schemas: formSchema, showActionButtonGroup: false, baseColProps: { span: 12 },
  });

  const [registerModal, { setModalProps, closeModal }] = useModalInner(async (data) => {
    await resetFields();
    setModalProps({ confirmLoading: false, showCancelBtn: !!data?.showFooter, showOkBtn: !!data?.showFooter });
    isUpdate.value = !!data?.isUpdate;
    isDetail.value = !!data?.showFooter;
    if (unref(isUpdate)) {
      // 编辑模式：注入 __editMode=true 允许修改计算状态
      await setFieldsValue({ ...data.record, __editMode: true });
    } else {
      // 新增模式：注入 __editMode=false 禁用计算状态，默认值 pending
      await setFieldsValue({ __editMode: false, calcStatus: 'pending' });
    }
    setProps({ disabled: !data?.showFooter });
  });

  const title = computed(() => (!unref(isUpdate) ? '新增' : !unref(isDetail) ? '详情' : '编辑'));

  async function handleSubmit(v) {
    try {
      let values = await validate();
      setModalProps({ confirmLoading: true });
      await saveOrUpdate(values, isUpdate.value);
      closeModal();
      emit('success');
    } catch ({ errorFields }) {
      if (errorFields) { const firstField = errorFields[0]; if (firstField) { scrollToField(firstField.name, { behavior: 'smooth', block: 'center' }); } }
      return Promise.reject(errorFields);
    } finally { setModalProps({ confirmLoading: false }); }
  }
</script>

<style lang="less" scoped>
  :deep(.ant-input-number) { width: 100%; }
  :deep(.ant-calendar-picker) { width: 100%; }
</style>
