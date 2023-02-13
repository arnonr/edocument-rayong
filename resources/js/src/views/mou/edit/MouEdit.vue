<script>
import {
  BRow,
  BCol,
  BFormGroup,
  BFormInput,
  BFormTextarea,
  BForm,
  BButton,
  BCard,
  BBadge,
  BFormFile,
  BOverlay,
  BSpinner,
  BInputGroup,
  BInputGroupPrepend,
} from "bootstrap-vue";
import vSelect from "vue-select";
import { ValidationProvider, ValidationObserver } from "vee-validate";
import { required, email } from "@validations";
import flatPickr from "vue-flatpickr-component";
import "flatpickr/dist/flatpickr.css";
import { Thai } from "flatpickr/dist/l10n/th.js";
import router from "../../../router";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

import { onUnmounted, ref, reactive, watch } from "@vue/composition-api";
import store from "@/store";
import mouStoreModule from "../mouStoreModule";

export default {
  components: {
    ValidationProvider,
    ValidationObserver,
    required,
    email,
    BRow,
    BCol,
    BFormGroup,
    BFormInput,
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
    BInputGroup,
    BInputGroupPrepend,
  },
  data() {
    return {
      configDate: {
        mode: "single",
        altInput: true,
        altFormat: "d/m/Y",
        dateFormat: "Y-m-d",
        locale: Thai,
        disableMobile: "true",
      },
    };
  },
  setup() {
    const MOU_EDIT_APP_STORE_MODULE_NAME = "mou-edit";

    // Register module
    if (!store.hasModule(MOU_EDIT_APP_STORE_MODULE_NAME))
      store.registerModule(MOU_EDIT_APP_STORE_MODULE_NAME, mouStoreModule);

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(MOU_EDIT_APP_STORE_MODULE_NAME))
        store.unregisterModule(MOU_EDIT_APP_STORE_MODULE_NAME);
    });

    const toast = useToast();
    const simpleRules = ref();
    const overLay = ref(false);

    const item = reactive({
      id: null,
      name: "",
      partner: "",
      partner_logo_file: null,
      partner_logo_file_old: null,
      mou_file: null,
      mou_file_old: null,
      mou_word_file: null,
      mou_word_file_old: null,
      host_id: { title: null, code: null },
      country_code: { title: null, code: null },
      start_date: null,
      end_date: null,
      address: "",
      type: { title: null, code: null },
      is_publish: { title: "Publish", code: 1 },
      partner_contact_name: "",
      partner_contact_phone: "",
      partner_contact_email: "",
      host_contact_name: "",
      host_contact_phone: "",
      host_contact_email: "",
      remark: "",
    });

    const selectOptions = ref({
      hosts: [],
      countries: [],
      types: [
        //   { title: "-- All Types -- ", code: "" },
        { title: "ในประเทศ", code: 1 },
        { title: "ต่างประเทศ", code: 2 },
      ],
      statuses: [
        //   { title: "-- All Statuses -- ", code: "" },
        { title: "Active", code: "active" },
        { title: "InActive", code: "inActive" },
        { title: "Warning", code: "warning" },
      ],
      is_publish: [
        //   { title: "-- All Publish -- ", code: "" },
        { title: "Publish", code: 1 },
        { title: "Non-Publish", code: 0 },
      ],
    });

    store
      .dispatch("mou-edit/fetchHosts")
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.hosts = data.map((d) => {
          return {
            code: d.id,
            title: d.name,
          };
        });
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Host's list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    store
      .dispatch("mou-edit/fetchCountries")
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.countries = data.map((d) => {
          return {
            code: d.ct_code,
            title: d.ct_nameTHA,
          };
        });
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Country's list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    store
      .dispatch("mou-edit/fetchMou", {
        id: router.currentRoute.params.id,
      })
      .then((response) => {
        const { data } = response.data;
        //
        item.id = data.id;
        item.name = data.name;
        item.partner = data.partner;
        item.host_id = { title: data.host_name, code: data.host_id };
        item.country_code = {
          title: data.country_name,
          code: data.country_code,
        };
        item.start_date = data.start_date;
        item.end_date = data.end_date;
        item.address = data.address ? data.address : "";
        item.type = { title: data.type_name, code: data.type };
        item.is_publish =
          data.is_publish == 1
            ? { title: "Publish", code: data.is_publish }
            : { title: "Non-Publish", code: data.is_publish };
        item.partner_contact_name = data.partner_contact_name
          ? data.partner_contact_name
          : "";
        item.partner_contact_phone = data.partner_contact_phone
          ? data.partner_contact_phone
          : "";
        item.partner_contact_email = data.partner_contact_email
          ? data.partner_contact_email
          : "";
        item.host_contact_name = data.host_contact_name
          ? data.host_contact_name
          : "";
        item.host_contact_phone = data.host_contact_phone
          ? data.host_contact_phone
          : "";
        item.host_contact_email = data.host_contact_email
          ? data.host_contact_email
          : "";

        item.partner_logo_file_old = data.partner_logo_file;

        item.mou_file_old = null;
        if (data.mou_file != null) {
          item.mou_file_old = data.mou_file;
        }

        item.mou_word_file_old = null;
        if (data.mou_word_file != null) {
          item.mou_word_file_old = data.mou_word_file;
        }

        item.remark = data.remark ? data.remark : "";
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Country's list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    const validationForm = () => {
      simpleRules.value.validate().then((success) => {
        if (success) {
          onSubmit();
        }
      });
    };

    const onSubmit = (ctx, callback) => {
      overLay.value = true;

      let dataSend = {
        id: item.id,
        name: item.name,
        partner: item.partner,
        partner_logo_file: item.partner_logo_file,
        mou_file: item.mou_file,
        mou_word_file: item.mou_word_file,
        host_id: item.host_id.code,
        country_code: item.country_code.code,
        start_date: item.start_date,
        end_date: item.end_date,
        address: item.address,
        type: item.type.code,
        is_publish: item.is_publish.code,
        partner_contact_name: item.partner_contact_name,
        partner_contact_phone: item.partner_contact_phone,
        partner_contact_email: item.partner_contact_email,
        host_contact_name: item.host_contact_name,
        host_contact_phone: item.host_contact_phone,
        host_contact_email: item.host_contact_email,
        remark: item.remark,
      };

      store
        .dispatch("mou-edit/editMou", dataSend)
        .then((response) => {
          if (response.data.message == "success") {
            localStorage.setItem("updated", 1);
            router.push({
              name: "mou-view",
              params: { id: response.data.data.id },
            });
          } else {
            toast({
              component: ToastificationContent,
              props: {
                title: response.data.message,
                icon: "AlertTriangleIcon",
                variant: "danger",
              },
            });
          }
          overLay.value = false;
        })
        .catch(() => {
          toast({
            component: ToastificationContent,
            props: {
              title: "Update MOU Error",
              icon: "AlertTriangleIcon",
              variant: "danger",
            },
          });
          overLay.value = false;
        });
    };

    watch(
      () => item.type,
      (value) => {
        if (value.code == 1) {
          item.country_code = { title: "ไทย (Thailand)", code: "THA" };
        } else {
          if (item.country_code.hasOwnProperty("code")) {
            if (item.country_code.code == "THA") {
              item.country_code = { title: null, code: null };
            }
          }
        }
      }
    );

    return {
      item,
      validationForm,
      simpleRules,
      selectOptions,
      overLay,
    };
  },
};
</script>

