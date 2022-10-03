export default [
    {
      path: "/email-group",
      name: "email-group-list",
      component: () => import("@/views/emailGroup/EmailGroupList.vue"),
      meta: {
        pageTitle: "รายการกลุ่มเมล",
        resource: "AdminUser",
        action: "manage",
      },
    },
    // {
    //     path: "/email-group/add",
    //     name: "email-group-add",
    //     component: () => import("@/views/emailGroup/add/EmailGroupAdd.vue"),
    //     meta: {
    //       pageTitle: "สร้างกลุ่ม",
    //       resource: "AdminUser",
    //       action: "manage",
    //     },
    //   },
    // {
    //   path: "/group/edit/:id",
    //   name: "group-edit",
    //   component: () => import("@/views/group/edit/GroupEdit.vue"),
    //   meta: {
    //     pageTitle: "แก้ไขกลุ่ม",
    //     resource: "AdminUser",
    //     action: "manage",
    //   },
    // },
  ];
  