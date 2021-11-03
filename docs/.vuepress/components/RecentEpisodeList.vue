<template>
    <div>
        <div class="columns" tabindex="0">
            <!-- Layout items -->    
            <RecentEpisode 
                v-for="unit in computedEpisodes"
                v-bind:key="unit.regularPath"
                v-bind:episode_fm="unit.frontmatter"
                v-bind:episode_link="unit.regularPath"
                v-bind:show_link="unit.regularPath.replace(/^.*\/episodes\/.*$/, '')"
            />
            <div class="separator"></div>
        </div>
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
            let number_of_eps = 5
            let num_order = -1; // récents en premier // (this.order === "new_first" ? -1 : 1);
            let res = this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/') && !x.frontmatter.podcast && !x.relativePath.includes("README"))
                .sort(function(a, b){
                    if ((new Date(a.frontmatter.date) - new Date(b.frontmatter.date)) != 0)
                        return (new Date(a.frontmatter.date) - new Date(b.frontmatter.date)) * num_order
                    else
                        return (a.frontmatter.main_title.localeCompare(b.frontmatter.main_title)) * num_order;
                })
                .filter(x => (new Date(x.frontmatter.date)) <= (new Date()) )
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