<style lang="scss">
.form-control[readonly] {
  background-color: #fff;
}
.form-control:disabled {
  background-color: #fff;
}
label {
  font-size: 1rem;
}
</style>

<template>
  <b-card class="container-lg">
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
            <b-col cols="12" class="text-center">
              <h2>EDIT MOU</h2>
              <hr />
            </b-col>
          </b-row>
          <b-row>
            <!-- with prop append -->

            <!-- partner group -->
            <b-col cols="12" class="mt-2">
              <h3>ข้อมูลคู่สัญญา/Partner Information</h3>
              <hr />
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="องค์กรคู่สัญญา/Partner Organization:"
                label-for="partner"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Partner"
                  rules="required"
                >
                  <b-form-input
                    id="partner"
                    placeholder=""
                    v-model="item.partner"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>
            <b-col cols="12">
              <b-form-group
                label="รูปโลโก้คู่สัญญา/Partner Logo"
                label-for="partner_logo_file"
                label-cols-md="4"
              >
                <validation-provider
                  name="partner_logo_file"
                  #default="{ errors }"
                >
                  <b-input-group>
                    <b-input-group-prepend>
                      <b-button
                        variant="outline-warning"
                        target="_blank"
                        :href="item.partner_logo_file_old"
                      >
                        <feather-icon icon="FileTextIcon" /> ดูไฟล์เดิม
                      </b-button>
                    </b-input-group-prepend>
                    <b-form-file
                      id="partner_logo_file"
                      v-model="item.partner_logo_file"
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
                label="ประเภทความร่วมมือ/MOU Type:"
                label-for="h-title"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="MOU Type"
                  rules="required"
                >
                  <v-select
                    input-id="type"
                    label="title"
                    v-model="item.type"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    :options="selectOptions.types"
                    placeholder=""
                    :clearable="false"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ประเทศคู่สัญญา/Partner Country:"
                label-for="country_code"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Country"
                  rules="required"
                >
                  <v-select
                    input-id="country_code"
                    label="title"
                    v-model="item.country_code"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    :options="selectOptions.countries"
                    placeholder=""
                    :clearable="false"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ที่อยู่คู่สัญญา/Address:"
                label-for="country_code"
                label-cols-md="4"
              >
                <validation-provider #default="{ errors }" name="Address">
                  <b-form-textarea
                    id="address"
                    placeholder=""
                    v-model="item.address"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ชื่อผู้ประสานงาน/Partner Contact Name:"
                label-for="partner_contact_name"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Host Partner Name"
                >
                  <b-form-input
                    id="host_partner_name"
                    placeholder=""
                    v-model="item.partner_contact_name"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เบอร์ติดต่อ/Partner Contact Phone:"
                label-for="partner_contact_phone"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Partner Contact Phone"
                >
                  <b-form-input
                    id="partner_contact_phone"
                    placeholder=""
                    v-model="item.partner_contact_phone"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เมล/Partner Contact Email:"
                label-for="partner_contact_email"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Partner Contact Email"
                >
                  <b-form-input
                    id="partner_contact_email"
                    placeholder=""
                    v-model="item.partner_contact_email"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!--  -->

            <b-col cols="12" class="mt-2">
              <h3>ข้อมูลหน่วยงานผู้รับผิดชอบ/Host Information</h3>
              <hr />
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="หน่วยงาน/Host Organization:"
                label-for="host_id"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Host"
                  rules="required"
                >
                  <v-select
                    input-id="host_id"
                    label="title"
                    v-model="item.host_id"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    :options="selectOptions.hosts"
                    placeholder=""
                    :clearable="false"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ชื่อผู้ประสานงาน/Host Contact Name:"
                label-for="host_contact_name"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Host Contact Name"
                >
                  <b-form-input
                    id="host_contact_name"
                    placeholder=""
                    v-model="item.host_contact_name"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เบอร์ติดต่อ/Host Contact Phone:"
                label-for="host_contact_phone"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Host Contact Phone"
                >
                  <b-form-input
                    id="host_contact_phone"
                    placeholder=""
                    v-model="item.host_contact_phone"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เมล/Host Contact Email:"
                label-for="host_contact_email"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Host Contact Email"
                >
                  <b-form-input
                    id="host_contact_email"
                    placeholder=""
                    v-model="item.host_contact_email"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!--  -->
            <b-col cols="12" class="mt-2">
              <h3>ข้อมูล MOU/MOU Information</h3>
              <hr />
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ชื่อความร่วมมือ/MOU Name:"
                label-for="name"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Name"
                  rules="required"
                >
                  <b-form-input
                    id="name"
                    placeholder=""
                    v-model="item.name"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="วันเริ่มสัญญา/Start Date:"
                label-for="start_date"
                label-cols-md="4"
              >
                <validation-provider #default="{ errors }" name="Start Date">
                  <flat-pickr
                    v-model="item.start_date"
                    placeholder="Start Date"
                    :config="configDate"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="วันสิ้นสุดสัญญา/End Date:"
                label-for="start_date"
                label-cols-md="4"
              >
                <validation-provider #default="{ errors }" name="End Date">
                  <flat-pickr
                    v-model="item.end_date"
                    placeholder="End Date"
                    :config="configDate"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!-- <b-col cols="12">
              <b-form-group
                label="สถานะการเผยแพร่/Publish:"
                label-for="is_publish"
                label-cols-md="4"
              >
                <validation-provider #default="{ errors }" name="Publish">
                  <v-select
                    input-id="is_publish"
                    label="title"
                    v-model="item.is_publish"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    :options="selectOptions.is_publish"
                    placeholder=""
                    :clearable="false"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col> -->

            <b-col cols="12">
              <b-form-group
                label="ไฟล์ PDF MOU/MOU File"
                label-for="mou_file"
                label-cols-md="4"
              >
                <validation-provider name="mou_file" #default="{ errors }">
                  <b-input-group>
                    <b-input-group-prepend>
                      <b-button
                        variant="outline-warning"
                        target="_blank"
                        :href="item.mou_file_old"
                      >
                        <feather-icon icon="FileTextIcon" /> ดูไฟล์เดิม
                      </b-button>
                    </b-input-group-prepend>
                    <b-form-file
                      id="mou_file"
                      v-model="item.mou_file"
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
                label="ไฟล์ WORD MOU/MOU File (.doc,.docx)"
                label-for="mou_word_file"
                label-cols-md="4"
              >
                <validation-provider name="mou_word_file" #default="{ errors }">
                  <b-input-group>
                    <b-input-group-prepend>
                      <b-button
                        variant="outline-warning"
                        target="_blank"
                        :href="item.mou_word_file_old"
                      >
                        <feather-icon icon="FileTextIcon" /> ดูไฟล์เดิม
                      </b-button>
                    </b-input-group-prepend>
                    <b-form-file
                      id="mou_word_file"
                      v-model="item.mou_word_file"
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
                label="หมายเหตุ/Remark:"
                label-for="remark"
                label-cols-md="4"
              >
                <validation-provider #default="{ errors }" name="Remark">
                  <b-form-textarea
                    id="remark"
                    placeholder=""
                    v-model="item.remark"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!-- submit and reset -->
            <b-col offset-md="4">
              <b-button
                type="submit"
                variant="primary"
                @click.prevent="validationForm"
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
