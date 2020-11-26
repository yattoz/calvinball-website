<template>
    <div>
    <!-- 
        <div v-for="episode in episodes">
            <h4>
                <router-link :to="episode.path">
                    {{ episode.frontmatter.title }}
                </router-link>
            </h4>
            <p>{{ episode.frontmatter.description }}</p>
        </div>
    -->
    <div class="box" tabindex="0">
        <!-- Layout items -->
        <PodcastEpisodeCover 
            v-for="unit in computedEpisodes" 
            v-bind:episode="unit" 
            v-bind:key="unit.title"
        /> 
    </div>
    </div>
</template>

<script>
import lozad from 'lozad'

export default {
    props: {
       podcast : String
    },
    mounted() {
            console.log("mounted")
            console.log(this.$site.pages)
    },
    computed: {
        computedEpisodes() {
            return this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/' + this.podcast + '/') && !x.frontmatter.podcast)
                .sort((a, b) => new Date(a.frontmatter.date) - new Date(b.frontmatter.date))
                .map(function(unit) { 
                    let v = {title: unit.frontmatter.episode_title, 
                              image: unit.frontmatter.episode_image, 
                              link: unit.regularPath}
                    return v;
                });
        }
    }
}
</script>

<style scoped>

    @media (min-width: 768px) {  /* bigger than or equal to tablet */
        .box {
            display: grid;
            grid-gap: 0.8em;
            grid-template-columns: repeat(auto-fill, minmax(9em,1fr)); /* 120px */
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }

    }

    @media (max-width: 768px) {  /* smaller than tablet */
        .box {
            display: grid;
            grid-gap: 0.6em;
            grid-template-columns: repeat(auto-fill, minmax(7em,1fr)); /* 120px */
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }
    }

    @media (max-width: 576px) {  /* smaller than smartphone */
        .box {
            display: grid;
            grid-gap: 0.4em;
            grid-template-columns: repeat(auto-fill, minmax(6em,1fr)); /* 120px */
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }

    }

    .no_result{
        font-size: large
    }
</style>
