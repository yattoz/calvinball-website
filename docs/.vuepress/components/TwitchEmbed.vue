<!--

<template>
<div id="twitch-embed"></div>
</template>

<script>

import Twitch from 'twitch'

export default {
  mounted() {
    new Twitch.Embed("twitch-embed", {
    width: 854,
    height: 480,
    channel: "calvinball_consortium",
    // only needed if your site is also embedded on embed.example.com and othersite.example.com 
    // parent: ["embed.example.com", "othersite.example.com"]
    });
  }
}
</script>

-->

<template>
    <div class="iframe-container">
        <iframe
            id="twitch-iframe"
            :src="'https://player.twitch.tv/?channel=calvinball_consortium&muted=true&autoplay=true&parent=localhost'"
            allow="fullscreen"
        />
    </div>
</template>

<script>

export default {
  name: 'twitch-video',
  computed () {
    website_url
  }
};
</script>

<style scoped>
    .iframe-container {
        width: auto;
    }

    #twitch-iframe {
        display: block;
        margin-left: auto;
        margin-right: auto;
        width: 600px;
        height: 360px;
    }
</style>