<template>
    <router-link :to="podcast.link" >
    <div class="card inner" >
        <img class="lozad card-img-top podcast-cover" :data-src="podcast.image" loading="lazy" :src="podcast.image" :alt="podcast.title" data-loaded="true">
        <div class="extendview">
            <span class="card-text adn-text" > <!-- v-tooltip.top="{content: podcast.title, delay: 300}" -->
                {{podcast.title}}
            </span>
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
            podcast: {
                //type: Object,
                default: {
                    title: "",
                    description: "",
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
                return this.cardWidthDef * 2.0;
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

    .inner .podcast-cover{
        transition: all 0.2s ease;
    }
    
    .inner:hover .podcast-cover{
         transform: scale(1.07); 
    }

    .adn-text{
         /* margin:5.33333333px 0 0 0;*/
        max-height:2.3em;
        font-size:0.7em;
        overflow:hidden;
        display:-webkit-box;
        -webkit-line-clamp:2;
        -webkit-box-orient:vertical;
        line-clamp:2;

        color: #222222;

        margin: 4px 4px 4px 4px;
        text-transform:uppercase;
        font-weight:bold;
        line-height:1.2em
    }

    .extendview{
        display: flex;
        bottom: 0px;
        width: 100%;
        height: auto; /* */
        min-height: 2.2em;
        z-index: 10;
        
    }

    .extendview span {
        text-align: left;
        margin-left: 4px;
        margin-right: 4px;
        margin-bottom: auto;
    }

    .card{
        border-radius: 4px;
        margin: 0em 0em 0em 0em; /* margins set by father element grid-gap (AnimeLineup.vue) */
        padding: 0em 0em 0em 0em;
        width: auto;
        height: 100%;
        background-color: "#23232323";
        border: 1px solid rgba(0, 0, 0, 0.2);
        background-clip: padding-box;
        z-index: 1;
    }
    
    img{
        object-fit: cover;
        height: 100%;
        z-index: 1;
    }


</style>