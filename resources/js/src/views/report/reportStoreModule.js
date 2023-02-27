import axios from "@axios";

export default {
  namespaced: true,
  state: {
    year: {
      id: 1,
      name: "2566",
    },
  },
  getters: {},
  mutations: {
    SET_YEAR(state, val) {
      state.year = val;
    },
  },
  actions: {
    fetchBookYears(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-year`, { params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    
    fetchBookIns(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-in/`, { params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    // 
    
    fetchBookInCategories(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-in-category`, { params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookOuts(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-out/`, { params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookOutCategories(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-out-category`, { params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookInTypes(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-in-type`, { params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
  },
};
