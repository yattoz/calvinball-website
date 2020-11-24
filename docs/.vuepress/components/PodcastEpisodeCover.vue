<template>
    <router-link :to="episode.link" >
    <div class="card z-depth-1 inner hoverable" >
        <img class="lozad card-img-top episode-cover" :data-src="episode.image" loading="lazy" :src="episode.image" :alt="episode.title" data-loaded="true">
        <div class="extendview">
            <span class="card-text adn-text" > <!-- v-tooltip.top="{content: episode.title, delay: 300}" -->
                {{episode.title}}
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
                cardWidthDef: 150,
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

        .slide-enter-active {
            transition: all .3s ease;
        }
        .slide-leave-active {
            transition: all .3s;
        }
        .slide-enter, .slide-leave-to {
            transform: translateY(100%);
            opacity: 0;
        }

        .fade-enter-active {
            transition: all .4s;
        }
        .fade-leave-active {
            transition: all .4s;
        }
        .fade-enter, .fade-leave-to {
            opacity: 0;
        }

        .compactview{
            position: absolute;
            display: flex;
            bottom: 0px;
            width: 100%;
            height: auto; /* */
            min-height: 2.8em;
            z-index: 10;
        }

        .compactview span{
            color: #fefefe;
            margin-top: 4px;
            margin-bottom: auto;
            margin-left: auto;
            margin-right: auto;
        }


        .extendview{
            background-color: rgb(255, 255, 255);
            display: flex;
            bottom: 0px;
            width: 100%;
            height: auto; /* */
            min-height: 2.2em;
            z-index: 10;
            
        }

        .extendview span {
            color: #121212;
            text-align: left;
            margin-left: 4px;
            margin-right: 4px;
            margin-bottom: auto;
        }

        .card-image span{
            position: absolute;
            top: -2px;
            right: -2px;
            z-index: 100;
            /* border: solid 1px #121212; */
        }

        span.badge{
            text-transform:uppercase;
            font-weight: 500; 
            font-size: 0.8rem;
            color: #fff;
            border-radius: 2px;
            padding: auto;
            /* padding: 0 6px;*/
            margin-left: 14px;
        }
        
        .card{
            border-radius: 4px;
            margin: 0em 0em 0em 0em; /* margins set by father element grid-gap (AnimeLineup.vue) */
            padding: 0em 0em 0em 0em;
            width: auto;
            height: 100%;
            border: solid 1px rgba(0, 0, 0, 0.4);
            z-index: 1;
        }

        .mycard-extend{
            margin: 0em 0em 0em 0em; /* margins set by father element grid-gap (AnimeLineup.vue) */
            padding: 0em 0em 0em 0em;
            width: auto;
            height: 100%;
            border: solid 1px rgba(0, 0, 0, 0.4);
            z-index: 1;
            display: grid;
            grid-gap: 1em;
            grid-template-rows: 1fr 2em;
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }

        .mycard-compact{
            margin: 0em 0em 0em 0em; /* margins set by father element grid-gap (AnimeLineup.vue) */
            padding: 0em 0em 0em 0em;
            width: auto;
            height: 100%;
            border: solid 1px rgba(0, 0, 0, 0.4);
            z-index: 1;
            display: grid;
            grid-gap: 1em;
            grid-template-rows: 1fr;
            /* grid-template-rows: repeat(auto-fill, minmax(225px, 1fr)); */
        }


        .card-inside{
            height: 100%;
            top: 0px;
            z-index: 1;
        }
        
        img{
            object-fit: cover;
            height: 100%;
            z-index: 1;
        }

        .badge-icon{
            position: absolute;
            top: 2px;
            right: 2px;
            z-index: 100;
            background-color: #fefefefe;
            border-radius: 30%;
            border: solid 1px rgba(0, 0, 0, 0.5);
            /* border: solid 1px #121212; */
        }


        .service-icon{
            height: 2em;
            padding: 3px;
            position: relative;
        }



</style>