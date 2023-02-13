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

import { onUnmounted, ref, reactive } from "@vue/composition-api";
import store from "@/store";
import mouStoreModule from "../mouStoreModule";
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
    const MOU_VIEW_APP_STORE_MODULE_NAME = "mou-view";
    const showBtnAdmin = ref(true);

    // Register module
    if (!store.hasModule(MOU_VIEW_APP_STORE_MODULE_NAME))
      store.registerModule(MOU_VIEW_APP_STORE_MODULE_NAME, mouStoreModule);

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(MOU_VIEW_APP_STORE_MODULE_NAME))
        store.unregisterModule(MOU_VIEW_APP_STORE_MODULE_NAME);
    });

    const toast = useToast();
    const isAdmin = getUserData().type == "admin" ? true : false;
    const isStaff = getUserData().type == "staff" ? true : false;
    const overLay = ref(false);
    const isActivityModal = ref(false);
    const isActivitySubmit = ref(false);
    const simpleRules = ref();

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

    const activityFields = [
      {
        key: "name",
        label: "ชื่อกิจกรรม",
        sortable: true,
      },
      {
        key: "start_date",
        label: "วันที่เริ่มกิจกรรม",
        sortable: true,
      },
      {
        key: "end_date",
        label: "วันที่สิ้นสุด",
        sortable: true,
      },
      {
        key: "detail",
        label: "รายละเอียด",
        sortable: true,
      },
      {
        key: "activity_file",
        label: "ไฟล์",
        sortable: true,
      },
    ];

    if (isAdmin || isStaff) {
      activityFields.push({
        key: "action",
        label: "ดำเนินการ",
      });
    }
    const activityItems = ref([]);

    const activityItem = ref({
      name: "",
      detail: "",
      start_date: "",
      end_date: "",
      activity_file_old: null,
      activity_file: null,
    });

    if (localStorage.getItem("added") == 1) {
      toast({
        component: ToastificationContent,
        props: {
          title: "Added MOU",
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
          title: "Updated MOU",
          icon: "CheckIcon",
          variant: "success",
        },
      });

      localStorage.removeItem("updated");
    }

    const item = ref({
      id: null,
      name: "",
      partner: "",
      partner_logo_file: null,
      partner_logo_file_old: null,
      mou_file_file: null,
      mou_file_old: null,
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
    });

    store
      .dispatch("mou-view/fetchMou", { id: router.currentRoute.params.id })
      .then((response) => {
        const { data } = response.data;
        //
        item.value = data;
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error Get MOU Information",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    const fetchActivities = () => {
      store
        .dispatch("mou-view/fetchActivities", {
          mou_id: router.currentRoute.params.id,
        })
        .then((response) => {
          const { data } = response.data;
          activityItems.value = data;
        })
        .catch((error) => {
          console.log(error);
          toast({
            component: ToastificationContent,
            props: {
              title: "Error Get Activity Information",
              icon: "AlertTriangleIcon",
              variant: "danger",
            },
          });
        });
    };

    fetchActivities();

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
        .dispatch("mou-view/deleteMou", { id: id })
        .then((response) => {
          if (response.data.message == "success") {
            router.push({ name: "lists" });
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

    // Activity

    const onConfirmActivityDelete = (id) => {
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
          onActivityDelete(id);
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

    const onActivityDelete = (id) => {
      store
        .dispatch("mou-view/deleteActivity", { id: id })
        .then((response) => {
          if (response.data.message == "success") {
            toast({
              component: ToastificationContent,
              props: {
                title: "Success : Deleted Activity",
                icon: "CheckIcon",
                variant: "success",
              },
            });
            fetchActivities();
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

    const handleEditActivityClick = (data) => {
      activityItem.value = data;
      activityItem.value.activity_file_old = data.activity_file;
      activityItem.value.activity_file = null;
      isActivityModal.value = true;
    };

    const handleAddActivityClick = () => {
      activityItem.value = {
        name: "",
        start_date: "",
        end_date: "",
        detail: "",
        activity_file: null,
        activity_file_old: null,
      };
      isActivityModal.value = true;
    };

    const handleDeleteActivityClick = (id) => {
      // activityItem.value = data;
      onConfirmActivityDelete(id);
    };

    const validationForm = (bvModalEvent) => {
      bvModalEvent.preventDefault();
      simpleRules.value.validate().then((success) => {
        if (success) {
          onActivitySubmit();
        }
      });
    };

    const onActivitySubmit = () => {
      // Prevent modal from closing

      overLay.value = true;
      isActivitySubmit.value = true;

      let dataSend = {
        name: activityItem.value.name,
        detail: activityItem.value.detail,
        start_date: activityItem.value.start_date,
        end_date: activityItem.value.end_date,
        activity_file: activityItem.value.activity_file,
        mou_id: router.currentRoute.params.id,
      };

      if (activityItem.value.id == null) {
        store
          .dispatch("mou-view/addActivity", dataSend)
          .then(async (response) => {
            if (response.data.message == "success") {
              fetchActivities();

              isActivitySubmit.value = false;
              isActivityModal.value = false;
              overLay.value = false;

              toast({
                component: ToastificationContent,
                props: {
                  title: "Success : Added Activity",
                  icon: "CheckIcon",
                  variant: "success",
                },
              });
            } else {
              isActivitySubmit.value = false;
              overLay.value = false;
              errorToast(response.data.message);
            }
          })
          .catch((error) => {
            isActivitySubmit.value = false;
            overLay.value = false;

            errorToast("Add Activity Error");
          });
      } else {
        // Update
        dataSend["id"] = activityItem.value.id;

        store
          .dispatch("mou-view/editActivity", dataSend)
          .then(async (response) => {
            if (response.data.message == "success") {
              fetchActivities();

              isActivitySubmit.value = false;
              isActivityModal.value = false;
              overLay.value = false;

              toast({
                component: ToastificationContent,
                props: {
                  title: "Success : Updated Activity",
                  icon: "CheckIcon",
                  variant: "success",
                },
              });
            } else {
              isActivitySubmit.value = false;
              isActivityModal.value = false;
              overLay.value = false;
              errorToast(response.data.message);
            }
          })
          .catch(() => {
            isActivitySubmit.value = false;
            overLay.value = false;
            errorToast("Update Activity Error");
          });
      }
    };

    return {
      item,
      overLay,
      dayjs,
      onConfirmDelete,
      activityItems,
      activityItem,
      activityFields,
      showBtnAdmin,
      handleEditActivityClick,
      handleAddActivityClick,
      handleDeleteActivityClick,
      isActivityModal,
      isActivitySubmit,
      onActivitySubmit,
      validationForm,
      simpleRules,
      isAdmin,
      isStaff,
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
          <h3>MOU Information</h3>
          <hr width="80px;" style="border: solid 2px; border-color: #ffcb05" />
        </b-col>
      </b-row>
      <b-row>
        <b-col class="text-center mt-2 mb-3">
          <img :src="item.partner_logo_file" alt="" style="max-width: 100%" />
        </b-col>
      </b-row>
      <b-row>
        <b-col class="pt-1 pb-1 mb-2" style="background-color: #eee">
          <h4>ข้อมูลคู่สัญญา/Partner Information</h4>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <span class="label">องค์กรคู่สัญญา/Partner Organization : </span>
          <span class="text-data font-italic">{{ item.name }}</span>
          <hr />
          <span class="label">ประเภทความร่วมมือ/MOU Type : </span>
          <span class="text-data font-italic">{{ item.type_name }}</span>
          <hr />
          <span class="label">ประเทศคู่สัญญา/Partner Country : </span>
          <span class="text-data font-italic">{{ item.country_name }}</span>
          <hr />
          <span class="label">ที่อยู่คู่สัญญา/Address : </span>
          <span class="text-data font-italic">{{ item.address }}</span>
          <hr />
          <span class="label">ชื่อผู้ประสานงาน/Partner Contact Name : </span>
          <span class="text-data font-italic">
            {{ item.partner_contact_name }}</span
          >
          <hr />
          <span class="label">เบอร์ติดต่อ/Partner Contact Phone : </span>
          <span class="text-data font-italic">{{
            item.partner_contact_phone
          }}</span>
          <hr />
          <span class="label">เมล/Partner Contact Email : </span>
          <span class="text-data font-italic">{{
            item.partner_contact_email
          }}</span>
        </b-col>
      </b-row>
      <!--  -->
      <b-row>
        <b-col class="pt-1 pb-1 mb-2 mt-4" style="background-color: #eee">
          <h4>ข้อมูลหน่วยงานผู้รับผิดชอบ/Host Information</h4>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <span class="label">หน่วยงาน/Host Organization : </span>
          <span class="text-data font-italic">{{ item.host_name }}</span>
          <hr />
          <span class="label">ชื่อผู้ประสานงาน/Host Contact Name : </span>
          <span class="text-data font-italic">{{
            item.host_contact_name
          }}</span>
          <hr />
          <span class="label">เบอร์ผู้ประสานงาน/Host Contact Phone : </span>
          <span class="text-data font-italic">{{
            item.host_contact_phone
          }}</span>
          <hr />
          <span class="label">เมลผู้ประสานงาน/Host Contact Email : </span>
          <span class="text-data font-italic">{{
            item.host_contact_email
          }}</span>
        </b-col>
      </b-row>

      <!--  -->
      <b-row>
        <b-col class="pt-1 pb-1 mb-2 mt-4" style="background-color: #eee">
          <h4>ข้อมูล MOU/MOU Information</h4>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <span class="label">ชื่อความร่วมมือ/MOU Name : </span>
          <span class="text-data font-italic">{{ item.name }}</span>
          <hr />
          <span class="label">ไฟล์ MOU/File : </span>
          <span class="text-data">
            <b-button
              :disabled="
                (isAdmin || isStaff) && item.mou_file != null
                  ? false
                  : true
              "
              :variant="
                (isAdmin || isStaff) && item.mou_file != null
                  ? 'outline-success'
                  : 'outline-secondary'
              "
              alt="เปิดไฟล์แนบ"
              title="เปิดไฟล์แนบ"
              class="btn-icon btn-sm"
              style="margin-bottom: 2px"
              :href="item.mou_file"
              target="_blank"
            >
              <feather-icon icon="FileIcon" style="margin-bottom: -2px" /> PDF
            </b-button>
            |

            <b-button
              :disabled="
                (isAdmin || isStaff) && item.mou_word_file != null
                  ? false
                  : true
              "
              :variant="
                (isAdmin || isStaff) && item.mou_word_file != null
                  ? 'outline-warning'
                  : 'outline-secondary'
              "
              alt="เปิดไฟล์แนบ"
              title="เปิดไฟล์แนบ"
              class="btn-icon btn-sm"
              style="margin-bottom: 2px"
              :href="item.mou_word_file"
              target="_blank"
            >
              <feather-icon icon="FileIcon" style="margin-bottom: -2px" /> WORD
            </b-button>
          </span>
          <hr />
          <span class="label">วันเริ่มสัญญา/Start Date : </span>
          <span class="text-data">{{
            dayjs(item.start_date).locale("th").format("DD/MM/BBBB")
          }}</span>
          <hr />
          <span class="label">วันสิ้นสุดสัญญา/End Date : </span>
          <span class="text-data">{{
            dayjs(item.end_date).locale("th").format("DD/MM/BBBB")
          }}</span>
          <hr />
          <span class="label">หมายเหตุ : </span>
          <span class="text-data font-italic">{{ item.remark }}</span>
        </b-col>
      </b-row>

      <b-row>
        <b-col class="pt-1 pb-1 mb-2 mt-4" style="background-color: #eee">
          <h4>ข้อมูลกิจกรรมภายใต้ MOU</h4>
        </b-col>
      </b-row>

      <b-row>
        <b-col class="col-md-12" v-if="isAdmin || isStaff">
          <b-button
            type="button"
            variant="outline-warning"
            class="float-right mb-1"
            @click="handleAddActivityClick()"
          >
            Add Activity
          </b-button>
        </b-col>
        <b-col class="col-12">
          <b-table
            striped
            hover
            :items="activityItems"
            :fields="activityFields"
            responsive
          >
            <template #cell(start_date)="data">
              {{ dayjs(data.start_date).locale("th").format("DD/MM/BBBB") }}
            </template>

            <template #cell(end_date)="data">
              {{ dayjs(data.end_date).locale("th").format("DD/MM/BBBB") }}
            </template>

            <template #cell(activity_file)="row">
              <b-button
                alt="เปิดเอกสาร"
                title="เปิดเอกสาร"
                class="btn-icon btn-sm"
                target="_blank"
                :href="row.item.activity_file"
                :disabled="(isAdmin || isStaff) &&  row.item.activity_file != null ? false : true"
                :variant="(isAdmin || isStaff) &&  row.item.activity_file != null ? 'outline-primary' : 'outline-secondary'"
              >
                <feather-icon icon="FileIcon" style="margin-bottom: -2px" />
                <span class="d-none d-xl-inline">เปิดไฟล์แนบ</span>
              </b-button>
            </template>

            <template #cell(action)="row" v-if="isAdmin || isStaff">
              <b-button
                v-if="isAdmin || isStaff"
                variant="outline-success"
                alt="แก้ไข"
                title="แก้ไข"
                class="btn-icon btn-sm"
                @click="handleEditActivityClick({ ...row.item })"
              >
                <feather-icon icon="EditIcon" style="margin-bottom: -2px" />
              </b-button>
              <b-button
                v-if="isAdmin"
                @click="handleDeleteActivityClick(row.item.id)"
                variant="outline-danger"
                alt="ลบ"
                title="ลบ"
                class="btn-icon btn-sm"
              >
                <feather-icon icon="TrashIcon" style="margin-bottom: -2px" />
              </b-button>
            </template>
          </b-table>
        </b-col>
      </b-row>

      <b-row>
        <b-col class="mt-4" v-if="isAdmin || isStaff">
          <b-button
            type="button"
            variant="outline-primary"
            @click="
              $router.push({
                name: 'mou-edit',
                params: { id: item.id },
              })
            "
            v-if="isAdmin || isStaff"
          >
            Edit MOU</b-button
          >
          <b-button
            type="button"
            variant="outline-danger"
            @click="onConfirmDelete(item.id)"
            v-if="isAdmin"
          >
            Delete MOU</b-button
          >
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

      <b-modal
        ref="modalActivityForm"
        id="modal-activity-form"
        cancel-variant="outline-secondary"
        ok-title="Submit"
        cancel-title="Close"
        centered
        size="lg"
        title="Activity Form"
        :visible="isActivityModal"
        @ok="validationForm"
        :ok-disabled="isActivitySubmit"
        :cancel-disabled="isActivitySubmit"
        @change="
          (val) => {
            isActivityModal = val;
          }
        "
      >
        <b-overlay
          :show="isActivitySubmit"
          opacity="0.17"
          spinner-variant="primary"
        >
          <validation-observer ref="simpleRules">
            <b-form>
              <div class="row">
                <b-form-group
                  label="ชื่อกิจกรรม*"
                  label-for="activityName"
                  class="col-md"
                >
                  <validation-provider
                    #default="{ errors }"
                    name="name"
                    rules="required"
                  >
                    <b-form-input
                      id="activityName"
                      placeholder=""
                      v-model="activityItem.name"
                      :state="errors.length > 0 ? false : null"
                    />
                    <small class="text-danger">{{ errors[0] }}</small>
                  </validation-provider>
                </b-form-group>
              </div>

              <div class="row">
                <b-form-group
                  label="วันที่เริ่มกิจกรรม"
                  label-for="activityStartDate"
                  class="col-md"
                >
                  <validation-provider #default="{ errors }" name="Start Date">
                    <flat-pickr
                      v-model="activityItem.start_date"
                      placeholder="Start Date"
                      :config="configDate"
                    />
                    <small class="text-danger">{{ errors[0] }}</small>
                  </validation-provider>
                </b-form-group>
              </div>

              <div class="row">
                <b-form-group
                  label="วันที่สิ้นสุดกิจกรรม"
                  label-for="activityEndDate"
                  class="col-md"
                >
                  <validation-provider #default="{ errors }" name="End Date">
                    <flat-pickr
                      v-model="activityItem.end_date"
                      placeholder="End Date"
                      :config="configDate"
                    />
                    <small class="text-danger">{{ errors[0] }}</small>
                  </validation-provider>
                </b-form-group>
              </div>

              <div class="row">
                <b-form-group class="col-md">
                  <validation-provider
                    #default="{ errors }"
                    name="activityDetail"
                  >
                    <label for="activityDetail">รายละเอียด:</label>
                    <b-form-textarea
                      id="activityDetail"
                      placeholder="รายละเอียด"
                      v-model="activityItem.detail"
                      :state="errors.length > 0 ? false : null"
                    />
                    <small class="text-danger">{{ errors[0] }}</small>
                  </validation-provider>
                </b-form-group>
              </div>

              <div class="row">
                <b-form-group class="col-md">
                  <validation-provider #default="{ errors }" name="file">
                    <label for="file">File:</label>
                    <b-input-group>
                      <b-input-group-prepend>
                        <b-button
                          :variant="`outline-${
                            activityItem.activity_file_old == null
                              ? 'dark'
                              : 'warning'
                          }`"
                          target="_blank"
                          :disabled="activityItem.activity_file_old == null"
                          :href="activityItem.activity_file_old"
                        >
                          <feather-icon icon="FileTextIcon" />
                          View File
                        </b-button>
                      </b-input-group-prepend>
                      <b-form-file
                        id="activity-file"
                        v-model="activityItem.activity_file"
                        placeholder="Choose a new file or drop it here..."
                        drop-placeholder="Drop file here..."
                      />
                    </b-input-group>
                    <small class="text-danger">{{ errors[0] }}</small>
                  </validation-provider>
                </b-form-group>
              </div>
            </b-form>
          </validation-observer>
        </b-overlay>
      </b-modal>
    </b-overlay>
  </b-card>
</template>
