<template>
    <router-link :to="episode.link" >
    <div class="card z-depth-1 inner hoverable" >
        <img class="lozad card-img-top episode-cover" :data-src="episode.image" loading="lazy" :src="episode.image" :alt="episode.title" data-loaded="true">
        <div class="extendview">
            <div class="card-text adn-text" > <!-- v-tooltip.top="{content: episode.title, delay: 300}" -->
                {{episode.title}}
            </div>
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
        name: "PodcastEpisodeCover",
        props: {
            episode: {
                //type: Object,
                default: {
                    title: "",
                    link: "",
                    image: "",
                }
            }
        },
        data() {
            return {
                cardWidthDef: 200,
            }
        },
        mounted() {
            document.addEventListener('DOMContentLoaded', function() {
                // can initialize some JS if needed
            });
        },
        computed: {
            cardWidth() {
                return this.cardWidthDef * 1.0;
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
         transform: scale(1.07); 
    }

    .adn-text{
         /* margin:5.33333333px 0 0 0;*/
        height:3.4em;
        font-size:0.7em;
        overflow:hidden;
        display:-webkit-box;
        -webkit-line-clamp:3;
        -webkit-box-orient:vertical;
        line-clamp:2;
        text-align: left;
        margin: 4px 2px 2px 4px;
        margin-bottom: auto;
        text-transform:uppercase;
        font-weight:bold;
        line-height:1.1em
    }


    body.yuu-theme-dark .extendview {
        background-color: #555555;
        color: #f1f1f1;
    }
    .extendview{
        display: flex;
        bottom: 0px;
        width: 100%;
        height: auto; /* */
        min-height: 2.2em;
        z-index: 10;
        border-radius: 0px 0px 4px 4px;
        background-color: transparent;
        color: #121212;
    }

    .card{
        border-radius: 4px 4px 4px 4px ;
        margin: 0em 0em 0em 0em; /* margins set by father element grid-gap (AnimeLineup.vue) */
        padding: 0em 0em 0em 0em;
        width: auto;
        height: 100%;
        background-color: #00000000;
        z-index: 1;
        border: solid 1px #12121233;
    }
    
    img{
        object-fit: cover;
        height: 100%;
        z-index: 1;
        border: solid 0px #00000000;
    }


</style>