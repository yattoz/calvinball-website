<template>
    <div>
    <div class="box" tabindex="0">
        <!-- Layout items -->
        <PodcastCover 
            v-for="unit in computedPodcasts" 
            v-bind:episode="unit" 
            v-bind:key="unit.regularPath"
        /> 
    </div>
    </div>
</template>

<script>
import lozad from 'lozad'

export default {
    props: {
        podcast : String,
        displayTitle: {
            type: Boolean,
            default: true
        }
    },
    mounted() {
            console.log("mounted")
    },
    computed: {
        computedPodcasts() {
            let displayTitle = this.displayTitle
            let res = this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/') && x.frontmatter.podcast)
                //.sort((a,b) => Math.random() >= 0.5)
                .sort((a, b) => a.frontmatter.title.localeCompare(b.frontmatter.title) > 0)
                .map(function(unit) { 
                    let v = { title: displayTitle ? unit.frontmatter.title : "",
                              subtitle: unit.frontmatter.description,
                              image: unit.frontmatter.image, 
                              link: unit.regularPath }
                    return v;
                });
            return res;
        }
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
            grid-template-columns: repeat(auto-fill, minmax(14em,1fr)); /* 120px */
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

    .no_result{
        font-size: large
    }
</style>
