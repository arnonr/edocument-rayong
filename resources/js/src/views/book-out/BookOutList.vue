<script>
import {
  BCard,
  BRow,
  BCol,
  BFormInput,
  BButton,
  BLink,
  BDropdown,
  BDropdownItem,
  BPagination,
  BSpinner,
  BOverlay,
  BFormGroup,
  BCardText,
  BTable,
  BModal,
  BForm,
  BBadge,
} from "bootstrap-vue";
import vSelect from "vue-select";
import flatPickr from "vue-flatpickr-component";
import "flatpickr/dist/flatpickr.css";
import { Thai } from "flatpickr/dist/l10n/th.js";

import dayjs from "dayjs";
import "dayjs/locale/th";
import isBetween from "dayjs/plugin/isBetween";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

import * as XLSX from "xlsx/xlsx";
// import XLSX from "xlsx";

import {
  ref,
  watch,
  watchEffect,
  reactive,
  onUnmounted,
  computed,
} from "@vue/composition-api";
import store from "@/store";
import bookOutStoreModule from "./bookOutStoreModule";

import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";
import { getUserData } from "@/auth/utils";

export default {
  filters: {
    formatYear(year, buddhistYear) {
      return buddhistYear ? +year + 543 : year;
    },
  },
  components: {
    BCard,
    BRow,
    BCol,
    BFormInput,
    BButton,
    BLink,
    BDropdown,
    BDropdownItem,
    BPagination,
    BSpinner,
    BOverlay,
    vSelect,
    BFormGroup,
    flatPickr,
    BPagination,
    BCardText,
    dayjs,
    BTable,
    BModal,
    BForm,
    BBadge,
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
      buddhistYear: true,
    };
  },
  setup() {
    const BOOK_OUT_APP_STORE_MODULE_NAME = "book-out";

    // Register module
    if (!store.hasModule(BOOK_OUT_APP_STORE_MODULE_NAME))
      store.registerModule(BOOK_OUT_APP_STORE_MODULE_NAME, bookOutStoreModule);

    // UnRegister on leave
    onUnmounted(() => {
      // if (store.hasModule(BOOK_OUT_APP_STORE_MODULE_NAME))
      // store.unregisterModule(BOOK_OUT_APP_STORE_MODULE_NAME);
    });

    const toast = useToast();

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

    const isAdmin = getUserData().type == "admin" ? true : false;
    const isStaff = getUserData().type == "staff" ? true : false;
    const isCEO = getUserData().type == "ceo" ? true : false;
    const isOverLay = ref(false);

    const items = ref([]);
    const perPage = ref({ title: "40", code: 40 });
    const currentPage = ref(1);
    const totalPage = ref(1);
    const totalItems = ref(0);
    const orderBy = ref({
      title: "ลงวันที่",
      code: "book_date",
    });
    const order = ref({ title: "มาก -> น้อย", code: "desc" });

    const advancedSearch = reactive({
      title: "",
      book_out_category_id: null,
      book_no: "",
      book_date: null,
      receive_date: null,
      status_id: null,
      to_send: "",
      department_id: null,
      user_id: null,
      year: null,
    });

    const resetAdvancedSearch = () => {
      advancedSearch.title = "";
      advancedSearch.book_out_category_id = null;
      advancedSearch.book_no = "";
      advancedSearch.book_date = null;
      advancedSearch.receive_date = null;
      advancedSearch.status_id = null;
      advancedSearch.to_send = "";
      advancedSearch.department_id = null;
      advancedSearch.user_id = null;
      advancedSearch.year = null;
    };

    const exportXLS = reactive({
      book_out_category_id: "",
      start_date: "",
      end_date: "",
    });

    const fields = reactive([
      {
        key: "id",
        label: "Id",
        visible: false,
      },
      {
        key: "book_out_category_name",
        label: "หมวดหมู่",
        sortable: true,
        visible: true,
        class: "text-center",
        thStyle: {
          width: "100px",
        },
      },
      {
        key: "book_no",
        label: "เลขที่",
        sortable: true,
        visible: true,
        class: "text-center",
        thStyle: {
          width: "100px",
        },
      },
      {
        key: "title",
        label: "เรื่อง",
        sortable: true,
        visible: true,
        class: "text-left",
      },
      {
        key: "fullname",
        label: "ผู้รับผิดชอบ",
        sortable: true,
        visible: true,
        class: "text-center",
        thStyle: {
          width: "200px",
        },
      },
      {
        key: "book_date",
        label: "ลงวันที่",
        sortable: true,
        visible: true,
        class: "text-center",
        thStyle: {
          width: "150px",
        },
      },
      {
        key: "status_name",
        label: "สถานะ",
        sortable: true,
        visible: true,
        class: "text-center",
        thStyle: {
          width: "100px",
        },
      },
      {
        key: "book_out_file",
        label: "ไฟล์ต้นฉบับ",
        sortable: true,
        visible: true,
        class: "text-center",
        thStyle: {
          width: "150px",
        },
      },
      {
        key: "book_out_success_file",
        label: "ไฟล์ฉบับสมบูรณ์",
        sortable: true,
        visible: true,
        class: "text-center",
        thStyle: {
          width: "150px",
        },
      },
      // {
      //   key: "to_send",
      //   label: "เรียนถึง",
      //   sortable: true,
      //   visible: true,
      //   class: "text-center",
      //   thStyle: {
      //     width: "100px",
      //   },
      // },
      {
        key: "action",
        label: "จัดการ",
        visible: true,
        class: "text-center",
        thStyle: {
          width: "100px",
        },
      },
    ]);

    const visibleFields = computed(() => fields.filter((f) => f.visible));

    const selectOptions = ref({
      book_out_categories: [],
      departments: [],
      perPage: [
        { title: "10", code: 10 },
        { title: "40", code: 40 },
        { title: "60", code: 60 },
      ],
      orderBy: [
        { title: "หมวดหมู่", code: "book_out_category_id" },
        { title: "เลขที่เอกสาร", code: "book_no" },
        { title: "ชื่อเรื่อง", code: "title" },
        // { title: "ประเภท", code: "book_type_id" },
        { title: "ลงวันที่", code: "book_date" },
        { title: "สถานะ", code: "status_id" },
      ],
      order: [
        { title: "น้อย -> มาก", code: "asc" },
        { title: "มาก -> น้อย", code: "desc" },
      ],
      years: [],
      users: [],
    });

    const yearSelect = dayjs().locale("th").format("BBBB");
    selectOptions.value.years.push({
      title: String(yearSelect),
      code: String(yearSelect),
    });
    for (let i = 1; i <= 9; i++) {
      selectOptions.value.years.push({
        title: String(parseInt(yearSelect) - i),
        code: String(parseInt(yearSelect) - i),
      });
    }

    store
      .dispatch("book-out/fetchBookOutCategories")
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
            title: "Error fetching Category's list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    store
      .dispatch("book-out/fetchDepartments")
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.departments = data.map((d) => {
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
            title: "Error fetching Department's list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    store
      .dispatch("book-out/fetchUsers",{
        perPage: 100
      })
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.users = data.map((d) => {
          return {
            code: d.id,
            title: d.prefix + d.firstname + " " + d.lastname,
          };
        });
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching User's list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    const fetchItems = () => {
      let search = { ...advancedSearch };
      if (search.book_out_category_id) {
        if (search.book_out_category_id.hasOwnProperty("code")) {
          search.book_out_category_id = search.book_out_category_id.code;
        }
      }

      if (search.department_id) {
        if (search.department_id.hasOwnProperty("code")) {
          search.department_id = search.department_id.code;
        }
      }

      if (search.user_id) {
        if (search.user_id.hasOwnProperty("code")) {
          search.user_id = search.user_id.code;
        }
      }

      // if (search.is_publish) {
      //   if (search.is_publish.hasOwnProperty("code")) {
      //     search.is_publish = search.is_publish.code;
      //   }
      // }

      isOverLay.value = true;
      store
        .dispatch("book-out/fetchBookOuts", {
          perPage: perPage.value.code,
          currentPage: currentPage.value == 0 ? undefined : currentPage.value,
          orderBy: orderBy.value.code,
          order: order.value.code,
          ...search,
        })
        .then((response) => {
          // const { data, totalData, totalPage } = response.data;
          items.value = response.data.data;
          totalPage.value = response.data.totalPage;
          totalItems.value = response.data.totalData;
          isOverLay.value = false;
        })
        .catch((error) => {
          console.log(error);
          toast({
            component: ToastificationContent,
            props: {
              title: "Error fetching Book Out's list",
              icon: "AlertTriangleIcon",
              variant: "danger",
            },
          });
          isOverLay.value = false;
        });
    };
    fetchItems();

    // watch(
    //   () => advancedSearch.type,
    //   (value) => {
    //     if (value) {
    //       if (value.code == 1) {
    //         advancedSearch.country_code = { title: "ไทย", code: "THA" };
    //       } else {
    //         advancedSearch.country_code = {
    //           title: "-- All Country --",
    //           code: null,
    //         };
    //       }
    //     } else {
    //       advancedSearch.country_code = {
    //         title: "-- All Country --",
    //         code: null,
    //       };
    //     }
    //   }
    // );

    watchEffect(() => {
      fetchItems();
    });

    const onChangePage = (page) => {
      currentPage.value = page;
    };

    const displayDateInput = (date) => {
      return date ? dayjs(date).locale("th").format("DD/MM/BBBB") : date;
    };

    const onExportExcel = async () => {
      await store
        .dispatch("book-out/fetchBookOuts", {
          start_receive_date: exportXLS.start_date,
          end_receive_date: exportXLS.end_date,
          book_out_category_id: exportXLS.book_out_category_id.code,
        })
        .then((response) => {
          let exportExcels = response.data.data.map((x) => {
            return {
              วันที่สารบรรณรับเรื่อง: dayjs(x.receive_date)
                .locale("th")
                .format("DD MMM BB"),
              เลขรับ: x.book_no,
              เรื่อง: x.title,
              วันที่รับเอกสาร: "",
              ผู้รับเอกสาร: "",
            };
          });

          const dataWS = XLSX.utils.json_to_sheet(exportExcels);

          dataWS["!cols"] = [
            { width: 20 },
            { width: 20 },
            { width: 100 },
            { width: 20 },
            { width: 20 },
          ];

          const wb = XLSX.utils.book_new();
          XLSX.utils.book_append_sheet(wb, dataWS);
          XLSX.writeFile(wb, "export.xlsx");

          return;

          // const { data, totalData, totalPage } = response.data;
          // items.value = response.data.data;
          // totalPage.value = response.data.totalPage;
          // totalItems.value = response.data.totalData;
          // isOverLay.value = false;
        })
        .catch((error) => {
          console.log(error);
          toast({
            component: ToastificationContent,
            props: {
              title: "Error Export",
              icon: "AlertTriangleIcon",
              variant: "danger",
            },
          });
        });

      // dayjs.extend(isBetween);
      // // dayjs.extend(isSame)

      // let exportExcel = items.value.filter((x) => {
      //   if (
      //     dayjs(x.receive_date).isBetween(
      //       exportXLS.start_date,
      //       exportXLS.end_date
      //     )
      //   ) {
      //     return true;
      //   } else {
      //     let start = dayjs(x.receive_date).isSame(exportXLS.start_date);
      //     let end = dayjs(x.receive_date).isSame(exportXLS.end_date);

      //     // console.log(start)
      //     // console.log(x.date_receive)

      //     if (start == true || end == true) {
      //       return true;
      //     } else {
      //       return false;
      //     }
      //   }
      // });

      // let exportExcels = exportExcel.map((x) => {
      //   return {
      //     วันที่สารบรรณรับเรื่อง: dayjs(x.receive_date)
      //       .locale("th")
      //       .format("DD MMM BB"),
      //     เลขรับ: x.book_no,
      //     เรื่อง: x.title,
      //     วันที่รับเอกสาร: "",
      //     ผู้รับเอกสาร: "",
      //   };
      // });

      // const dataWS = XLSX.utils.json_to_sheet(exportExcels);

      // dataWS["!cols"] = [
      //   { width: 20 },
      //   { width: 20 },
      //   { width: 100 },
      //   { width: 20 },
      //   { width: 20 },
      // ];

      // const wb = XLSX.utils.book_new();
      // XLSX.utils.book_append_sheet(wb, dataWS);
      // XLSX.writeFile(wb, "export.xlsx");
    };

    return {
      items,
      totalItems,
      isOverLay,
      selectOptions,
      advancedSearch,
      resetAdvancedSearch,
      visibleFields,
      order,
      orderBy,
      perPage,
      currentPage,
      totalPage,
      onChangePage,
      dayjs,
      isAdmin,
      isStaff,
      isCEO,
      displayDateInput,
      exportXLS,
      onExportExcel,
      // onConfirmDelete,
      // formatYear
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
.table th {
  padding: 1em 1em 1em 1em;
  //   // padding: 1em 2px 1em 2px;
  //   // padding: 0.75rem 0.2rem !important;
  //   // padding-top: 1em !important;
  font-size: 1rem !important;
}

.table td {
  padding: 0.8em 1em 0.8em 1em;
  // padding: 0.75rem 0.2rem !important;
  // font-size: 0.9rem;
}
</style>

<template>
  <div>
    <!-- Search -->
    <b-card>
      <div class="m-2">
        <b-row>
          <b-col>
            <h4>ค้นหา/Search</h4>
            <hr />
          </b-col>
        </b-row>
        <b-row>
          <b-form-group
            label="หมวดหมู่เอกสาร/Category"
            label-for="category"
            class="col-md-3"
          >
            <v-select
              v-model="advancedSearch.book_out_category_id"
              :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
              label="title"
              :clearable="true"
              placeholder="-- All Category --"
              :options="selectOptions.book_out_categories"
            />
          </b-form-group>

          <b-form-group
            label="เลขที่/BookNo"
            label-for="book_no"
            class="col-md-3"
          >
            <b-form-input
              id="book_no"
              v-model="advancedSearch.book_no"
              placeholder="เลขที่..."
            />
          </b-form-group>

          <b-form-group label="เรื่อง/Title" label-for="title" class="col-md-6">
            <b-form-input
              id="title"
              v-model="advancedSearch.title"
              placeholder="ชื่อเรื่อง..."
            />
          </b-form-group>

          <b-form-group
            label="ลงวันที่/Book Date"
            label-for="book_date"
            class="col-md-2"
          >
            <flat-pickr
              v-model="advancedSearch.book_date"
              placeholder="ลงวันที่"
              :config="configDate"
            />
          </b-form-group>

          <!-- <b-form-group
            label="วันที่รับเอกสาร/Receive Date"
            label-for="receive_date"
            class="col-md-3"
          >
            <flat-pickr
              v-model="advancedSearch.receive_date"
              placeholder="วันที่รับเอกสาร"
              :config="configDate"
            />
          </b-form-group> -->

          <b-form-group
            label="สถานะเอกสาร"
            label-for="status_id"
            class="col-md-2"
          >
            <v-select
              v-model="advancedSearch.status_id"
              :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
              label="title"
              :clearable="true"
              placeholder="-- All Status --"
              :options="selectOptions.departments"
            />
          </b-form-group>

          <b-form-group
            label="เรียนถึง (ชื่อผู้รับในเอกสาร)"
            label-for="to_send"
            class="col-md-4"
          >
            <b-form-input
              id="to_send"
              v-model="advancedSearch.to_send"
              placeholder="เรียนถึง (ชื่อผู้รับในเอกสาร)"
            />
          </b-form-group>

          <b-form-group
            label="ผู้รับผิดชอบ"
            label-for="user_id"
            class="col-md-4"
          >
            <v-select
              v-model="advancedSearch.user_id"
              :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
              label="title"
              :clearable="true"
              placeholder="-- All User --"
              :options="selectOptions.users"
            />
          </b-form-group>
        </b-row>

        <b-row>
          <b-col>
            <b-button variant="outline-danger" @click="resetAdvancedSearch()">
              Clear
            </b-button>
          </b-col>
        </b-row>
      </div>
    </b-card>

    <b-card no-body style="box-shadow: 0 4px 24px 0 rgb(34 41 47 / 10%)">
      <b-overlay :show="isOverLay" opacity="0.3" spinner-variant="primary">
        <!-- Sort -->
        <div class="m-2">
          <b-row>
            <b-col>
              <b-button
                v-if="isAdmin || isStaff"
                variant="outline-success"
                @click="$router.push({ name: 'book-out-add' })"
                style="margin-top: 1em"
              >
                <feather-icon icon="PlusIcon" />
                <span class="d-none d-xl-inline d-md-inline">ADD</span>
              </b-button>

              <b-button
                v-if="isAdmin || isStaff"
                variant="outline-warning"
                style="margin-top: 1em"
                v-b-modal.modal-export
              >
                <feather-icon icon="FileIcon" />
                <span class="d-none d-xl-inline d-md-inline"
                  >พิมพ์ตารางรับเอกสาร</span
                >
              </b-button>

              <b-button
                variant="outline-info"
                @click="$router.push({ name: 'book-out-old' })"
                class="float-right"
                style="margin-top: 1em"
              >
                <feather-icon icon="ArchiveIcon" />
                <span class="d-none d-xl-inline d-md-inline">Archive</span>
              </b-button>
              <hr />
            </b-col>
          </b-row>
          <b-row>
            <b-col>
              <b-form-group class="float-left col-lg-2">
                <span>จำนวนเอกสาร ต่อ page</span>
                <v-select
                  v-model="perPage"
                  :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                  label="title"
                  :options="selectOptions.perPage"
                  :clearable="false"
                />
              </b-form-group>
              <b-form-group class="float-left col-lg-4">
                <span>ลักษณะการแสดงผล</span>
                <v-select
                  v-model="orderBy"
                  :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                  label="title"
                  :options="selectOptions.orderBy"
                  :clearable="false"
                />
              </b-form-group>
              <b-form-group class="float-left col-lg-2">
                <span>ลำดับการแสดงผล</span>
                <v-select
                  v-model="order"
                  :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                  label="title"
                  :options="selectOptions.order"
                  :clearable="false"
                />
              </b-form-group>
            </b-col>
          </b-row>

          <hr />
        </div>
        <!-- List -->
        <div class="m-2">
          <b-row>
            <b-col cols="12">
              <b-table
                striped
                bordered
                hover
                responsive
                :items="items"
                :fields="visibleFields"
              >
                <template #cell(receive_date)="row">
                  {{
                    row.item.receive_date
                      ? dayjs(row.item.receive_date)
                          .locale("th")
                          .format("DD MMM BB")
                      : ""
                  }}
                </template>
                <template #cell(book_out_category_name)="row">
                  {{ row.item.book_out_category_name }}
                </template>
                <template #cell(book_date)="row">
                  {{
                    row.item.book_date
                      ? dayjs(row.item.book_date)
                          .locale("th")
                          .format("DD MMM BB")
                      : ""
                  }}
                </template>

                <template #cell(status_name)="row">
                  <b-badge :variant="row.item.status_color">
                    {{ row.item.status_name }}
                  </b-badge>
                </template>

                <template #cell(book_out_file)="data">
                  <b-button
                    variant="outline-primary"
                    alt="เปิดเอกสาร"
                    title="เปิดเอกสาร"
                    class="btn-icon btn-sm"
                    target="_blank"
                    :href="data.value"
                    v-if="data.value != ''"
                  >
                    <feather-icon icon="FileIcon" style="margin-bottom: -2px" />
                    <span class="d-none d-xl-inline">เปิดเอกสาร</span>
                  </b-button>
                  <span v-if="data.value == ''">-</span>
                </template>

                <template #cell(book_out_success_file)="data">
                  <b-button
                    variant="outline-success"
                    alt="เปิดเอกสาร"
                    title="เปิดเอกสาร"
                    class="btn-icon btn-sm"
                    target="_blank"
                    :href="data.value"
                    v-if="data.value != ''"
                  >
                    <feather-icon icon="FileIcon" style="margin-bottom: -2px" />
                    <span class="d-none d-xl-inline">เปิดเอกสาร</span>
                  </b-button>
                  <span v-if="data.value == ''">-</span>
                </template>

                <template #cell(action)="row">
                  <b-button
                    variant="outline-warning"
                    alt="ดูข้อมูล"
                    title="ดูข้อมูล"
                    class="btn-icon btn-sm"
                    @click="
                      $router.push({
                        name: 'book-out-view',
                        params: { id: row.item.id },
                      })
                    "
                  >
                    <feather-icon icon="EyeIcon" style="margin-bottom: -2px" />
                  </b-button>
                  <b-button
                    variant="outline-info"
                    alt="แก้ไข"
                    title="แก้ไข"
                    class="btn-icon btn-sm"
                    @click="
                      $router.push({
                        name: 'book-out-edit',
                        params: { id: row.item.id },
                      })
                    "
                  >
                    <feather-icon icon="EditIcon" style="margin-bottom: -2px" />
                  </b-button>
                  <!-- <b-button
                    @click="onConfirmDelete(row.item.id)"
                    variant="outline-danger"
                    alt="ลบ"
                    title="ลบ"
                    class="btn-icon btn-sm"
                  >
                    <feather-icon
                      icon="TrashIcon"
                      style="margin-bottom: -2px"
                    />
                  </b-button> -->
                </template>
              </b-table>
            </b-col>
          </b-row>

          <b-row>
            <b-col cols="12" class="text-center">
              <b-pagination
                v-model="currentPage"
                :total-rows="totalItems"
                :per-page="perPage.code"
                align="center"
                aria-controls="my-book-out"
                @change="onChangePage"
              />
            </b-col>
          </b-row>
        </div>
      </b-overlay>
    </b-card>

    <!-- Modal -->
    <b-modal
      id="modal-export"
      cancel-variant="outline-secondary"
      ok-title="Submit"
      cancel-title="Close"
      centered
      title="พิมพ์ตารางรับเอกสาร"
    >
      <b-form>
        <b-form-group>
          <label for="start">หมวดหมู่เอกสาร : </label>
          <v-select
            v-model="exportXLS.book_out_category_id"
            :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
            label="title"
            :clearable="true"
            placeholder="-- All Category --"
            :options="selectOptions.book_out_categories"
          />
        </b-form-group>
        <b-form-group>
          <label for="start">วันที่เริ่ม : </label>
          <flat-pickr
            v-model="exportXLS.start_date"
            class="form-control"
            placeholder="วันที่เริ่ม"
            :config="configDate"
          />
        </b-form-group>
        <b-form-group>
          <label for="password">ถึงวันที่ : </label>
          <flat-pickr
            v-model="exportXLS.end_date"
            class="form-control"
            placeholder="ถึงวันที่"
            :config="configDate"
          />
        </b-form-group>
      </b-form>
      <template #modal-footer="{ cancel }">
        <b-button variant="success" @click="onExportExcel"> Submit </b-button>
        <b-button variant="danger" @click="cancel()"> Cancel </b-button>
      </template>
    </b-modal>
  </div>
</template>
