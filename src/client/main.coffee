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
Projects = require './components/Projects.vue'
KB = require './components/KnowledgeBase.vue'

routes = [
  { path: '/', name: 'Home', component: Home }
  { path: '/projects', name: 'Projects', component: Projects }
  { path: '/projects/:id', name: 'Project Info', component: Projects }
  { path: '/kb', name: 'Knowledge Base', component: KB }
  { path: '/kb/:id', name: 'Knowledge Base Article', component: KB }
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
