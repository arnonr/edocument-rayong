<script>
import {
  BContainer,
  BRow,
  BCol,
  BButton,
  BCard,
  BBadge,
  BOverlay,
  BSpinner,
  BLink,
  BTable,
  BForm,
  BFormGroup,
  BFormTextarea,
  BInputGroup,
  BInputGroupPrepend,
  BFormFile,
  BFormInput,
} from "bootstrap-vue";
import flatPickr from "vue-flatpickr-component";
import "flatpickr/dist/flatpickr.css";
import { Thai } from "flatpickr/dist/l10n/th.js";
import router from "../../../router";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";
import Swal from "sweetalert2";
import { ValidationProvider, ValidationObserver } from "vee-validate";
import { required, email } from "@validations";

import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

import { onUnmounted, ref } from "@vue/composition-api";
import store from "@/store";
import bookInStoreModule from "../bookInStoreModule";
import { getUserData } from "@/auth/utils";

export default {
  components: {
    BContainer,
    BRow,
    BCol,
    BButton,
    BCard,
    BBadge,
    BOverlay,
    BSpinner,
    BLink,
    dayjs,
    BTable,
    BForm,
    BFormGroup,
    BFormTextarea,
    BInputGroup,
    BInputGroupPrepend,
    BFormFile,
    BFormInput,
    ValidationProvider,
    ValidationObserver,
    flatPickr,
    required,
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
    const BOOK_IN_VIEW_APP_STORE_MODULE_NAME = "book-in-view";
    const showBtnAdmin = ref(true);

    // Register module
    if (!store.hasModule(BOOK_IN_VIEW_APP_STORE_MODULE_NAME))
      store.registerModule(
        BOOK_IN_VIEW_APP_STORE_MODULE_NAME,
        bookInStoreModule
      );

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(BOOK_IN_VIEW_APP_STORE_MODULE_NAME))
        store.unregisterModule(BOOK_IN_VIEW_APP_STORE_MODULE_NAME);
    });

    const toast = useToast();
    const isAdmin = getUserData().type == "admin" ? true : false;
    const isCEO = getUserData().type == "ceo" ? true : false;
    const isStaff = getUserData().type == "staff" ? true : false;
    const overLay = ref(false);
    // const isActivityModal = ref(false);
    // const isActivitySubmit = ref(false);
    const simpleRules = ref();
    const isDepartment = ref(true);

    const errorToast = (message) => {
      toast({
        component: ToastificationContent,
        props: {
          title: "Error : " + message,
          icon: "AlertTriangleIcon",
          variant: "danger",
        },
      });
    };

    if (localStorage.getItem("added") == 1) {
      toast({
        component: ToastificationContent,
        props: {
          title: "Added Book In",
          icon: "CheckIcon",
          variant: "success",
        },
      });

      localStorage.removeItem("added");
    }

    if (localStorage.getItem("updated") == 1) {
      toast({
        component: ToastificationContent,
        props: {
          title: "Updated Book In",
          icon: "CheckIcon",
          variant: "success",
        },
      });

      localStorage.removeItem("updated");
    }

    const item = ref({});

    store
      .dispatch("book-in-view/fetchBookIn", {
        id: router.currentRoute.params.id,
      })
      .then((response) => {
        const { data } = response.data;
        //
        let book_to = "";
        if (data.book_to != null) {
          let bookJson = JSON.parse(data.book_to);
          book_to = bookJson.map((b) => {
            return b.title;
          });

          book_to = book_to.toString();
        }
        data.book_to = book_to;
        if (data.book_in_category_id == 2) {
          isDepartment.value = false;
        } else {
          isDepartment.value = true;
        }
        item.value = data;
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error Get Book In Information",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    const onConfirmDelete = (id) => {
      Swal.fire({
        title: "Are you sure?",
        text: "You won't be able to revert this!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, delete it!",
        customClass: {
          confirmButton: "btn btn-primary",
          cancelButton: "btn btn-outline-danger ml-1",
        },
        buttonsStyling: false,
      }).then((result) => {
        if (result.isConfirmed) {
          onDelete(id);
          Swal.fire({
            icon: "success",
            title: "Deleted!",
            text: "Your file has been deleted.",
            customClass: {
              confirmButton: "btn btn-success",
            },
          });
        }
      });
    };

    const onDelete = (id) => {
      store
        .dispatch("book-in-view/deleteBookIn", { id: id })
        .then((response) => {
          if (response.data.message == "success") {
            router.push({ name: "book-in-list" });
          } else {
            console.log("error");
          }
        })
        .catch((error) => {
          let textErrors = "";
          Object.values(error.response.data.errors).forEach((textError) => {
            textErrors = textErrors + textError + "<br>";
          });
          errorToast(textErrors);
        });
    };

    return {
      item,
      overLay,
      dayjs,
      onConfirmDelete,
      showBtnAdmin,
      simpleRules,
      isAdmin,
      isStaff,
      isDepartment,
    };
  },
};
</script>

