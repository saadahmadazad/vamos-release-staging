import "babel-polyfill"
import Vue from 'vue'
import Vuex from 'vuex'
import App from '@/app.vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import VueAuth from '@websanova/vue-auth'
import router from '@/router'
// Custom css
// UI FrameWork
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import locale from 'element-ui/lib/locale/lang/ja'

Vue.prototype.$http = axios
Vue.router = router
Vue.use(VueAxios, axios)
axios.defaults.baseURL = process.env.API_ENDPOINT
Vue.use(VueAuth, {
  auth: require('@websanova/vue-auth/drivers/auth/bearer.js'),
  http: require('@websanova/vue-auth/drivers/http/axios.1.x.js'),
  router: require('@websanova/vue-auth/drivers/router/vue-router.2.x.js'),
  authRedirect: {path: '/auth/sign_in'},
  loginData: {url: '/api/v1/users/sign_in', method: 'POST', redirect: '/system/dashboard', fetchUser: true},
  logoutData: {url: '/api/v1/users/sign_out', method: 'GET', redirect: '/auth/sign_in', makeRequest: false},
  refreshData: {enabled: false},
  fetchData: {url: '/api/v1/current_user', method: 'GET', enabled: true},
  parseUserData: (data) => { return data.user }
})
Vue.use(ElementUI, { locale })

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#application',
    components: {
      App
    },
    template: '<App/>',
    router,
    render: (h) => h(App),
  });
});

