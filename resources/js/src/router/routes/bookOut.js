export default [
    {
        path: "/book-out",
        name: "bookout",
        component: () => import("@/views/book-out/BookOutList.vue"),
        meta: {
            pageTitle: "ระบบออกเลข",
            resource: "User",
            action: "manage",
        },
    },
    {
        path: "/book-out-add",
        name: "bookout-add",
        component: () => import("@/views/book-out/add/BookOutAdd.vue"),
        meta: {
            pageTitle: "สร้างเอกสารออกเลข",
            resource: "User",
            action: "manage",
        },
    },
    {
        path: "/book-out-edit/:id",
        name: "bookout-edit",
        component: () => import("@/views/book-out/edit/BookOutEdit.vue"),
        meta: {
            pageTitle: "แก้ไขเอกสารออกเลข",
            resource: "AdminUser",
            action: "manage",
        },
    },
    {
        path: "/book-out-old",
        name: "bookout-old",
        component: () => import("@/views/book-out/old/BookOutOld.vue"),
        meta: {
            pageTitle: "ดูเอกสารย้อนหลัง",
            resource: "User",
            action: "manage",
        },
    },
    {
        path: "/book-out-old-add",
        name: "bookout-old-add",
        component: () => import("@/views/book-out/old/add/BookOutOldAdd.vue"),
        meta: {
            pageTitle: "เพิ่มเอกสารย้อนหลัง",
            resource: "AdminUser",
            action: "manage",
        },
    },
    {
        path: "/book-out-old-edit",
        name: "bookout-old-edit",
        component: () => import("@/views/book-out/old/edit/BookOutOldEdit.vue"),
        meta: {
            pageTitle: "แก้ไขเอกสารย้อนหลัง",
            resource: "AdminUser",
            action: "manage",
        },
    },
];
