<!-- .vuepress/theme/layouts/GlobalLayout.vue -->
<template>
  <div class="people">
    <img :src="this.$frontmatter.image"/>
      <h1>
      {{this.$frontmatter.name}}
    </h1>
    <span class="button-box" v-if="this.$frontmatter.twitter != null">
      <a class="btn btn-twitter" :href="'https://twitter.com/' + this.$frontmatter.twitter">
         <svg style="margin-right: 0.4em" width="1em" height="1em" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
           <path fill="white" d="M23.643 4.937c-.835.37-1.732.62-2.675.733.962-.576 1.7-1.49 2.048-2.578-.9.534-1.897.922-2.958 1.13-.85-.904-2.06-1.47-3.4-1.47-2.572 0-4.658 2.086-4.658 4.66 0 .364.042.718.12 1.06-3.873-.195-7.304-2.05-9.602-4.868-.4.69-.63 1.49-.63 2.342 0 1.616.823 3.043 2.072 3.878-.764-.025-1.482-.234-2.11-.583v.06c0 2.257 1.605 4.14 3.737 4.568-.392.106-.803.162-1.227.162-.3 0-.593-.028-.877-.082.593 1.85 2.313 3.198 4.352 3.234-1.595 1.25-3.604 1.995-5.786 1.995-.376 0-.747-.022-1.112-.065 2.062 1.323 4.51 2.093 7.14 2.093 8.57 0 13.255-7.098 13.255-13.254 0-.2-.005-.402-.014-.602.91-.658 1.7-1.477 2.323-2.41z"></path>
        </svg>@{{this.$frontmatter.twitter}}
      </a>
    </span>
      <span class="button-box" v-if="this.$frontmatter.facebook != null">
      <a class="btn btn-facebook" :href="'https://www.facebook.com/' + this.$frontmatter.facebook">
      <svg style="margin-right: 0.4em" width="1em" height="1em" viewBox="0 0 50 50" xmlns="http://www.w3.org/2000/svg">
      <path fill="white" d="M40,0H10C4.486,0,0,4.486,0,10v30c0,5.514,4.486,10,10,10h30c5.514,0,10-4.486,10-10V10C50,4.486,45.514,0,40,0z M39,17h-3 c-2.145,0-3,0.504-3,2v3h6l-1,6h-5v20h-7V28h-3v-6h3v-3c0-4.677,1.581-8,7-8c2.902,0,6,1,6,1V17z"></path>
      </svg>/{{this.$frontmatter.facebook}}
      </a>
      </span>
    <div v-html="description_html">
    </div>
    <div v-if="mini == false">
    <h4>Emissions</h4>
    <div class="emissions">
      <PodcastList
        :filterShows="this.$frontmatter.podcasts"
        />
    </div>
    </div>
    <link rel="stylesheet" href="/css/sns.css"/>
  </div>
</template>

<script>
import MarkdownIt from 'markdown-it';

export default {
  props: {
    mini: {
      type: Boolean,
      default: false
    }
  },
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
