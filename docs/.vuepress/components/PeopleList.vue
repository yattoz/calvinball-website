<template>
    <div>
    <div class="box" tabindex="0">
        <!-- Layout items -->
        <div
            class="people"
            v-for="unit in computedPeople"
        >
        <router-link :to="unit.regularPath">
        <img class="people-image" :src="unit.frontmatter.image">
        </img>
        <h6>
            {{unit.frontmatter.name}}
        </h6>
        </router-link>
        </div>
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
    },
    computed: {
        computedPeople() {
            let res = this.$site.pages
                .filter(x => x.path.startsWith('/people/') && x.regularPath != "/people/")
                .sort((a, b) => a.frontmatter.name.localeCompare(b.frontmatter.name));
            return res;
        }
    }
}
</script>

<style scoped>


    .people-image{
        transition: all 0.2s ease;
    }
    
    .people-image:hover{
         transform: scale(1.1); 
    }

    @media (min-width: 768px) {  /* bigger than or equal to tablet */
        .box {
            display: grid;
            grid-gap: 0.8em;
            grid-template-columns: repeat(auto-fill, minmax(8em,1fr)); /* 120px */
        }

    }

    @media (max-width: 768px) {  /* smaller than tablet */
        .box {
            display: grid;
            grid-gap: 0.6em;
            grid-template-columns: repeat(auto-fill, minmax(7em,1fr)); /* 120px */
        }
    }

    @media (max-width: 576px) {  /* smaller than smartphone */
        .box {
            display: grid;
            grid-gap: 0.6em;
            grid-template-columns: repeat(auto-fill, minmax(6em,1fr)); /* 120px */
        }

    }

    .people {
        text-align: center;
    }

    img {
        border-radius: 99em;
        width: auto;
        max-height: 100px;
    }

    .no_result{
        font-size: large
    }
</style>
