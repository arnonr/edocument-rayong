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
} from "bootstrap-vue";
import vSelect from "vue-select";
import flatPickr from "vue-flatpickr-component";
import "flatpickr/dist/flatpickr.css";
import { Thai } from "flatpickr/dist/l10n/th.js";

import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

import * as XLSX from "xlsx/xlsx";

import {
  ref,
  watch,
  watchEffect,
  reactive,
  onUnmounted,
  computed,
} from "@vue/composition-api";
import store from "@/store";
import bookOutOldStoreModule from "./bookOutOldStoreModule";
import router from "../../../router";

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
    const BOOK_OUT_OLD_APP_STORE_MODULE_NAME = "book-out-old";

    // Register module
    if (!store.hasModule(BOOK_OUT_OLD_APP_STORE_MODULE_NAME))
      store.registerModule(
        BOOK_OUT_OLD_APP_STORE_MODULE_NAME,
        bookOutOldStoreModule
      );

    // UnRegister on leave
    onUnmounted(() => {
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
      title: "วันที่รับเอกสาร",
      code: "receive_date",
    });
    const order = ref({ title: "มาก -> น้อย", code: "desc" });

    const advancedSearch = reactive({
      title: "",
      book_out_category_id: null,
      receive_date: null,
      book_no: "",
      to_send: "",
      department_id: null,
      book_year_id: null,
    });

    const resetAdvancedSearch = () => {
      advancedSearch.title = "";
      advancedSearch.book_out_category_id = null;
      advancedSearch.receive_date = null;
      advancedSearch.book_no = "";
      advancedSearch.to_send = "";
      advancedSearch.department_id = null;
      // advancedSearch.year = null;
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
        key: "receive_date",
        label: "วันที่รับ",
        sortable: true,
        visible: true,
        class: "text-center",
        thStyle: {
          width: "100px",
        },
      },
      {
        key: "book_no",
        label: "เลขรับ",
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
        key: "book_from",
        label: "หน่วยงาน (ต้นทาง)",
        sortable: true,
        visible: true,
        class: "text-left",
        thStyle: {
          width: "300px",
        },
      },
      {
        key: "to_send",
        label: "เรียนถึง",
        sortable: true,
        visible: true,
        class: "text-center",
        thStyle: {
          width: "100px",
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
        { title: "วันที่รับเอกสาร", code: "receive_date" },
        { title: "เลขรับเอกสาร", code: "book_no" },
        { title: "ชื่อเรื่อง", code: "title" },
        { title: "หมวดหมู่", code: "book_category_id" },
        { title: "ประเภท", code: "book_type_id" },
        { title: "หน่วยงาน (ต้นทาง)", code: "book_from" },
        { title: "เรียนถึง (ชื่อผู้รับในเอกสาร)", code: "to_send" },
      ],
      order: [
        { title: "น้อย -> มาก", code: "asc" },
        { title: "มาก -> น้อย", code: "desc" },
      ],
      book_years: [],
    });

    // const yearSelect = dayjs().locale("th").format("BBBB");
    // selectOptions.value.book_years.push({
    //   title: String(yearSelect),
    //   code: String(yearSelect),
    // });
    // for (let i = 1; i <= 9; i++) {
    //   selectOptions.value.book_years.push({
    //     title: String(parseInt(yearSelect) - i),
    //     code: String(parseInt(yearSelect) - i),
    //   });
    // }

    store
      .dispatch("book-out-old/fetcOutCategories")
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
      .dispatch("book-out-old/fetchDepartments")
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
      .dispatch("book-out-old/fetchBookYears", { status: 0 })
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.book_years = data.map((d) => {
          return {
            code: d.id,
            title: d.name,
          };
        });

        if (typeof router.currentRoute.query.book_year_id !== "undefined") {
          let book_year = selectOptions.value.book_years.find((e) => {
            return e.code == router.currentRoute.query.book_year_id;
          });
          advancedSearch.book_year_id = {
            title: book_year.title,
            code: router.currentRoute.query.book_year_id,
          };
        }
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Book Year's list",
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

      if (search.book_year_id) {
        if (search.book_year_id.hasOwnProperty("code")) {
          search.book_year_id = search.book_year_id.code;
        }
      }

      // if (search.is_publish) {
      //   if (search.is_publish.hasOwnProperty("code")) {
      //     search.is_publish = search.is_publish.code;
      //   }
      // }

      isOverLay.value = true;
      store
        .dispatch("book-out-old/fetchBookOuts", {
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
    // fetchItems();

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
      if (advancedSearch.book_year_id != null) {
        fetchItems();
      }
    });

    const onChangePage = (page) => {
      currentPage.value = page;
    };

    const displayDateInput = (date) => {
      return date ? dayjs(date).locale("th").format("DD/MM/BBBB") : date;
    };

    const onExportExcel = async () => {
      if (advancedSearch.book_year_id == null) {
        errorToast("โปรดระบุปี");
        return;
      }
      console.log(exportXLS.book_out_category_id);
      if (
        exportXLS.book_out_category_id == "" ||
        exportXLS.end_date == "" ||
        exportXLS.start_date == ""
      ) {
        errorToast("โปรดระบุข้อมูลให้ครบถ้วน");
        return;
      }

      await store
        .dispatch("book-out-old/fetchBookOuts", {
          start_receive_date: exportXLS.start_date,
          end_receive_date: exportXLS.end_date,
          book_out_category_id: exportXLS.book_out_category_id.code,
          book_year_id: advancedSearch.book_year_id.code,
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
            <h4>ค้นหาเอกสารย้อนหลัง/Search</h4>
            <hr />
          </b-col>
        </b-row>
        <b-row>
          <b-form-group label="เรื่อง/Title" label-for="title" class="col-md-4">
            <b-form-input
              id="title"
              v-model="advancedSearch.title"
              placeholder="ชื่อเรื่อง..."
            />
          </b-form-group>

          <b-form-group
            label="หมวดหมู่เอกสาร/Category"
            label-for="category"
            class="col-md-4"
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
            label="วันที่รับเอกสาร/Receive Date"
            label-for="receive_date"
            class="col-md-3"
          >
            <flat-pickr
              v-model="advancedSearch.receive_date"
              placeholder="วันที่รับเอกสาร"
              :config="configDate"
            />
          </b-form-group>

          <b-form-group
            label="เลขรับ/Book No"
            label-for="book_no"
            class="col-md-2"
          >
            <b-form-input
              id="book_no"
              v-model="advancedSearch.book_no"
              placeholder="เลขรับเอกสาร"
            />
          </b-form-group>

          <b-form-group
            label="เรียนถึง (ชื่อผู้รับในเอกสาร)"
            label-for="to_send"
            class="col-md-3"
          >
            <b-form-input
              id="to_send"
              v-model="advancedSearch.to_send"
              placeholder="เรียนถึง (ชื่อผู้รับในเอกสาร)"
            />
          </b-form-group>

          <b-form-group
            label="ฝ่ายที่เกี่ยวข้อง/Department"
            label-for="department"
            class="col-md-4"
          >
            <v-select
              v-model="advancedSearch.department_to"
              :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
              label="title"
              :clearable="true"
              placeholder="-- All Department --"
              :options="selectOptions.departments"
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

    <b-card>
      <div class="m-2">
        <b-row>
          <b-col>
            <b-form-group
              label="เลือกปีเอกสาร"
              label-for="category"
              class="col-md-12"
            >
              <v-select
                v-model="advancedSearch.book_year_id"
                :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                label="title"
                :clearable="true"
                placeholder="-- Choose Year --"
                :options="selectOptions.book_years"
              />
            </b-form-group>
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
              <h2
                class="text-center"
                v-if="advancedSearch.book_year_id != null"
              >
                เอกสารปี
                {{ advancedSearch.book_year_id.title }}
              </h2>
            </b-col>
          </b-row>
        </div>
        <div class="m-2">
          <b-row>
            <b-col>
              <b-button
                v-if="isAdmin || isStaff"
                :variant="advancedSearch.book_year_id != null ? 'outline-success' : 'outline-secondary'"
                :disabled="advancedSearch.book_year_id != null ? false : true"
                @click="
                  $router.push({
                    name: 'book-out-old-add',
                    query: {
                      book_year_id: advancedSearch.book_year_id.code,
                    },
                  })
                "
                style="margin-top: 1em"
              >
                <feather-icon icon="PlusIcon" />
                <span class="d-none d-xl-inline d-md-inline">ADD</span>
              </b-button>

              <b-button
                v-if="isAdmin || isStaff"
                :variant="advancedSearch.book_year_id != null ? 'outline-warning' : 'outline-secondary'"
                :disabled="advancedSearch.book_year_id != null ? false : true"
                style="margin-top: 1em"
                v-b-modal.modal-export
              >
                <feather-icon icon="FileIcon" />
                <span class="d-none d-xl-inline d-md-inline"
                  >พิมพ์ตารางรับเอกสาร</span
                >
              </b-button>

              <b-button
                variant="outline-success"
                @click="$router.push({ name: 'book-out-list' })"
                class="float-right"
                style="margin-top: 1em"
              >
                <feather-icon icon="ChevronsLeftIcon" />
                <span class="d-none d-xl-inline d-md-inline"
                  >กลับปีปัจจุบัน</span
                >
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
                  {{
                    row.item.book_out_category_name == "เอกสารรับภายนอก"
                      ? "รับภายนอก"
                      : "รับภายใน"
                  }}
                </template>

                <template #cell(book_out_success_file)="data">
                  <b-button
                    variant="outline-success"
                    alt="เปิดเอกสาร"
                    title="เปิดเอกสาร"
                    class="btn-icon btn-sm"
                    target="_blank"
                    :href="data.value"
                    v-if="data.value != '-'"
                  >
                    <feather-icon icon="FileIcon" style="margin-bottom: -2px" />
                    <span class="d-none d-xl-inline">เปิดเอกสาร</span>
                  </b-button>
                  <span v-if="data.value == '-'">-</span>
                </template>

                <template #cell(action)="row">
                  <b-button
                    variant="outline-warning"
                    alt="ดูข้อมูล"
                    title="ดูข้อมูล"
                    class="btn-icon btn-sm"
                    @click="
                      $router.push({
                        name: 'book-out-old-view',
                        params: { id: row.item.id },
                        query: {
                          book_year_id: advancedSearch.book_year_id.code,
                        },
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
                        name: 'book-out-old-edit',
                        params: { id: row.item.id },
                        query: {
                          book_year_id: advancedSearch.book_year_id.code,
                        },
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
