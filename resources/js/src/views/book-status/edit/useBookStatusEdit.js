import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useBookStatusEdit() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const bookStatusData = reactive({
    id: "",
    title: "",
  });

  store
  .dispatch("book-status-edit/fetchBookStatus", { id: router.currentRoute.params.id })
  .then((response) => {
    const { status } = response.data;

    bookStatusData.id = status.id;
    bookStatusData.title = status.title;
  })
  .catch((error) => {
    console.log(error);
  });

  const onSubmit = (ctx, callback) => {
    overLay.value = true;

    let dataSend = {
        id: bookStatusData.id,
        title: bookStatusData.title,
    };

    console.log(dataSend)

    store
      .dispatch("book-status-edit/editBookStatus", dataSend)
      .then((response) => {
        if (response.data.message == "success") {
          localStorage.setItem("edited", 1);
          router.push({ name: "book-status-list" });
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
            title: "Edit Book Status Error",
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
    bookStatusData,
    validationForm,
    simpleRules,
    overLay,
  };
}
