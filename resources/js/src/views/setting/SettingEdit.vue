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
            <!-- with prop append -->
            <b-col cols="12">
              <b-form-group
                label="email"
                label-for="h-email"
                label-cols-md="4"
              >
                <validation-provider
                  name="email"
                  rules="required"
                  #default="{ errors }"
                >
                  <b-form-input
                    id="h-email"
                    placeholder="email..."
                    v-model="settingData.email"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="password"
                label-for="h-password"
                label-cols-md="4"
              >
                <validation-provider
                  name="password"
                  rules="required"
                  #default="{ errors }"
                >
                  <b-form-input
                    id="h-password"
                    type="password"
                    placeholder="password..."
                    v-model="settingData.password"
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
} from "bootstrap-vue";
import vSelect from "vue-select";
import { ValidationProvider, ValidationObserver } from "vee-validate";
import { required, email } from "@validations";
import Ripple from "vue-ripple-directive";

import { onUnmounted } from "@vue/composition-api";
import store from "@/store";
import settingStoreModule from "./settingStoreModule";
import useSettingEdit from "./useSettingEdit";

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
  },
  directives: {
    Ripple,
  },
  setup() {
    const SETTING_EDIT_APP_STORE_MODULE_NAME = "setting-edit";

    // Register module
    if (!store.hasModule(SETTING_EDIT_APP_STORE_MODULE_NAME))
      store.registerModule(
        SETTING_EDIT_APP_STORE_MODULE_NAME,
        settingStoreModule
      );

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(SETTING_EDIT_APP_STORE_MODULE_NAME))
        store.unregisterModule(SETTING_EDIT_APP_STORE_MODULE_NAME);
    });

    const {
      settingData,
      validationForm,
      simpleRules,
      selectOptions,
      overLay,
    } = useSettingEdit();

    return {
      settingData,
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
</style>
