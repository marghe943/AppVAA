<template>
    <div class="fs-5">
        <p>Domanda:</p>
        <p class="h3">{{text}}</p>

        <hr class="my-4">

        <div class="form-check mt-3">
            <input class="form-check-input" type="radio" value="1" v-model="answer" name="answer" id="ans1" /> 
            <label class="form-check-label" for="ans1">    
                completamente d'accordo
            </label>
        </div>    
            
        <div class="form-check">
            <input class="form-check-input" type="radio" value="2" v-model="answer" name="answer" id="ans2" /> 
            <label class="form-check-label" for="ans2">
                d'accordo
            </label>
        </div>
            
        <div class="form-check">
            <input class="form-check-input" type="radio" value="3" v-model="answer" name="answer" id="ans3" /> 
            <label class="form-check-label" for="ans3">
                né d'accordo né in disaccordo
            </label>
        </div>
            
        <div class="form-check">    
            <input class="form-check-input" type="radio" value="4" v-model="answer" name="answer" id="ans4" /> 
            <label class="form-check-label" for="ans4">
                in disaccordo
            </label>
        </div>
            
        <div class="form-check mb-3">    
            <input class="form-check-input" type="radio" value="5" v-model="answer" name="answer" id="ans5" /> 
            <label class="form-check-label" for="ans5">
                completamente in disaccordo
            </label>
        </div>

        <div class="btn-group d-flex btn-group-lg my-3">
            <button type="submit" class="btn btn-primary" @click="onClickPrevious"  v-if="showButton">Indietro</button>
            <button type="submit" class="btn btn-secondary" v-if="!showButton" disabled>Indietro</button>
            <button type="submit" class="btn btn-primary" @click="onClickNext">Avanti</button>
        </div>

        <Error v-show="errorShow" :text="errorText" />
    </div>
</template>

<script>
import Error from './Error.vue'

export default {
    name: 'Question',
    props: {
        text: String
    }, 
    data() {
        return {
            answer: '',
            oldAnswer: '',
            errorShow: false,
            errorText: '',
            showButton: false
        }
    },
    components: {
        Error
    },
    methods: {
        async onClickNext(e) {
            e.preventDefault()
            const next = parseInt(this.$route.params.id) + 1

            if (this.answer !== '') {
                if (this.errorShow) {
                    this.errorShow = false
                    this.errorText = ''
                }
                
                // controllo se avevo una risposta e l'ho cambiata
                let isNew = true
                if (this.oldAnswer !== '' && this.answer === this.oldAnswer)
                    isNew = false

                // comunico la risposta al component padre
                this.$emit('answer', {'answer' : this.answer, 'isNew' : isNew})
                this.oldAnswer = ''

                // controllo se ho gia risposto alla domanda successiva
                const res = await this.checkIfAnswered(next)
                
                // se non ho una risposta non mostro nessun radio button segnato
                if (!res)
                    this.answer = ''

                if (!this.showButton)
                    this.showButton = true
            } else {
                this.errorText = 'Scegliere una risposta'
                this.errorShow = true
            }
        },
        async onClickPrevious(e) {
            e.preventDefault()
            const actual = parseInt(this.$route.params.id)

            // rimuovo eventuali messaggi d'errore
            if (this.errorShow) {
                this.errorShow = false
                this.errorText = ''
            }

            // attivo l'evento, ho 3 casi (Nessuna Risposta/Risposta non cambiata/Risposta nuova o cambiata)
            if (this.answer === '') {
                this.$emit('previousQuestion', {'answer' : null, 'isNew' : false})
            } else if (this.oldAnswer !== '' && this.answer === this.oldAnswer) {
                this.$emit('previousQuestion', {'answer' : null, 'isNew' : false})
            } else {
                this.$emit('previousQuestion', {'answer' : this.answer, 'isNew' : true})
            }

            // carico la vecchia risposta
            this.oldAnswer = ''
            const res = await this.checkIfAnswered(actual - 1)

            // se non ho una risposta non mostro nessun radio button segnato
            if (!res)
                this.answer = ''
            
            // se sto tornando alla prima domanda nascondo il tasto indietro
            if (actual === 2)
                this.showButton = false
        },
        async checkIfAnswered(question) {
            // richiedo la risposta in base all'utente e alla domanda
            const res = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/answers/${question}`, {
                method: 'GET',
                headers: { 'Authorization': 'Bearer ' + sessionStorage['token'] }
            })
            const data = await res.json()

            if (res.status === 200) {
                // se la risposta è gia registrata, segno il radio button
                if (data.answer != 0) {                
                    this.answer = this.oldAnswer = data.answer
                    return true
                } else {
                    return false
                }
            }
        }
    },
    beforeMount() {
        // se parto da una domanda diversa dalla prima devo mostrare il tasto indietro
        if (parseInt(this.$route.params.id) !== 1)
            this.showButton = true
    }
}
</script>