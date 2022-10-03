import { ref, reactive, watch, computed } from "@vue/composition-api";
import store from "@/store";
import { getUserData } from "@/auth/utils";

import dayjs from "dayjs";
import locale from "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
// import isSame from "dayjs/plugin/isSame";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";
import Swal from "sweetalert2";

export default function useUserList() {
  // Use toast
  const toast = useToast();

  const items = ref([]);
  const userLists = ref([]);
  const perPage = ref(20);
  const pageOptions = ref([20, 50]);
  const totalRows = ref(1);
  const currentPage = ref(1);
  const sortBy = ref("");
  const sortDesc = ref(false);
  const sortDirection = ref("asc");
  const filter = ref(null);
  const filterOn = reactive([]);
  const table = ref(null);

  const advancedSearch = reactive({
    firstname: "",
    lastname: "",
    email: "",
    departmentName: { title: "-- ทุกฝ่าย --", code: "" },
    typeName: { title: "-- ทุกประเภท --", code: "" },
    statusName: { title: "-- ทุกสถานะ --", code: "" },
  });

  const fields = reactive([
    {
      key: "id",
      label: "Id",
      visible: false,
    },
    {
      key: "firstname",
      label: "ชื่อ",
      sortable: true,
      visible: true,
      class: "text-center",
      tdClass: "mw-3-5",
    },
    {
        key: "lastname",
        label: "นามสกุล",
        sortable: true,
        visible: true,
        class: "text-center",
        tdClass: "mw-3-5",
    },
    {
      key: "email",
      label: "เมล",
      sortable: true,
      visible: true,
      class: "text-center",
      tdClass: "mw-3-7",
    },
    {
      key: "departmentName",
      label: "ฝ่าย",
      sortable: true,
      visible: true,
      class: "text-center",
    },
    {
        key: "typeName",
        label: "ประเภท",
        sortable: true,
        visible: true,
        class: "text-center",
    },
    {
        key: "statusName",
        label: "สถานะ",
        sortable: true,
        visible: true,
        class: "text-center",
    },
    {
      key: "action",
      label: "Action",
      visible: true,
      class: "text-center",
      tdClass: "mw-8",
    },
  ]);

  const sortOptions = computed(() =>
    fields
      .filter((f) => f.sortable)
      .map((f) => ({ text: f.label, value: f.key }))
  );
  const visibleFields = computed(() => fields.filter((f) => f.visible));

  const selectOptions = reactive({
    department: [
        { title: "-- ทุกฝ่าย --", code: "" },
    ],
    status: [
        { title: "-- ทุกสถานะ --", code: "" },
        { title: "รอการอนุมัติ", code: "รอการอนุมัติ" },
        { title: "อนุมัติเรียบร้อย", code: "อนุมัติเรียบร้อย" },
    ],
    type: [
        { title: "-- ทุกประเภท --", code: "" },
        { title: "admin", code: "admin" },
        { title: "staff", code: "staff" },
    ]
  });

  const onFiltered = (filteredItems) => {
    totalRows.value = filteredItems.length;
    currentPage.value = 1;
  };

  const fetchUsers = (ctx, callback) => {
    store
      .dispatch("user-list/fetchUsers")
      .then((response) => {
        const { user } = response.data;

        userLists.value = user.map((item) => {
          let u = item;

            u.id = item.userID;

            if(item.status == 1){
                u.statusName = "รอการอนุมัติ"
            }else if(item.status == 2){
                u.statusName = "อนุมัติเรียบร้อย"
            }else{
                u.statusName = "-"
            }

            u.typeName = item.type

          return u;
        });

        items.value = userLists.value;
        totalRows.value = userLists.value.length;
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching User",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

  };

  fetchUsers();

  const fetchDepartments = (ctx, callback) => {
    store
      .dispatch("user-list/fetchDepartments")
      .then((response) => {
        const { department } = response.data;
        selectOptions.department = department.map((x) => {
          return { title: x.name, code: x.id };
        });
        selectOptions.department.unshift({ title: "-- ทุกฝ่าย --", code: "" });
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Department",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });
  };

  fetchDepartments();

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
      .dispatch("user-list/deleteUser", { id: id })
      .then((response) => {
        if (response.data.message == "success") {
          items.value = items.value.filter((el) => el.id !== id);
          console.log("success");
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

  watch(
    () => [
        advancedSearch.firstname,
        advancedSearch.lastname,
        advancedSearch.email,
        advancedSearch.departmentName.code,
        advancedSearch.typeName.code,
        advancedSearch.statusName.code,
    ],
    (newData) => {
      items.value = userLists.value.filter((x) => {

        const firstnameCheck =
          advancedSearch.firstname != ""
            ? x.firstname.includes(advancedSearch.firstname)
            : true;

        const lastnameCheck =
            advancedSearch.lastname != ""
              ? x.lastname.includes(advancedSearch.lastname)
              : true;

        let emailCheck = true;
        if(advancedSearch.email != ""){
            if(x.email != null){
                // emailCheck = false
                emailCheck = x.email.includes(advancedSearch.email)
            }else{
                emailCheck = false
            }  
        }else{
            emailCheck = true
        }

        let departmentNameCheck = true;
        if (
          advancedSearch.departmentName.code != "" &&
          advancedSearch.departmentName.code != null
        ) {
          if (x.departmentName == null) {
            departmentNameCheck = false;
          } else {
            departmentNameCheck = x.departmentName.includes(
              advancedSearch.departmentName.title
            );
          }
        } else {
          departmentNameCheck = true;
        }

        let typeNameCheck = true;
        if (
          advancedSearch.typeName.code != "" &&
          advancedSearch.typeName.code != null
        ) {
          if (x.typeName == null) {
            typeNameCheck = false;
          } else {
            typeNameCheck = x.typeName.includes(
              advancedSearch.typeName.title
            );
          }
        } else {
            typeNameCheck = true;
        }

        console.log('fddf')
        let statusNameCheck = true;
        if (
          advancedSearch.statusName.code != "" &&
          advancedSearch.statusName.code != null
        ) {
          if (x.statusName == null) {
            statusNameCheck = false;
          } else {
            statusNameCheck = x.statusName.includes(
              advancedSearch.statusName.title
            );
          }
        } else {
            statusNameCheck = true;
        }

        return (
            firstnameCheck &&
            lastnameCheck &&
            emailCheck &&
            departmentNameCheck &&
            typeNameCheck &&
            statusNameCheck
        );
      });

      totalRows.value = items.value.length;
      currentPage.value = 1;
    }
  );

  // *===============================================---*
  // *--------- UI ---------------------------------------*
  // *===============================================---*

  const resolveStatusVariant = (status) => {
    if (status === "อนุมัติเรียบร้อย") return "success";
    if (status === "รอการอนุมัติ") return "info";
    return "warning";
  };

  if (localStorage.getItem("edited") == 1) {
    toast({
      component: ToastificationContent,
      props: {
        title: "Edited User",
        icon: "CheckIcon",
        variant: "success",
      },
    });

    localStorage.removeItem("edited");
  }

  return {
    resolveStatusVariant,
    items,
    perPage,
    pageOptions,
    totalRows,
    currentPage,
    sortBy,
    sortDesc,
    sortDirection,
    filter,
    filterOn,
    visibleFields,
    sortOptions,
    onFiltered,
    table,
    onConfirmDelete,
    advancedSearch,
    selectOptions,
  };
}
