import { ref, watch, watchEffect, reactive } from "@vue/composition-api";
import store from "@/store";

// Notification
import { useToast } from "vue-toastification/composition";
import ToastificationContent from "@core/components/toastification/ToastificationContent.vue";
import Swal from "sweetalert2";

export default function useMouList() {
  const toast = useToast();

  const errorToast = (message) => {
    toast({
      component: ToastificationContent,
      props: {
        title: "Error : " + message,
        icon: "AlertTriangleIcon",
        variant: "danger",
      },
    });
  };

  // Start List
  const isViewModal = ref(false);
  const isModal = ref(false);
  const isAddModal = ref(false);
  const isSubmit = ref(false);
  const isOverLay = ref(false);
  const perPage = ref({ title: "10", code: 10 });
  const currentPage = ref(1);
  const totalPage = ref(1);
  const totalItems = ref(0);
  const orderBy = ref({ title: "id", code: "id" });
  const order = ref({ title: "DESC", code: "desc" });
  const admin = ref(true);

  const items = ref([]);

  const blankMou = {
    id: null,
    name: "",
    partner: "",
    partner_logo_file: null,
    partner_logo_file_old: null,
    mou_file_file: null,
    mou_file_old: null,
    host_id: { title: null, code: null },
    country_code: { title: null, code: null },
    start_date: null,
    end_date: null,
    address: "",
    type: { title: null, code: null },
    is_publish: { title: "Publish", code: 1 },
  };
  const item = ref(JSON.parse(JSON.stringify(blankMou)));

  const advancedSearch = reactive({
    name: "",
    partner: "",
    host_id: null,
    country_code: null,
    start_date: null,
    end_date: null,
    type: null,
    is_publish: { title: "Publish", code: 1 },
    status: null,
  });

  const selectOptions = ref({
    hosts: [],
    countries: [],
    types: [
      //   { title: "-- All Types -- ", code: "" },
      { title: "ในประเทศ", code: 1 },
      { title: "ต่างประเทศ", code: 2 },
    ],
    statuses: [
      //   { title: "-- All Statuses -- ", code: "" },
      { title: "Active", code: "active" },
      { title: "InActive", code: "inActive" },
      { title: "Warning", code: "warning" },
    ],
    is_publish: [
      //   { title: "-- All Publish -- ", code: "" },
      { title: "Publish", code: 1 },
      { title: "Non-Publish", code: 0 },
    ],
    perPage: [
      { title: "1", code: 1 },
      { title: "2", code: 2 },
      { title: "10", code: 10 },
      { title: "20", code: 20 },
      { title: "50", code: 50 },
    ],
    orderBy: [
      { title: "id", code: "id" },
      { title: "Name", code: "name" },
      { title: "Partner", code: "partner" },
      { title: "Host", code: "host" },
      { title: "Type", code: "type" },
      { title: "Country", code: "country_code" },
      { title: "Status", code: "status" },
      { title: "Start Date", code: "start_date" },
      { title: "End Date", code: "end_date" },
      { title: "Is Publish", code: "is_publish" },
    ],
    order: [
      { title: "ASC", code: "asc" },
      { title: "DESC", code: "desc" },
    ],
  });

  //   const refetchData = () => {
  //     refetchClient({
  //       q: searchQuery.value,
  //     });
  //   };

  //   const refetchClient = (config) => {
  //     const {
  //       q = "",
  //       perPage = 25,
  //       page = 1,
  //       sort_by = "id",
  //       sort_desc = false,
  //     } = config;

  //     const queryLowered = q.toLowerCase();
  //     const filteredData = initialItems.value.filter((data) => {
  //       return (
  //         data.name_th?.toLowerCase().includes(queryLowered) ||
  //         data.name_en?.toLowerCase().includes(queryLowered) ||
  //         data.province.label?.toLowerCase().includes(queryLowered) ||
  //         data.amphur.label?.toLowerCase().includes(queryLowered) ||
  //         data.tumbol.label?.toLowerCase().includes(queryLowered)
  //       );
  //     });

  //     const sortedData = filteredData.sort(sortCompare(sort_by));
  //     if (sort_desc) sortedData.reverse();

  //     items.value = paginateArray(sortedData, perPage, page);
  //     totalProjects.value = filteredData.length;
  //   };

  //   const initDataConvert = (data) => {
  //     return data;
  //   };

  store
    .dispatch("mou/fetchHosts")
    .then((response) => {
      const { data } = response.data;
      selectOptions.value.hosts = data.map((d) => {
        return {
          code: d.id,
          title: d.name,
        };
      });
    })
    .catch((error) => {
      console.log(error);
      toast({
        component: ToastificationContent,
        props: {
          title: "Error fetching Host's list",
          icon: "AlertTriangleIcon",
          variant: "danger",
        },
      });
    });

  store
    .dispatch("mou/fetchCountries")
    .then((response) => {
      const { data } = response.data;
      selectOptions.value.countries = data.map((d) => {
        return {
          code: d.ct_code,
          title: d.ct_nameTHA,
        };
      });
    })
    .catch((error) => {
      console.log(error);
      toast({
        component: ToastificationContent,
        props: {
          title: "Error fetching Country's list",
          icon: "AlertTriangleIcon",
          variant: "danger",
        },
      });
    });

  const fetchItems = (ctx, callback) => {
    let search = { ...advancedSearch };
    if (search.host_id) {
      if (search.host_id.hasOwnProperty("code")) {
        search.host_id = search.host_id.code;
      }
    }
    if (search.country_code) {
      if (search.country_code.hasOwnProperty("code")) {
        search.country_code = search.country_code.code;
      }
    }
    if (search.type) {
      if (search.type.hasOwnProperty("code")) {
        search.type = search.type.code;
      }
    }
    if (search.status) {
      if (search.status.hasOwnProperty("code")) {
        search.status = search.status.code;
      }
    }
    if (search.is_publish) {
      if (search.is_publish.hasOwnProperty("code")) {
        search.is_publish = search.is_publish.code;
      }
    }

    isOverLay.value = true;
    store
      .dispatch("mou/fetchMous", {
        // year_id: store.state.project.year.id,
        perPage: perPage.value.code,
        currentPage: currentPage.value == 0 ? undefined : currentPage.value,
        orderBy: orderBy.value.code,
        order: order.value.code,
        ...search,
      })
      .then((response) => {
        // const { data, totalData, totalPage } = response.data;
        items.value = response.data.data;
        totalPage.value = response.data.totalPage;
        totalItems.value = response.data.totalData;
        isOverLay.value = false;
      })
      .catch((error) => {
        console.log(error);
        toast({
          component: ToastificationContent,
          props: {
            title: "Error fetching Mou's list",
            icon: "AlertTriangleIcon",
            variant: "danger",
          },
        });
        isOverLay.value = false;
      });
  };
  fetchItems();

  // End List

  // Start Form
  const onSubmit = () => {
    isSubmit.value = true;
    isOverLay.value = true;

    let dataSend = {
      name: item.value.name,
      partner: item.value.partner,
      partner_logo_file: item.value.partner_logo_file,
      mou_file: item.value.mou_file,
      host_id: item.value.host_id.code,
      country_code: item.value.country_code.code,
      start_date: item.value.start_date,
      end_date: item.value.end_date,
      address: item.value.address,
      type: item.value.type.code,
      is_publish: item.value.is_publish.code,
    };

    if (item.value.id == null) {
      store
        .dispatch("mou/addMou", dataSend)
        .then(async (response) => {
          if (response.status == 200) {
            let { data } = response;

            fetchItems();

            isSubmit.value = false;
            isModal.value = false;
            isOverLay.value = false;

            toast({
              component: ToastificationContent,
              props: {
                title: "Success : Added Mou",
                icon: "CheckIcon",
                variant: "success",
              },
            });
          } else {
            isSubmit.value = false;
            isOverLay.value = false;
            errorToast(response.data);
          }
        })
        .catch((error) => {
          isSubmit.value = false;
          isOverLay.value = false;

          let errorText = error.response.data.error.message.replaceAll(
            "mou.",
            ""
          );
          errorText = errorText.replaceAll("\n", "<br>");
          errorText = errorText.slice(0, 0) + "<br>" + errorText.slice(0);
          errorToast(errorText);
        });
    } else {
      // Update
      dataSend["mou_id"] = item.value.id;

      store
        .dispatch("mou/editMou", dataSend)
        .then(async (response) => {
          if (response.status == 200) {
            let { data } = response;

            // data = initDataConvert(data);

            // const indexInit = initialItems.value.findIndex((e) => {
            //     return item.value.id === e.id;
            // });

            // initialItems.value.splice(indexInit, 1, { ...data });

            // const index = items.value.findIndex((e) => {
            //     return item.value.id === e.id;
            // });
            // items.value.splice(index, 1, { ...data });

            fetchItems();

            isSubmit.value = false;
            isModal.value = false;
            isOverLay.value = false;

            toast({
              component: ToastificationContent,
              props: {
                title: "Success : Updated Mou",
                icon: "CheckIcon",
                variant: "success",
              },
            });
          } else {
            isSubmit.value = false;
            isOverLay.value = false;

            errorToast(response.data);
          }
        })
        .catch((error) => {
          isSubmit.value = false;
          isOverLay.value = false;

          let errorText = error.response.data.error.message.replaceAll(
            "mou.",
            ""
          );
          errorText = errorText.replaceAll("\n", "<br>");
          errorText = errorText.slice(0, 0) + "<br>" + errorText.slice(0);
          errorToast(errorText);
        });
    }
  };
  // const validationForm = () => {
  //   simpleRules.value.validate().then((success) => {
  //     if (success) {
  //       onSubmit();
  //     }
  //   });
  // };

  const onDelete = () => {
    Swal.fire({
      title: "Are you sure?",
      text: "You won't be able to revert this!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: "Yes, delete it!",
      customClass: {
        confirmButton: "btn btn-primary",
        cancelButton: "btn btn-outline-danger ml-1",
      },
      buttonsStyling: false,
    }).then((result) => {
      if (result.isConfirmed) {
        isOverLay.value = true;
        store
          .dispatch("mou/deleteMou", { id: item.value.id })
          .then(async (response) => {
            if (response.status == 200) {
              isOverLay.value = false;

              Swal.fire({
                icon: "success",
                title: "Deleted!",
                text: "Your file has been deleted.",
                customClass: {
                  confirmButton: "btn btn-success",
                },
              });

              fetchItems();
            } else {
              errorToast(response.data);
              isOverLay.value = false;
            }
          })
          .catch((error) => {
            let errorText = error.response.data.error.message.replaceAll(
              "mou.",
              ""
            );
            errorText = errorText.replaceAll("\n", "<br>");
            errorText = errorText.slice(0, 0) + "<br>" + errorText.slice(0);
            errorToast(errorText);
            isOverLay.value = false;
          });
      }
    });
  };

  // 👉 watching current page
  //   watchEffect(() => {
  //     if (currentPage.value > totalPage.value)
  //       currentPage.value = totalPage.value;
  //   });

  //   watch(() => [advancedSearch], () => {
  //     fetchItems();
  //   });

  watch(
    () => advancedSearch.type,
    (value) => {
      if (value) {
        if (value.code == 1) {
          advancedSearch.country_code = { title: "ไทย", code: "THA" };
        } else {
          advancedSearch.country_code = {
            title: "-- All Country --",
            code: null,
          };
        }
      } else {
        advancedSearch.country_code = {
          title: "-- All Country --",
          code: null,
        };
      }
      // item.value.province_id = item.value.province.code;
    }
  );

  watchEffect(() => {
    // console.log(advancedSearch.name)
    fetchItems();
  });

  //   watchEffect(() => {
  //     ;
  //     console.log(currentPage.value);
  //   });

  const onChangePage = (page) => {
    currentPage.value = page;
  };

  // *===============================================---*
  // *--------- UI ---------------------------------------*
  // *===============================================---*

  return {
    fetchItems,
    blankMou,
    items,
    item,
    isModal,
    isAddModal,
    isViewModal,
    isSubmit,
    onSubmit,
    onDelete,
    isOverLay,
    selectOptions,
    advancedSearch,
    perPage,
    order,
    orderBy,
    totalItems,
    totalPage,
    onChangePage,
  };
}
