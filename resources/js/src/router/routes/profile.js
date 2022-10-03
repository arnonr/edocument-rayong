export default [
    {
      path: '/profile',
      name: 'profile',
      component: () => import('@/views/profile/ProfileEdit.vue'),
      meta: {
        pageTitle: "Profile",
        resource: 'Auth',
        action: 'manage',
      },
    },
  ]
  