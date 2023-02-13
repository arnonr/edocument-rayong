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
} from "@vue/composition-api";
import store from "@/store";
import mouStoreModule from "./mouStoreModule";

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
    const MOU_APP_STORE_MODULE_NAME = "mou";

    // Register module
    if (!store.hasModule(MOU_APP_STORE_MODULE_NAME))
      store.registerModule(MOU_APP_STORE_MODULE_NAME, mouStoreModule);

    // UnRegister on leave
    onUnmounted(() => {
      // if (store.hasModule(MOU_APP_STORE_MODULE_NAME))
      // store.unregisterModule(MOU_APP_STORE_MODULE_NAME);
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

    const items = ref([]);
    const isAdmin = getUserData().type == "admin" ? true : false;
    const isStaff = getUserData().type == "staff" ? true : false;
    const isOverLay = ref(false);
    const perPage = ref({ title: "20", code: 20 });
    const currentPage = ref(1);
    const totalPage = ref(1);
    const totalItems = ref(0);
    const orderBy = ref({
      title: "วันเริ่มสัญญา/Start Date",
      code: "start_date",
    });
    const order = ref({ title: "มาก -> น้อย", code: "desc" });

    const advancedSearch = reactive({
      name: "",
      partner: "",
      host_id: null,
      country_code: null,
      start_date: null,
      end_date: null,
      type: null,
      // is_publish: { title: "Publish", code: 1 },
      status: null,
      year: null,
    });

    const resetAdvancedSearch = () => {
      advancedSearch.name = "";
      advancedSearch.partner = "";
      advancedSearch.host_id = null;
      advancedSearch.country_code = null;
      advancedSearch.start_date = null;
      advancedSearch.end_date = null;
      advancedSearch.type = null;
      advancedSearch.status = null;
      // advancedSearch.is_publish = { title: "Publish", code: 1 };
    };

    const selectOptions = ref({
      hosts: [],
      countries: [],
      types: [
        { title: "ในประเทศ (Domestic Type)", code: 1 },
        { title: "ต่างประเทศ (Foreign Type)", code: 2 },
      ],
      statuses: [
        { title: "Active", code: "active" },
        { title: "InActive", code: "inActive" },
        { title: "Warning", code: "warning" },
      ],
      // is_publish: [
      //   { title: "Publish", code: 1 },
      //   { title: "Non-Publish", code: 0 },
      // ],
      perPage: [
        { title: "20", code: 20 },
        { title: "40", code: 40 },
        { title: "60", code: 60 },
      ],
      orderBy: [
        { title: "องค์กรคู่สัญญา/Partner", code: "partner" },
        { title: "หน่วยงาน/Host", code: "host.name" },
        { title: "ประเภทความร่วมมือ/Mou Type", code: "type" },
        { title: "ประเทศคู่สัญญา/Country", code: "country.ct_nameTHA" },
        { title: "สถานะความร่วมมือ/Status", code: "status" },
        { title: "วันเริ่มสัญญา/Start Date", code: "start_date" },
        { title: "วันสิ้นสุดสัญญา/End Date", code: "end_date" },
        // { title: "ชื่อความร่วมมือ/MOU Name", code: "name" },
      ],
      order: [
        { title: "น้อย -> มาก", code: "asc" },
        { title: "มาก -> น้อย", code: "desc" },
      ],
      years: [],
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
      .dispatch("mou/fetchHosts")
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
      .dispatch("mou/fetchCountries")
      .then((response) => {
        const { data } = response.data;
        selectOptions.value.countries = data.map((d) => {
          return {
            code: d.ct_code,
            title: d.ct_nameTHA + " (" + d.ct_nameENG + ")",
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

    const fetchItems = () => {
      let search = { ...advancedSearch };
      if (search.host_id) {
        if (search.host_id.hasOwnProperty("code")) {
          search.host_id = search.host_id.code;
        }
      }
      if (search.country_code) {
        if (search.country_code.hasOwnProperty("code")) {
          search.country_code = search.country_code.code;
        }
      }
      if (search.type) {
        if (search.type.hasOwnProperty("code")) {
          search.type = search.type.code;
        }
      }
      if (search.status) {
        if (search.status.hasOwnProperty("code")) {
          search.status = search.status.code;
        }
      }

      if (search.year) {
        if (search.year.hasOwnProperty("code")) {
          search.year = search.year.code;
        }
      }
      // if (search.is_publish) {
      //   if (search.is_publish.hasOwnProperty("code")) {
      //     search.is_publish = search.is_publish.code;
      //   }
      // }

      isOverLay.value = true;
      store
        .dispatch("mou/fetchMous", {
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
              title: "Error fetching Mou's list",
              icon: "AlertTriangleIcon",
              variant: "danger",
            },
          });
          isOverLay.value = false;
        });
    };
    fetchItems();

    watch(
      () => advancedSearch.type,
      (value) => {
        if (value) {
          if (value.code == 1) {
            advancedSearch.country_code = { title: "ไทย", code: "THA" };
          } else {
            advancedSearch.country_code = {
              title: "-- All Country --",
              code: null,
            };
          }
        } else {
          advancedSearch.country_code = {
            title: "-- All Country --",
            code: null,
          };
        }
      }
    );

    watchEffect(() => {
      fetchItems();
    });

    const onChangePage = (page) => {
      currentPage.value = page;
    };

    const displayDateInput = (date) => {
      return date ? dayjs(date).locale("th").format("DD/MM/BBBB") : date;
    };

    return {
      items,
      totalItems,
      isOverLay,
      selectOptions,
      advancedSearch,
      resetAdvancedSearch,
      order,
      orderBy,
      perPage,
      currentPage,
      totalPage,
      onChangePage,
      dayjs,
      isAdmin,
      isStaff,
      displayDateInput,
      // formatYear
    };
  },
};
</script>

<style lang="scss">
.mou-item-card {
  border: 10px solid;
  cursor: pointer;
}
.mou-item-active {
  border-color: #99cc33;
}
.mou-item-warning {
  border-color: #ffcc00;
}
.mou-item-inActive {
  border-color: #ff0000;
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
</style>

<template>
  <div class="container-lg">
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
            label="ชื่อความร่วมมือ/MOU Name"
            label-for="name"
            class="col-md-4"
          >
            <b-form-input
              id="name"
              v-model="advancedSearch.name"
              placeholder=""
            />
          </b-form-group>

          <b-form-group
            label="หน่วยงาน/Host Organization"
            label-for="host_id"
            class="col-md-4"
          >
            <v-select
              v-model="advancedSearch.host_id"
              :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
              label="title"
              :clearable="true"
              placeholder="-- All Host --"
              :options="selectOptions.hosts"
            />
          </b-form-group>

          <b-form-group
            label="องค์กรคู่สัญญา/Partner Organization"
            label-for="partner"
            class="col-md-4"
          >
            <b-form-input
              id="partner"
              v-model="advancedSearch.partner"
              placeholder=""
            />
          </b-form-group>

          <b-form-group
            label="ประเภทความร่วมมือ/Mou Type"
            label-for="type"
            class="col-md-4"
          >
            <v-select
              v-model="advancedSearch.type"
              :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
              label="title"
              :clearable="true"
              placeholder="-- All Type --"
              :options="selectOptions.types"
            />
          </b-form-group>

          <b-form-group
            label="ประเทศคู่สัญญา/Country"
            label-for="country_code"
            class="col-md-4"
          >
            <v-select
              v-model="advancedSearch.country_code"
              :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
              label="title"
              :clearable="true"
              placeholder="-- All Country --"
              :options="selectOptions.countries"
            />
          </b-form-group>

          <b-form-group
            label="สถานะความร่วมมือ/Status"
            label-for="status"
            class="col-md-4"
          >
            <v-select
              v-model="advancedSearch.status"
              :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
              label="title"
              :clearable="true"
              placeholder="-- All Status --"
              :options="selectOptions.statuses"
            />
          </b-form-group>

          <b-form-group
            label="วันเริ่มสัญญา/Start Date"
            label-for="start_date"
            class="col-md-4"
          >
            <flat-pickr
              v-model="advancedSearch.start_date"
              placeholder="Start Date"
              :config="configDate"
            />
          </b-form-group>

          <b-form-group
            label="วันสิ้นสุดสัญญา/End Date"
            label-for="end_date"
            class="col-md-4"
          >
            <flat-pickr
              v-model="advancedSearch.end_date"
              placeholder="End Date"
              :config="configDate"
            />

            <!-- <vc-date-picker
              v-model="advancedSearch.end_date"
              locale="th"
              :masks="{ input: 'DD/MM/YYYY' }"
            >
              <template
                slot="header-title"
                slot-scope="{ monthLabel, yearLabel }"
                >{{ monthLabel }}
                {{ yearLabel | formatYear(buddhistYear) }}</template
              >

              <template #default="{ inputValue, inputEvents }">
                <b-form-input
                  id="end_date"
                  placeholder="End Date"
                  :value="displayDateInput(inputValue)"
                  :readonly="true"
                  v-on="inputEvents"
                />
              </template>
            </vc-date-picker> -->
          </b-form-group>

          <b-form-group
            label="ปีที่เซ็นสัญญา/Year"
            label-for="year"
            class="col-md-4"
          >
            <v-select
              v-model="advancedSearch.year"
              :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
              label="title"
              :clearable="true"
              placeholder="-- All Year --"
              :options="selectOptions.years"
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
              <b-form-group class="float-left col-lg-2">
                <span>จำนวน MOU ต่อ page</span>
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

              <b-button
                v-if="isAdmin || isStaff"
                variant="outline-success"
                @click="$router.push({ name: 'mou-add' })"
                class="float-right"
                style="margin-top: 1em;"
              >
                <feather-icon icon="PlusIcon" />
                ADD
              </b-button>
            </b-col>
          </b-row>

          <hr />
        </div>
        <!-- List -->
        <div class="m-2">
          <b-row>
            <b-col
              v-for="(it, key) of items"
              :key="it.id"
              class="col-md-4 col-sm-6 col-lg-3"
            >
              <b-card
                :class="'mou-item-card pa-2 mou-item-' + it.status"
                :img-src="it.partner_logo_file"
                img-top
                img-alt="card img"
                class="position-static"
                @click="
                  $router.push({
                    name: 'mou-view',
                    params: { id: it.id },
                  })
                "
              >
                <b-card-text>
                  <div style="min-height: 80px">
                    <b-link :to="'view'"
                      ><h4>{{ it.partner }}</h4></b-link
                    >
                  </div>
                  <hr />
                  <div style="min-height: 50px">
                    {{ it.host_name }}
                  </div>
                  <span style="font-size: 0.9em">
                    {{
                      dayjs(it.start_date).locale("th").format("DD/MM/BB") +
                      " - " +
                      dayjs(it.end_date).locale("th").format("DD/MM/BB")
                    }}
                  </span>
                  <br />
                  <span style="font-size: 0.9em">
                    ({{ it.remain_date }} วัน)
                  </span>
                </b-card-text>
              </b-card>
            </b-col>
          </b-row>

          <b-row>
            <b-col cols="12" class="text-center">
              <b-pagination
                v-model="currentPage"
                :total-rows="totalItems"
                :per-page="perPage.code"
                align="center"
                aria-controls="my-mou"
                @change="onChangePage"
              />
            </b-col>
          </b-row>
        </div>
      </b-overlay>
    </b-card>
  </div>
</template>
