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
    fetchBookOuts(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-out`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookOutsWithYear(ctx, { yearID }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-out/getWithYear/${yearID}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookOut(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-out/${id}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    addBookOut(ctx, dataSend) {
      var form_data = new FormData();

      for (var key in dataSend) {
        if (key == "book_to") {
          dataSend[key] = JSON.stringify(dataSend[key]);
        }
        form_data.append(key, dataSend[key]);
      }

      return new Promise((resolve, reject) => {
        axios
          .post("/book-out", form_data, {
            headers: {
              "content-type": "multipart/form-data",
            },
          })
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },

    editBookOut(ctx, dataSend) {
      var form_data = new FormData();

      for (var key in dataSend) {
        if (key == "book_to") {
          dataSend[key] = JSON.stringify(dataSend[key]);
        }
        form_data.append(key, dataSend[key]);
      }

      form_data.append("_method", "PUT");

      return new Promise((resolve, reject) => {
        axios
          .post(`/book-out/${dataSend.id}`, form_data, {
            headers: {
              "content-type": "multipart/form-data",
            },
          })
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },

    deleteBookOut(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/book-out/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
    fetchBookYears(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-year`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookStatuses(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-status`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookOutCategories(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-out-category`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchDepartments(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/department`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchEmailPersons(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/email/person`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchEmailGroups(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/email/group`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },

    fetchBookCode(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-out/generate-code`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchUsers(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/user`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    // fetchBookCode(ctx) {
    //   return new Promise((resolve, reject) => {
    //     axios
    //       .get(`/bookCode`)
    //       .then((response) => resolve(response))
    //       .catch((error) => reject(error));
    //   });
    // },
  },
};
