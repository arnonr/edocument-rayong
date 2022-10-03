export default [
  {
    path: "/email-group",
    name: "email-group-list",
    component: () => import("@/views/email-group/EmailGroupList.vue"),
    meta: {
      pageTitle: "รายการกลุ่มเมล",
      resource: "AdminUser",
      action: "manage",
    },
  },
  {
      path: "/email-group/add",
      name: "email-group-add",
      component: () => import("@/views/email-group/add/EmailGroupAdd.vue"),
      meta: {
        pageTitle: "สร้างกลุ่ม",
        resource: "AdminUser",
        action: "manage",
      },
    },
  {
    path: "/email-group/edit/:id",
    name: "email-group-edit",
    component: () => import("@/views/email-group/edit/EmailGroupEdit.vue"),
    meta: {
      pageTitle: "แก้ไขกลุ่ม",
      resource: "AdminUser",
      action: "manage",
    },
  },
];
