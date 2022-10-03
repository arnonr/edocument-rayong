import { ref, reactive, watch } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useUserEdit() {
  // Use toast
  const toast = useToast();
  const simpleRules = ref();
  const overLay = ref(false);

  const userData = reactive({
    id: "",
    firstname: "",
    lastname: "",
    email: "",
    department: { title: "", code: "" },
    type: { title: "", code: "" },
    status: { title: "", code: "" },
  });

  const selectOptions = reactive({
    department: [
    ],
    status: [
        { title: "รอการอนุมัติ", code: 1 },
        { title: "อนุมัติเรียบร้อย", code: 2 },
    ],
    type: [
        { title: "admin", code: "admin" },
        { title: "staff", code: "staff" },
    ]
  });

  store
    .dispatch("user-edit/fetchUser", { id: router.currentRoute.params.id })
    .then((response) => {
      const { user } = response.data;

      userData.id = user.userID;

      userData.firstname = user.firstname
      userData.lastname = user.lastname
      userData.email = user.email
      userData.department.title = user.department.name
      userData.department.code = user.department.id


      userData.type.title = user.type
      userData.type.code = user.type

        if(user.status == 1){
            userData.status.title = 'รอการอนุมัติ'
            
        }else if(user.status == 2){
            userData.status.title = 'อนุมัติเรียบร้อย'
        }else{
            userData.status.title = user.status
        }
        userData.status.code = user.status
      

    })
    .catch((error) => {
      console.log(error);
    });


  const fetchDepartments = (ctx, callback) => {
    store
      .dispatch("user-edit/fetchDepartments")
      .then((response) => {
        const { department } = response.data;
        selectOptions.department = department.map((x) => {
          return { title: x.name, code: x.id };
        });
      })
      .catch(() => {
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Department",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
      });
  };

  fetchDepartments();

  const onSubmit = (ctx, callback) => {
    overLay.value = true;

    let dataSend = {
      id: userData.id,
      firstname: userData.firstname,
      lastname: userData.lastname,
      departmentID: userData.department.code,
      type: userData.type.code,
      status: userData.status.code,
    };

    store
      .dispatch("user-edit/editUser", dataSend)
      .then((response) => {
        if (response.data.message == "success") {
          localStorage.setItem("edited", 1);
          router.push({ name: "user-list" });
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
            title: "Edit User In Error",
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
    userData,
    validationForm,
    simpleRules,
    selectOptions,
    overLay,
  };
}
