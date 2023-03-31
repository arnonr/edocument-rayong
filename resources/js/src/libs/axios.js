import Vue from 'vue'

// axios
import axios from 'axios'

let baseUrl = "http://edoc.rayong.kmutnb.ac.th/api";
if (location.hostname === "localhost" || location.hostname === "127.0.0.1"){
  baseUrl = "http://localhost/api/";
}
//
const axiosIns = axios.create({
  // You can add your headers here
  // ================================
  baseURL: baseUrl,
  // baseURL: 'http://localhost:8105/api/',
  // timeout: 1000,
  // headers: {'X-Custom-Header': 'foobar'}
})

Vue.prototype.$http = axiosIns

export default axiosIns
