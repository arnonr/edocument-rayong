export default [
    {
      path: "/setting/edit",
      name: "setting-edit",
      component: () => import("@/views/setting/SettingEdit.vue"),
      meta: {
        pageTitle: "แก้ไขเมล",
        resource: "AdminUser",
        action: "manage",
      },
    },
  ];
  