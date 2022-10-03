import { ref, reactive, watch } from "@vue/composition-api";
import router from "../../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useBookOutOldAdd() {
    // Use toast
    const toast = useToast();
    const simpleRules = ref();
    const overLay = ref(false);

    const showForAdmin = getUserData().type == "admin" ? true : false;

    const bookOutData = reactive({
        bookType: "",
        toSend: "",
        title: "",
        userID: "",
        bookNo: "",
        bookStatus: "",
        dateReceive: "",
        dateSend: "",
        dateReturn: "",
        department: "",
        bookTo: "",
        detail: "",
        file: null,
        fileSuccess: null,
        status: "",
        reference: "",
        emailGroup: "",
    });

    const selectOptions = reactive({
        bookType: [],
        department: [],
        email: [],
        emailGroup: [],
        users: [],
        bookStatus: [],
    });

    const bookNoLastest = ref("เลขทะเบียนรับล่าสุด");

    const fetchBookTypes = (ctx, callback) => {
        store
            .dispatch("book-out-old-add/fetchBookTypesYear",{ yearID: router.currentRoute.query.year})
            .then((response) => {
                const { bookType } = response.data;

                
                selectOptions.bookType = bookType.map((x) => {
                    return {
                        title: x.title,
                        code: x.id,
                        acronym: x.acronym,
                        codeLastest: x.code,
                        year: x.year,
                    };
                });
            })
            .catch(() => {
                toast({
                    component: ToastificationContent,
                    props: {
                        title: "Error fetching Book Type",
                        icon: "AlertTriangleIcon",
                        variant: "danger",
                    },
                });
            });
    };

    fetchBookTypes();

    const fetchDepartments = (ctx, callback) => {
        store
            .dispatch("book-out-old-add/fetchDepartments")
            .then((response) => {
                const { department } = response.data;
                selectOptions.department = department.map((x) => {
                    return { title: x.name, code: x.id };
                });
                selectOptions.department.unshift({
                    title: "ทุกฝ่าย",
                    code: null,
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

    const fetchUsers = (ctx, callback) => {
        store
            .dispatch("book-out-old-add/fetchUsers")
            .then((response) => {
                const { user } = response.data;
                selectOptions.users = user.map((x) => {
                    return {
                        title: x.firstname + " " + x.lastname,
                        code: x.userID,
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

    fetchUsers();

    const fetchEmailPersons = (ctx, callback) => {
        store
            .dispatch("book-out-old-add/fetchEmailPersons")
            .then((response) => {
                const { email } = response.data;
                selectOptions.email = email.map((x) => {
                    return {
                        title:
                            x.firstname +
                            " " +
                            x.lastname +
                            " (" +
                            x.email +
                            ")",
                        code: x.id,
                        email: x.email,
                        groupID: x.groupID,
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

    const fetchEmailGroups = (ctx, callback) => {
        store
            .dispatch("book-out-old-add/fetchEmailGroups")
            .then((response) => {
                const { emailGroup } = response.data;
                selectOptions.emailGroup = emailGroup.map((x) => {
                    return {
                        title: x.name,
                        code: x.id,
                        emailAll: JSON.parse(x.emailAll),
                    };
                });
            })
            .catch(() => {
                toast({
                    component: ToastificationContent,
                    props: {
                        title: "Error fetching Email Group",
                        icon: "AlertTriangleIcon",
                        variant: "danger",
                    },
                });
            });
    };

    fetchEmailGroups();

    const fetchBookStatus = (ctx, callback) => {
        store
            .dispatch("book-out-old-add/fetchBookStatus")
            .then((response) => {
                const { status } = response.data;
                selectOptions.bookStatus = status.map((x) => {
                    return { title: x.title, code: x.id };
                });
            })
            .catch(() => {
                toast({
                    component: ToastificationContent,
                    props: {
                        title: "Error fetching Status",
                        icon: "AlertTriangleIcon",
                        variant: "danger",
                    },
                });
            });
    };

    fetchBookStatus();

    const onSubmit = (ctx, callback) => {
        overLay.value = true;
        let bookToSend = null;
        if (bookOutData.bookTo) {
            bookToSend = bookOutData.bookTo.map((x) => {
                if (!x.hasOwnProperty("email")) {
                    x.email = x.title;
                    x.code = null;
                    x.groupID = null;
                }

                return {
                    title: x.title,
                    code: x.code,
                    email: x.email,
                    groupID: x.groupID,
                };
            });
        }

        let dataSend = {
            bookTypeID: bookOutData.bookType.code,
            dateSend: bookOutData.dateSend,
            bookNo: bookOutData.bookNo,
            title: bookOutData.title,
            toSend: bookOutData.toSend,
            // departmentID: bookOutData.department.code,
            departmentID: null,
            userID: bookOutData.userID.code,
            detail: bookOutData.detail,
            file: bookOutData.file,
            fileSuccess: bookOutData.fileSuccess,
            statusID: bookOutData.bookStatus.code,
            bookTo: bookToSend,
        };

        store
            .dispatch("book-out-old-add/addBookOut", dataSend)
            .then((response) => {
                if (response.data.message == "success") {
                    localStorage.setItem("added", 1);
                    router.push({ name: "bookout-old" });
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

                if (response.data.message == "error Duplicate Book No") {
                    let book =
                        response.data.bookType.acronym +
                        (response.data.bookType.codeLastest + 1) +
                        "/" +
                        response.data.bookType.year;
                    bookNoLastest.value = "เลขทะเบียนรับล่าสุด : " + " " + book;
                }
                overLay.value = false;
            })
            .catch(() => {
                toast({
                    component: ToastificationContent,
                    props: {
                        title: "Edit Book Out Error",
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

    // Watch Email Group
    watch(
        () => bookOutData.emailGroup,

        (newData) => {
            if (newData != null) {
                let bookToWithGroup = selectOptions.email.filter((x) => {
                    let emailArr = bookOutData.emailGroup.emailAll.map((e) => {
                        return e.code;
                    });
                    let findEmail = emailArr.includes(x.code);
                    return findEmail;
                });

                let bookToWithGroupFilter = null;
                if (bookOutData.bookTo) {
                    bookToWithGroupFilter = bookToWithGroup.filter((x) => {
                        let check = bookOutData.bookTo.find((e) => {
                            return x.code === e.code;
                        });

                        return check ? false : true;
                    });
                } else {
                    bookToWithGroupFilter = bookToWithGroup;
                }

                bookOutData.bookTo = [
                    ...bookOutData.bookTo,
                    ...bookToWithGroupFilter,
                ];
            }
        }
    );

    //   Watch Book Type
    watch(
        () => bookOutData.bookType,
        (newData) => {
            if (newData != null) {
                let codeLastest = bookOutData.bookType.codeLastest + 1;
                let codeLastest1 = bookOutData.bookType.codeLastest;

                let count = codeLastest.toString().length;
                let count1 = codeLastest1.toString().length;

                if (count == 1) {
                    codeLastest = "00" + codeLastest;
                }
                if (count == 2) {
                  codeLastest = "0" + codeLastest;
                }

                if (count1 == 1) {
                    codeLastest1 = "00" + codeLastest1;
                }
                if (count1 == 2) {
                  codeLastest1 = "0" + codeLastest1;
                }

                let book =
                    bookOutData.bookType.acronym +
                    codeLastest +
                    "/" +
                    bookOutData.bookType.year;

                let book1 =
                    bookOutData.bookType.acronym +
                    codeLastest1 +
                    "/" +
                    bookOutData.bookType.year;

                bookNoLastest.value = "เลขทะเบียนรับล่าสุด : " + " " + book1;
                bookOutData.bookNo = book;
            }
        }
    );

    // *===============================================---*
    // *--------- UI ---------------------------------------*
    // *===============================================---*

    return {
        bookOutData,
        validationForm,
        simpleRules,
        selectOptions,
        bookNoLastest,
        overLay,
        showForAdmin,
    };
}
