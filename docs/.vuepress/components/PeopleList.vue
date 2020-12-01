<template>
    <div>
    <div class="box" tabindex="0">
        <!-- Layout items -->
        <div
            class="people"
            v-for="unit in computedPeople"
        >
        <a :href="unit.regularPath">
        <img :src="unit.frontmatter.image">
        </img>
        <h6>
            {{unit.frontmatter.name}}
        </h6>
        </a>
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
                .sort((a, b) => a.frontmatter.name.localeCompare(b.frontmatter.name) > 0);
            return res;
        }
    }
}
</script>

<style scoped>

    @media (min-width: 768px) {  /* bigger than or equal to tablet */
        .box {
            display: grid;
            grid-gap: 0.6em;
            grid-template-columns: repeat(auto-fill, minmax(8em,1fr)); /* 120px */
        }

    }

    @media (max-width: 768px) {  /* smaller than tablet */
        .box {
            display: grid;
            grid-gap: 0.4em;
            grid-template-columns: repeat(auto-fill, minmax(7em,1fr)); /* 120px */
        }
    }

    @media (max-width: 576px) {  /* smaller than smartphone */
        .box {
            display: grid;
            grid-gap: 0.4em;
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
