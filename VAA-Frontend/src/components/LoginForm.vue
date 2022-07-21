<template>
    <h2>Accedi al tuo Account:</h2>

    <hr class="my-4">

    <form @submit="onSubmit">
        <div class="mb-3">
            <label class="form-label">Username</label>
            <input type="text" v-model="username" name="username" class="form-control" placeholder="Inserisci il nome" />
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" v-model="password" name="password" class="form-control" placeholder="Inserisci la password" />
        </div>
        
        <input type="submit" value="Accedi" class="btn btn-primary col-sm-4 mb-3"/>
        <Error v-show="errorShow" :text="errorText" />
    </form>
</template>

<script>
    import router from '../router'
    import Error from '../components/Error.vue'

    export default {
        name: 'LoginForm',
        data: () => {
            return {
                username: '',
                password: '',
                numQuestions: 0,
                errorText: '',
                errorShow: false
            }
        },
        components: {
            Error
        },
        methods: {
            async onSubmit(e) {
                e.preventDefault();

                // se il form non è completo lo notifico
                if (this.username === '' || this.password === '') {
                    this.errorText = 'Inserire tutti i dati'
                    this.errorShow = true  
                    return
                }

                const user = {
                    "user" : this.username, 
                    "password" : this.password
                }

                // POST per il login
                const res = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/users/login`, {
                    method: 'POST',
                    headers: { 'Content-type': 'application/json' },
                    body: JSON.stringify(user)
                })
                const data = await res.json()

                if (res.status !== 200) {
                    this.errorText = data.message
                    this.errorShow = true  
                    return
                }
                    
                // salvo l'id come variabile di sessione
                sessionStorage['token'] = data.token

                // riprendo dall'ultima domanda o dal risultato in base alla cronologia
                if (data.last <= this.numQuestions) {
                    router.push(`/survey/${data.last}`)
                } else {
                    router.push('/result')
                }
            }
        },
        async mounted() {
            // carico il numero totale di domande
            const resCount = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/questions/count`)
            const count = await resCount.json()
            this.numQuestions = count.count

            // se è attiva una sessione carico direttamente la prossima domanda
            if (typeof(sessionStorage['token']) !== 'undefined') {
                // GET numero prossima domanda
                const res = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/users/last`, {
                    method: 'GET',
                    headers: { 'Authorization': 'Bearer ' + sessionStorage['token'] }
                })
                const data = await res.json()

                if (res.status === 200) {
                    if (data.last <= this.numQuestions) {
                        router.push(`/survey/${data.last}`)
                    } else {
                        router.push('/result')
                    }
                } else {
                    // nessun utente ha quell'id, elimino le variabili di sessione
                    sessionStorage.clear()
                }
            }
        }
    }
</script>