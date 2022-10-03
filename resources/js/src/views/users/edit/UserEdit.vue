<template>
  <b-card>
    <b-overlay
      :show="overLay"
      variant="light"
      opacity="0.3"
      blur="2px"
      rounded="sm"
      no-center
    >
      <validation-observer ref="simpleRules">
        <b-form>
          <b-row>

            <b-col cols="12">
              <b-form-group
                label="ชื่อ"
                label-for="h-firstname"
                label-cols-md="4"
              >
                <validation-provider name="firstname" #default="{ errors }">
                  <b-form-input
                    id="h-firstname"
                    placeholder="ชื่อ"
                    v-model="userData.firstname"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

             <b-col cols="12">
              <b-form-group
                label="นามสกุล"
                label-for="h-lastname"
                label-cols-md="4"
              >
                <validation-provider name="lastname" #default="{ errors }">
                  <b-form-input
                    id="h-lastname"
                    placeholder="นามสกุล"
                    v-model="userData.lastname"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เมล"
                label-for="h-email"
                label-cols-md="4"
              >
                <validation-provider name="email" #default="{ errors }">
                  <b-form-input
                    id="h-email"
                    placeholder="เมล"
                    v-model="userData.email"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ฝ่าย"
                label-for="h-department"
                label-cols-md="4"
              >
                <validation-provider
                  name="department"
                  rules="required"
                  #default="{ errors }"
                >
                  <v-select
                    v-model="userData.department"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    label="title"
                    placeholder="-- เลือกฝ่าย --"
                    :options="selectOptions.department"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

             <b-col cols="12">
              <b-form-group
                label="ประเภทผู้ใช้งาน"
                label-for="h-type"
                label-cols-md="4"
              >
                <validation-provider
                  name="type"
                  rules="required"
                  #default="{ errors }"
                >
                  <v-select
                    v-model="userData.type"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    label="title"
                    placeholder="-- เลือกประเภทผู้ใช้งาน --"
                    :options="selectOptions.type"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

             <b-col cols="12">
              <b-form-group
                label="สถานะ"
                label-for="h-status"
                label-cols-md="4"
              >
                <validation-provider
                  name="status"
                  rules="required"
                  #default="{ errors }"
                >
                  <v-select
                    v-model="userData.status"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    label="title"
                    placeholder="-- เลือกสถานะ --"
                    :options="selectOptions.status"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!-- submit and reset -->
            <b-col offset-md="4">
              <b-button
                v-ripple.400="'rgba(255, 255, 255, 0.15)'"
                type="submit"
                variant="primary"
                @click.prevent="validationForm"
                class="mr-1"
              >
                Submit
              </b-button>
            </b-col>
          </b-row>
        </b-form>
      </validation-observer>
      <template #overlay>
        <div>
          <div
            class="position-absolute"
            style="
              bottom: 10em;
              margin-left: auto;
              margin-right: auto;
              left: 0;
              right: 0;
              text-align: center;
            "
          >
            <b-spinner type="border" variant="primary"></b-spinner>
            <br />
            <span>Please wait...</span>
          </div>
        </div>
      </template>
    </b-overlay>
  </b-card>
</template>

<script>
import {
  BRow,
  BCol,
  BFormGroup,
  BInputGroup,
  BFormInput,
  BFormCheckbox,
  BFormTextarea,
  BForm,
  BButton,
  BCard,
  BBadge,
  BFormFile,
  BOverlay,
  BSpinner,
  BInputGroupPrepend,
} from "bootstrap-vue";
import vSelect from "vue-select";
import { ValidationProvider, ValidationObserver } from "vee-validate";
import { required, email } from "@validations";
import Ripple from "vue-ripple-directive";

import { onUnmounted } from "@vue/composition-api";
import store from "@/store";
import userListStoreModule from "../userListStoreModule";
import useUserEdit from "./useUserEdit";

export default {
  components: {
    ValidationProvider,
    ValidationObserver,
    required,
    email,
    BRow,
    BCol,
    BFormGroup,
    BInputGroup,
    BFormInput,
    BFormCheckbox,
    BFormTextarea,
    BForm,
    BButton,
    BCard,
    BBadge,
    vSelect,
    BFormFile,
    BOverlay,
    BSpinner,
    BInputGroupPrepend,
  },
  directives: {
    Ripple,
  },
  setup() {
    const USER_EDIT_APP_STORE_MODULE_NAME = "user-edit";

    // Register module
    if (!store.hasModule(USER_EDIT_APP_STORE_MODULE_NAME))
      store.registerModule(
        USER_EDIT_APP_STORE_MODULE_NAME,
        userListStoreModule
      );

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(USER_EDIT_APP_STORE_MODULE_NAME))
        store.unregisterModule(USER_EDIT_APP_STORE_MODULE_NAME);
    });

    const {
      userData,
      validationForm,
      simpleRules,
      selectOptions,
      overLay,
    } = useUserEdit();

    return {
      userData,
      validationForm,
      simpleRules,
      selectOptions,
      overLay,
    };
  },
};
</script>

<style lang="scss">
@import "@core/scss/vue/libs/vue-select.scss";
@import "@core/scss/vue/libs/vue-flatpicker.scss";
</style>
