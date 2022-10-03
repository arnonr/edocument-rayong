import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useSettingEdit() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const settingData = reactive({
    id: "",
    email: "",
    password: "",
  });

  store
  .dispatch("setting-edit/fetchSetting")
  .then((response) => {
    const { setting } = response.data;

    settingData.id = setting.id;
    settingData.email = setting.email;
    settingData.password = setting.password;
  })
  .catch((error) => {
    console.log(error);
  });

  const onSubmit = (ctx, callback) => {
    overLay.value = true;

    let dataSend = {
        id: settingData.id,
        email: settingData.email,
        password: settingData.password
    };
    store
      .dispatch("setting-edit/editSetting", dataSend)
      .then((response) => {
        if (response.data.message == "success") {
        //   router.push({ name: "setting-edit" });
          toast({
            component: ToastificationContent,
            props: {
              title: "Edited Mail",
              icon: "CheckIcon",
              variant: "success",
            },
          });
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
            title: "Edit Setting Error",
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
    settingData,
    validationForm,
    simpleRules,
    overLay,
  };
}
