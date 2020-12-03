<template>
<div>
<h2> {{ this.$frontmatter.title }} </h2>

<p v-if="typeof this.$frontmatter.people_link !== 'undefined'">
De: <span v-for="unit in this.$frontmatter.people_link">
        <router-link class="people-link" :to="'/people/' + unit.key">{{unit.name}}</router-link>{{((unit.key != $frontmatter.people_link[$frontmatter.people_link.length - 1].key)? ", " : "")}}
    </span>
</p>
<p>
    {{ this.$frontmatter.description }}
</p>
<div class="button-box">
<a class="btn btn-primary" href="./feed.rss"> 
    Flux RSS 
    <span>
        <svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-rss-fill" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2zm1.5 2.5a1 1 0 0 0 0 2 8 8 0 0 1 8 8 1 1 0 1 0 2 0c0-5.523-4.477-10-10-10zm0 4a1 1 0 0 0 0 2 4 4 0 0 1 4 4 1 1 0 1 0 2 0 6 6 0 0 0-6-6zm.5 7a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3z"/>
        </svg>
    </span>
</a>
<a class="btn btn-success" 
    v-if="this.$frontmatter.spotify_url != null"
    :href="this.$frontmatter.spotify_url"> 
    Spotify
    <span>
        <img class="btn-icon"  src="/icons/spotify.png"/>
    </span> 
</a>
<a class="btn btn-secondary"  
    v-if="this.$frontmatter.apple_podcast_url != null" 
    :href="this.$frontmatter.apple_podcast_url"> 
    Apple Podcast 
    <span>
        <img class="btn-icon"  src="/icons/apple.png"/>
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
        console.log(this.$frontmatter)
    }
}
</script>
<style>
    .btn {
        margin: 0.2em 0.2em 0.2em 0em;
    }
    .button-box .btn,
    .button-box .btn:hover {
      color: white;
    }
    .theme-default-content:not(.custom) .button-box a:hover {
      text-decoration: none;
    }
    a span img,
    a span svg {
        margin-left: 0.2em;
        vertical-align: sub;
        height: 1.2em;
    }
</style>