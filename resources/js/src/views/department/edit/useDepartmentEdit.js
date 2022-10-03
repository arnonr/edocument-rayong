import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useDepartmentEdit() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const departmentData = reactive({
    id: "",
    name: "",
  });

  store
  .dispatch("department-edit/fetchDepartment", { id: router.currentRoute.params.id })
  .then((response) => {
    const { department } = response.data;

    departmentData.id = department.id;
    departmentData.name = department.name;
  })
  .catch((error) => {
    console.log(error);
  });

  const onSubmit = (ctx, callback) => {
    overLay.value = true;

    let dataSend = {
        id: departmentData.id,
        name: departmentData.name,
    };

    console.log(dataSend)

    store
      .dispatch("department-edit/editDepartment", dataSend)
      .then((response) => {
        if (response.data.message == "success") {
          localStorage.setItem("edited", 1);
          router.push({ name: "department-list" });
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
            title: "Edit Department Error",
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
    departmentData,
    validationForm,
    simpleRules,
    overLay,
  };
}
