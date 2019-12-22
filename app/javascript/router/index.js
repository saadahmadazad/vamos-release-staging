import Vue from 'vue'
import Router from 'vue-router'
import routes from './routes'

Vue.use(Router)
const ROUTES = [
  // Default route
  { path: '*', redirect: '/system/dashboard' }
].concat(routes)

const router = new Router({
  base: '/',
  mode: 'history',
  routes: ROUTES
})

router.beforeEach(async (to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    next()
  } else {
    next()
  }
})
export default router
