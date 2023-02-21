<script>
import {
  BRow,
  BCol,
  BFormGroup,
  BInputGroup,
  BInputGroupText,
  BFormInput,
  BFormTextarea,
  BForm,
  BButton,
  BCard,
  BBadge,
  BFormFile,
  BOverlay,
  BSpinner,
  BInputGroupPrepend,
  BFormCheckbox,
} from "bootstrap-vue";
import vSelect from "vue-select";
import { ValidationProvider, ValidationObserver } from "vee-validate";
import { required, email } from "@validations";
import flatPickr from "vue-flatpickr-component";
import "flatpickr/dist/flatpickr.css";
import { Thai } from "flatpickr/dist/l10n/th.js";
import router from "../../../../router";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

import { onUnmounted, ref, reactive, watch } from "@vue/composition-api";
import store from "@/store";
import bookOutOldStoreModule from "../bookOutOldStoreModule";

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
    BInputGroupText,
    BFormCheckbox,
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
    const BOOK_OUT_OLD_EDIT_APP_STORE_MODULE_NAME = "book-out-old-edit";

    // Register module
    if (!store.hasModule(BOOK_OUT_OLD_EDIT_APP_STORE_MODULE_NAME))
      store.registerModule(
        BOOK_OUT_OLD_EDIT_APP_STORE_MODULE_NAME,
        bookOutOldStoreModule
      );

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(BOOK_OUT_OLD_EDIT_APP_STORE_MODULE_NAME))
        store.unregisterModule(BOOK_OUT_OLD_EDIT_APP_STORE_MODULE_NAME);
    });

    const toast = useToast();
    const simpleRules = ref();
    const overLay = ref(false);

    const item = reactive({
      id: null,
      title: "",
      book_out_category_id: null,
      receive_date: null,
      book_no: "",
      to_send: "",
      book_out_file: null,
      book_out_file_old: null,
      book_out_success_file: null,
      book_out_success_file_old: null,
      department_id: null,
      book_to: null,
      book_reference: "",
      book_year_id: null,
      remark: "",
      status_id: 4,
      is_publish: { title: "Publish", code: 1 },
      email_group: null,
    });

    const book_code_latest = ref("เลขทะเบียนรับล่าสุด :");

    const fetchBookCode = (book_out_category_id) => {
      store
        .dispatch("book-out-old-edit/fetchBookCode", {
          book_year_id: router.currentRoute.query.book_year_id,
          book_out_category_id: book_out_category_id,
        })
        .then((response) => {
          book_code_latest.value =
            "เลขทะเบียนรับล่าสุด : " + response.data.data.code_lastest;
          // item.book_no = response.data.data.code_next;
        })
        .catch(() => {
          toast({
            component: ToastificationContent,
            props: {
              title: "Error fetching Book Code",
              icon: "AlertTriangleIcon",
              variant: "danger",
            },
          });
        });
    };

    const selectOptions = ref({
      book_out_categories: [],
      departments: [],
      email_groups: [],
      emails: [],
    });

    store
      .dispatch("book-out-old-edit/fetchBookOutCategories")
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.book_out_categories = data.map((d) => {
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
            title: "Error fetching Category list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    store
      .dispatch("book-out-old-edit/fetchDepartments")
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.departments = data.map((d) => {
          return {
            code: d.id,
            title: d.name,
          };
        });
        selectOptions.value.departments.unshift({
          code: null,
          title: "ทุกฝ่าย",
        });
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Department's list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    store
      .dispatch("book-out-old-edit/fetchEmailPersons")
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.emails = data.map((d) => {
          return {
            code: d.id,
            title: d.firstname + " " + d.lastname + " (" + d.email + ")",
            email: d.email,
          };
        });
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Email's list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    store
      .dispatch("book-out-old-edit/fetchEmailGroups")
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.email_groups = data.map((d) => {
          return {
            code: d.id,
            title: d.name,
            email_all: JSON.parse(d.email_all),
          };
        });
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Email Group's list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    store
      .dispatch("book-out-old-edit/fetchBookOut", {
        id: router.currentRoute.params.id,
      })
      .then((response) => {
        const { data } = response.data;
        item.id = data.id;
        item.title = data.title;

        item.book_out_category_id = {
          title: data.book_out_category_name,
          code: data.book_out_category_id,
        };

        item.book_date = data.book_date;
        item.receive_date = data.receive_date;
        item.book_no = data.book_no;
        item.to_send = data.to_send;

        if (data.department_id == null) {
          item.department_id = {
            title: "ทุกฝ่าย",
            code: null,
          };
        } else {
          item.department_id = {
            title: data.department_name,
            code: data.department_id,
          };
        }

        item.book_to = JSON.parse(data.book_to);

        item.book_out_file_old = null;
        if (data.book_out_file != null) {
          item.book_out_file_old = data.book_out_file;
        }

        item.book_out_success_file_old = null;
        if (data.book_out_success_file != null) {
          item.book_out_success_file_old = data.book_out_success_file;
        }

        item.book_reference = data.book_reference;
        item.book_year_id = data.book_year_id;
        item.remark = data.remark;
        item.status_id = data.status_id;
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error Get Book Out Information",
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

      let book_to = null;
      if (item.book_to) {
        book_to = item.book_to.map((x) => {
          if (!x.hasOwnProperty("email")) {
            x.email = x.title;
            x.code = null;
          }
          return {
            title: x.title,
            code: x.code,
            email: x.email,
          };
        });
      }

      let dataSend = {
        id: item.id,
        title: item.title,
        book_out_category_id: item.book_out_category_id.code,
        receive_date: item.receive_date,
        book_date: item.book_date,
        book_no: item.book_no,
        to_send: item.to_send,
        book_out_file: item.book_out_file,
        book_out_success_file: item.book_out_success_file,
        department_id: item.department_id.code,
        book_to: book_to,
        book_reference: item.book_reference,
        remark: item.remark,
        status_id: item.status_id,
        is_send_email: item.is_send_email,
        is_publish: item.is_publish.code,
      };

      store
        .dispatch("book-out-old-edit/editBookOut", dataSend)
        .then((response) => {
          if (response.data.message == "success") {
            localStorage.setItem("updated", 1);
            // console.log()
            router.push({
              name: "book-out-old-view",
              params: { id: response.data.data.id },
              query: { book_year_id: router.currentRoute.query.book_year_id },
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
              title: "Add Book Out Error",
              icon: "AlertTriangleIcon",
              variant: "danger",
            },
          });
          overLay.value = false;
        });
    };

    watch(
      () => item.book_out_category_id,
      (newValue, oldValue) => {
        fetchBookCode(newValue.code);
        //
      }
    );

    watch(
      () => item.email_group,
      (newData) => {
        if (newData != null) {
          // Find Email
          let book_to_with_group = selectOptions.value.emails.filter((x) => {
            let email_arr = item.email_group.email_all.map((e) => {
              return e.code;
            });
            let findEmail = email_arr.includes(x.code);
            return findEmail;
          });

          // Find Duplicate
          let book_to_with_group_filter = null;
          if (item.book_to) {
            book_to_with_group_filter = book_to_with_group.filter((x) => {
              let check = item.book_to.find((e) => {
                return x.code === e.code;
              });

              return check ? false : true;
            });
          } else {
            book_to_with_group_filter = book_to_with_group;
          }

          if (item.book_to == null) {
            item.book_to = [];
          }
          item.book_to = [...item.book_to, ...book_to_with_group_filter];

          console.log(item.book_to)
        }
      }
    );

    return {
      item,
      validationForm,
      simpleRules,
      selectOptions,
      overLay,
      book_code_latest,
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
              <h2>แก้ไขเอกสารรับเข้า-ส่งออก</h2>
              <hr />
            </b-col>
          </b-row>
          <b-row>
            <!-- with prop append -->

            <b-col cols="12" class="mt-2">
              <h3>ข้อมูลต้นทาง</h3>
              <hr />
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เลขที่ต้นทาง :"
                label-for="book_from_no"
                label-cols-md="4"
              >
                <validation-provider #default="{ errors }" name="Book From No">
                  <b-form-input
                    id="book_from_no"
                    placeholder="เลขเอกสารจากต้นทาง"
                    v-model="item.book_from_no"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ลงวันที่ต้นทาง :"
                label-for="book_from_date"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Book From Date"
                >
                  <flat-pickr
                    v-model="item.book_from_date"
                    placeholder="ลงวันที่จากต้นทาง"
                    :config="configDate"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="หน่วยงานต้นทาง :"
                label-for="book_from"
                label-cols-md="4"
              >
                <validation-provider #default="{ errors }" name="Book From">
                  <b-form-input
                    id="book_from"
                    placeholder="หน่วยงานต้นทาง"
                    v-model="item.book_from"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!-- partner group -->
            <b-col cols="12" class="mt-2">
              <h3>ข้อมูลเอกสาร</h3>
              <hr />
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="หมวดหมู่เอกสาร :"
                label-for="book_out_category_id"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Category"
                  rules="required"
                >
                  <v-select
                    input-id="book_out_category_id"
                    label="title"
                    v-model="item.book_out_category_id"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    :options="selectOptions.book_out_categories"
                    placeholder="-- เลือกหมวดหมู่เอกสาร --"
                    :clearable="false"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เรื่อง :"
                label-for="title"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Title"
                  rules="required"
                >
                  <b-form-input
                    id="title"
                    placeholder="ชื่อเรื่อง..."
                    v-model="item.title"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="เรียนถึง (ชื่อผู้รับในเอกสาร) :"
                label-for="to_send"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="To Send"
                  rules="required"
                >
                  <b-form-input
                    id="to_send"
                    placeholder="เรียนถึง (ชื่อผู้รับในเอกสาร)"
                    v-model="item.to_send"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!--  -->
            <b-col cols="12">
              <b-form-group
                label="วันที่รับเอกสาร :"
                label-for="receive_date"
                label-cols-md="4"
              >
                <validation-provider
                  #default="{ errors }"
                  name="Receive Date"
                  rules="required"
                >
                  <flat-pickr
                    v-model="item.receive_date"
                    placeholder="วันที่รับเอกสาร"
                    :config="configDate"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <!-- เลชรับ -->
            <b-col cols="12">
              <b-form-group
                label="เลขรับเอกสาร"
                label-for="book_no"
                label-cols-md="4"
              >
                <validation-provider
                  name="Book No"
                  rules="required"
                  #default="{ errors }"
                >
                  <!-- <b-input-group prepend="$" append=".00">
                    <b-form-input></b-form-input>
                  </b-input-group> -->

                  <b-input-group :append="book_code_latest">
                    <b-form-input
                      id="book_no"
                      placeholder="เลขรับเอกสาร"
                      v-model="item.book_no"
                    />
                  </b-input-group>

                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ฝ่ายที่เกี่ยวข้อง :"
                label-for="department_to"
                label-cols-md="4"
              >
                <validation-provider #default="{ errors }" name="Department To">
                  <v-select
                    v-model="item.department_to"
                    :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                    input-id="department_to"
                    label="title"
                    :options="selectOptions.departments"
                    placeholder="-- เลือกฝ่ายที่เกี่ยวข้อง --"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ผู้ที่เกี่ยวข้อง (ส่งเมล)"
                label-for="book_to"
                label-cols-md="4"
              >
                <b-row>
                  <b-col cols="12">
                    <validation-provider name="Book To" #default="{ errors }">
                      <v-select
                        v-model="item.book_to"
                        :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                        label="title"
                        multiple
                        taggable
                        :options="selectOptions.emails"
                        placeholder="-- เลือกผู้ที่เกี่ยวข้อง (ได้มากกว่า 1) --"
                      />
                      <small class="text-danger">{{ errors[0] }}</small>
                    </validation-provider>
                  </b-col>
                  <b-col cols="2" class="mt-2">
                    <b-button
                      type="button"
                      variant="danger"
                      @click.prevent="item.book_to = ''"
                      class="mr-1"
                    >
                      Clear
                    </b-button>
                  </b-col>
                  <b-col cols="10" class="mt-2">
                    <v-select
                      v-model="item.email_group"
                      :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                      label="title"
                      :options="selectOptions.email_groups"
                      placeholder="-- เลือกจากกลุ่ม --"
                    />
                  </b-col>
                </b-row>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="หมายเหตุ :"
                label-for="remark"
                label-cols-md="4"
              >
                <validation-provider #default="{ errors }" name="Remark">
                  <b-form-textarea
                    id="remark"
                    placeholder="หมายเหตุ"
                    v-model="item.remark"
                    :state="errors.length > 0 ? false : null"
                  />
                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ไฟล์ต้นฉบับ"
                label-for="book_out_file"
                label-cols-md="4"
              >
                <validation-provider name="book_out_file" #default="{ errors }">
                  <b-input-group>
                    <b-input-group-prepend>
                      <b-button
                        variant="outline-warning"
                        target="_blank"
                        :href="item.book_out_file_old"
                      >
                        <feather-icon icon="FileTextIcon" /> ดูไฟล์เดิม
                      </b-button>
                    </b-input-group-prepend>
                    <b-form-file
                      id="book_out_file"
                      v-model="item.book_out_file"
                      placeholder="Choose a file or drop it here..."
                      drop-placeholder="Drop file here..."
                    />
                  </b-input-group>

                  <small class="text-danger">{{ errors[0] }}</small>
                </validation-provider>
              </b-form-group>
            </b-col>

            <b-col cols="12">
              <b-form-group
                label="ไฟล์ฉบับสมบูรณ์"
                label-for="book_out_success_file"
                label-cols-md="4"
              >
                <validation-provider
                  name="book_out_success_file"
                  #default="{ errors }"
                >
                  <b-input-group>
                    <b-input-group-prepend>
                      <b-button
                        variant="outline-warning"
                        target="_blank"
                        :href="item.book_out_success_file_old"
                      >
                        <feather-icon icon="FileTextIcon" /> ดูไฟล์เดิม
                      </b-button>
                    </b-input-group-prepend>
                    <b-form-file
                      id="book_out_success_file"
                      v-model="item.book_out_success_file"
                      placeholder="Choose a file or drop it here..."
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
                <b-form-checkbox
                  v-model="item.is_send_email"
                  value="true"
                  class="custom-control-success"
                  style="margin-top: 0.5rem"
                >
                  ใช่
                </b-form-checkbox>
              </b-form-group>
            </b-col>
            <!-- submit and reset -->
            <b-col offset-md="12" class="text-center">
              <b-button
                type="submit"
                variant="primary"
                @click.prevent="validationForm"
              >
                Submit
              </b-button>

              <b-button
                style="float: right"
                variant="outline-info"
                @click="$router.push({ name: 'book-out-old', query: { book_year_id: $router.currentRoute.query.book_year_id } });"
              >
                Back to List
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
