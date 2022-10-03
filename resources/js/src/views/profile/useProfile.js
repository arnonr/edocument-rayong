import { ref, reactive, watch, computed } from "@vue/composition-api";
import store from "@/store";
import { getUserData } from "@/auth/utils";
import useJwt from "@/auth/jwt/useJwt";
import { Ability } from '@casl/ability'

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useProfile() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  let ability = new Ability();

  const profileData = reactive({
    id: "",
    prefix: "",
    firstname: "",
    lastname: "",
    email: "",
    type: "",
    department: "",
    status: "",
  });

  const fetchUser = (ctx, callback) => {
    store
      .dispatch("profile-edit/fetchUser", { id: getUserData().userID })
      .then((response) => {
        const { user } = response.data;
        profileData.id = user.userID;
        profileData.prefix = user.prefix;
        profileData.firstname = user.firstname;
        profileData.lastname = user.lastname;
        profileData.email = user.email;
        profileData.type = user.type;
        profileData.status = user.status;
        profileData.department = user.department;

        //
        const { userData } = response.data;
        useJwt.setToken(response.data.accessToken);
        useJwt.setRefreshToken(response.data.refreshToken);
        localStorage.setItem("userData", JSON.stringify(userData));
        ability.update(userData.ability);
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching user",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });
  };

  fetchUser();

  const onSubmit = (ctx, callback) => {
    store
      .dispatch("profile-edit/editUser", { ...profileData })
      .then((response) => {
        if (response.data.message == "success") {
          toast({
            component: ToastificationContent,
            props: {
              title: "Edit Profile Success",
              icon: "AlertTriangleIcon",
              variant: "success",
            },
          });
        }
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Edit Profile Error",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
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

  const resolveUserTypeVariant = (role) => {
    if (role === "admin") return "success";
    if (role === "staff") return "primary";
    return "primary";
  };

  const resolveUserStatusVariant = (status) => {
    if (status === 1) return ["รอการอนุมัติ", "warning"];
    if (status === 2) return ["อนุมัติเรียบร้อย", "success"];
    return ["บล็อค", "danger"];
  };

  return {
    fetchUser,
    profileData,
    resolveUserTypeVariant,
    resolveUserStatusVariant,
    validationForm,
    simpleRules,
  };
}
