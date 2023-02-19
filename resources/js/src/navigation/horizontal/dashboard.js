export default [
  {
    header: "Menus",
    resource: "Auth",
    action: "read",
  },
  {
    title: "เว็บไซต์/Website",
    href: "http://sci.kmutnb.ac.th",
    icon: "ExternalLinkIcon",
    
    resource: "Auth",
    action: "read",
  },
  {
    title: "เอกสารรับเข้า-ส่งออก",
    route: "book-in-list",
    icon: "FileTextIcon",
    resource: "Auth",
    action: "read",
  },
  {
    title: "รายงาน/Report",
    route: "report",
    icon: "PieChartIcon",
    resource: "Auth",
    action: "read",
  },
  {
    title: "จัดการผู้ใช้งาน/User",
    route: "user-list",
    icon: "UsersIcon",
    resource: "AdminUser",
    action: "manage",
  },
];
