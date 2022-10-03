import axios from "@axios";

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchBookStatuses(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookStatus`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookStatus(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookStatus/${id}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    addBookStatus(ctx, bookStatusData) {
      return new Promise((resolve, reject) => {
        axios
          .post("/bookStatus", bookStatusData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editBookStatus(ctx, bookStatusData) {
      return new Promise((resolve, reject) => {
        axios
          .put("/bookStatus", bookStatusData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    deleteBookStatus(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/bookStatus/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
  },
};
