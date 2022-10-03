export default [
    {
      path: "/category",
      name: "category-list",
      component: () => import("@/views/category/CategoryList.vue"),
      meta: {
        pageTitle: "ประเภทเอกสารรับเข้า-ส่งออก",
        resource: "AdminUser",
        action: "manage",
      },
    },
    {
        path: "/category/add",
        name: "category-add",
        component: () => import("@/views/category/add/CategoryAdd.vue"),
        meta: {
          pageTitle: "เพิ่มประเภทเอกสารรับเข้า-ส่งออก",
          resource: "AdminUser",
          action: "manage",
        },
      },
    {
      path: "/category/edit/:id",
      name: "category-edit",
      component: () => import("@/views/category/edit/CategoryEdit.vue"),
      meta: {
        pageTitle: "แก้ไขประเภทเอกสารรับเข้า-ส่งออก",
        resource: "AdminUser",
        action: "manage",
      },
    },
    {
        path: "/category/code-edit",
        name: "book-code-edit",
        component: () => import("@/views/category/codeEdit/CodeEdit.vue"),
        meta: {
          pageTitle: "แก้ไขเลขเอกสารรับเข้า-ส่งออก",
          resource: "AdminUser",
          action: "manage",
        },
      },
  ];
  