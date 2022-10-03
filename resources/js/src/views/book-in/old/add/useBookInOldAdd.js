import { ref, reactive, watch, computed } from "@vue/composition-api";
import router from "../../../../router";
import store from "@/store";
import { getUserData } from "@/auth/utils";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";

export default function useBookInOldAdd() {
    // Use toast
    const toast = useToast();
    const simpleRules = ref();
    const overLay = ref(false);
    const yearID = router.currentRoute.params.year
    const bookInData = reactive({
        category: "",
        title: "",
        fromNo: "",
        from: "",
        fromDate: "",
        bookNo: "",
        dateReceive: "",
        departmentTo: "",
        bookTo: "",
        detail: "",
        file: null,
        fileSuccess: null,
        reference: "",
        emailGroup: "",
        toSend: "",
    });

    const selectOptions = reactive({
        category: [],
        department: [],
        email: [],
        emailGroup: [],
    });

    const bookNoLastest = ref("");

    const fetchBookCode = (ctx, callback) => {
        store
            .dispatch("book-in-old-add/fetchBookCodeOld",{yearID: router.currentRoute.query.year})
            .then((response) => {
                const { code } = response.data;

                let codeLastest = code.bookIn;
                let codeLastest1 = code.bookIn + 1;
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

                bookNoLastest.value =
                    "เลขทะเบียนรับล่าสุด : " +
                    " " +
                    codeLastest +
                    "/" +
                    code.year;

                bookInData.bookNo = codeLastest1 + "/" + code.year;
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
            .dispatch("book-in-old-add/fetchCategories")
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
            .dispatch("book-in-old-add/fetchDepartments")
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
            .dispatch("book-in-old-add/fetchEmailPersons")
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
            .dispatch("book-in-old-add/fetchEmailGroups")
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

        let dataSend = {
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
            toSend: bookInData.toSend,
        };

        store
            .dispatch("book-in-old-add/addBookIn", dataSend)
            .then((response) => {
                if (response.data.message == "success") {
                    localStorage.setItem("added", 1);
                    router.push({ name: "bookin-old" });
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
                        title: "Add Book In Error",
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
