import axios from "@axios";

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchBookYears(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookYear`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookYear(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookYear/${id}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    addBookYear(ctx, bookYearData) {
      return new Promise((resolve, reject) => {
        axios
          .post("/bookYear", bookYearData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editBookYear(ctx, bookYearData) {
      return new Promise((resolve, reject) => {
        axios
          .put("/bookYear", bookYearData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    deleteBookYear(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/bookYear/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
  },
};
