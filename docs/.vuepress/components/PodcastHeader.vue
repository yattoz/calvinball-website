
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
      {{ this.$frontmatter.main_title }} - {{ this.$frontmatter.subtitle }}
  </h4>

    <div v-if="typeof this.$frontmatter.people_link !== 'undefined'">
    Avec: <span v-for="unit in this.$frontmatter.people_link">
            <router-link class="people-link" :to="'/people/' + unit.key">  
                {{unit.name + ((unit.key != $frontmatter.people_link[$frontmatter.people_link.length - 1].key)? ", " : "")}}
            </router-link>
            </span>
    </div>
    <!-- 
  <ShikwasaPlayer
    :episode_fm="this.$frontmatter"/>
  -->
  <PodlovePlayer
    :episode_fm="this.$frontmatter"/>
  <div class="button-box">
  <a class="btn btn-primary override-btn" :href="this.$frontmatter.episode_mp3 + '?ref=download'">
      Télécharger l'épisode (mp3)
  </a>
  </div>
  </div>
</template>

<script>
export default {
    mounted() {
    },
    computed: {
      computedDate() {
          let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
          return (new Date(this.$frontmatter.date)).toLocaleDateString("fr-FR", options)
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