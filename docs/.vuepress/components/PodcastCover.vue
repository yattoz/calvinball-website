<template>
    <router-link :to="episode.link" class="inner" >
    <div class="inner hoverable" >
        <img class="lozad episode-cover" 
            loading="lazy"
            data-loaded="true"
            :data-src="episode.image" 
            :src="episode.image" 
            :alt="episode.title"/>

    </div>
    <div class="extendview" v-if="episode.title.length > 0">
        <div style="width: 100%">
            <div style="font-style: italic; margin-bottom: 1em;" v-if="episode.date != null"> {{computedDate}} </div>
            <p>{{episode.title}}</p>
            <div class="separator"></div>
            <p class="subtitle">{{episode.subtitle}}</p>
        </div>
    </div>
    </router-link>
</template>

<script>

    // shamelessly ripped off https://stackoverflow.com/questions/1199352/smart-way-to-shorten-long-strings-with-javascript
    String.prototype.trunc =
        function( n, useWordBoundary ){
            if (this.length <= n) { return this; }
            var subString = this.substr(0, n-1);
            return (useWordBoundary
                ? subString.substr(0, subString.lastIndexOf(' '))
                : subString) + "...";
        };

    export default {
        name: "PodcastCover",
        props: {
            episode: {
                //type: Object,
                default: {
                    title: "",
                    subtitle: "",
                    link: "",
                    image: "",
                    date: null
                }
            }
        },
        data() {
            return {
                cardWidthDef: 200,
            }
        },
        mounted() {
            // document.addEventListener('DOMContentLoaded', function() {
            //     // can initialize some JS if needed
            // });
        },
        computed: {
            cardWidth() {
                return this.cardWidthDef * 1.0;
            },
            computedDate() {
                let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
                return (new Date(this.episode.date)).toLocaleDateString("fr-FR", options)
            }
        },
        methods: {

        }
    }
</script>

<style scoped>
    .inner{
        overflow: hidden;
    }
    
    .inner div{
        overflow: hidden;
    }

    .inner .episode-cover{
        transition: all 0.2s ease;
    }
    
    .inner:hover .episode-cover{
         transform: scale(1.1); 
    }

    body.yuu-theme-dark .extendview {
        color: #f1f1f1;
    }

    .extendview{
        display: flex;
        bottom: 0px;
        width: 100%;
        height: auto; /* */
        z-index: 100;
        background-color: transparent;
        color: #121212;
        text-align: center;
    }
    .extendview p {
        text-align: center;
        margin-top: 0.4em;
        margin-bottom: 0.4em;
        width: 100%;
        line-height: 1.4em;
    }

    .separator {
        border-top: solid 1px #888888;
        margin:  0em 0.4em 0em 0.4em;
    }

    img{
        object-fit: cover;
        height: auto;
        border: solid 0px #00000000;
        z-index: 1
    }


</style>