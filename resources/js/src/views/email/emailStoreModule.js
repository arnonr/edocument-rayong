import axios from "@axios";

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchSetting(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`/setting`)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
    editSetting(ctx, settingData) {
      return new Promise((resolve, reject) => {
        axios
          .put("/setting", settingData)
          .then((response) => resolve(response))
          .catch((error) => reject(error));
      });
    },
  },
};
