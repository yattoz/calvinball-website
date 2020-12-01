<template>
<div>
<h2> {{ this.$frontmatter.title }} </h2>

<p v-if="typeof this.$frontmatter.people_link !== 'undefined'">
De: <span v-for="unit in this.$frontmatter.people_link">
        <a class="people-link" :href="'/people/' + unit.key">  
            {{unit.name + ((unit.key != $frontmatter.people_link[$frontmatter.people_link.length - 1].key)? ", " : "")}}
        </a>
        </span>
</p>
<p>
    {{ this.$frontmatter.description }}
</p>
<div class="button-box">
<a class="btn btn-primary" href="./feed.rss"> 
    Flux RSS 
    <span>
        <img style="height: 1.3em" src="/icons/rss.png"/>
    </span>
</a>
<a class="btn btn-success" :href="this.$frontmatter.spotify_url"> 
    Spotify
    <span>
        <img style="height: 1.3em" src="/icons/spotify.png"/>
    </span> 
</a>
<a class="btn btn-secondary" :href="this.$frontmatter.apple_podcast_url"> 
    Apple Podcast 
    <span>
        <img style="height: 1.3em" src="/icons/apple.png"/>
    </span> 
</a>
</div>

<div style="margin-bottom: 1em"></div>
<PodcastEpisodeList v-bind:podcast="`${this.$frontmatter.key}`" />
</div>
</template>

<script>
export default {
    mounted() {
    }
}
</script>
<style>
    .button-box .btn,
    .button-box .btn:hover {
      color: white;
    }
    .theme-default-content:not(.custom) .button-box a:hover {
      text-decoration: none;
    }
</style>