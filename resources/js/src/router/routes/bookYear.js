export default [
    {
      path: "/book-year",
      name: "book-year-list",
      component: () => import("@/views/book-year/BookYearList.vue"),
      meta: {
        pageTitle: "ปี",
        resource: "AdminUser",
        action: "manage",
      },
    },
    {
        path: "/book-year/add",
        name: "book-year-add",
        component: () => import("@/views/book-year/add/BookYearAdd.vue"),
        meta: {
          pageTitle: "เพิ่มปี",
          resource: "AdminUser",
          action: "manage",
        },
      },
    {
      path: "/book-year/edit/:id",
      name: "book-year-edit",
      component: () => import("@/views/book-year/edit/BookYearEdit.vue"),
      meta: {
        pageTitle: "แก้ไขปี",
        resource: "AdminUser",
        action: "manage",
      },
    },
  ];
  