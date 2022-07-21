<template>
    <div class="row justify-content-center mt-5">
        <div class="col-sm-6 justify-content-center ">
            <p class="h3 text-center">Il risultato è:</p>
            <p class="fs-5 text-center">{{result}}</p>
            <hr class="mb-5">
            <div class="my-5">
                <svg height="20rem" width="20rem" class="m-auto d-block m-auto">
                    <!-- assi -->
                    <line x1="0%" y1="50%" x2="100%" y2="50%" style="stroke:rgb(0,0,0);stroke-width:2" />
                    <line x1="50%" y1="0%" x2="50%" y2="100%" style="stroke:rgb(0,0,0);stroke-width:2" />
                    
                    <!-- partiti -->
                    <image v-for="logo in loghi" :key="logo.nome" :href="logo.link" height="15%" width="15%" :x="logo.x" :y="logo.y" />

                    <!-- risultato -->
                    <image href="loghi/result.png" height="15%" width="15%" :x="x" :y="y" />
                </svg>
            </div>
            <div class="d-grid">
                <button type="submit" @click="onClick" class="btn btn-primary mb-5">Fine</button>
            </div>
        </div>
    </div>
</template>

<script>
import router from '../router'
import settings from '../loghi.js'

export default {
    name: 'Result',
    data: () => {
        return {
            x: 0,
            y: 0,
            result: "",
            loghi: []
        }
    },
    methods: {
        onClick() {
            // cancello le varibili di sessione e torno al login
            sessionStorage.clear()
            router.push('/')
        }
    },
    async created() {
        // richiedo il risultato al server
        const res = await fetch(`${process.env.VUE_APP_API_ENDPOINT}/result`, {
            method: 'GET',
            headers: { 'Authorization': 'Bearer ' + sessionStorage['token'] }
        })
        const data = await res.json()

        // aggiorno le variabili
        this.x = Math.round( data.x * 100 )
        this.y = Math.round( data.y * 100 )
        this.result = "Risultato"
    },
    mounted() {
        this.loghi = [...settings.loghi]
    }
}
</script>