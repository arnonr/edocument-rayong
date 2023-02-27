export default [
    {
      path: "/email-person",
      name: "email-person",
      component: () => import("@/views/email-person/EmailPerson.vue"),
      meta: {
        pageTitle: "รายการเมลบุคคล",
        resource: "AdminUser",
        action: "manage",
      },
    },
    {
      path: "/email-group",
      name: "email-group",
      component: () => import("@/views/email-group/EmailGroup.vue"),
      meta: {
        pageTitle: "รายการเมลกลุ่ม",
        resource: "AdminUser",
        action: "manage",
      },
    },
  ];
  