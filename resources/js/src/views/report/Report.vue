<template>
  <div>
    <b-row id="row-form">
      <b-col md="12">
        <b-card>
          <b-row>
            <!-- Contact -->

            <b-col md="12">
              <b-form-group label="เลือกปี" label-for="">
                <v-select
                  v-model="yearID"
                  :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                  label="title"
                  :clearable="false"
                  :options="selectOptions.year"
                />
              </b-form-group>
            </b-col>

            <b-col md="12">
              <b-form-group label="วันที่" label-for="">
                <flat-pickr
                  v-model="date"
                  class="form-control"
                  placeholder="วันที่"
                  :config="configDate"
                />
              </b-form-group>
            </b-col>

            <b-col md="12">
              <b-button
                variant="success"
                class="mb-sm-0 mr-0"
                @click="onSubmit()"
                :block="$store.getters['app/currentBreakPoint'] === 'xs'"
              >
                <span class="d-none d-sm-inline">Submit</span>
              </b-button>
            </b-col>
          </b-row>
        </b-card>
      </b-col>
    </b-row>

    <b-row>
      <b-col md="6">
        <b-card no-body class="">
          <b-card-header>
            <div>
              <b-card-title>หนังสือรับ (ทั้งหมด)</b-card-title>
            </div>
          </b-card-header>

          <!-- body -->
          <b-card-body>
            <b-card-text class="font-small-2">
              {{ date }}
            </b-card-text>
            <div>
              <table class="table table-bordered">
                <tr>
                  <td>เลขเริ่มต้น</td>
                  <td class="text-center">{{ bookInData.minBookNo }}</td>
                </tr>
                <tr>
                  <td>เลขสิ้นสุด</td>
                  <td class="text-center">{{ bookInData.maxBookNo }}</td>
                </tr>
                <tr>
                  <td style="width: 80%">รวม</td>
                  <td class="text-center" style="width: 20%">
                    {{ bookInData.total }} เอกสาร
                  </td>
                </tr>
              </table>
            </div>
          </b-card-body>
          <!--/ body -->
        </b-card>
      </b-col>

      <b-col md="6">
        <b-card no-body class="">
          <b-card-header>
            <div>
              <b-card-title>หนังสือรับ (แบ่งตามประเภท)</b-card-title>
            </div>
          </b-card-header>

          <!-- body -->
          <b-card-body>
            <b-card-text class="font-small-2">
              {{ date }}
            </b-card-text>
            <div>
              <div v-for="(bc, index) in bookCategory" :key="index">
                <b-media no-body>
                  <b-media-aside>
                    <b-avatar rounded size="42" variant="light-primary">
                      <feather-icon size="18" icon="CheckIcon" />
                    </b-avatar>
                  </b-media-aside>
                  <b-media-body>
                    <h6 class="transaction-title">
                      {{ bc.title }}
                    </h6>
                    <small>ประเภทที่ {{ index + 1 }}</small>
                    <div class="font-weight-bolder" style="float: right">
                      {{ bc.total }} เอกสาร
                    </div>
                  </b-media-body>
                </b-media>
                <hr />
              </div>
            </div>
          </b-card-body>
          <!--/ body -->
        </b-card>
      </b-col>
    </b-row>

    <b-row>
      <b-col md="12">
        <b-card no-body class="">
          <b-card-header>
            <div>
              <b-card-title>หนังสือส่งออก</b-card-title>
            </div>
          </b-card-header>

          <!-- body -->
          <b-card-body>
            <b-card-text class="font-small-2">
              {{ date }}
            </b-card-text>
            <div>
              <table class="table table-bordered">
                <tr>
                  <th>หมวดหนังสือ</th>
                  <th class="text-center">เลขเริ่มต้น</th>
                  <th class="text-center">เลขสิ้นสุด</th>
                  <th class="text-center">รวม</th>
                </tr>
                <tr v-for="(t, index) in type" :key="index">
                  <td>{{ t.title }}</td>
                  <td class="text-center">{{ t.minBookNo }}</td>
                  <td class="text-center">{{ t.maxBookNo }}</td>
                  <td class="text-center">{{ t.total }} เอกสาร</td>
                </tr>
                <tr>
                  <th colspan="3" class="text-right">รวม</th>
                  <th class="text-center">{{ bookOutData.total }} เอกสาร</th>
                </tr>
              </table>
            </div>
          </b-card-body>
          <!--/ body -->
        </b-card>
      </b-col>
    </b-row>

    <!--  -->
    <b-row>
      <b-col md="12">
        <b-card no-body class="">
          <b-card-header>
            <div>
              <b-card-title>ปริมาณกระดาษ</b-card-title>
            </div>
          </b-card-header>

          <!-- body -->
          <b-card-body>
            <b-card-text class="font-small-2">
              {{ date }}
            </b-card-text>
            <div class="text-center">
              <span>
                เอกสารทั้งหมด
                {{ bookInData.total + bookOutData.total }} ชุด</span
              >
              <br />
              <span>
                ลดการใช้กระดาษทั้งหมด
                {{ bookInData.paper + bookOutData.paper }} แผ่น</span
              >
            </div>
          </b-card-body>
          <!--/ body -->
        </b-card>
      </b-col>
    </b-row>

    <b-row id="row-btn-print">
      <b-col md="12" class="text-center">
        <b-button
          @click="onPrint()"
          variant="success"
          class="mb-sm-0 mr-0"
          :block="$store.getters['app/currentBreakPoint'] === 'xs'"
        >
          Print
        </b-button>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import {
  BTable,
  BAvatar,
  BBadge,
  BRow,
  BCol,
  BFormGroup,
  BFormSelect,
  BPagination,
  BInputGroup,
  BFormInput,
  BInputGroupAppend,
  BButton,
  BCard,
  BForm,
  BFormRating,
  BModal,
  VBModal,
  BCardText,
  BCardHeader,
  BCardTitle,
  BCardBody,
  BMedia,
  BMediaAside,
  BMediaBody,
} from "bootstrap-vue";
import vSelect from "vue-select";
import Ripple from "vue-ripple-directive";
import flatPickr from "vue-flatpickr-component";
import { Thai } from "flatpickr/dist/l10n/th.js";

