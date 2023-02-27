import axios from "@axios";

export default {
  namespaced: true,
  getters: {},
  actions: {
    fetchEmailGroups(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/email/group`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchEmailGroup(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/email/group/${id}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    addEmailGroup(ctx, emailGroupData) {
      var form_data = new FormData();

      for (var key in emailGroupData) {
        if (key == "email_all") {
          emailGroupData[key] = JSON.stringify(emailGroupData[key]);
        }
        form_data.append(key, emailGroupData[key]);
      }

      return new Promise((resolve, reject) => {
        axios
          .post("/email/group", form_data, {
            headers: {
              "content-type": "multipart/form-data",
            },
          })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editEmailGroup(ctx, emailGroupData) {
      var form_data = new FormData();

      for (var key in emailGroupData) {
        if (key == "email_all") {
          emailGroupData[key] = JSON.stringify(emailGroupData[key]);
        }
        form_data.append(key, emailGroupData[key]);
      }
      form_data.append("_method", "PUT");

      return new Promise((resolve, reject) => {
        axios
          .post(`/email/group/${emailGroupData.id}`, form_data, {
            headers: {
              "content-type": "multipart/form-data",
            },
          })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    deleteEmailGroup(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/email/group/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },

    fetchEmailPersons(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get("/email/person", { params: queryParams })
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
  },
};
