export default [
  {
    path: "/list",
    name: "mou-list",
    component: () => import("@/views/mou/MouList.vue"),
    meta: {
      pageTitle: "รายการ MOU",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/add",
    name: "mou-add",
    component: () => import("@/views/mou/add/MouAdd.vue"),
    meta: {
      pageTitle: "เพิ่ม MOU",
      resource: "StaffUser",
      action: "manage",
    },
  },
  {
    path: "/view/:id",
    name: "mou-view",
    component: () => import("@/views/mou/view/MouView.vue"),
    meta: {
      pageTitle: "ดูข้อมูล MOU",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/edit/:id",
    name: "mou-edit",
    component: () => import("@/views/mou/edit/MouEdit.vue"),
    meta: {
      pageTitle: "แก้ไข MOU",
      resource: "StaffUser",
      action: "manage",
    },
  },
];
