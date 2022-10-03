import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchUser(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`user/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    editUser(ctx, profileData) {
      return new Promise((resolve, reject) => {
        axios
          .put('/user', profileData )
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
  },
}
