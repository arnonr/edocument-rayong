import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useBookTypeEdit() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const bookTypeData = reactive({
    id: "",
    title: "",
    acronym: "",
    code: "",
    year: {title: "",code: ""},
  });

  store
  .dispatch("book-type-edit/fetchBookType", { id: router.currentRoute.params.id })
  .then((response) => {
    const { bookType } = response.data;

    bookTypeData.id = bookType.id;
    bookTypeData.title = bookType.title;
    bookTypeData.acronym = bookType.acronym;
    bookTypeData.code = bookType.code;
    bookTypeData.year.code = bookType.year;
    bookTypeData.year.title = bookType.yearTitle;
  })
  .catch((error) => {
    console.log(error);
  });

  const selectOptions = reactive({
    year: [],
  });

  store
  .dispatch("book-type-edit/fetchBookYears")
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
        id: bookTypeData.id,
        title: bookTypeData.title,
        acronym: bookTypeData.acronym,
        code: bookTypeData.code,
        year: bookTypeData.year.code
    };

    store
      .dispatch("book-type-edit/editBookType", dataSend)
      .then((response) => {
        if (response.data.message == "success") {
          localStorage.setItem("edited", 1);
          router.push({ name: "book-type-list" });
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
            title: "Edit Book Type Error",
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
    bookTypeData,
    selectOptions,
    validationForm,
    simpleRules,
    overLay,
  };
}