<style lang="scss">
.label {
  font-weight: bold;
}
.div-spinner {
  bottom: 10em;
  margin-left: auto;
  margin-right: auto;
  left: 0;
  right: 0;
  text-align: center;
}
.form-control[readonly] {
  background-color: #fff;
}
.form-control:disabled {
  background-color: #fff;
}
label {
  font-size: 1rem;
}
h1,
h2,
h3,
h4,
h5,
h6,
.h1,
.h2,
.h3,
.h4,
.h5,
.h6 {
  color: #000;
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
      <b-row>
        <b-col class="text-center mt-2">
          <h3>ข้อมูลเอกสารรับเข้า-ส่งออก</h3>
          <hr width="80px;" style="border: solid 2px; border-color: #fe7300" />
        </b-col>
      </b-row>

      <b-row>
        <b-col class="pt-1 pb-1 mb-2 mt-4" style="background-color: #eee">
          <h4>ข้อมูลต้นทาง</h4>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <span class="label">เลขที่ต้นทาง : </span>
          <span class="text-data font-italic">{{ item.book_from_no }}</span>
          <hr />
          <span class="label">ลงวันที่ต้นทาง : </span>
          <span class="text-data font-italic">
            {{ dayjs(item.book_from_date).locale("th").format("DD/MM/BBBB") }}
          </span>
          <hr />
          <span class="label">หน่วยงานต้นทาง : </span>
          <span class="text-data font-italic">{{ item.book_from }}</span>
        </b-col>
      </b-row>

      <b-row>
        <b-col class="pt-1 pb-1 mb-2 mt-4" style="background-color: #eee">
          <h4>ข้อมูลเอกสาร</h4>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <span class="label">เรื่อง : </span>
          <span class="text-data font-italic">{{ item.title }}</span>
          <hr />
          <span class="label">หมวดหมู่เอกสาร : </span>
          <span class="text-data font-italic">{{
            item.book_in_category_name
          }}</span>
          <hr />
          <span class="label">ประเภทเอกสาร : </span>
          <span class="text-data font-italic">{{
            item.book_in_type_name
          }}</span>
          <hr />
          <span class="label">วันที่รับเอกสาร : </span>
          <span class="text-data font-italic">
            {{ dayjs(item.receive_date).locale("th").format("DD/MM/BBBB") }}
          </span>
          <hr />
          <span class="label">เลขรับเอกสาร : </span>
          <span class="text-data font-italic">{{ item.book_no }}</span>
          <hr />
          <span class="label">เรียนถึง (ชื่อผู้รับในเอกสาร) : </span>
          <span class="text-data font-italic">{{ item.to_send }}</span>
          <hr />
          <span class="label" v-if="isDepartment"
            >หน่วยงานที่เกี่ยวข้อง :
          </span>
          <span class="text-data font-italic" v-if="isDepartment">{{
            item.department_name ? item.department_name : "ทุกฝ่าย"
          }}</span>
          <hr v-if="isDepartment" />
          <span class="label">ส่งเมล : </span>
          <span class="text-data font-italic">
            {{ item.book_to }}
          </span>
          <hr />
          <!-- <span class="label">อ้างถึงเลขรับเอกสาร : </span>
          <span class="text-data font-italic">{{ item.book_reference }}</span>
          <hr /> -->
          <span class="label">ปี : </span>
          <span class="text-data font-italic">{{ item.book_year_name }}</span>
          <hr />
          <span class="label">หมายเหตุ : </span>
          <span class="text-data font-italic">{{ item.remark }}</span>
          <hr />
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <span class="label">ไฟล์ : </span>
          <span class="text-data">
            <b-button
              :disabled="item.book_in_file != null ? false : true"
              :variant="
                item.book_in_file != null
                  ? 'outline-success'
                  : 'outline-secondary'
              "
              alt="เปิดไฟล์แนบ"
              title="เปิดไฟล์แนบ"
              class="btn-icon btn-sm"
              style="margin-bottom: 2px"
              :href="item.book_in_file"
              target="_blank"
            >
              <feather-icon icon="FileIcon" style="margin-bottom: -2px" />
              ต้นฉบับ
            </b-button>
            |
            <b-button
              :disabled="item.book_in_success_file != null ? false : true"
              :variant="
                item.book_in_success_file != null
                  ? 'outline-warning'
                  : 'outline-secondary'
              "
              alt="เปิดไฟล์แนบ"
              title="เปิดไฟล์แนบ"
              class="btn-icon btn-sm"
              style="margin-bottom: 2px"
              :href="item.book_in_success_file"
              target="_blank"
            >
              <feather-icon icon="FileIcon" style="margin-bottom: -2px" />
              ฉบับสมบูรณ์
            </b-button>
          </span>
        </b-col>
      </b-row>

      <b-row>
        <b-col class="mt-4 text-center">
          <b-button
            type="button"
            variant="outline-success"
            @click="
              $router.push({
                name: 'book-in-edit',
                params: { id: item.id },
              })
            "
            v-if="isAdmin"
          >
            แก้ไขเอกสาร</b-button
          >
          <b-button
            type="button"
            variant="outline-danger"
            @click="onConfirmDelete(item.id)"
            v-if="isAdmin"
          >
            ลบเอกสาร</b-button
          >

          <b-button
            style="float: right"
            variant="outline-info"
            @click="
              $router.push({
                name: 'book-in-list',
              })
            "
          >
            Back to List
          </b-button>
        </b-col>
      </b-row>

      <!-- Button -->

      <template #overlay>
        <div>
          <div class="position-absolute div-spinner">
            <b-spinner type="border" variant="primary"></b-spinner>
            <br />
            <span>Please wait...</span>
          </div>
        </div>
      </template>
    </b-overlay>
  </b-card>
</template>
