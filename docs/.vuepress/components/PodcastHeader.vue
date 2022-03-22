
<template>
<div style="margin-bottom: 1em">
  <div  style="margin-bottom: 2em;">
      <router-link :to="this.$page.regularPath.replace(/\/episodes\/.*$/, '')" >
    <span class="">
      <svg style="vertical-align: sub;" width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-chevron-left" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
      </svg> <span> Tous les épisodes </span>
   </span>
     </router-link>
   </div>
  <h5>
    {{computedDate}}
  </h5>
  <h4>
      {{ this.$frontmatter.title }}
  </h4>

    <div v-if="typeof this.$frontmatter.people_link !== 'undefined'">
    Avec: <span v-for="unit in this.$frontmatter.people_link" v-bind:key="unit.key">
            <span v-if="!((unit.key.startsWith('twitter=')) || (unit.key.startsWith('site=')))">
            <router-link class="people-link" v-bind:to="methodPeopleLink(unit.key)" v-if=" !(unit.key == 'None' || unit.key == 'none' || unit.key == '_') ">  
                {{unit.name + ((unit.key != $frontmatter.people_link[$frontmatter.people_link.length - 1].key)? ", " : "")}}
            </router-link>
            <span v-if=" (unit.key == 'None' || unit.key == 'none' || unit.key == '_') ">
                {{unit.name + ((unit.key != $frontmatter.people_link[$frontmatter.people_link.length - 1].key)? ", " : "")}}
            </span>
            </span>
            <span v-if="(unit.key.startsWith('twitter=')) || (unit.key.startsWith('site='))">
              <a v-bind:href="methodPeopleLink(unit.key)">
                {{unit.name + ((unit.key != $frontmatter.people_link[$frontmatter.people_link.length - 1].key)? ", " : "")}}
              </a>
            </span>
          </span>

    </div>
    <!-- 
  <ShikwasaPlayer
    :episode_fm="this.$frontmatter"/>
  -->
  <PodlovePlayer
    :episode_fm="this.$frontmatter"
    :is_podtrac="this.is_podtrac"/>
  <div class="button-box">

  <a v-if="this.is_podtrac == false" class="btn btn-primary override-btn" :href="this.$frontmatter.episode_mp3 + '?ref=download'">
      Télécharger l'épisode (mp3)
  </a>

  <a v-if="this.is_podtrac == true" class="btn btn-primary override-btn" :href="'https://dts.podtrac.com/redirect.mp3/' + this.$site.themeConfig.domain + this.$frontmatter.episode_mp3 + '?ref=download'">
      Télécharger l'épisode (mp3)
  </a>
  </div>
  </div>
</template>

<script>
export default {
    data() {
    return {
        podcast_key: "",
        is_podtrac: false
        }
    },
    mounted() {
        this.podcast_key = this.$page.regularPath.replace(/\/episodes\/.*$/, '').replace("/podcasts/", "")
        let parent_frontmatter = this.$site.pages.find(x => x.frontmatter.key == this.podcast_key)
        console.log(this.podcast_key)
        console.log(this.$site)
        this.is_podtrac = parent_frontmatter.frontmatter.is_podtrac == true
    },
    computed: {
      computedDate() {
          let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
          return (new Date(this.$frontmatter.date)).toLocaleDateString("fr-FR", options)
      }
    },
    methods: {
      methodPeopleLink(key)
      {
        if (key.startsWith("twitter="))
          return key.replace(/^twitter=/, "https://twitter.com/")
        if (key.startsWith("site="))
          return key.replace(/^site=/, "")
        if (key == "None" || key == "none")
          return 
        return `/people/${key}.html`
      }
    }
}
</script>

<style scoped>
 span a .people-link {
   text-decoration: underline;
 }
 .btn-primary {
      color: white;
      margin-top: 0.4em;
 }
 
  .theme-default-content:not(.custom) .button-box a:hover {
    text-decoration: none;
  }
</style>
