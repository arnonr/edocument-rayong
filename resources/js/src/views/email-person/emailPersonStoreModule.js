import axios from "@axios";

export default {
  namespaced: true,
  getters: {},
  actions: {
    fetchEmailPersons(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get("/email/person", { params: queryParams })
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
    addEmailPerson(ctx, dataSend) {
      return new Promise((resolve, reject) => {
        axios
          .post("/email/person", dataSend)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },

    editEmailPerson(ctx, dataSend) {
      return new Promise((resolve, reject) => {
        axios
          .put(`/email/person/${dataSend.id}`, dataSend)
          .then((response) => {
            return resolve(response);
          })
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
