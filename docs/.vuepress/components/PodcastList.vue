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
    <link rel="stylesheet" href="/css/fixedcolumnitems.css"/>
    </div>
</template>

<script>
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
    },
    computed: {
        computedPodcasts() {
            let displayTitle = this.displayTitle
            let res = this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/') && x.frontmatter.podcast)
                .filter(x => this.filterShows.length == 0 || this.filterShows.includes(x.regularPath.substring(10, x.regularPath.length - 1)))
                .sort((a, b) => a.frontmatter.title.localeCompare(b.frontmatter.title))
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

</style>
