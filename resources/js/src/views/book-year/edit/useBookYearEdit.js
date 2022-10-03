import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useBookYearEdit() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const bookYearData = reactive({
    id: "",
    title: "",
    status: "",
  });

  store
  .dispatch("book-year-edit/fetchBookYear", { id: router.currentRoute.params.id })
  .then((response) => {
    const { bookYear } = response.data;

    bookYearData.id = bookYear.id;
    bookYearData.title = bookYear.title;
    bookYearData.status = bookYear.status;
  })
  .catch((error) => {
    console.log(error);
  });

  const onSubmit = (ctx, callback) => {
    overLay.value = true;

    let dataSend = {
        id: bookYearData.id,
        title: bookYearData.title,
        status: bookYearData.status,
    };

    console.log(dataSend)

    store
      .dispatch("book-year-edit/editBookYear", dataSend)
      .then((response) => {
        if (response.data.message == "success") {
          localStorage.setItem("edited", 1);
          router.push({ name: "book-year-list" });
        } else {
          toast({
            component: ToastificationContent,
            props: {
              title: response.data.message,
              icon: "AlertTriangleIcon",
              variant: "danger",
            },
          });
        }

        overLay.value = false;
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Edit Book Year Error",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
        overLay.value = false;
      });
  };

  const validationForm = () => {
    simpleRules.value.validate().then((success) => {
      if (success) {
        onSubmit();
      }
    });
  };


  // *===============================================---*
  // *--------- UI ---------------------------------------*
  // *===============================================---*

  return {
    bookYearData,
    validationForm,
    simpleRules,
    overLay,
  };
}
