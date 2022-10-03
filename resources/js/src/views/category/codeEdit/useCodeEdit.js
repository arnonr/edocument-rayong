import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useCodeEdit() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const bookCodeData = reactive({
    id: "",
    year: {title: "", code: ""},
    bookIn: ""
  });

  store
  .dispatch("code-edit/fetchBookCode")
  .then((response) => {
    const { code } = response.data;

    bookCodeData.id = code.id;
    bookCodeData.year.title = code.year;
    bookCodeData.year.code = code.yearID;
    bookCodeData.bookIn = code.bookIn;
  })
  .catch((error) => {
    console.log(error);
  });

  const selectOptions = reactive({
    year: [],
  });

  store
  .dispatch("code-edit/fetchBookYears")
  .then((response) => {
    const { bookYear} = response.data;

    selectOptions.year = bookYear.map((x) => {
        return {
          title: x.title,
          code: x.id,
        };
    });
  })
  .catch((error) => {
    console.log(error);
  });

  const onSubmit = (ctx, callback) => {
    overLay.value = true;

    let dataSend = {
        id: bookCodeData.id,
        year: bookCodeData.year.code,
        bookIn: bookCodeData.bookIn,
        
    };

    store
      .dispatch("code-edit/editBookCode", dataSend)
      .then((response) => {
        if (response.data.message == "success") {
          localStorage.setItem("edited", 1);
          router.push({ name: "category-list" });
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
            title: "Edit Book Code Error",
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
    bookCodeData,
    selectOptions,
    validationForm,
    simpleRules,
    overLay,
  };
}
