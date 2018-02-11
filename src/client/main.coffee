Vue = require 'vue'
VueRouter = require 'vue-router'
Vue.use VueRouter
DMStore = require 'vue-dmstore'
Vue.use new DMStore

API = require 'vue-dmresource'
User = new API 'user',
  me:
    method: 'GET'
    url: '/me'

Home = require './components/Home.vue'

routes = [
  { path: '/', name: 'Home', component: Home }
  { path: '*', component: Home }
]

router = new VueRouter
  base: '/'
  mode: 'history'
  routes: routes

new Vue({
  computed:
    fullPage: -> @$route.name is 'Full Page'
  data:
    user: {}
  router: router
  created: ->
    

}).$mount('#app')
