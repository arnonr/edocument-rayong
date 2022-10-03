export default [
    {
      path: "/user",
      name: "user-list",
      component: () => import("@/views/users/UserList.vue"),
      meta: {
        pageTitle: "รายการผู้ใช้งาน",
        resource: "AdminUser",
        action: "manage",
      },
    },
    {
      path: "/user/edit/:id",
      name: "user-edit",
      component: () => import("@/views/users/edit/UserEdit.vue"),
      meta: {
        pageTitle: "แก้ไขผู้ใช้งาน",
        resource: "AdminUser",
        action: "manage",
      },
    },
  ];
  