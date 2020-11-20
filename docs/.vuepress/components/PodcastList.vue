<template>
    <div>
        <div v-for="podcast in podcasts">
            <h2>
                <router-link :to="podcast.path">
                    {{ podcast.frontmatter.title }}
                </router-link>
            </h2>
            <p>{{ podcast.frontmatter.description }}</p>
        </div>
    </div>
</template>

<script>
export default {
    computed: {
        podcasts() {
            return this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/') && x.frontmatter.podcast)
                .sort((a, b) => a.frontmatter.title - b.frontmatter.title); // alphabetical
        }
    }
}
</script>