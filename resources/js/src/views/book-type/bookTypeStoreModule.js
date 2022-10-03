import axios from "@axios";

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchBookTypes(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookType`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookType(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookType/${id}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    addBookType(ctx, bookTypeData) {
      return new Promise((resolve, reject) => {
        axios
          .post("/bookType", bookTypeData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editBookType(ctx, bookTypeData) {
      return new Promise((resolve, reject) => {
        axios
          .put("/bookType", bookTypeData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    deleteBookType(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/bookType/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },

    fetchBookYears(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookYear`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
  },
};
