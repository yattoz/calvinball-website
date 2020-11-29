<!-- .vuepress/theme/layouts/GlobalLayout.vue -->
<template>
  <div class="people">
    <h1>
      {{this.$frontmatter.name}}
    </h1>
    <img :src="this.$frontmatter.image"/>
    <div v-html="description_html">
    </div>
    <h4>Emissions</h4>
    <div class="emissions">
      <PodcastList
        :filterShows="this.$frontmatter.podcasts"
        />
    </div>
  </div>
</template>

<script>
import MarkdownIt from 'markdown-it';

export default {
  mounted() {

  },
  computed: {
    description_html() {
      let md_options = {
                          html: true,
                          breaks: true,
                          linkify: true,
                          typographer: true
                        }
      let md = new MarkdownIt(md_options);
      let res = md.render(this.$frontmatter.description)
      return res;
    }
  }
}
</script>
<style scoped>
  img {
    border-radius: 99em;
    width: auto;
    max-height: 150px;
  }

  .people {
    text-align: center;
  }
</style>
