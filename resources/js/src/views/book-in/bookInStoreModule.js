import axios from "@axios";

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchBookIns(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookIn`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookInsWithYear(ctx, {yearID}) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookIn/getWithYear/${yearID}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchBookIn(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookIn/${id}`)
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
    fetchDepartments(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/department`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchEmailPersons(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/email/person`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchEmailGroups(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/email/group`)
          .then((response) => resolve(response))
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
    fetchBookCodeOld(ctx, {yearID}) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookCode/old/${yearID}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    addBookIn(ctx, bookInData) {
      var form_data = new FormData();

      for (var key in bookInData) {
        if (key == "bookTo") {
          bookInData[key] = JSON.stringify(bookInData[key]);
        }
        form_data.append(key, bookInData[key]);
      }

      return new Promise((resolve, reject) => {
        axios
          .post("/bookIn", form_data, {
            headers: {
              "content-type": "multipart/form-data",
            },
          })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editBookIn(ctx, bookInData) {
      var form_data = new FormData();

      for (var key in bookInData) {
        if (key == "bookTo") {
          bookInData[key] = JSON.stringify(bookInData[key]);
        }
        form_data.append(key, bookInData[key]);
      }
      form_data.append("_method", "PUT");
      return new Promise((resolve, reject) => {
        axios
          .post("/bookIn/", form_data, {
            headers: {
              "content-type": "multipart/form-data",
            },
          })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    deleteBookIn(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/bookIn/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
    addBookFavorite(ctx, bookFavoriteData) {
      return new Promise((resolve, reject) => {
        axios
          .post(`/bookFavorite/`, bookFavoriteData)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
    deleteBookFavorite(ctx, bookFavoriteData) {
      return new Promise((resolve, reject) => {
        axios
          .post(`/bookFavorite/delete/`, bookFavoriteData)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },

    fetchYears(ctx) {
        return new Promise((resolve, reject) => {
          axios
            .get(`/bookYear`)
            .then((response) => resolve(response))
            .catch((error) => reject(error));
        });
      },
  },
};
