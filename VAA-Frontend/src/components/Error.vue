<template>
    <p>{{text}}</p>
</template>

<script>
export default {
    name: 'Error',
    props: {
        text: String
    }
}
</script>

<style scoped>
p {
    color: red;
    margin-top: 10px;
}
</style>