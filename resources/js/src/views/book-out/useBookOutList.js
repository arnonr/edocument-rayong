import { ref, reactive, watch, computed } from "@vue/composition-api";
import store from "@/store";
import { getUserData } from "@/auth/utils";
import router from "../../router";
import dayjs from "dayjs";
import locale from "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
import isBetween from "dayjs/plugin/isBetween";
// import isSame from "dayjs/plugin/isSame";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";
import Swal from "sweetalert2";
import XLSX from "xlsx";

export default function useBookOutList() {
    // Use toast
    const toast = useToast();

    const items = ref([]);
    const bookOutLists = ref([]);
    const perPage = ref(20);
    const pageOptions = ref([20, 50]);
    const totalRows = ref(1);
    const currentPage = ref(1);
    const sortBy = ref("");
    const sortDesc = ref(false);
    const sortDirection = ref("asc");
    const filter = ref(null);
    const filterOn = reactive([]);
    const table = ref(null);

    const showBtnAdmin = getUserData().type == "admin" ? true : false;

    const exportDate = reactive({
        start: "",
        end: "",
    });

    const statusCount = reactive({
        status1: 0,
        status2: 0,
        status3: 0,
        status4: 0,
    });

    const advancedSearch = reactive({
        title: "",
        bookNo: "",
        fullName: "",
        toSend: "",
        bookTypeName: { title: "-- ทุกประเภท --", code: "" },
        statusName: { title: "-- ทุกสถานะ --", code: "" },
        departmentName: { title: "-- ทุกฝ่าย --", code: "" },
        dateSend: "",
        dateReceive: "",
        dateReturn: "",
        // favorite: { title: "-- NO --", code: 0 },
    });

    if (showBtnAdmin != true) {
        advancedSearch.departmentName = {
            title: getUserData().department.name,
            code: getUserData().department.id,
        };
    }

    const fields = reactive([
        "show_details",
        {
            key: "id",
            label: "Id",
            visible: false,
        },
        // {
        //   key: "favorite",
        //   label: "Fav",
        //   sortable: true,
        //   visible: true,
        //   class: "text-center",
        //   tdClass: "mw-3-5",
        // },
        {
            key: "bookType",
            label: "ประเภท",
            sortable: true,
            visible: true,
            class: "text-center",
            tdClass: "mw-3-7",
        },
        {
            key: "bookNo",
            label: "เลขที่",
            sortable: true,
            visible: true,
            class: "text-center",
            tdClass: "mw-3-7",
        },
        {
            key: "title",
            label: "เรื่อง",
            sortable: true,
            visible: true,
            tdClass: "mw-10",
        },
        {
            key: "dateSend",
            label: "ลงวันที่",
            sortable: true,
            visible: true,
            class: "text-center",
            tdClass: "mw-4",
        },
        {
            key: "userID",
            label: "ผู้รับผิดชอบ",
            sortable: true,
            visible: false,
        },
        {
            key: "department",
            label: "ฝ่าย",
            sortable: true,
            visible: false,
        },
        {
            key: "status",
            label: "สถานะ",
            sortable: true,
            visible: true,
            class: "text-center",
        },
        {
            key: "file",
            label: "ไฟล์ต้นฉบับ",
            sortable: false,
            visible: true,
            class: "text-center",
            tdClass: "mw-e-8",
        },
        {
            key: "fileSuccess",
            label: "ไฟล์ฉบับสมบูรณ์",
            sortable: false,
            visible: true,
            class: "text-center",
            tdClass: "mw-e-8",
        },
        {
            key: "btnChangeStatus",
            label: "รับเอกสาร",
            sortable: false,
            visible: true,
            class: "text-center",
            tdClass: "mw-e-8",
        },
        {
            key: "action",
            label: "Action",
            visible: true,
            class: "text-center",
            tdClass: "mw-8",
        },

        {
            key: "bookTypeName",
            label: "ประเภท",
            sortable: true,
            visible: false,
            class: "text-center",
        },

        {
            key: "dateReturn",
            label: "วันที่....",
            sortable: true,
            visible: false,
        },
        { key: "detail", label: "หมายเหตุ", sortable: false, visible: false },
    ]);

    const sortOptions = computed(() =>
        fields
            .filter((f) => f.sortable)
            .map((f) => ({ text: f.label, value: f.key }))
    );

    const visibleFields = computed(() => fields.filter((f) => f.visible));

    const selectOptions = reactive({
        bookType: [],
        department: [],
        status: [],
        favorite: [
            { title: "-- NO --", code: 0 },
            { title: "-- YES --", code: 1 },
        ],
    });

    const onFiltered = (filteredItems) => {
        totalRows.value = filteredItems.length;
        currentPage.value = 1;
    };

    const fetchBookOuts = (ctx, callback) => {
        store
            .dispatch("book-out-list/fetchBookOuts")
            .then((response) => {
                const { bookOut } = response.data;
                dayjs.extend(buddhistEra);

                bookOutLists.value = bookOut.map((item) => {
                    let book = item;

                    book.dateSendReal = item.dateSend
                        ? dayjs(item.dateSend).format("YYYY-MM-DD")
                        : "";

                    book.dateSend = item.dateSend
                        ? dayjs(item.dateSend).locale("th").format("DD MMM BB")
                        : "";

                    book.dateReceiveReal = item.dateReceive
                        ? dayjs(item.dateReceive).format("YYYY-MM-DD")
                        : "";
                    book.dateReceive = item.dateReceive
                        ? dayjs(item.dateReceive)
                              .locale("th")
                              .format("DD MMM BB")
                        : "";

                    book.dateReturnReal = item.dateReturn
                        ? dayjs(item.dateReturn).format("YYYY-MM-DD")
                        : "";
                    book.dateReturn = item.dateReturn
                        ? dayjs(item.dateReturn)
                              .locale("th")
                              .format("DD MMM BB")
                        : "";

                    // console.log(item)
                    book.bookType = item.bookTypeName

                    let bookNoArr = item.bookNo.split("/");
                    book.bookNo = bookNoArr[0].substr(bookNoArr[0].length-3,3)+"/"+bookNoArr[1];

                    if (item.bookTo != null) {
                        let email = JSON.parse(item.bookTo);

                        book.bookTo = "";
                        for (const el of email) {
                            book.bookTo = el.title + ", " + book.bookTo;
                        }
                    }
                    book.file = window.location.origin + "/storage" + item.file;

                    if (item.fileSuccess != null) {
                        book.fileSuccess =
                            window.location.origin +
                            "/storage" +
                            item.fileSuccess;
                    } else {
                        book.fileSuccess = "-";
                    }

                    book.favorite = false;
                    if (item.bookOutFavoriteID != null) {
                        book.favorite = true;
                    }

                    book.status = {
                        id: item.statusID,
                        title: item.statusTitle,
                        color: item.statusColor,
                    };
                    if(item.statusID == 1){
                        console.log(item.statusID)
                        statusCount.status1 = statusCount.status1+1;
                    }
                    if(item.statusID == 2){
                        statusCount.status2 = statusCount.status2+1;
                    }
                    if(item.statusID == 3){
                        statusCount.status3 = statusCount.status3+1;
                    }
                    if(item.statusID == 4){
                        statusCount.status4 = statusCount.status4+1;
                    }

                    book.fullName =
                        item.prefix + item.firstname + " " + item.lastname;
                    return book;
                });

                if (router.currentRoute.query.status == 'รอสารบรรณรับเรื่อง') {
                  // advancedSearch.statusName = {title: 'รอสารบรรณรับเรื่อง',code: 4}
                  sortBy.value = 'status';
                }

                if (showBtnAdmin != true) {
                    bookOutLists.value = bookOutLists.value.filter((x) => {
                        if (x.departmentID != null) {
                            return (
                                x.departmentID == getUserData().department.id
                            );
                        } else {
                            return true;
                        }
                    });
                } else {
                }

                items.value = bookOutLists.value;
                totalRows.value = bookOutLists.value.length;
            })
            .catch(() => {
                toast({
                    component: ToastificationContent,
                    props: {
                        title: "Error fetching Book Out",
                        icon: "AlertTriangleIcon",
                        variant: "danger",
                    },
                });
            });
    };

    fetchBookOuts();

    const fetchBookTypes = (ctx, callback) => {
        store
            .dispatch("book-out-list/fetchBookTypes")
            .then((response) => {
                const { bookType } = response.data;
                
                selectOptions.bookType = bookType.map((x) => {
                    return { title: x.title, code: x.id };
                });
                selectOptions.bookType.unshift({
                    title: "-- ทุกประเภท --",
                    code: "",
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

    fetchBookTypes();

    const fetchDepartments = (ctx, callback) => {
        store
            .dispatch("book-out-list/fetchDepartments")
            .then((response) => {
                const { department } = response.data;

                if (showBtnAdmin != true) {
                    selectOptions.department = [
                        {
                            title: getUserData().department.name,
                            code: getUserData().department.id,
                        },
                    ];
                } else {
                    selectOptions.department = department.map((x) => {
                        return { title: x.name, code: x.id };
                    });
                    selectOptions.department.unshift({
                        title: "-- ทุกฝ่าย --",
                        code: "",
                    });
                }
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

    const fetchStatus = (ctx, callback) => {
        store
            .dispatch("book-out-list/fetchBookStatus")
            .then((response) => {
                const { status } = response.data;
                selectOptions.status = status.map((x) => {
                    return { title: x.title, code: x.id };
                });
                selectOptions.status.unshift({
                    title: "-- ทุกสถานะ --",
                    code: "",
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

    fetchStatus();

    const onConfirmDelete = (id) => {
        Swal.fire({
            title: "Are you sure?",
            text: "You won't be able to revert this!",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#3085d6",
            cancelButtonColor: "#d33",
            confirmButtonText: "Yes, delete it!",
            customClass: {
                confirmButton: "btn btn-primary",
                cancelButton: "btn btn-outline-danger ml-1",
            },
            buttonsStyling: false,
        }).then((result) => {
            if (result.isConfirmed) {
                onDelete(id);
                Swal.fire({
                    icon: "success",
                    title: "Deleted!",
                    text: "Your file has been deleted.",
                    customClass: {
                        confirmButton: "btn btn-success",
                    },
                });
            }
        });
    };

    const onDelete = (id) => {
        store
            .dispatch("book-out-list/deleteBookOut", { id: id })
            .then((response) => {
                if (response.data.message == "success") {
                    items.value = items.value.filter((el) => el.id !== id);
                    console.log("success");
                } else {
                    console.log("error");
                }
            })
            .catch((error) => {
                let textErrors = "";
                Object.values(error.response.data.errors).forEach(
                    (textError) => {
                        textErrors = textErrors + textError + "<br>";
                    }
                );
                errorToast(textErrors);
            });
    };

    const onFavoriteChange = (id, favoriteOld) => {
        if (favoriteOld == true) {
            store
                .dispatch("book-out-list/deleteBookOutFavorite", {
                    bookID: id,
                    userID: getUserData().userID,
                    bookType: 1,
                })
                .then((response) => {
                    if (response.data.message == "success") {
                        let found = items.value.findIndex((x) => x.id == id);
                        items.value[found].favorite = !favoriteOld;

                        console.log("success");
                    } else {
                        console.log("error");
                    }
                })
                .catch((error) => {
                    let textErrors = "";
                    Object.values(error.response.data.errors).forEach(
                        (textError) => {
                            textErrors = textErrors + textError + "<br>";
                        }
                    );
                    errorToast(textErrors);
                });
        } else {
            store
                .dispatch("book-out-list/addBookOutFavorite", {
                    bookID: id,
                    userID: getUserData().userID,
                    bookType: 1,
                })
                .then((response) => {
                    if (response.data.message == "success") {
                        let found = items.value.findIndex((x) => x.id == id);
                        items.value[found].favorite = !favoriteOld;

                        console.log("success");
                    } else {
                        console.log("error");
                    }
                })
                .catch((error) => {
                    let textErrors = "";
                    Object.values(error.response.data.errors).forEach(
                        (textError) => {
                            textErrors = textErrors + textError + "<br>";
                        }
                    );
                    errorToast(textErrors);
                });
        }
    };

    const onChangeStatus = (id, statusID) => {
        store
            .dispatch("book-out-list/changeBookOutStatus", {
                id: id,
                statusID: statusID,
            })
            .then((response) => {
                if (response.data.message == "success") {
                    let found = items.value.findIndex((x) => x.id == id);

                    items.value[found].status = {
                        id: statusID,
                        title: response.data.status.title,
                        color: response.data.status.color,
                    };

                    if (statusID == 2) {
                        items.value[found].dateReceive =
                            response.data.dateReceive;

                        response.data.dateReceiveReal = response.data
                            .dateReceive
                            ? dayjs(response.data.dateReceive).format(
                                  "YYYY-MM-DD"
                              )
                            : "";

                        items.value[found].dateReceive = response.data
                            .dateReceive
                            ? dayjs(response.data.dateReceive)
                                  .locale("th")
                                  .format("DD MMM BB")
                            : "";
                    }

                    if (statusID == 4) {
                        items.value[found].dateReturn =
                            response.data.dateReturn;

                        response.data.dateReturnReal = response.data.dateReturn
                            ? dayjs(response.data.dateReturn).format(
                                  "YYYY-MM-DD"
                              )
                            : "";

                        items.value[found].dateReturn = response.data.dateReturn
                            ? dayjs(response.data.dateReturn)
                                  .locale("th")
                                  .format("DD MMM BB")
                            : "";
                    }

                    toast({
                        component: ToastificationContent,
                        props: {
                            title: "รับเรื่องเรียบร้อย",
                            icon: "CheckIcon",
                            variant: "success",
                        },
                    });
                } else {
                    console.log("error");
                }
            })
            .catch((error) => {
                let textErrors = "";
                Object.values(error.response.data.errors).forEach(
                    (textError) => {
                        textErrors = textErrors + textError + "<br>";
                    }
                );
                errorToast(textErrors);
            });
    };

    const onExportExcel = () => {
        dayjs.extend(isBetween);
        // dayjs.extend(isSame)

        let exportExcel = bookOutLists.value.filter((x) => {
            if (
                dayjs(x.dateSendReal).isBetween(
                    exportDate.start,
                    exportDate.end
                )
            ) {
                return true;
            } else {
                let start = dayjs(x.dateSendReal).isSame(exportDate.start);
                let end = dayjs(x.dateSendReal).isSame(exportDate.end);
                if (start == true || end == true) {
                    return true;
                } else {
                    return false;
                }
            }
        });

        let exportExcels = exportExcel.map((x) => {
            //   console.log(x);
            return {
                เลขรับ: x.bookNo,
                เรื่อง: x.title,
                ลงวันที่: x.dateSend,
                วันที่รับเอกสาร: "",
                ผู้รับเอกสาร: "",
            };
        });

        const dataWS = XLSX.utils.json_to_sheet(exportExcels);

        dataWS["!cols"] = [
            { width: 20 },
            { width: 100 },
            { width: 20 },
            { width: 20 },
            { width: 20 },
        ];

        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, dataWS);
        XLSX.writeFile(wb, "export.xlsx");
    };

    watch(
        () => [
            advancedSearch.bookTypeName.code,
            advancedSearch.bookNo,
            advancedSearch.dateSend,
            advancedSearch.toSend,
            advancedSearch.title,
            advancedSearch.fullName,
            advancedSearch.departmentName.code,
            advancedSearch.dateReceive,
            advancedSearch.dateReturn,
            advancedSearch.statusName.code,
            // advancedSearch.favorite.code
        ],
        (newData) => {
            items.value = bookOutLists.value.filter((x) => {
                let bookTypeNameCheck = true;
                if (
                    advancedSearch.bookTypeName.code != "" &&
                    advancedSearch.bookTypeName.code != null
                ) {
                    if(x.bookTypeID == advancedSearch.bookTypeName.code){
                        bookTypeNameCheck = true;
                    }else{
                        bookTypeNameCheck = false;
                    }
                } else {
                    bookTypeNameCheck = true;
                }

                const bookNoCheck =
                    advancedSearch.bookNo != ""
                        ? x.bookNo.includes(advancedSearch.bookNo)
                        : true;

                let dateSendCheck = true;
                if (advancedSearch.dateSend != "") {
                    dateSendCheck = dayjs(x.dateSendReal).isSame(
                        dayjs(advancedSearch.dateSend)
                    );
                }

                const toSendCheck =
                    advancedSearch.toSend != ""
                        ? x.toSend.includes(advancedSearch.toSend)
                        : true;

                const titleCheck =
                    advancedSearch.title != ""
                        ? x.title.includes(advancedSearch.title)
                        : true;

                const fullNameCheck =
                    advancedSearch.fullName != ""
                        ? x.fullName.includes(advancedSearch.fullName)
                        : true;

                let departmentNameCheck = true;
                if (
                    advancedSearch.departmentName.code != "" &&
                    advancedSearch.departmentName.code != null
                ) {
                    if (x.departmentName == null) {
                        departmentNameCheck = false;
                    } else {
                        departmentNameCheck = x.departmentName.includes(
                            advancedSearch.departmentName.title
                        );
                    }
                } else {
                    departmentNameCheck = true;
                }

                let dateReceiveCheck = true;
                if (advancedSearch.dateReceive != "") {
                    dateReceiveCheck = dayjs(x.dateReceiveReal).isSame(
                        dayjs(advancedSearch.dateReceive)
                    );
                }

                let dateReturnCheck = true;
                if (advancedSearch.dateReturn != "") {
                    dateReturnCheck = dayjs(x.dateReturnReal).isSame(
                        dayjs(advancedSearch.dateReturn)
                    );
                }

                let statusNameCheck = true;
                if (
                    advancedSearch.statusName.code != "" &&
                    advancedSearch.statusName.code != null
                ) {
                    if (x.status.title == null) {
                        statusNameCheck = false;
                    } else {
                        statusNameCheck = x.status.title.includes(
                            advancedSearch.statusName.title
                        );
                    }
                }

                // let favoriteCheck = true;
                // if(advancedSearch.favorite.code === 1){
                //   favoriteCheck = x.favorite == true;
                // }

                return (
                    bookTypeNameCheck &&
                    bookNoCheck &&
                    dateSendCheck &&
                    toSendCheck &&
                    titleCheck &&
                    fullNameCheck &&
                    departmentNameCheck &&
                    dateReceiveCheck &&
                    dateReturnCheck &&
                    statusNameCheck
                    // && favoriteCheck
                );
            });

            totalRows.value = items.value.length;
            currentPage.value = 1;
        }
    );

    // *===============================================---*
    // *--------- UI ---------------------------------------*
    // *===============================================---*

    const resolveFavoriteVariant = (fav) => {
        if (fav === true) return "info";
        if (fav === false) return "outline-info";
        return "outline-info";
    };

    if (localStorage.getItem("added") == 1) {
        toast({
            component: ToastificationContent,
            props: {
                title: "เพิ่มเอกสารออกเลขเรียบร้อย",
                icon: "CheckIcon",
                variant: "success",
            },
        });

        localStorage.removeItem("added");
    }

    if (localStorage.getItem("edited") == 1) {
        toast({
            component: ToastificationContent,
            props: {
                title: "Edited Book Out",
                icon: "CheckIcon",
                variant: "success",
            },
        });

        localStorage.removeItem("edited");
    }

    return {
        resolveFavoriteVariant,
        items,
        perPage,
        pageOptions,
        totalRows,
        currentPage,
        sortBy,
        sortDesc,
        sortDirection,
        filter,
        filterOn,
        visibleFields,
        sortOptions,
        onFiltered,
        table,
        onConfirmDelete,
        showBtnAdmin,
        advancedSearch,
        selectOptions,
        onFavoriteChange,
        onChangeStatus,
        exportDate,
        onExportExcel,
        statusCount
    };
}
