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
            let num_order = -1; // récents en premier // (this.order === "new_first" ? -1 : 1);
            let res = this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/') && !x.frontmatter.podcast && !x.relativePath.includes("README"))
                .sort((a, b) => (new Date(a.frontmatter.date) - new Date(b.frontmatter.date)) * num_order)
                .slice(0, 5);
            console.log(res);
            return res;
        }
    },
    methods: {

    }
}
</script>

<style scoped>


    @media (min-width: 768px) {  /* bigger than or equal to tablet */
        .box {
            display: grid;
            grid-gap: 1em;
            grid-template-columns: repeat(auto-fill, minmax(16em,1fr)); /* 120px */
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }

    }

    @media (max-width: 768px) {  /* smaller than tablet */
        .box {
            display: grid;
            grid-gap: 0.8em;
            grid-template-columns: repeat(auto-fill, minmax(12em,1fr)); /* 120px */
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }
    }

    @media (max-width: 576px) {  /* smaller than smartphone */
        .box {
            display: grid;
            grid-gap: 0.6em;
            grid-template-columns: repeat(auto-fill, minmax(9em,1fr)); /* 120px */
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }

    }


</style>