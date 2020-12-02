<template>
<div class="local-card">
    <PodcastCover :episode=" {title: episode_fm.main_title,
                              subtitle: episode_fm.subtitle,
                              image: episode_fm.image,
                              link: this.link,
                              date: episode_fm.date}" />
</div>
</template>

<script>
export default {
    props: {
        episode_fm: Object,
        link: String
    },
    mounted() {
    }
}
</script>

<style scoped>
    .local-card {
        padding: 1em;
        border: 1px solid #99999999;
        border-radius: 1em;
    }

</style>