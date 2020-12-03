<template>
    <div>
    <select class="form-select" aria-label="Tri des épisodes"
            id="combo"
            v-on:change="selectChanged()">
        <option value="old_first">Plus ancien d'abord</option>
        <option value="new_first">Plus récent d'abord</option>
    </select>
    <h4 style="margin-bottom: 1em;">{{computedEpisodes.length}} épisodes</h4>
    <div class="box" tabindex="0">
        <!-- Layout items -->
        <PodcastCover 
            v-for="unit in computedEpisodes" 
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
       podcast : String
    },
    mounted() {
        this.checkUserPreference();
    },
    data() {
        return {
            order: "old_first"
        }
    },
    computed: {
        computedEpisodes() {
            let num_order = (this.order === "new_first" ? -1 : 1);
            let res = this.$site.pages
                .filter(x => x.path.startsWith('/podcasts/' + this.podcast + '/') && !x.frontmatter.podcast)
                .sort((a, b) => (new Date(a.frontmatter.date) - new Date(b.frontmatter.date)) * num_order)
                .map(function(unit) { 
                    let v = { title: unit.frontmatter.main_title,
                              subtitle: unit.frontmatter.subtitle,
                              image: unit.frontmatter.image, 
                              link: unit.regularPath}
                    return v;
                });
            return res;
        }
    },
    methods: {
        selectChanged() {
            let element = document.getElementById("combo");
            let op = element.options[element.selectedIndex].value;
            this.order = op
            localStorage.setItem("order", op)
        },
        checkUserPreference() {
            //Check Storage on Page load. Keep user preference through sessions
            let storedValue = localStorage.getItem("order")
            if (storedValue) {
                document.getElementById("combo").value = storedValue;
                this.order = storedValue
            }
        }
    }
}
</script>

<style scoped>

    @media (min-width: 768px) {  /* bigger than or equal to tablet */
        .box {
            display: grid;
            grid-gap: 1em;
            grid-template-columns: repeat(auto-fill, minmax(12em,1fr)); /* 120px */
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }

    }

    @media (max-width: 768px) {  /* smaller than tablet */
        .box {
            display: grid;
            grid-gap: 0.8em;
            grid-template-columns: repeat(auto-fill, minmax(10em,1fr)); /* 120px */
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }
    }

    @media (max-width: 576px) {  /* smaller than smartphone */
        .box {
            display: grid;
            grid-gap: 0.6em;
            grid-template-columns: repeat(auto-fill, minmax(7em,1fr)); /* 120px */
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }

    }

    .form-select {
        width: auto;
        margin: 2em 0em 2em 0em;
    }
    .no_result{
        font-size: large
    }
</style>
