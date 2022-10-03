import axios from "@axios";

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchUsers(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/users`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchUser(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/users/${id}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchDepartments(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/department`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editUser(ctx, userData) {
      return new Promise((resolve, reject) => {
        axios
          .put("/users/", userData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    deleteUser(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/users/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
  },
};
