<!-- .vuepress/theme/layouts/GlobalLayout.vue -->
<template>
  <div class="people">
    <h1>
      {{this.$frontmatter.name}}
    </h1>
    <img :src="this.$frontmatter.image"/>
    <div v-html="description_html">
    </div>
  </div>
</template>

<script>
import MarkdownIt from 'markdown-it';

export default {
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
      console.log(res)
      return res;
      // return markdown.toHTML( this.$frontmatter.description );
    }
  }
}
</script>
<style scoped>
  img {
    border-radius: 99em;
    width: auto;
    max-height: 200px;
  }

  .people {
    text-align: center;
  }
</style>
