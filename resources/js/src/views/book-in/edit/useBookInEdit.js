import { ref, reactive, watch } from "@vue/composition-api";
import router from "../../../router";
import store from "@/store";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useBookInEdit() {
    // Use toast
    const toast = useToast();
    const simpleRules = ref();
    const overLay = ref(false);

    const bookInData = reactive({
        id: "",
        category: "",
        title: "",
        fromNo: "",
        from: "",
        fromDate: "",
        bookNo: "",
        dateReceive: "",
        departmentTo: "",
        bookYearID: "",
        bookTo: "",
        detail: "",
        file: null,
        oldFile: null,
        fileSuccess: null,
        oldFileSuccess: null,
        reference: "",
        emailGroup: "",
        isSendEmail: false,
        toSend: "",
    });

    const selectOptions = reactive({
        category: [],
        department: [],
        email: [],
        emailGroup: [],
    });

    const bookNoLastest = ref("");

    store
        .dispatch("book-in-edit/fetchBookIn", {
            id: router.currentRoute.params.id,
        })
        .then((response) => {
            const { bookIn } = response.data;

            bookInData.id = bookIn.id;
            bookInData.category = {
                title: bookIn.categoryName,
                code: bookIn.categoryID,
            };
            bookInData.title = bookIn.title;
            bookInData.from = bookIn.bookFrom;
            bookInData.fromNo = bookIn.bookFromNo;
            bookInData.fromDate = bookIn.bookFromDate;
            bookInData.bookNo = bookIn.bookNo;
            bookInData.dateReceive = bookIn.dateReceive;
            if (bookIn.departmentTo == null) {
                bookInData.departmentTo = {
                    title: 'ทุกฝ่าย',
                    code: null,
                };
            } else {
                bookInData.departmentTo = {
                    title: bookIn.departmentName,
                    code: bookIn.departmentTo,
                };
            }

            bookInData.detail = bookIn.detail;
            bookInData.toSend = bookIn.toSend;
            bookInData.bookTo = JSON.parse(bookIn.bookTo);
            bookInData.oldFile =
                window.location.origin + "/storage" + bookIn.file;
            bookInData.oldFileSuccess = null;
            if (bookIn.fileSuccess != null) {
                bookInData.oldFileSuccess =
                    window.location.origin + "/storage" + bookIn.fileSuccess;
            }
            bookInData.bookYearID = bookIn.bookYearID;
        })
        .catch((error) => {
            console.log(error);
        });

    const fetchBookCode = (ctx, callback) => {
        store
            .dispatch("book-in-edit/fetchBookCode")
            .then((response) => {
                const { code } = response.data;

                let codeLastest = code.bookIn;

                let count = codeLastest.toString().length;

                if (count == 1) {
                    codeLastest = "00" + codeLastest;
                }

                if (count == 2) {
                    codeLastest = "0" + codeLastest;
                }

                bookNoLastest.value =
                    "เลขทะเบียนรับล่าสุด : " +
                    " " +
                    codeLastest +
                    "/" +
                    code.year;
                    
            })
            .catch(() => {
                toast({
                    component: ToastificationContent,
                    props: {
                        title: "Error fetching Book Code",
                        icon: "AlertTriangleIcon",
                        variant: "danger",
                    },
                });
            });
    };

    fetchBookCode();

    const fetchCategories = (ctx, callback) => {
        store
            .dispatch("book-in-edit/fetchCategories")
            .then((response) => {
                const { category } = response.data;
                selectOptions.category = category.map((x) => {
                    return { title: x.title, code: x.id };
                });
            })
            .catch(() => {
                toast({
                    component: ToastificationContent,
                    props: {
                        title: "Error fetching Category",
                        icon: "AlertTriangleIcon",
                        variant: "danger",
                    },
                });
            });
    };

    fetchCategories();

    const fetchDepartments = (ctx, callback) => {
        store
            .dispatch("book-in-edit/fetchDepartments")
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

    const fetchEmailPersons = (ctx, callback) => {
        store
            .dispatch("book-in-edit/fetchEmailPersons")
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
            .dispatch("book-in-edit/fetchEmailGroups")
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

    const onSubmit = (ctx, callback) => {
        overLay.value = true;
        let bookToSend = null;
        if (bookInData.bookTo) {
            bookToSend = bookInData.bookTo.map((x) => {
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
        console.log(bookInData.bookYearID);
        let dataSend = {
            id: bookInData.id,
            title: bookInData.title,
            fromNo: bookInData.fromNo,
            from: bookInData.from,
            fromDate: bookInData.fromDate,
            bookNo: bookInData.bookNo,
            dateReceive: bookInData.dateReceive,
            bookTo: bookToSend,
            detail: bookInData.detail,
            file: bookInData.file,
            fileSuccess: bookInData.fileSuccess,
            reference: bookInData.reference,
            categoryID: bookInData.category.code,
            departmentID: bookInData.departmentTo.code,
            isSendEmail: bookInData.isSendEmail,
            toSend: bookInData.toSend,
            bookYearID: bookInData.bookYearID,
        };

        store
            .dispatch("book-in-edit/editBookIn", dataSend)
            .then((response) => {
                if (response.data.message == "success") {
                    localStorage.setItem("edited", 1);
                    router.push({ name: "bookin" });
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
                    bookNoLastest.value =
                        "เลขทะเบียนรับล่าสุด : " +
                        " " +
                        (response.data.code.book_in + 1) +
                        "/" +
                        response.data.code.year;
                }
                overLay.value = false;
            })
            .catch(() => {
                toast({
                    component: ToastificationContent,
                    props: {
                        title: "Edit Book In Error",
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
        () => bookInData.emailGroup,
        (newData) => {
            if (newData != null) {
                let bookToWithGroup = selectOptions.email.filter((x) => {
                    let emailArr = bookInData.emailGroup.emailAll.map((e) => {
                        return e.code;
                    });
                    let findEmail = emailArr.includes(x.code);
                    return findEmail;
                });

                let bookToWithGroupFilter = null;
                if (bookInData.bookTo) {
                    bookToWithGroupFilter = bookToWithGroup.filter((x) => {
                        let check = bookInData.bookTo.find((e) => {
                            return x.code === e.code;
                        });

                        return check ? false : true;
                    });
                } else {
                    bookToWithGroupFilter = bookToWithGroup;
                }

                bookInData.bookTo = [
                    ...bookInData.bookTo,
                    ...bookToWithGroupFilter,
                ];
            }
        }
    );

    // *===============================================---*
    // *--------- UI ---------------------------------------*
    // *===============================================---*

    return {
        bookInData,
        validationForm,
        simpleRules,
        selectOptions,
        bookNoLastest,
        overLay,
    };
}