import store from "@/store";
import useReport from "./useReport";
import reportStoreModule from "./reportStoreModule";
import { onUnmounted } from "@vue/composition-api";

export default {
  components: {
    BTable,
    BAvatar,
    BBadge,
    BRow,
    BCol,
    BFormGroup,
    BFormSelect,
    BPagination,
    BInputGroup,
    BFormInput,
    BInputGroupAppend,
    BButton,
    BCard,
    BForm,
    flatPickr,
    vSelect,
    BFormRating,
    BModal,
    BCardText,
    BCardHeader,
    BCardTitle,
    BCardBody,
    BMedia,
    BMediaAside,
    BMediaBody,
  },
  directives: {
    "b-modal": VBModal,
    Ripple,
  },
  data() {
    return {
      configDate: {
        mode: "range",
        altInput: true,
        altFormat: "j M Y",
        dateFormat: "Y-m-d",
        locale: Thai,
      },
    };
  },
  setup() {
    const REPORT_APP_STORE_MODULE_NAME = "report";

    // Register module
    if (!store.hasModule(REPORT_APP_STORE_MODULE_NAME))
      store.registerModule(REPORT_APP_STORE_MODULE_NAME, reportStoreModule);

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(REPORT_APP_STORE_MODULE_NAME))
        store.unregisterModule(REPORT_APP_STORE_MODULE_NAME);
    });

    const onPrint = () => {
      window.print();
    };

    const {
      yearID,
      date,
      selectOptions,
      onSubmit,
      bookInData,
      bookCategory,
      bookOutData,
      type,
    } = useReport();

    return {
      yearID,
      date,
      selectOptions,
      onSubmit,
      bookInData,
      bookCategory,
      bookOutData,
      type,
      onPrint,
    };
  },
};
</script>

<style lang="scss">
@import "@core/scss/vue/libs/vue-select.scss";
@import "@core/scss/vue/libs/vue-flatpicker.scss";

.table th,
.table td {
  padding: 0.75rem 1rem;
}

.mw-3-5 {
  padding: 0.75rem 0.2rem !important;
  min-width: 3.5rem !important;
}

.mw-3-7 {
  padding: 0.75rem 0.2rem !important;
  min-width: 3.7rem !important;
}

.mw-4 {
  padding: 0.75rem 0.2rem !important;
  min-width: 6rem !important;
}

.mw-8 {
  padding: 0.75rem 0.2rem !important;
  min-width: 8rem !important;
}

.mw-10 {
  padding: 0.75rem 0.2rem !important;
  min-width: 10rem !important;
}

@media only screen and (min-width: 1200px) {
  .mw-e-8 {
    padding: 0.75rem 0.2rem !important;
    min-width: 8rem !important;
  }
}

@media print {
  .main-menu {
    display: none !important;
  }

  #row-form {
    display: none !important;
  }

  #row-btn-print {
    display: none !important;
  }

//   .footer {
//     display: none !important;
//   }

  .btn-scroll-to-top {
    display: none !important;
  }
  //
}
</style>
