import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useEmailPersonEdit() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const emailPersonData = reactive({
    id: "",
    prefix: "",
    firstname: "",
    lastname: "",
    email: ""
  });

  store
  .dispatch("email-person-edit/fetchEmailPerson", { id: router.currentRoute.params.id })
  .then((response) => {
    const { emailPerson } = response.data;

    emailPersonData.id = emailPerson.id;
    emailPersonData.prefix = emailPerson.prefix;
    emailPersonData.firstname = emailPerson.firstname;
    emailPersonData.lastname = emailPerson.lastname;
    emailPersonData.email = emailPerson.email;
  })
  .catch((error) => {
    console.log(error);
  });

  const onSubmit = (ctx, callback) => {
    overLay.value = true;

    let dataSend = {
        id: emailPersonData.id,
        prefix: emailPersonData.prefix,
        firstname: emailPersonData.firstname,
        lastname: emailPersonData.lastname,
        email: emailPersonData.email,
    };

    store
      .dispatch("email-person-edit/editEmailPerson", dataSend)
      .then((response) => {
        if (response.data.message == "success") {
          localStorage.setItem("edited", 1);
          router.push({ name: "email-person-list" });
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
            title: "Edit EMail Person Error",
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
    emailPersonData,
    validationForm,
    simpleRules,
    overLay,
  };
}
