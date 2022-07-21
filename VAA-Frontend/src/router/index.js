import { createRouter, createWebHashHistory } from 'vue-router'
import Login from '../views/Login.vue'
import SignUp from '../views/SignUp.vue'
import Survey from '../views/Survey.vue'
import Result from '../views/Result.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    redirect: '/login',
    component: null,
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/signup',
    name: 'SignUp',
    component: SignUp
  },
  {
    path: '/survey/:id',
    name: 'Survey',
    component: Survey
  },
  {
    path: '/result',
    name: 'Result',
    component: Result
  }
]

const router = createRouter({
  mode: 'history',
  history: createWebHashHistory(),
  routes
})

export default router
