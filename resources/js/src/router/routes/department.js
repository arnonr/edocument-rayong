export default [
    {
      path: "/department",
      name: "department-list",
      component: () => import("@/views/department/DepartmentList.vue"),
      meta: {
        pageTitle: "รายการหน่วยงาน",
        resource: "AdminUser",
        action: "manage",
      },
    },
    {
        path: "/department/add",
        name: "department-add",
        component: () => import("@/views/department/add/DepartmentAdd.vue"),
        meta: {
          pageTitle: "สร้างหน่วยงาน",
          resource: "AdminUser",
          action: "manage",
        },
      },
    {
      path: "/department/edit/:id",
      name: "department-edit",
      component: () => import("@/views/department/edit/DepartmentEdit.vue"),
      meta: {
        pageTitle: "แก้ไขหน่วยงาน",
        resource: "AdminUser",
        action: "manage",
      },
    },
  ];
  