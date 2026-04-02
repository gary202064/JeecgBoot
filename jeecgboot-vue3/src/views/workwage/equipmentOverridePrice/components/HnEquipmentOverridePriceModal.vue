<template>
  <BasicModal v-bind="$attrs" @register="registerModal" destroyOnClose :title="title" :width="800" @ok="handleSubmit">
    <BasicForm @register="registerForm" name="HnEquipmentOverridePriceForm" />
  </BasicModal>
</template>

<script lang="ts" setup>
  import { ref, computed, unref } from 'vue';
  import { BasicModal, useModalInner } from '/@/components/Modal';
  import { BasicForm, useForm } from '/@/components/Form/index';
  import { formSchema } from '../HnEquipmentOverridePrice.data';
  import { saveOrUpdate } from '../HnEquipmentOverridePrice.api';

  const emit = defineEmits(['register', 'success']);
  const isUpdate = ref(true);
  const isDetail = ref(false);

  const [registerForm, { setProps, resetFields, setFieldsValue, validate, scrollToField }] = useForm({
    labelWidth: 150, schemas: formSchema, showActionButtonGroup: false, baseColProps: { span: 24 },
  });

  const [registerModal, { setModalProps, closeModal }] = useModalInner(async (data) => {
    await resetFields();
    setModalProps({ confirmLoading: false, showCancelBtn: !!data?.showFooter, showOkBtn: !!data?.showFooter });
    isUpdate.value = !!data?.isUpdate;
    isDetail.value = !!data?.showFooter;
    if (unref(isUpdate)) { await setFieldsValue({ ...data.record }); }
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
