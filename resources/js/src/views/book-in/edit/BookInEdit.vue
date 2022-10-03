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
                label="ประเภทเอกสาร"
                label-for="h-category"
                label-cols-md="4"
              >
                <validation-provider
                  name="category"
                  rules="required"
                  #default="{ errors }"
                >
                  <v-select
                    v-model="bookInData.category"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    label="title"
                    placeholder="-- เลือกประเภทเอกสาร --"
                    :options="selectOptions.category"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เรื่องเอกสาร"
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
                    placeholder="ชื่อเรื่อง..."
                    v-model="bookInData.title"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เลขที่ต้นทาง"
                label-for="h-from-no"
                label-cols-md="4"
              >
                <validation-provider name="fromNo" #default="{ errors }">
                  <b-form-input
                    id="h-from-no"
                    placeholder="เลขเอกสารจากต้นทาง"
                    v-model="bookInData.fromNo"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="จาก"
                label-for="h-from"
                label-cols-md="4"
              >
                <validation-provider name="from" #default="{ errors }">
                  <b-form-input
                    id="h-from-no"
                    placeholder="หน่วยงานต้นทาง"
                    v-model="bookInData.from"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
                <b-form-group
                    label="ถึง"
                    label-for="h-toSend"
                    label-cols-md="4"
                >
                    <validation-provider name="toSend" #default="{ errors }">
                    <b-form-input
                        id="h-to-send"
                        placeholder="ถึง"
                        v-model="bookInData.toSend"
                    />
                    <small class="text-danger">{{ errors[0] }}</small>
                    </validation-provider>
                </b-form-group>
                </b-col>

            <b-col cols="12">
              <b-form-group
                label="ลงวันที่"
                label-for="h-fromDate"
                label-cols-md="4"
              >
                <validation-provider name="fromDate" #default="{ errors }">
                  <flat-pickr
                    id="h-fromDate"
                    v-model="bookInData.fromDate"
                    placeholder="วันที่ส่งเอกสารจากต้นทาง"
                    class="form-control"
                    :config="configDate"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เลขรับเอกสาร"
                label-for="h-book-no"
                label-cols-md="4"
              >
                <validation-provider
                  name="bookNo"
                  rules="required"
                  #default="{ errors }"
                >
                  <b-input-group :append="bookNoLastest">
                    <b-form-input
                      id="h-book-no"
                      placeholder="book No."
                      v-model="bookInData.bookNo"
                    />
                  </b-input-group>

                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="วันที่รับเอกสาร"
                label-for="h-dateReceive"
                label-cols-md="4"
              >
                <validation-provider
                  name="dateReceive"
                  #default="{ errors }"
                  rules="required"
                >
                  <flat-pickr
                    id="h-dateReceive"
                    v-model="bookInData.dateReceive"
                    placeholder="วันที่รับเอกสาร"
                    class="form-control"
                    :config="configDate"
                  />

                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ฝ่ายที่เกี่ยวข้อง"
                label-for="h-departmentTo"
                label-cols-md="4"
              >
                <validation-provider
                  name="departmentTo"
                  rules="required"
                  #default="{ errors }"
                >
                  <v-select
                    v-model="bookInData.departmentTo"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    label="title"
                    placeholder="-- เลือกฝ่ายที่เกี่ยวข้อง --"
                    :options="selectOptions.department"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ผู้ที่เกี่ยวข้อง (ส่งเมล)"
                label-for="h-bookTo"
                label-cols-md="4"
              >
                <b-row>
                  <b-col cols="12">
                    <validation-provider name="bookTo" #default="{ errors }">
                      <v-select
                        v-model="bookInData.bookTo"
                        :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                        label="title"
                        multiple
                        taggable
                        placeholder="-- เลือกผู้ที่เกี่ยวข้อง --"
                        :options="selectOptions.email"
                      />
                      <small class="text-danger">{{ errors[0] }}</small>
                    </validation-provider>
                  </b-col>

                  <b-col cols="2" class="mt-1">
                    <b-button
                      v-ripple.400="'rgba(255, 255, 255, 0.15)'"
                      type="button"
                      variant="danger"
                      @click.prevent="bookInData.bookTo = ''"
                      class="mr-1"
                    >
                      Clear
                    </b-button>
                  </b-col>
                  <b-col cols="10" class="mt-1">
                    <v-select
                      v-model="bookInData.emailGroup"
                      :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                      label="title"
                      placeholder="-- เลือกจากกลุ่ม --"
                      :options="selectOptions.emailGroup"
                    />
                  </b-col>
                </b-row>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="หมายเหตุ"
                label-for="h-detail"
                label-cols-md="4"
              >
                <validation-provider name="detail" #default="{ errors }">
                  <b-form-textarea
                    id="h-detail"
                    placeholder="หมายเหตุ"
                    v-model="bookInData.detail"
                    rows="3"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!-- <b-col cols="12">
            <b-form-group label="เอกสารที่เกี่ยวข้อง" label-for="h-bookTo" label-cols-md="4">
              <validation-provider name="bookTo" #default="{ errors }">
                <b-form-input
                  id="h-bookTo"
                  placeholder="ผู้เกี่ยวข้อง"
                  v-model="bookInData.bookTo"
                />
                <small class="text-danger">{{ errors[0] }}</small>
              </validation-provider>
            </b-form-group>
          </b-col> -->

            <b-col cols="12">
              <b-form-group
                label="แก้ไขไฟล์ต้นฉบับ"
                label-for="h-file"
                label-cols-md="4"
              >
                <validation-provider name="file" #default="{ errors }">
                  <b-input-group>
                    <b-input-group-prepend>
                      <b-button
                        variant="outline-warning"
                        target="_blank"
                        :href="bookInData.oldFile"
                      >
                        <feather-icon icon="FileTextIcon" /> ดูไฟล์เดิม
                      </b-button>
                    </b-input-group-prepend>
                    <b-form-file
                      id="h-file"
                      v-model="bookInData.file"
                      placeholder="Choose a new file or drop it here..."
                      drop-placeholder="Drop file here..."
                    />
                  </b-input-group>

                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

             <b-col cols="12">
              <b-form-group
                label="แก้ไขไฟล์ฉบับสมบูรณ์"
                label-for="h-file"
                label-cols-md="4"
              >
                <validation-provider name="fileSuccess" #default="{ errors }">
                  <b-input-group>
                    <b-input-group-prepend>
                      <b-button
                        :variant="`outline-${bookInData.oldFileSuccess == null ? 'dark': 'warning'}`"
                        target="_blank"
                        :disabled="bookInData.oldFileSuccess == null"
                        :href="bookInData.oldFileSuccess"
                      >
                        <feather-icon icon="FileTextIcon" /> ดูไฟล์เดิม
                      </b-button>
                    </b-input-group-prepend>
                    <b-form-file
                      id="h-file-success"
                      v-model="bookInData.fileSuccess"
                      placeholder="Choose a new file or drop it here..."
                      drop-placeholder="Drop file here..."
                    />
                  </b-input-group>

                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ต้องการส่งเมลอีกครั้งใช่หรือไม่?"
                label-for="h-detail"
                label-cols-md="4"
              >
                <b-form-checkbox v-model="bookInData.isSendEmail" value="true" class="custom-control-success" style="margin-top:0.5rem">
                    ใช่
                </b-form-checkbox>
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
import flatPickr from "vue-flatpickr-component";
import { Thai } from "flatpickr/dist/l10n/th.js";

