<template>
    <div>
        <div class="box" tabindex="0">
            <!-- Layout items -->
            <RecentEpisode 
                v-for="unit in computedEpisodes"
                v-bind:episode_fm="unit.frontmatter"
                v-bind:link="unit.regularPath"
            />
        </div>
        <link rel="stylesheet" href="/css/fixedcolumnitems.css"/>
    </div>
</template>

<script>
export default {
    props: {
       podcast : String
    },
    mounted() {

    },
    data() {
        return {
            order: "old_first"
        }
    },
    computed: {
        computedEpisodes() {
            let number_of_eps = 6
            let num_order = -1; // récents en premier // (this.order === "new_first" ? -1 : 1);
            let res = this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/') && !x.frontmatter.podcast && !x.relativePath.includes("README"))
                .sort((a, b) => (new Date(a.frontmatter.date) - new Date(b.frontmatter.date)) * num_order)
                .slice(0, number_of_eps);
            return res;
        }
    },
    methods: {

    }
}
</script>

<style scoped>


</style>