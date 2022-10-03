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
                label-for="h-bookType"
                label-cols-md="4"
              >
                <validation-provider
                  name="bookType"
                  rules="required"
                  #default="{ errors }"
                >
                  <v-select
                    v-model="bookOutData.bookType"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    label="title"
                    placeholder="-- เลือกประเภทเอกสาร --"
                    :options="selectOptions.bookType"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ลงวันที่"
                label-for="h-dateSend"
                label-cols-md="4"
              >
                <validation-provider name="dateSend" #default="{ errors }">
                  <flat-pickr
                    id="h-dateSend"
                    v-model="bookOutData.dateSend"
                    placeholder="ลงวันที่"
                    class="form-control"
                    :config="configDate"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เลขที่เอกสาร"
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
                      v-model="bookOutData.bookNo"
                    />
                  </b-input-group>

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
                <validation-provider
                  name="toSend"
                  rules="required"
                  #default="{ errors }"
                >
                  <b-form-input
                    id="h-title"
                    placeholder="ถึง..."
                    v-model="bookOutData.toSend"
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
                    v-model="bookOutData.title"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!-- <b-col cols="12">
              <b-form-group
                label="ฝ่ายที่เกี่ยวข้อง"
                label-for="h-department"
                label-cols-md="4"
              >
                <validation-provider
                  name="department"
                  rules="required"
                  #default="{ errors }"
                >
                  <v-select
                    v-model="bookOutData.department"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    label="title"
                    placeholder="-- เลือกฝ่ายที่เกี่ยวข้อง --"
                    :options="selectOptions.department"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col> -->

            <b-col cols="12">
              <b-form-group
                label="ผู้รับผิดชอบ"
                label-for="h-userID"
                label-cols-md="4"
              >
                <validation-provider
                  name="userID"
                  rules="required"
                  #default="{ errors }"
                >
                  <v-select
                    v-model="bookOutData.userID"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    label="title"
                    placeholder="-- เลือกผู้รับผิดชอบ --"
                    :options="selectOptions.users"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!-- <b-col cols="12">
              <b-form-group
                label="หมายเหตุ"
                label-for="h-detail"
                label-cols-md="4"
              >
                <validation-provider name="detail" #default="{ errors }">
                  <b-form-textarea
                    id="h-detail"
                    placeholder="หมายเหตุ"
                    v-model="bookOutData.detail"
                    rows="3"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col> -->

            <!-- <b-col cols="12" v-if="showForAdmin">
              <b-form-group
                label="ส่งเมล"
                label-for="h-bookTo"
                label-cols-md="4"
              >
                <b-row>
                  <b-col cols="12">
                    <validation-provider name="bookTo" #default="{ errors }">
                      <v-select
                        v-model="bookOutData.bookTo"
                        :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                        label="title"
                        multiple
                        taggable
                        placeholder="-- อีเมล --"
                        :options="selectOptions.email"
                      />
                      <small class="text-danger">{{ errors[0] }}</small>
                    </validation-provider>
                  </b-col>
                  <b-col cols="2" class="mt-2">
                    <b-button
                      v-ripple.400="'rgba(255, 255, 255, 0.15)'"
                      type="button"
                      variant="danger"
                      @click.prevent="bookOutData.bookTo = ''"
                      class="mr-1"
                    >
                      Clear
                    </b-button>
                  </b-col>
                  <b-col cols="10" class="mt-2">
                    <v-select
                      v-model="bookOutData.emailGroup"
                      :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                      label="title"
                      placeholder="-- เลือกจากกลุ่ม --"
                      :options="selectOptions.emailGroup"
                    />
                  </b-col>
                </b-row>
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
                        :variant="`outline-${bookOutData.oldFile == null ? 'dark': 'warning'}`"
                        target="_blank"
                        :disabled="bookOutData.oldFile == null"
                        :href="bookOutData.oldFile"
                      >
                        <feather-icon icon="FileTextIcon" /> ดูไฟล์เดิม
                      </b-button>
                    </b-input-group-prepend>
                    <b-form-file
                      id="h-file"
                      v-model="bookOutData.file"
                      placeholder="Choose a new file or drop it here..."
                      drop-placeholder="Drop file here..."
                    />
                  </b-input-group>

                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12" v-if="showForAdmin">
              <b-form-group
                label="แก้ไขไฟล์ฉบับสมบูรณ์"
                label-for="h-file"
                label-cols-md="4"
              >
                <validation-provider name="fileSuccess" #default="{ errors }">
                  <b-input-group>
                    <b-input-group-prepend>
                      <b-button
                        :variant="`outline-${bookOutData.oldFileSuccess == null ? 'dark': 'warning'}`"
                        target="_blank"
                        :disabled="bookOutData.oldFileSuccess == null"
                        :href="bookOutData.oldFileSuccess"
                      >
                        <feather-icon icon="FileTextIcon" /> ดูไฟล์เดิม
                      </b-button>
                    </b-input-group-prepend>
                    <b-form-file
                      id="h-file-success"
                      v-model="bookOutData.fileSuccess"
                      placeholder="Choose a new file or drop it here..."
                      drop-placeholder="Drop file here..."
                    />
                  </b-input-group>

                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>


            <b-col cols="12" v-if="showForAdmin">
              <b-form-group
                label="สถานะ"
                label-for="h-bookStatus"
                label-cols-md="4"
              >
                <validation-provider
                  name="bookStatus"
                  #default="{ errors }"
                >
                  <v-select
                    v-model="bookOutData.bookStatus"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    label="title"
                    placeholder="-- เลือกสถานะ --"
                    :options="selectOptions.bookStatus"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12" >
              <b-form-group
                label="ต้องการส่งเมลอีกครั้งใช่หรือไม่?"
                label-for="h-detail"
                label-cols-md="4"
              >
                <b-form-checkbox v-model="bookOutData.isSendEmail" value="true" class="custom-control-success" style="margin-top:0.5rem">
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
  BInputGroupPrepend,
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
import flatPickr from "vue-flatpickr-component";
import { Thai } from "flatpickr/dist/l10n/th.js";

import { onUnmounted } from "@vue/composition-api";
import store from "@/store";
import bookOutStoreModule from "../bookOutStoreModule";
import useBookOutEdit from "./useBookOutEdit";

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
    BInputGroupPrepend,
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
    const BOOK_OUT_EDIT_APP_STORE_MODULE_NAME = "book-out-edit";

    // Register module
    if (!store.hasModule(BOOK_OUT_EDIT_APP_STORE_MODULE_NAME))
      store.registerModule(
        BOOK_OUT_EDIT_APP_STORE_MODULE_NAME,
        bookOutStoreModule
      );

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(BOOK_OUT_EDIT_APP_STORE_MODULE_NAME))
        store.unregisterModule(BOOK_OUT_EDIT_APP_STORE_MODULE_NAME);
    });

    const {
      bookOutData,
      validationForm,
      simpleRules,
      selectOptions,
      bookNoLastest,
      overLay,
      showForAdmin,
    } = useBookOutEdit();

    return {
      bookOutData,
      validationForm,
      simpleRules,
      selectOptions,
      bookNoLastest,
      overLay,
      showForAdmin,
    };
  },
};
</script>

<style lang="scss">
@import "@core/scss/vue/libs/vue-select.scss";
@import "@core/scss/vue/libs/vue-flatpicker.scss";
</style>
