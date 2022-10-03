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

export default function useReport() {
  // Use toast
  const toast = useToast();

  const yearID = ref({
    title: "",
    code: "",
  });

  const date = ref("");

  const selectOptions = reactive({
    year: [],
  });

  const bookInData = reactive({
    maxBookNo: "",
    minBookNo: "",
    total: 0,
    paper: 0,
  });
  const bookCategory = ref(null);

  const bookOutData = reactive({
    total: 0,
    paper: 0,
  });
  const type = ref(null);

  const fetchCategories = (ctx, callback) => {
    store
      .dispatch("report/fetchCategories")
      .then((response) => {
        const { category } = response.data;
        bookCategory.value = category.map((x) => {
          return { title: x.title, code: x.id };
        });
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

  const fetchBookTypes = (ctx, callback) => {
    store
      .dispatch("report/fetchBookTypes")
      .then((response) => {
        const { bookType } = response.data;
        type.value = bookType.map((x) => {
          return { title: x.title, code: x.id };
        });
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

  fetchBookTypes();

  const fetchReports = () => {
    bookInData.paper = 0;
    bookOutData.paper = 0;
    store
      .dispatch("report/fetchBookInsWithYear", {
        yearID: yearID.value.code,
      })
      .then((response) => {
        dayjs.extend(isBetween);
        const { bookIn } = response.data;
        const dateSplit = date.value.split(" ถึง ");
        let book = bookIn.filter((x) => {
          if (dayjs(x.dateReceive).isBetween(dateSplit[0], dateSplit[1])) {
            return true;
          } else {
            let start = dayjs(x.dateReceive).isSame(dateSplit[0]);
            let end = dayjs(x.dateReceive).isSame(dateSplit[1]);
            if (start == true || end == true) {
              return true;
            } else {
              return false;
            }
          }
        });

        let bookNoArr = book.map((x) => {
          let no = x.bookNo.split("/");
          bookInData.paper = bookInData.paper + x.bookPageCountSum;
          return no[0];
        });

        let minBookNo = Math.min(...bookNoArr);
        let maxBookNo = Math.max(...bookNoArr);

        bookInData.minBookNo = minBookNo + "/" + yearID.value.title;
        bookInData.maxBookNo = maxBookNo + "/" + yearID.value.title;

        bookInData.total = bookNoArr.length;

        bookCategory.value = bookCategory.value.map((x) => {
          let bookTypeArr = book.filter((m) => {
            return m.categoryID == x.code;
          });

          x.total = bookTypeArr.length;
          return x;
        });
      });

    store
      .dispatch("report/fetchBookOutsWithYear", {
        yearID: yearID.value.code,
      })
      .then((response) => {
        dayjs.extend(isBetween);
        const { bookOut } = response.data;
        const dateSplit = date.value.split(" ถึง ");
        let book = bookOut.filter((x) => {
          if (dayjs(x.dateSend).isBetween(dateSplit[0], dateSplit[1])) {
            return true;
          } else {
            let start = dayjs(x.dateSend).isSame(dateSplit[0]);
            let end = dayjs(x.dateSend).isSame(dateSplit[1]);
            if (start == true || end == true) {
              return true;
            } else {
              return false;
            }
          }
        });

        type.value = type.value.map((x) => {
          let bookTypeArr = book.filter((m) => {
            return m.bookTypeID == x.code;
          });
          x.total = bookTypeArr.length;
          bookOutData.total = bookOutData.total + x.total;
          if (x.total != 0) {
            let bookNoArr = bookTypeArr.map((x) => {
              let no = x.bookNo.split("/");
              bookOutData.paper = bookOutData.paper + x.bookPageCountSum;
              return no[0];
            });

            bookNoArr = bookNoArr.sort();
            let countBookNoArr = bookNoArr.length;

            x.minBookNo = bookNoArr[0] + "/" + yearID.value.title;
            x.maxBookNo =
              bookNoArr[countBookNoArr - 1] + "/" + yearID.value.title;
            //   x.maxBookNo = maxBookNo + "/" + yearID.value.title;
          }else{
            x.minBookNo = 0 + "/" + yearID.value.title;
            x.maxBookNo = 0 + "/" + yearID.value.title;
          }

          
          return x;
        });
      });
  };

  const fetchYears = (ctx, callback) => {
    store
      .dispatch("report/fetchYears")
      .then((response) => {
        const { bookYear } = response.data;

        selectOptions.year = bookYear.map((x) => {
          return { title: x.title, code: x.id };
        });

        yearID.value.title = selectOptions.year[0].title;
        yearID.value.code = selectOptions.year[0].code;

        let year = parseInt(yearID.value.title) - 543;
        date.value = year + "-01-01 ถึง " + year + "-12-31";

        fetchReports();
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

  const onSubmit = () => {
    fetchReports();
  };

  watch(
    () => [yearID.value.code],
    (newData) => {
      date.value = "";
      let year = parseInt(yearID.value.title) - 543;
      date.value = year + "-01-01 ถึง " + year + "-12-31";
    }
  );

  return {
    yearID,
    date,
    selectOptions,
    onSubmit,
    bookInData,
    bookCategory,
    bookOutData,
    type,
  };
}
