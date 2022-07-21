<template>
  <Header />
  <div class="container shadow bg-white border rounded-3 mt-2 mb-5">
    <router-view/>
  </div>
  <Footer />
</template>

<script>
import Header from './components/PageHeader.vue'
import Footer from './components/PageFooter.vue'

export default {
  name: 'App',
  components: {
    Header,
    Footer
  }
}
</script>