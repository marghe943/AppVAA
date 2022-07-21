<template>
    <h2>Crea un nuovo Account:</h2>

    <hr class="my-4">

    <form @submit="onSubmit">
        <div class="mb-3">
            <label for="username" class="form-label">Username</label>
            <input type="text" v-model="username" class="form-control" name="username" placeholder="Inserisci il nome" id="username" />
        </div>

        <div class="mb-3">
            <label for="password" class="input-group input-group-lg form-label">Password</label>
            <input type="password" v-model="password" name="password" class="form-control" placeholder="Inserisci la password" id="password" />
        </div>
        
        <input type="submit" value="Registrati" class="btn btn-primary col-sm-4 mb-3"/>
        <Error v-show="errorShow" :text="errorText" />
    </form>
</template>

<script>
    import router from '../router'
    import Error from '../components/Error.vue'

    export default {
        name: 'SignUpForm',
        data: () => {
            return {
                username: '',
                password: '',
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

                // POST per la registrazione
                const res = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/users/register`, {
                    method: 'POST',
                    headers: { 'Content-type': 'application/json' },
                    body: JSON.stringify(user)
                })
                const data = await res.json()

                if (res.status !== 201) {
                    this.errorText = data.message
                    this.errorShow = true  
                    return
                }
                    
                // salvo l'id come variabile di sessione
                sessionStorage['token'] = data.token
                    
                router.push('/survey/1')
                
                this.username = ''
                this.password = ''            
            }
        }
    }
</script>