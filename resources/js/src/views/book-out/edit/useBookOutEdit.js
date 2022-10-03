import { ref, reactive, watch } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useBookOutEdit() {
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
        dateReceive: "",
        dateSend: "",
        dateReturn: "",
        department: "",
        bookTo: "",
        detail: "",
        file: null,
        fileSuccess: null,
        bookStatus: "",
        reference: "",
        emailGroup: "",
        oldFile: null,
        oldFileSuccess: null,
        isSendEmail: false,
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
            .dispatch("book-out-edit/fetchBookTypes")
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

    store
        .dispatch("book-out-edit/fetchBookOut", {
            id: router.currentRoute.params.id,
        })
        .then((response) => {
            const { bookOut } = response.data;

            bookOutData.id = bookOut.id;
            bookOutData.bookType = {
                title: bookOut.bookTypeName,
                code: bookOut.bookTypeID,
                acronym: bookOut.bookTypeAcronym,
            };

            bookOutData.title = bookOut.title;
            bookOutData.toSend = bookOut.toSend;
            bookOutData.userID = {
                title:
                    bookOut.prefix + bookOut.firstname + " " + bookOut.lastname,
                code: bookOut.userID,
            };

            bookOutData.bookNo = bookOut.bookNo;
            bookOutData.dateSend = bookOut.dateSend;
            bookOutData.dateReceive = bookOut.dateReceive;
            bookOutData.dateReturn = bookOut.dateReturn;

            bookOutData.department = {
                title: bookOut.departmentName,
                code: bookOut.departmentID,
            };

            bookOutData.bookTo = JSON.parse(bookOut.bookTo);
            bookOutData.detail = bookOut.detail;

            // bookOutData.status =
            bookOutData.oldFile =
                window.location.origin + "/storage" + bookOut.file;

            bookOutData.oldFileSuccess = null;
            if (bookOut.fileSuccess != null) {
                bookOutData.oldFileSuccess =
                    window.location.origin + "/storage" + bookOut.fileSuccess;
            }

            bookOutData.bookStatus = {
                title: bookOut.statusTitle,
                code: bookOut.statusID,
            };
        })
        .catch((error) => {
            console.log(error);
        });

    const fetchDepartments = (ctx, callback) => {
        store
            .dispatch("book-out-edit/fetchDepartments")
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
            .dispatch("book-out-edit/fetchUsers")
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
            .dispatch("book-out-edit/fetchEmailPersons")
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
            .dispatch("book-out-edit/fetchEmailGroups")
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
            .dispatch("book-out-edit/fetchBookStatus")
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
            id: bookOutData.id,
            bookTypeID: bookOutData.bookType.code,
            dateSend: bookOutData.dateSend,
            bookNo: bookOutData.bookNo,
            toSend: bookOutData.toSend,
            title: bookOutData.title,
            departmentID: null,
            departmentID: bookOutData.department.code,
            userID: bookOutData.userID.code,
            detail: bookOutData.detail,
            bookTo: bookToSend,
            file: bookOutData.file,
            fileSuccess: bookOutData.fileSuccess,
            statusID: bookOutData.bookStatus.code,
            isSendEmail: bookOutData.isSendEmail,
        };

        store
            .dispatch("book-out-edit/editBookOut", dataSend)
            .then((response) => {
                if (response.data.message == "success") {
                    localStorage.setItem("edited", 1);
                    router.push({ name: "bookout" });
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
        async (newData) => {
            if (newData != null) {

                let bookTypeLastest = await selectOptions.bookType.find((x) => {
                    return x.code == newData.code;
                });
                
                console.log(bookTypeLastest)
                // 
                let codeLastest = bookTypeLastest.codeLastest;
                let count = codeLastest.toString().length;

                if (count == 1) {
                    codeLastest = "00" + codeLastest;
                }
                if (count == 2) {
                    codeLastest = "0" + codeLastest;
                }

                setTimeout(() => {
                    let book =
                        bookTypeLastest.acronym +
                        (codeLastest) +
                        "/" +
                        bookTypeLastest.year;
                    bookNoLastest.value = "เลขทะเบียนรับล่าสุด : " + " " + book;
                }, 1000);
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
