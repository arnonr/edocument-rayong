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
  BForm,
  BModal,
} from "bootstrap-vue";
import vSelect from "vue-select";

import {
  ref,
  watch,
  watchEffect,
  reactive,
  onUnmounted,
  computed,
} from "@vue/composition-api";
import store from "@/store";
import emailGroupStoreModule from "./emailGroupStoreModule";
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";
import Swal from "sweetalert2";
import { ValidationProvider, ValidationObserver } from "vee-validate";
import { required } from "@validations";
import { getUserData } from "@/auth/utils";

export default {
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
    BPagination,
    BCardText,
    BTable,
    BForm,
    BModal,
    ValidationProvider,
    ValidationObserver,
    required,
  },
  setup() {
    const EMAIL_GROUP_APP_STORE_MODULE_NAME = "email-group";

    // Register module
    if (!store.hasModule(EMAIL_GROUP_APP_STORE_MODULE_NAME))
      store.registerModule(
        EMAIL_GROUP_APP_STORE_MODULE_NAME,
        emailGroupStoreModule
      );

    onUnmounted(() => {});

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

    const items = ref([]);

    const isAdd = ref(false);
    const isOverLay = ref(false);
    const isModal = ref(false);
    const isSubmit = ref(false);
    const simpleRules = ref();

    const perPage = ref({ title: "50", code: 50 });
    const currentPage = ref(1);
    const totalPage = ref(1);
    const totalItems = ref(0);
    const orderBy = ref({
      title: "ชื่อกลุ่ม",
    });
    const order = ref({ title: "DESC", code: "desc" });

    const fields = reactive([
      {
        key: "id",
        label: "Id",
        visible: false,
      },
      {
        key: "name",
        label: "ชื่อกลุ่ม",
        sortable: true,
        visible: true,
      },
      {
        key: "action",
        label: "Action",
        visible: true,
        class: "text-center",
        tdClass: "mw-8",
      },
    ]);

    const visibleFields = computed(() => fields.filter((f) => f.visible));

    const item = ref({
      name: "",
      email_all: "",
    });

    const selectOptions = ref({
      perPage: [
        { title: "20", code: 20 },
        { title: "50", code: 50 },
      ],
      orderBy: [{ title: "ชื่อกลุ่ม", code: "name" }],
      order: [
        { title: "ASC", code: "asc" },
        { title: "DESC", code: "desc" },
      ],
      email_persons: [],
    });

    const fetchEmailPersonItems = () => {
      store
        .dispatch("email-group/fetchEmailPersons", {
          perPage: 500,
          currentPage: currentPage.value == 0 ? undefined : currentPage.value,
          orderBy: orderBy.value.code,
          order: order.value.code,
        })
        .then((response) => {
          const { data } = response.data;

          selectOptions.value.email_persons = data.map((d) => {
            return {
              title: d.firstname + " " + d.lastname + " (" + d.email + ")",
              code: d.id,
              email: d.email,
            };
          });
        })
        .catch((error) => {
          console.log(error);
          toast({
            component: ToastificationContent,
            props: {
              title: "Error fetching Email Person's list",
              icon: "AlertTriangleIcon",
              variant: "danger",
            },
          });
          isOverLay.value = false;
        });
    };
    fetchEmailPersonItems();

    const fetchItems = () => {
      isOverLay.value = true;
      store
        .dispatch("email-group/fetchEmailGroups", {
          perPage: perPage.value.code,
          currentPage: currentPage.value == 0 ? undefined : currentPage.value,
          orderBy: orderBy.value.code,
          order: order.value.code,
        })
        .then((response) => {
          let { data } = response.data;
          
          items.value = data.map((d) => {
            d.email_all = JSON.parse(d.email_all);
            return d;
          });

          totalPage.value = response.data.totalPage;
          totalItems.value = response.data.totalData;
          isOverLay.value = false;
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
          isOverLay.value = false;
        });
    };
    fetchItems();

    watchEffect(() => {
      fetchItems();
    });

    const onChangePage = (page) => {
      currentPage.value = page;
    };

    //
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
        .dispatch("email-group/deleteEmailGroup", { id: id })
        .then((response) => {
          if (response.data.message == "success") {
            toast({
              component: ToastificationContent,
              props: {
                title: "Success : Deleted EmailGroup",
                icon: "CheckIcon",
                variant: "success",
              },
            });
            fetchItems();
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

    const handleEditClick = (data) => {
      item.value = data;

      isAdd.value = false;
      isModal.value = true;
    };

    const handleAddClick = () => {
      item.value = {
        name: "",
        email_all: "",
      };
      isAdd.value = true;
      isModal.value = true;
    };

    const validationForm = (bvModalEvent) => {
      bvModalEvent.preventDefault();
      simpleRules.value.validate().then((success) => {
        if (success) {
          onSubmit();
        }
      });
    };

    const onSubmit = () => {
      // Prevent modal from closing

      isOverLay.value = true;
      isSubmit.value = true;

      let emailAllSend = null;

      if (item.value.email_all) {
        emailAllSend = item.value.email_all.map((x) => {
          return {
            title: x.title,
            code: x.code,
            email: x.email,
          };
        });
      }

      let dataSend = {
        name: item.value.name,
        email_all: emailAllSend,
      };

      if (item.value.id == null) {
        store
          .dispatch("email-group/addEmailGroup", dataSend)
          .then(async (response) => {
            if (response.data.message == "success") {
              fetchItems();

              isSubmit.value = false;
              isModal.value = false;
              isOverLay.value = false;

              toast({
                component: ToastificationContent,
                props: {
                  title: "Success : Added Email Group",
                  icon: "CheckIcon",
                  variant: "success",
                },
              });
            } else {
              isSubmit.value = false;
              isOverLay.value = false;
              errorToast(response.data.message);
            }
          })
          .catch((error) => {
            isSubmit.value = false;
            isOverLay.value = false;

            errorToast("Add Email Person Error");
          });
      } else {
        // Update
        dataSend["id"] = item.value.id;

        store
          .dispatch("email-group/editEmailGroup", dataSend)
          .then(async (response) => {
            if (response.data.message == "success") {
              fetchItems();

              isSubmit.value = false;
              isModal.value = false;
              isOverLay.value = false;

              toast({
                component: ToastificationContent,
                props: {
                  title: "Success : Updated Email Group",
                  icon: "CheckIcon",
                  variant: "success",
                },
              });
            } else {
              isSubmit.value = false;
              isModal.value = false;
              isOverLay.value = false;
              errorToast(response.data.message);
            }
          })
          .catch(() => {
            isSubmit.value = false;
            isOverLay.value = false;
            errorToast("Update Email PGroup Error");
          });
      }
    };

    return {
      items,
      item,
      isOverLay,
      perPage,
      currentPage,
      totalPage,
      totalItems,
      orderBy,
      order,
      selectOptions,
      onChangePage,
      visibleFields,
      validationForm,
      onConfirmDelete,
      handleEditClick,
      handleAddClick,
      simpleRules,
      isModal,
      isOverLay,
      isSubmit,
      isAdd,
      isAdmin,
    };
  },
};
</script>

<style></style>

<template>
  <div class="container-lg">
    <b-card no-body>
      <b-overlay :show="isOverLay" opacity="0.3" spinner-variant="primary">
        <div class="m-2">
          <b-row>
            <b-col>
              <b-form-group class="float-left col-lg-2">
                <v-select
                  v-model="perPage"
                  :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                  label="title"
                  :options="selectOptions.perPage"
                  :clearable="false"
                />
              </b-form-group>
              <b-form-group class="float-left col-lg-4">
                <v-select
                  v-model="orderBy"
                  :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                  label="title"
                  :options="selectOptions.orderBy"
                  :clearable="false"
                />
              </b-form-group>
              <b-form-group class="float-left col-lg-2">
                <v-select
                  v-model="order"
                  :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                  label="title"
                  :options="selectOptions.order"
                  :clearable="false"
                />
              </b-form-group>

              <b-button
                variant="success"
                @click="handleAddClick()"
                class="float-right"
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
            <!-- Table -->
            <b-col cols="12">
              <b-table
                striped
                bordered
                hover
                responsive
                :items="items"
                :fields="visibleFields"
              >
                <template #cell(action)="row">
                  <b-button
                    variant="outline-success"
                    alt="แก้ไข"
                    title="แก้ไข"
                    class="btn-icon btn-sm"
                    @click="handleEditClick({ ...row.item })"
                  >
                    <feather-icon icon="EditIcon" style="margin-bottom: -2px" />
                  </b-button>
                  <b-button
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
                  </b-button>
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
                aria-controls="my-mou"
                @change="onChangePage"
              />
            </b-col>
          </b-row>
        </div>

        <b-modal
          ref="modalForm"
          id="modal-form"
          cancel-variant="outline-secondary"
          ok-title="Submit"
          cancel-title="Close"
          centered
          size="lg"
          title="Email Form"
          :visible="isModal"
          @ok="validationForm"
          :ok-disabled="isSubmit"
          :cancel-disabled="isSubmit"
          @change="
            (val) => {
              isModal = val;
            }
          "
        >
          <b-overlay :show="isSubmit" opacity="0.17" spinner-variant="primary">
            <validation-observer ref="simpleRules">
              <b-form>
                <div class="row">
                  <b-form-group
                    label="ชื่อกลุ่ม"
                    label-for="name"
                    class="col-md"
                  >
                    <validation-provider #default="{ errors }" name="name">
                      <b-form-input
                        id="name"
                        placeholder=""
                        v-model="item.name"
                        :state="errors.length > 0 ? false : null"
                      />
                      <small class="text-danger">{{ errors[0] }}</small>
                    </validation-provider>
                  </b-form-group>
                </div>
                <!--  -->
                <div class="row">
                  <b-form-group
                    label="อีเมล/Email:"
                    label-for="email_all"
                    class="col-md"
                  >
                    <validation-provider #default="{ errors }" name="email">
                      <v-select
                        v-model="item.email_all"
                        :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                        label="title"
                        multiple
                        taggable
                        placeholder="-- เลือก email --"
                        :options="selectOptions.email_persons"
                      />
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
  </div>
</template>
