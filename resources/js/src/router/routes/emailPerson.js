export default [
    {
      path: "/email-person",
      name: "email-person-list",
      component: () => import("@/views/email-person/EmailPersonList.vue"),
      meta: {
        pageTitle: "รายการเมลบุคคล",
        resource: "AdminUser",
        action: "manage",
      },
    },
    {
        path: "/email-person/add",
        name: "email-person-add",
        component: () => import("@/views/email-person/add/EmailPersonAdd.vue"),
        meta: {
          pageTitle: "สร้างเมลบุคคล",
          resource: "AdminUser",
          action: "manage",
        },
      },
    {
      path: "/email-person/edit/:id",
      name: "email-person-edit",
      component: () => import("@/views/email-person/edit/EmailPersonEdit.vue"),
      meta: {
        pageTitle: "แก้ไขเมลบุคคล",
        resource: "AdminUser",
        action: "manage",
      },
    },
  ];
  