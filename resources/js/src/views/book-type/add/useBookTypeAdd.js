import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useBookTypeAdd() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const bookTypeData = reactive({
    title: "",
    acronym: "",
    code: "",
  });

  const onSubmit = (ctx, callback) => {
    overLay.value = true;

    let dataSend = {
      title: bookTypeData.title,
      acronym: bookTypeData.acronym,
      code: bookTypeData.code
    };

    store
      .dispatch("book-type-add/addBookType", dataSend)
      .then((response) => {
        if (response.data.message == "success") {
          localStorage.setItem("added", 1);
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
            title: "Add Book Type Error",
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
    validationForm,
    simpleRules,
    overLay,
  };
}
