<template>
<div class="full-height">
    <!-- 
    <PodcastCover :episode=" {title: episode_fm.title,
                              subtitle: episode_fm.subtitle,
                              image: episode_fm.image,
                              link: this.link,
                              date: episode_fm.date}" />
        -->

    <h6>{{computedDate}}</h6>
    <PodlovePlayer :episode_fm="episode_fm"
                    :episode_link="episode_link"
                    :player_size="'l'"/>

    <div class="separator"></div>

</div>
</template>

<script>

/* 
   <ShikwasaPlayer :episode_fm="episode_fm"
                  />
*/

export default {
    props: {
        episode_fm: Object,
        show_link: String,
        episode_link: String
    },
    mounted() {
    },
    computed: {
        computedDate() {
            let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
            return (new Date(this.episode_fm.date)).toLocaleDateString("fr-FR", options)
        }
    }
                
}
</script>

<style scoped>
    .separator {
        border-top: solid 0px transparent;
        margin:  2em 1em 3em 2em;
    }
</style>
