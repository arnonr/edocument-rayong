import axios from "@axios";

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchCategories(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/category`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchCategory(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/category/${id}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    addCategory(ctx, categoryData) {
      return new Promise((resolve, reject) => {
        axios
          .post("/category", categoryData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editCategory(ctx, categoryData) {
      return new Promise((resolve, reject) => {
        axios
          .put("/category", categoryData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    deleteCategory(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/category/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
    fetchBookCode(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookCode`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },

    editBookCode(ctx, bookCodeData) {
      return new Promise((resolve, reject) => {
        axios
          .put("/bookCode", bookCodeData)
          .then((response) => resolve(response))
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
