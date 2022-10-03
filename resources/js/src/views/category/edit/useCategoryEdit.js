import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useCategoryEdit() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const categoryData = reactive({
    id: "",
    title: "",
  });

  store
  .dispatch("category-edit/fetchCategory", { id: router.currentRoute.params.id })
  .then((response) => {
    const { bookCategory } = response.data;

    categoryData.id = bookCategory.id;
    categoryData.title = bookCategory.title;
  })
  .catch((error) => {
    console.log(error);
  });

  const selectOptions = reactive({
    // year: [],
  });

  const onSubmit = (ctx, callback) => {
    overLay.value = true;

    let dataSend = {
        id: categoryData.id,
        title: categoryData.title,
    };

    store
      .dispatch("category-edit/editCategory", dataSend)
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
            title: "Edit Category Error",
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
    categoryData,
    selectOptions,
    validationForm,
    simpleRules,
    overLay,
  };
}
