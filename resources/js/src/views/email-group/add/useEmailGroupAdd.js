import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useEmailGroupAdd() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const emailGroupData = reactive({
    name: "",
    emailAll: "",

  });

  const selectOptions = reactive({
    email: [],
  });

  const fetchEmailPersons = (ctx, callback) => {
    store
      .dispatch("email-group-add/fetchEmailPersons")
      .then((response) => {
        const { email } = response.data;
        selectOptions.email = email.map((x) => {
          return {
            title: x.firstname + " " + x.lastname + " (" + x.email + ")",
            code: x.id,
            email: x.email,
          };
        });
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching User Email",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });
  };

  fetchEmailPersons();

  const onSubmit = (ctx, callback) => {
    overLay.value = true;
    let emailAllSend = null;
    
    if (emailGroupData.emailAll) {
      emailAllSend = emailGroupData.emailAll.map((x) => {
        return {
          title: x.title,
          code: x.code,
          email: x.email,
        };
      });
    }

    let dataSend = {
      name: emailGroupData.name,
      emailAll: emailAllSend
    };

    store
      .dispatch("email-group-add/addEmailGroup", dataSend)
      .then((response) => {
        if (response.data.message == "success") {
          localStorage.setItem("added", 1);
          router.push({ name: "email-group-list" });
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
            title: "Add EMail Group Error",
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
    emailGroupData,
    validationForm,
    simpleRules,
    selectOptions,
    overLay,
  };
}
