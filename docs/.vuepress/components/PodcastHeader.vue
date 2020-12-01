
<template>
<div style="margin-bottom: 1em">
  <h4>
      {{ this.$frontmatter.main_title }} - {{ this.$frontmatter.subtitle }}
  </h4>
  <h5>
    {{computedDate}}
  </h5>
    <div v-if="typeof this.$frontmatter.people_link !== 'undefined'">
    Avec: <span v-for="unit in this.$frontmatter.people_link">
            <a class="people-link" :href="'/people/' + unit.key">  
                {{unit.name + ((unit.key != $frontmatter.people_link[$frontmatter.people_link.length - 1].key)? ", " : "")}}
            </a>
            </span>
    </div>
  <ShikwasaPlayer/>
  <a class="btn btn-primary" :href="this.$frontmatter.episode_mp3 + '?ref=download'">
      Télécharger l'épisode (mp3)
  </a>
  </div>
</template>

<script>
export default {
    mounted() {
      console.log(this.$frontmatter);
    },
    computed: {
      computedDate() {
          let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
          return (new Date(this.$frontmatter.date)).toLocaleDateString(navigator.language, options)
      }
    }
}
</script>

<style scoped>
 span a .people-link {
   text-decoration: underline;
 }
</style>