export default [
    {
      path: "/book-type",
      name: "book-type-list",
      component: () => import("@/views/book-type/BookTypeList.vue"),
      meta: {
        pageTitle: "ประเภทเอกสารออกเลข",
        resource: "AdminUser",
        action: "manage",
      },
    },
    {
        path: "/book-type/add",
        name: "book-type-add",
        component: () => import("@/views/book-type/add/BookTypeAdd.vue"),
        meta: {
          pageTitle: "เพิ่มประเภท เอกสารออกเลข",
          resource: "AdminUser",
          action: "manage",
        },
      },
    {
      path: "/book-type/edit/:id",
      name: "book-type-edit",
      component: () => import("@/views/book-type/edit/BookTypeEdit.vue"),
      meta: {
        pageTitle: "แก้ไข ประเภทเอกสารออกเลข",
        resource: "AdminUser",
        action: "manage",
      },
    },
  ];
  