import { onUnmounted } from "@vue/composition-api";
import store from "@/store";
import bookInStoreModule from "../bookInStoreModule";
import useBookInEdit from "./useBookInEdit";

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
    flatPickr,
    BFormFile,
    BOverlay,
    BSpinner,
    BInputGroupPrepend,
  },
  directives: {
    Ripple,
  },
  data() {
    return {
      configDate: {
        altInput: true,
        altFormat: "j F Y",
        dateFormat: "Y-m-d",
        locale: Thai,
      },
    };
  },
  setup() {
    const BOOK_IN_EDIT_APP_STORE_MODULE_NAME = "book-in-edit";

    // Register module
    if (!store.hasModule(BOOK_IN_EDIT_APP_STORE_MODULE_NAME))
      store.registerModule(
        BOOK_IN_EDIT_APP_STORE_MODULE_NAME,
        bookInStoreModule
      );

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(BOOK_IN_EDIT_APP_STORE_MODULE_NAME))
        store.unregisterModule(BOOK_IN_EDIT_APP_STORE_MODULE_NAME);
    });

    const {
      bookInData,
      validationForm,
      simpleRules,
      selectOptions,
      bookNoLastest,
      overLay,
    } = useBookInEdit();

    return {
      bookInData,
      validationForm,
      simpleRules,
      selectOptions,
      bookNoLastest,
      overLay,
    };
  },
};
</script>

<style lang="scss">
@import "@core/scss/vue/libs/vue-select.scss";
@import "@core/scss/vue/libs/vue-flatpicker.scss";
</style>
