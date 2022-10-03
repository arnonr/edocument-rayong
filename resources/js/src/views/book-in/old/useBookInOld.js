import { ref, reactive, watch, computed } from "@vue/composition-api";
import store from "@/store";
import { getUserData } from "@/auth/utils";

import dayjs from "dayjs";
import locale from "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
import customParseFormat from "dayjs/plugin/customParseFormat";
import isBetween from "dayjs/plugin/isBetween";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";
import Swal from "sweetalert2";
import XLSX from "xlsx";

export default function useBookInOld() {
  // Use toast
  const toast = useToast();

  const items = ref([]);
  const bookInLists = ref([]);
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

  const yearID = ref({
      title: "",
      code: ""
  });

  const showBtnAdmin = getUserData().type == "admin" ? true : false;

  const advancedSearch = reactive({
    categoryName: { title: "-- ทุกประเภท --", code: "" },
    bookFromNo: "",
    bookFromDate: "",
    title: "",
    bookFrom: "",
    bookNo: "",
    dateReceive: "",
    departmentName: { title: "-- ทุกฝ่าย --", code: "" },
    favorite: { title: "-- NO --", code: 0 },
    toSend: "",
  });

  const fields = reactive([
    "show_details",
    {
      key: "id",
      label: "Id",
      visible: false,
    },
    // {
    //   key: "favorite",
    //   label: "Fav",
    //   sortable: true,
    //   visible: true,
    //   class: "text-center",
    //   tdClass: "mw-3-5",
    // },
    {
      key: "dateReceive",
      label: "วันที่รับ",
      sortable: true,
      visible: true,
      class: "text-center",
      tdClass: "mw-4",
    },
    {
      key: "bookNo",
      label: "เลขรับ",
      sortable: true,
      visible: true,
      class: "text-center",
      tdClass: "mw-3-7",
    },
    {
      key: "title",
      label: "เรื่อง",
      sortable: true,
      visible: true,
      tdClass: "mw-10",
    },
    {
      key: "categoryName",
      label: "ประเภท",
      sortable: true,
      visible: true,
      class: "text-center",
    },
    {
      key: "bookFrom",
      label: "จาก",
      sortable: true,
      visible: true,
    },
    {
      key: "toSend",
      label: "ถึง",
      sortable: true,
      visible: true,
    },
    {
      key: "file",
      label: "ไฟล์",
      sortable: false,
      visible: true,
      class: "text-center",
      tdClass: "mw-e-8",
    },
    {
      key: "action",
      label: "Action",
      visible: true,
      class: "text-center",
      tdClass: "mw-8",
    },

    { key: "bookFromNo", label: "เลขที่", sortable: true, visible: false },
    { key: "bookFromDate", label: "ลงวันที่", sortable: true, visible: false },
    {
      key: "departmentTo",
      label: "ฝ่ายที่เกี่ยวข้อง",
      sortable: true,
      visible: false,
    },
    { key: "detail", label: "หมายเหตุ", sortable: false, visible: false },
    // { key: "bookTo", label: "ผู้เกี่ยวข้อง", sortable: false, visible: false },
    { key: "status", label: "สถานะ", sortable: false, visible: false },
  ]);

  const sortOptions = computed(() =>
    fields
      .filter((f) => f.sortable)
      .map((f) => ({ text: f.label, value: f.key }))
  );
  const visibleFields = computed(() => fields.filter((f) => f.visible));

  const selectOptions = reactive({
    category: [],
    department: [],
    favorite: [
      { title: "-- NO --", code: 0 },
      { title: "-- YES --", code: 1 },
    ],
    year: [],
  });

  const onFiltered = (filteredItems) => {
    totalRows.value = filteredItems.length;
    currentPage.value = 1;
  };

  const fetchBookIns = (ctx, callback) => {
    store
      .dispatch("book-in-old/fetchBookInsWithYear", {
        yearID: yearID.value.code,
      })
      .then((response) => {
        const { bookIn } = response.data;
        dayjs.extend(buddhistEra);

        bookInLists.value = bookIn.map((item) => {
          let book = item;

          book.dateReceiveReal = item.dateReceive
            ? dayjs(item.dateReceive).format("YYYY-MM-DD")
            : "";

          book.dateReceive = item.dateReceive
            ? dayjs(item.dateReceive).locale("th").format("DD MMM BB")
            : "";

          book.bookFromDateReal = item.bookFromDate
            ? dayjs(item.bookFromDate).format("YYYY-MM-DD")
            : "";

          book.bookFromDate = item.bookFromDate
            ? dayjs(item.bookFromDate).locale("th").format("DD MMM BB")
            : "";

          if (item.bookTo != null) {
            let email = JSON.parse(item.bookTo);

            book.bookTo = "";
            for (const el of email) {
              book.bookTo = el.title + ", " + book.bookTo;
            }
          }

          book.file = window.location.origin + "/storage" + item.file;

          book.favorite = false;
          if (item.bookFavoriteID != null) {
            book.favorite = true;
          }

          book.toSend = item.toSend;
          return book;
        });

        items.value = bookInLists.value;
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Book In",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });

    totalRows.value = items.value.length;
  };

  //
  const fetchYears = (ctx, callback) => {
    store
      .dispatch("book-in-old/fetchYears")
      .then((response) => {
        const { bookYear } = response.data;

        selectOptions.year = bookYear.filter((x) => {
            // return x;
          return x.status != 1;
        });

        selectOptions.year = selectOptions.year.map((x) => {
          return { title: x.title, code: x.id };
        });

        yearID.value.title = selectOptions.year[0].title;
        yearID.value.code = selectOptions.year[0].code;

        fetchBookIns();
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Year",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });
  };

  fetchYears();

  const fetchCategories = (ctx, callback) => {
    store
      .dispatch("book-in-old/fetchCategories")
      .then((response) => {
        const { category } = response.data;
        selectOptions.category = category.map((x) => {
          return { title: x.title, code: x.id };
        });
        selectOptions.category.unshift({ title: "-- ทุกประเภท --", code: "" });
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Category",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });
  };

  fetchCategories();

  const fetchDepartments = (ctx, callback) => {
    store
      .dispatch("book-in-old/fetchDepartments")
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
      .dispatch("book-in-old/deleteBookIn", { id: id })
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

  const onFavoriteChange = (id, favoriteOld) => {
    if (favoriteOld == true) {
      store
        .dispatch("book-in-old/deleteBookFavorite", {
          bookID: id,
          userID: getUserData().userID,
          bookType: 1,
        })
        .then((response) => {
          if (response.data.message == "success") {
            let found = items.value.findIndex((x) => x.id == id);
            items.value[found].favorite = !favoriteOld;

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
    } else {
      store
        .dispatch("book-in-list/addBookFavorite", {
          bookID: id,
          userID: getUserData().userID,
          bookType: 1,
        })
        .then((response) => {
          if (response.data.message == "success") {
            let found = items.value.findIndex((x) => x.id == id);
            items.value[found].favorite = !favoriteOld;

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
    }
  };

  watch(
    () => [
      advancedSearch.categoryName.code,
      advancedSearch.bookFromNo,
      advancedSearch.bookFromDate,
      advancedSearch.title,
      advancedSearch.bookFrom,
      advancedSearch.bookNo,
      advancedSearch.dateReceive,
      advancedSearch.departmentName.code,
      advancedSearch.favorite.code,
      advancedSearch.toSend,
    ],
    (newData) => {
      items.value = bookInLists.value.filter((x) => {
        let categoryNameCheck = true;
        if (
          advancedSearch.categoryName.code != "" &&
          advancedSearch.categoryName.code != null
        ) {
          if (x.categoryName == null) {
            categoryNameCheck = false;
          } else {
            categoryNameCheck = x.categoryName.includes(
              advancedSearch.categoryName.title
            );
          }
        } else {
          categoryNameCheck = true;
        }

        const bookFromNoCheck =
          advancedSearch.bookFromNo != ""
            ? x.bookFromNo.includes(advancedSearch.bookFromNo)
            : true;

        let bookFromDateCheck = true;
        if (advancedSearch.bookFromDate != "") {
          bookFromDateCheck = dayjs(x.bookFromDateReal).isSame(
            dayjs(advancedSearch.bookFromDate)
          );
        }

        const titleCheck =
          advancedSearch.title != ""
            ? x.title.includes(advancedSearch.title)
            : true;

        const bookFromCheck =
          advancedSearch.bookFrom != ""
            ? x.bookFrom.includes(advancedSearch.bookFrom)
            : true;

        const bookNoCheck =
          advancedSearch.bookNo != ""
            ? x.bookNo.includes(advancedSearch.bookNo)
            : true;

        let dateReceiveCheck = true;
        if (advancedSearch.dateReceive != "") {
          dateReceiveCheck = dayjs(x.dateReceiveReal).isSame(
            dayjs(advancedSearch.dateReceive)
          );
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

        // const departmentNameCheck =
        //   ((advancedSearch.departmentName.code != "") && (advancedSearch.departmentName.code != null))
        //     ? (x.departmentName.includes(advancedSearch.departmentName.title))
        //     : true;

        let favoriteCheck = true;
        if (advancedSearch.favorite.code === 1) {
          favoriteCheck = x.favorite == true;
        }

        const toSendCheck =
          advancedSearch.toSend != ""
            ? x.toSend.includes(advancedSearch.toSend)
            : true;

        return (
          categoryNameCheck &&
          bookFromNoCheck &&
          bookFromDateCheck &&
          titleCheck &&
          bookFromCheck &&
          bookNoCheck &&
          dateReceiveCheck &&
          departmentNameCheck &&
          favoriteCheck &&
          toSendCheck
        );
      });

      totalRows.value = items.value.length;
      currentPage.value = 1;
    }
  );

  //
  watch(
      () => [
        yearID.value.code,
      ],
      (newData) => {
        fetchBookIns()
      }
  )

  // *===============================================---*
  // *--------- UI ---------------------------------------*
  // *===============================================---*

  const resolveFavoriteVariant = (fav) => {
    if (fav === true) return "info";
    if (fav === false) return "outline-info";
    return "outline-info";
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

  if (localStorage.getItem("edited") == 1) {
    toast({
      component: ToastificationContent,
      props: {
        title: "Edited Book In",
        icon: "CheckIcon",
        variant: "success",
      },
    });

    localStorage.removeItem("edited");
  }

  return {
    resolveFavoriteVariant,
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
    showBtnAdmin,
    advancedSearch,
    selectOptions,
    onFavoriteChange,
    yearID,
  };
}
