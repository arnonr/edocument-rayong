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

import {
  ref,
  watch,
  watchEffect,
  reactive,
  onUnmounted,
  computed,
} from "@vue/composition-api";
import store from "@/store";
import reportStoreModule from "./reportStoreModule";
import router from "../../router";

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
        mode: "range",
        altInput: true,
        altFormat: "j M Y",
        dateFormat: "Y-m-d",
        locale: Thai,
        disableMobile: "true",
      },
      buddhistYear: true,
    };
  },
  setup() {
    const REPORT_APP_STORE_MODULE_NAME = "report";

    // Register module
    if (!store.hasModule(REPORT_APP_STORE_MODULE_NAME))
      store.registerModule(REPORT_APP_STORE_MODULE_NAME, reportStoreModule);

    // UnRegister on leave
    onUnmounted(() => {
      // if (store.hasModule(BOOK_IN_APP_STORE_MODULE_NAME))
      // store.unregisterModule(BOOK_IN_APP_STORE_MODULE_NAME);
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

    const advancedSearch = reactive({
      book_date: null,
      book_start_date: null,
      book_end_date: null,
      book_year_id: null,
    });

    const resetAdvancedSearch = () => {
      advancedSearch.book_date = null;
      advancedSearch.book_start_date = null;
      advancedSearch.book_end_date = null;
      advancedSearch.book_year_id = null;
    };

    const selectOptions = ref({
      book_in_categories: [],
      book_in_types: [],
      book_out_categories: [],
      book_years: [],
    });

    store
      .dispatch("report/fetchBookInCategories")
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.book_in_categories = data.map((d) => {
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
      .dispatch("report/fetchBookOutCategories")
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
      .dispatch("report/fetchBookYears")
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

    let book_out_category_all = ref([]);
    let book_out_sum = ref({ total: 0, paper: 0 });

    const fetchBookOuts = () => {
      const date_split = advancedSearch.book_date.split(" ถึง ");
      store
        .dispatch("report/fetchBookOuts", {
          book_year_id: advancedSearch.book_year_id.code,
          start_book_date: date_split[0],
          end_book_date: date_split[1],
          perPage: 5000,
        })
        .then((response) => {
          const { data } = response.data;

          if (data.length != 0) {
            book_out_sum.value.total = data.length;
            let book_no_arr = data.map((d) => {
              let no = d.book_no.split("/");
              book_out_sum.value.paper =
                book_out_sum.value.paper + d.book_page_count_sum;

              return {
                book_no: no[0],
                book_out_categoty_id: d.book_out_category_id,
              };
            });

            book_out_category_all.value =
              selectOptions.value.book_out_categories.map((c) => {
                let book_out_category_arr = book_no_arr.filter((d) => {
                  return d.book_out_categoty_id == c.code;
                });
                book_out_category_arr.sort();

                let total = book_out_category_arr.length;

                let min_book_no =
                  "000" + "/" + advancedSearch.book_year_id.title;
                let max_book_no =
                  "000" + "/" + advancedSearch.book_year_id.title;

                if (total != 0) {
                  min_book_no =
                    book_out_category_arr[0].book_no +
                    "/" +
                    advancedSearch.book_year_id.title;
                  max_book_no =
                    book_out_category_arr[total - 1].book_no +
                    "/" +
                    advancedSearch.book_year_id.title;
                }

                return {
                  id: c.code,
                  name: c.title,
                  start_no: min_book_no,
                  end_no: max_book_no,
                  total_no: total,
                };
              });
          } else {
            book_out_category_all.value = [];
          }
        });
    };

    //
    let book_in_category_all = ref([]);
    let book_in_sum = ref({ total: 0, paper: 0 });

    const fetchBookIns = () => {
      let date_split = advancedSearch.book_date.split(" ถึง ");
      store
        .dispatch("report/fetchBookIns", {
          book_year_id: advancedSearch.book_year_id.code,
          start_book_date: date_split[0],
          end_book_date: date_split[1],
          perPage: 5000,
        })
        .then((response) => {
          const { data } = response.data;

          if (data.length != 0) {
            book_in_sum.value.total = data.length;
            let book_no_arr = data.map((d) => {
              let no = d.book_no.split("/");
              book_in_sum.value.paper =
                book_in_sum.value.paper + d.book_page_count_sum;

              return {
                book_no: no[0],
                book_in_categoty_id: d.book_in_category_id,
              };
            });

            book_in_category_all.value =
              selectOptions.value.book_in_categories.map((c) => {
                let book_in_category_arr = book_no_arr.filter((d) => {
                  return d.book_in_categoty_id == c.code;
                });
                book_in_category_arr.sort();

                let total = book_in_category_arr.length;

                let min_book_no =
                  "000" + "/" + advancedSearch.book_year_id.title;
                let max_book_no =
                  "000" + "/" + advancedSearch.book_year_id.title;

                if (total != 0) {
                  min_book_no =
                    book_in_category_arr[0].book_no +
                    "/" +
                    advancedSearch.book_year_id.title;
                  max_book_no =
                    book_in_category_arr[total - 1].book_no +
                    "/" +
                    advancedSearch.book_year_id.title;
                }

                return {
                  id: c.code,
                  name: c.title,
                  start_no: min_book_no,
                  end_no: max_book_no,
                  total_no: total,
                };
              });
          } else {
            book_in_category_all.value = [];
          }
        });
    };

    watch(
      () => [advancedSearch.book_year_id],
      (newData) => {
        let year = parseInt(advancedSearch.book_year_id.title) - 543;
        advancedSearch.book_date = year + "-01-01 ถึง " + year + "-12-31";
        //
      }
    );

    watch(
      () => [advancedSearch.book_date],
      (newData) => {
        if (advancedSearch.book_date.includes("ถึง")) {
          fetchBookOuts();
          fetchBookIns();
        }
        //
      }
    );

    const displayDateInput = (date) => {
      return date ? dayjs(date).locale("th").format("DD/MMM/BBBB") : date;
    };

    const onPrint = () => {
      window.print();
    };

    return {
      isOverLay,
      selectOptions,
      advancedSearch,
      resetAdvancedSearch,
      dayjs,
      isAdmin,
      isStaff,
      isCEO,
      displayDateInput,
      book_out_category_all,
      book_out_sum,
      book_in_category_all,
      book_in_sum,
      onPrint
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
}
</style>

<template>
  <div>
    <!-- Search -->
    <b-card>
      <div class="m-2">
        <b-row>
          <b-col>
            <h4>เลือกข้อมูลออกรายงาน</h4>
            <hr />
          </b-col>
        </b-row>
        <b-row>
          <b-form-group label="เลือกปี/Year" label-for="year" class="col-md-6">
            <v-select
              v-model="advancedSearch.book_year_id"
              :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
              label="title"
              :clearable="true"
              placeholder="-- Choose Year --"
              :options="selectOptions.book_years"
            />
          </b-form-group>

          <b-form-group
            label="วันที่/Date"
            label-for="book_date"
            class="col-md-6"
          >
            <flat-pickr
              v-model="advancedSearch.book_date"
              placeholder="เลือกวันที่"
              :config="configDate"
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
            <h4>เอกสารออกเลข</h4>
            <hr />
          </b-col>
        </b-row>
        <b-row>
          <b-col class="col-md-12">
            <table class="table table-bordered">
              <thead>
                <th class="text-center">หมวดเอกสาร</th>
                <th class="text-center">เลขเริ่มต้น</th>
                <th class="text-center">เลขล่าสุด</th>
                <th class="text-center">รวม</th>
              </thead>
              <tbody>
                <tr v-for="item in book_out_category_all">
                  <td class="text-center">{{ item.name }}</td>
                  <td class="text-center">{{ item.start_no }}</td>
                  <td class="text-center">{{ item.end_no }}</td>
                  <td class="text-center">{{ item.total_no }} เอกสาร</td>
                </tr>
                <tr>
                  <td colspan="3" class="text-right">รวม</td>
                  <td class="text-center">{{ book_out_sum.total }} เอกสาร</td>
                </tr>

                <tr>
                  <td colspan="3" class="text-right">ลดปริมาณกระดาษ</td>
                  <td class="text-center">{{ book_out_sum.paper }} แผ่น</td>
                </tr>
              </tbody>
            </table>
          </b-col>
        </b-row>
      </div>
    </b-card>
    <!--  -->
    <b-card>
      <div class="m-2">
        <b-row>
          <b-col>
            <h4>เอกสารรับเข้า-ส่งออก</h4>
            <hr />
          </b-col>
        </b-row>
        <b-row>
          <b-col class="col-md-12">
            <table class="table table-bordered">
              <thead>
                <th class="text-center">หมวดเอกสาร</th>
                <th class="text-center">เลขเริ่มต้น</th>
                <th class="text-center">เลขล่าสุด</th>
                <th class="text-center">รวม</th>
              </thead>
              <tbody>
                <tr v-for="item in book_in_category_all">
                  <td class="text-center">{{ item.name }}</td>
                  <td class="text-center">{{ item.start_no }}</td>
                  <td class="text-center">{{ item.end_no }}</td>
                  <td class="text-center">{{ item.total_no }} เอกสาร</td>
                </tr>
                <tr>
                  <td colspan="3" class="text-right">รวม</td>
                  <td class="text-center">{{ book_in_sum.total }} เอกสาร</td>
                </tr>
                <tr>
                  <td colspan="3" class="text-right">ลดปริมาณกระดาษ</td>
                  <td class="text-center">{{ book_in_sum.paper }} แผ่น</td>
                </tr>
              </tbody>
            </table>
          </b-col>
        </b-row>
      </div>
    </b-card>
    <!--  -->
  </div>
</template>
