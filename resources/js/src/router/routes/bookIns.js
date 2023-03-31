export default [
  {
    path: "/book-in-list",
    name: "book-in-list",
    component: () => import("@/views/book-in/BookInList.vue"),
    meta: {
      pageTitle: "รายการเอกสารรับเข้า-ส่งออก",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-in-add",
    name: "book-in-add",
    component: () => import("@/views/book-in/add/BookInAdd.vue"),
    meta: {
      pageTitle: "สร้างเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-in-edit/:id",
    name: "book-in-edit",
    component: () => import("@/views/book-in/edit/BookInEdit.vue"),
    meta: {
      pageTitle: "แก้ไขเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-in/view/:id",
    name: "book-in-view",
    component: () => import("@/views/book-in/view/BookInView.vue"),
    meta: {
      pageTitle: "ดูข้อมูลเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-in-old",
    name: "book-in-old",
    component: () => import("@/views/book-in/old/BookInOldList.vue"),
    meta: {
      pageTitle: "ดูข้อมูลเอกสารย้อนหลัง",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-in-old/view/:id",
    name: "book-in-old-view",
    component: () => import("@/views/book-in/old/view/BookInOldView.vue"),
    meta: {
      pageTitle: "ดูข้อมูลเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
  {
    path: "/book-in-old/edit/:id",
    name: "book-in-old-edit",
    component: () => import("@/views/book-in/old/edit/BookInOldEdit.vue"),
    meta: {
      pageTitle: "แก้ไขเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
   {
    path: "/book-in-old/add",
    name: "book-in-old-add",
    component: () => import("@/views/book-in/old/add/BookInOldAdd.vue"),
    meta: {
       pageTitle: "สร้างเอกสาร",
      resource: "Auth",
      action: "manage",
    },
  },
];
