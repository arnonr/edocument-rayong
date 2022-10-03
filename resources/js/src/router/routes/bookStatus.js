export default [
    {
      path: "/book-status",
      name: "book-status-list",
      component: () => import("@/views/book-status/BookStatusList.vue"),
      meta: {
        pageTitle: "สถานะเอกสาร",
        resource: "AdminUser",
        action: "manage",
      },
    },
    {
        path: "/book-status/add",
        name: "book-status-add",
        component: () => import("@/views/book-status/add/BookStatusAdd.vue"),
        meta: {
          pageTitle: "เพิ่มสถานะเอกสาร",
          resource: "AdminUser",
          action: "manage",
        },
      },
    {
      path: "/book-status/edit/:id",
      name: "book-status-edit",
      component: () => import("@/views/book-status/edit/BookStatusEdit.vue"),
      meta: {
        pageTitle: "แก้ไขสถานะเอกสาร",
        resource: "AdminUser",
        action: "manage",
      },
    },
  ];
  