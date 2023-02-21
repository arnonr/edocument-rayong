export default [
  {
    path: "/book-out-list",
    name: "book-out-list",
    component: () => import("@/views/book-out/BookOutList.vue"),
    meta: {
      pageTitle: "รายการเอกสารออกเลข",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-out-add",
    name: "book-out-add",
    component: () => import("@/views/book-out/add/BookOutAdd.vue"),
    meta: {
      pageTitle: "สร้างเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-out-edit/:id",
    name: "book-out-edit",
    component: () => import("@/views/book-out/edit/BookOutEdit.vue"),
    meta: {
      pageTitle: "แก้ไขเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-out/view/:id",
    name: "book-out-view",
    component: () => import("@/views/book-out/view/BookOutView.vue"),
    meta: {
      pageTitle: "ดูข้อมูลเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-out-old",
    name: "book-out-old",
    component: () => import("@/views/book-out/old/BookOutOldList.vue"),
    meta: {
      pageTitle: "ดูข้อมูลเอกสารย้อนหลัง",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-out-old/view/:id",
    name: "book-out-old-view",
    component: () => import("@/views/book-out/old/view/BookOutOldView.vue"),
    meta: {
      pageTitle: "ดูข้อมูลเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-out-old/edit/:id",
    name: "book-out-old-edit",
    component: () => import("@/views/book-out/old/edit/BookOutOldEdit.vue"),
    meta: {
      pageTitle: "แก้ไขเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
   {
    path: "/book-out-old/add",
    name: "book-out-old-add",
    component: () => import("@/views/book-out/old/add/BookOutOldAdd.vue"),
    meta: {
       pageTitle: "สร้างเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
];
