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
        displayTitle: {
            type: Boolean,
            default: true
        },
        filterShows: {
            type: Array,
            default: function() { return Array(); }
        }
    },
    mounted() {
        console.log("mounted")
        console.log(this.$site)
        console.log(this.filterShows)
        var site = this.$site
    },
    computed: {
        computedPodcasts() {
            let displayTitle = this.displayTitle
            let res = this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/') && x.frontmatter.podcast)
                .filter(x => this.filterShows.length == 0 || this.filterShows.includes(x.regularPath.substring(10, x.regularPath.length - 1)))
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
