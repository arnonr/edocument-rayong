import axios from "@axios";

export default {
  namespaced: true,
  state: {
    year: {
      id: 3,
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
    fetchBookIns(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-in`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookInsWithYear(ctx, { yearID }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-in/getWithYear/${yearID}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookIn(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-in/${id}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    addBookIn(ctx, dataSend) {
      var form_data = new FormData();

      for (var key in dataSend) {
        if (key == "book_to") {
          dataSend[key] = JSON.stringify(dataSend[key]);
        }
        form_data.append(key, dataSend[key]);
      }

      return new Promise((resolve, reject) => {
        axios
          .post("/book-in", form_data, {
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

    editBookIn(ctx, dataSend) {
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
          .post(`/book-in/${dataSend.id}`, form_data, {
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

    deleteBookIn(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/book-in/${id}`)
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
    fetchBookInCategories(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-in-category`,{ params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookInTypes(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/book-in-type`,{ params: queryParams })
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
          .get(`/book-in/generate-code`,{ params: queryParams })
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
