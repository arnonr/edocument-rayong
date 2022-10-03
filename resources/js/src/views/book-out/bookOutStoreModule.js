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
    fetchBookOuts(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookOut`)
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
    fetchBookOut(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookOut/${id}`)
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
    fetchBookTypesYear(ctx, { yearID }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookType`,{params: {yearID: 1 }})
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
    fetchBookStatus(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/bookStatus`)
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

    addBookOut(ctx, bookInData) {
      var form_data = new FormData();

      for (var key in bookInData) {
        if (key == "bookTo") {
          bookInData[key] = JSON.stringify(bookInData[key]);
        }
        form_data.append(key, bookInData[key]);
      }

      return new Promise((resolve, reject) => {
        axios
          .post("/bookOut", form_data, {
            headers: {
              "content-type": "multipart/form-data",
            },
          })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editBookOut(ctx, bookInData) {
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
          .post("/bookOut/", form_data, {
            headers: {
              "content-type": "multipart/form-data",
            },
          })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },

    deleteBookOut(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/bookOut/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },

    addBookOutFavorite(ctx, bookOutFavoriteData) {
      return new Promise((resolve, reject) => {
        axios
          .post(`/bookOutFavorite/`, bookOutFavoriteData)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
    deleteBookOutFavorite(ctx, bookOutFavoriteData) {
      return new Promise((resolve, reject) => {
        axios
          .post(`/bookOutFavorite/delete/`, bookOutFavoriteData)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
    changeBookOutStatus(ctx, bookOutData) {
      return new Promise((resolve, reject) => {
        axios
          .put(`/bookOut/changeStatus`, bookOutData)
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
