import axios from "@axios";

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchDepartments(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/department`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    fetchDepartment(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/department/${id}`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    addDepartment(ctx, departmentData) {
      return new Promise((resolve, reject) => {
        axios
          .post("/department", departmentData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editDepartment(ctx, departmentData) {
      return new Promise((resolve, reject) => {
        axios
          .put("/department", departmentData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    deleteDepartment(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`/department/${id}`)
          .then((response) => {
            return resolve(response);
          })
          .catch((error) => reject(error));
      });
    },
  },
};
