<template>
    <div>
        <div v-for="episode in episodes">
            <h2>
                <router-link :to="episode.path">
                    {{ episode.frontmatter.title }}
                </router-link>
            </h2>
            <p>{{ episode.frontmatter.description }}</p>
        </div>
    </div>
</template>

<script>
export default {
    props: {
       podcast : String
    },
    mounted() {
        console.log(this.podcast);
    },
    computed: {
        episodes() {
            return this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/' + this.podcast + '/') && !x.frontmatter.podcast)
                .sort((a, b) => new Date(a.frontmatter.date) - new Date(b.frontmatter.date));
        }
    }
}
</script>