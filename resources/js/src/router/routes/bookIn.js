export default [
  {
    path: "/book-in",
    name: "bookin",
    component: () => import("@/views/book-in/BookInList.vue"),
    meta: {
      pageTitle: "เอกสารรับเข้า-ส่งออก",
      resource: "User",
      action: "manage",
    },
  },
  {
    path: "/book-in-add",
    name: "bookin-add",
    component: () => import("@/views/book-in/add/BookInAdd.vue"),
    meta: {
      pageTitle: "เพิ่มเอกสารรับเข้า-ส่งออก",
      resource: "AdminUser",
      action: "manage",
    },
  },
  {
    path: "/book-in-edit/:id",
    name: "bookin-edit",
    component: () => import("@/views/book-in/edit/BookInEdit.vue"),
    meta: {
      pageTitle: "แก้ไขเอกสารรับเข้า-ส่งออก",
      resource: "AdminUser",
      action: "manage",
    },
  },

  {
    path: "/book-in-old",
    name: "bookin-old",
    component: () => import("@/views/book-in/old/BookInOld.vue"),
    meta: {
      pageTitle: "ดูเอกสารย้อนหลัง",
      resource: "AdminUser",
      action: "manage",
    },
  },
  {
    path: "/book-in-old-add",
    name: "bookin-old-add",
    component: () => import("@/views/book-in/old/add/BookInOldAdd.vue"),
    meta: {
      pageTitle: "เพิ่มเอกสารย้อนหลัง",
      resource: "AdminUser",
      action: "manage",
    },
  },
  {
    path: "/book-in-old-edit",
    name: "bookin-old-edit",
    component: () => import("@/views/book-in/old/edit/BookInOldEdit.vue"),
    meta: {
      pageTitle: "แก้ไขเอกสารย้อนหลัง",
      resource: "AdminUser",
      action: "manage",
    },
  },
];
