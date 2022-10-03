import axios from "@axios";

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchYears(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookYear`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookInsWithYear(ctx, { yearID }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookIn/getWithYear/${yearID}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchCategories(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/category`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookOutsWithYear(ctx, { yearID }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookOut/getWithYear/${yearID}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookTypes(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookType`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
  },
};
