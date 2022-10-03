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
                label="ชื่อประเภท"
                label-for="h-title"
                label-cols-md="4"
              >
                <validation-provider
                  name="title"
                  rules="required"
                  #default="{ errors }"
                >
                  <b-form-input
                    id="h-title"
                    placeholder="ชื่อประเภท..."
                    v-model="bookTypeData.title"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ตัวย่อ"
                label-for="h-acronym"
                label-cols-md="4"
              >
                <validation-provider
                  name="title"
                  rules="required"
                  #default="{ errors }"
                >
                  <b-form-input
                    id="h-code"
                    placeholder="ตัวย่อ..."
                    v-model="bookTypeData.acronym"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เลขปัจจุบัน"
                label-for="h-code"
                label-cols-md="4"
              >
                <validation-provider
                  name="title"
                  rules="required"
                  #default="{ errors }"
                >
                  <b-form-input
                    id="h-code"
                    placeholder="ลำดับเลขปัจจุบัน..."
                    v-model="bookTypeData.code"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ปี"
                label-for="h-year"
                label-cols-md="4"
              >
                <validation-provider
                  name="year"
                  rules="required"
                  #default="{ errors }"
                >
                  <v-select
                    v-model="bookTypeData.year"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    label="title"
                    placeholder="-- เลือกปี --"
                    :options="selectOptions.year"
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
import bookTypeStoreModule from "../bookTypeStoreModule";
import useBookTypeEdit from "./useBookTypeEdit";

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
    const BOOK_TYPE_EDIT_APP_STORE_MODULE_NAME = "book-type-edit";

    // Register module
    if (!store.hasModule(BOOK_TYPE_EDIT_APP_STORE_MODULE_NAME))
      store.registerModule(
        BOOK_TYPE_EDIT_APP_STORE_MODULE_NAME,
        bookTypeStoreModule
      );

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(BOOK_TYPE_EDIT_APP_STORE_MODULE_NAME))
        store.unregisterModule(BOOK_TYPE_EDIT_APP_STORE_MODULE_NAME);
    });

    const {
      bookTypeData,
      validationForm,
      simpleRules,
      overLay,
      selectOptions,
    } = useBookTypeEdit();

    return {
      bookTypeData,
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
