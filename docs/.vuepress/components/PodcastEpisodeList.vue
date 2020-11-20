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
    computed: {
        episodes() {
            return this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/recommande/') && !x.frontmatter.article_index)
                .sort((a, b) => new Date(b.frontmatter.date) - new Date(a.frontmatter.date));
        }
    }
}
</script>