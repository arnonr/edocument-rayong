import axios from "@axios";

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchEmailPersons(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/email/person`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchEmailPerson(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/email/person/${id}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    addEmailPerson(ctx, emailPersonData) {
      return new Promise((resolve, reject) => {
        axios
          .post("/email/person", emailPersonData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editEmailPerson(ctx, emailPersonData) {
      return new Promise((resolve, reject) => {
        axios
          .put("/email/person", emailPersonData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    deleteEmailPerson(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/email/person/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
  },
};
