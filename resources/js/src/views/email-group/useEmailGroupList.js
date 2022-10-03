import { ref, reactive, watch, computed } from "@vue/composition-api";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// import isSame from "dayjs/plugin/isSame";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";
import Swal from "sweetalert2";

export default function useEmailGroupList() {
  // Use toast
  const toast = useToast();

  const items = ref([]);
  const emailGroupLists = ref([]);
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


  const fields = reactive([
    "show_details",
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

  const sortOptions = computed(() =>
    fields
      .filter((f) => f.sortable)
      .map((f) => ({ text: f.label, value: f.key }))
  );
  const visibleFields = computed(() => fields.filter((f) => f.visible));

  const onFiltered = (filteredItems) => {
    totalRows.value = filteredItems.length;
    currentPage.value = 1;
  };

  const fetchEmailGroups = (ctx, callback) => {
    store
      .dispatch("email-group-list/fetchEmailGroups")
      .then((response) => {
        const { emailGroup } = response.data;

        emailGroupLists.value = emailGroup.map((item) => {
          let group = item;
          return group;
        });

        items.value = emailGroupLists.value;
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Email Group",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    totalRows.value = items.value.length;
  };

  fetchEmailGroups();

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
      .dispatch("email-group-list/deleteEmailGroup", { id: id })
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

  // *===============================================---*
  // *--------- UI ---------------------------------------*
  // *===============================================---*

 
  if (localStorage.getItem("added") == 1) {
    toast({
      component: ToastificationContent,
      props: {
        title: "Added Email Group",
        icon: "CheckIcon",
        variant: "success",
      },
    });

    localStorage.removeItem("added");
  }

  if (localStorage.getItem("edited") == 1) {
    toast({
      component: ToastificationContent,
      props: {
        title: "Edited Email Group",
        icon: "CheckIcon",
        variant: "success",
      },
    });

    localStorage.removeItem("edited");
  }

  return {
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
  };
}
