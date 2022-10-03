import Vue from "vue";
import VueRouter from "vue-router";

// Routes
import { canNavigate } from "@/libs/acl/routeProtection";
import {
  isUserLoggedIn,
  getUserData,
  getHomeRouteForLoggedInUser,
} from "@/auth/utils";
import pages from "./routes/pages";
import profile from "./routes/profile";
import bookIn from "./routes/bookIn";
import bookOut from "./routes/bookOut";
import user from "./routes/user";
import department from "./routes/department";
import bookType from "./routes/bookType";
import category from "./routes/category";
import bookStatus from "./routes/bookStatus";
import setting from "./routes/setting";
import emailPerson from "./routes/emailPerson";
import emailGroup from "./routes/emailGroup";
import report from "./routes/report";
import bookYear from "./routes/bookYear";

Vue.use(VueRouter);

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  scrollBehavior() {
    return { x: 0, y: 0 };
  },
  routes: [
    {
      path: "/",
      name: "home",
      component: () => import("@/views/Home.vue"),
      meta: {
        pageTitle: "Home",
        breadcrumb: [
          {
            text: "Home",
            active: true,
          },
        ],
      },
    },
    ...pages,
    ...profile,
    ...bookIn,
    ...bookOut,
    ...user,
    ...department,
    ...bookType,
    ...category,
    ...bookStatus,
    ...setting,
    ...emailPerson,
    ...emailGroup,
    ...report,
    ...bookYear,
    {
      path: "*",
      redirect: "error-404",
    },
  ],
});

router.beforeEach((to, _, next) => {
  const isLoggedIn = isUserLoggedIn();

  if (!canNavigate(to)) {
    // Redirect to login if not logged in
    if (!isLoggedIn) return next({ name: "auth-login" });

    // If logged in => not authorized
    return next({ name: "misc-not-authorized" });
  }

  // Redirect if logged in
  if (to.meta.redirectIfLoggedIn && isLoggedIn) {
    const userData = getUserData();
    next(getHomeRouteForLoggedInUser(userData ? userData.role : null));
  }

  return next();
});

// ? For splash screen
// Remove afterEach hook if you are not using splash screen
router.afterEach(() => {
  // Remove initial loading
  const appLoading = document.getElementById("loading-bg");
  if (appLoading) {
    appLoading.style.display = "none";
  }
});

export default router;
