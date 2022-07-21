<template>
  <div class="row justify-content-center fs-5">
    <div class="col-sm-6 mt-5">
      <LoginForm />
      <router-link to="/signup">Non hai un account? Registrati</router-link>
      <hr class="my-4">
      <p> Oppure accedi con: </p>
    </div>
  </div>
  <div class="row justify-content-center">
    <div class="col-sm-6">
      <div class="btn-group d-flex mb-5" role="group">
        <button type="button" class="btn btn-outline-primary rounded me-3 bg-white text-dark">Google</button>
        <button type="button" class="btn btn-outline-primary rounded bg-white text-dark">Twitter</button>
      </div>
    </div>
  </div>
</template>

<script>
import LoginForm from '../components/LoginForm.vue'

export default {
  name: 'Login',
  components: {
    LoginForm
  }
}
</script>