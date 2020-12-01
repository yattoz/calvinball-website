<template>
    <a :href="this.link">
        <!--
        <ShikwasaPlayer
         :episode_fm="this.episode_fm"
         :fixed="'static'"
         />
         -->
         <div class="card">
             <img :src="this.episode_fm.image"/>
         </div>
    </a>
</template>

<script>
export default {
    props: {
        episode_fm: Object,
        link: String
    },
    mounted() {
        console.log(this.episode_fm);
    }
}
</script>

<style scoped>

</style>