<template>
  <div class="row justify-content-center">
    <div class="col-sm-6 mt-5  mb-5">
      <Question :text="questionText" @answer="getAnswer" @previousQuestion="getPrevious"/>
      <hr class="my-4">
      <p class="fs-5">Domanda {{$route.params.id}}/{{numQuestions}}</p>
    </div>
  </div>
</template>

<script>
import Question from '../components/Question.vue'
import router from '../router'

export default {
  name: 'Survey',
  components: {
    Question
  },
  data() {
    return {
      numQuestions: 0,
      questionText: ''
    }
  },
  methods: {
    async getAnswer(answer) {
      // comunico al server la risposta se è nuova o cambiata
      if (answer.isNew) {
        await this.sendAnswer(answer.answer)
      } else {
      }

      // calcolo l'id della prossima domanda
      let actual = parseInt(this.$route.params.id) + 1

      // controllo se caricare un'altra domanda o passare al risultato
      if (actual <= this.numQuestions) {
        // carico la prossima domanda dal server
        const res = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/questions/${actual}`)
        const data = await res.json()
        this.questionText = data.text
        
        // cambio route
        router.push(`/survey/${actual}`)
      } else {
        router.push('/result')
      }
    },
    async getPrevious(answer) {
      // comunico al server la risposta se necessario
      if (answer.isNew)
        await this.sendAnswer(answer.answer)
      
      // estraggo il numero della domanda dal'URL
      let actual = parseInt(this.$route.params.id) - 1

      // carico la prossima domanda dal server
      const res = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/questions/${actual}`)
      const data = await res.json()
      this.questionText = data.text

      // aggiorno la route
      router.push(`/survey/${actual}`)
    },
    async sendAnswer(answer) {
      let newAnswer = true
      
      // preparo la risposta da inviare al server
      let toReg = {
        "answer": answer,
        "question": this.$route.params.id
      }

      // richiedo la prossima domanda alla quale l'utente deve rispondere
      const res = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/users/last`, {
          method: 'GET',
          headers: { 'Authorization': 'Bearer ' + sessionStorage['token'] }
      })
      let user = await res.json()

      // controllo se sto rispondendo ad una vecchia domanda
      if (user.last === parseInt(this.$route.params.id)) {
        user.last += 1
      } else {
        newAnswer = false
      }

      // se è una nuova risposta la registro, altrimenti richiedo l'update
      if (newAnswer) {
        await fetch(`${process.env.VUE_APP_API_ENDPOINT}/answers`, {
          method: 'POST',
          headers: { 'Content-type': 'application/json', 'Authorization': 'Bearer ' + sessionStorage['token'] },
          body: JSON.stringify(toReg)
        })
      } else {
        await fetch(`${process.env.VUE_APP_API_ENDPOINT}/answers`, {
          method: 'PUT',
          headers: { 'Content-type': 'application/json', 'Authorization': 'Bearer ' + sessionStorage['token'] },
          body: JSON.stringify(toReg)
        })
      }
      
      // update utente
      if (newAnswer) {
        const req = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/users/last`, {
          method: 'PUT',
          headers: { 'Content-type': 'application/json', 'Authorization': 'Bearer ' + sessionStorage['token'] },
          body: JSON.stringify({ 'last' : user.last })
        })
        const data = await req.json()
      }
    }
  },
  async created() {
    // richiedo la prossima domanda alla quale l'utente deve rispondere
    const resUser = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/users/last`, {
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + sessionStorage['token'] }
    })
    const user = await resUser.json()

    // carico il numero totale di domande
    const resCount = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/questions/count`)
    const count = await resCount.json()
    this.numQuestions = count.count

    // controllo se la route coincide con la prossima domanda (non permetto all'utente di usare l'url)
    if (user.last !== this.$route.params.id) {
      // controllo se caricare una vecchia domanda o passare al risultato
      if (user.last <= this.numQuestions) {
        router.push(`/survey/${user.last}`)
      } else {
        router.push('/result')
      }
    }

    // carico la domanda dal server in base alla route
    const resQuestion = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/questions/${user.last}`)
    const data = await resQuestion.json()
    this.questionText = data.text
  }
}
</script>
