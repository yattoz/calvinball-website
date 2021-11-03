<template>
    <router-link :to="episode.link" class="inner" >
    <div :class="computedMycard" >
        <div class="card-inside">
            <img class="episode-cover" 
                loading="lazy"
                data-loaded="true"
                :data-src="episode.image" 
                :src="episode.image" 
                :alt="episode.title"/>
        </div>

        <div class="extendview">
            <div style="width: 100%">
                <div class="date" v-if="episode.date != null"> 
                    {{computedDate}} 
                </div>
                <p>{{episode.title}}</p>
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
        name: "PodcastEpisodeUnit",
        props: {
            episode: {
                //type: Object,
                default: {
                    title: "",
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
            },
            computedMycard() {
                return (this.episode.title.length > 0 ? "mycard" : "")
            }
        },
        methods: {

        }
    }
</script>

<style scoped>
    .inner{
        height: 100%;
        width: auto;
        overflow: hidden;
        border-width: 0px;
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

    .date {
        color: #777777; 
        margin-bottom: 1em;
    }

    .extendview{
        display: flex;
        width: 100%;
        height: auto; /* */
        background-color: transparent;
        color: #121212;
        text-align: left;
    }
    .extendview p {
        text-align: left;
        margin-top: 0.4em;
        margin-bottom: 0.4em;
        width: 100%;
        line-height: 1.4em;
    }

    .separator {
        border-top: solid 1px #888888;
        margin:  0em 0.4em 0em 0.4em;
    }

    .card-inside{
        height: 100%;
        top: 0;
        z-index: 1;
        display: flex;
        align-items: center;
    }


    @media (min-width: 768px) {  /* bigger than or equal to tablet */
        .mycard .card-inside img{
            object-fit: cover;
            height: 120px;
        }
    }

    @media (max-width: 768px) {  /* smaller than tablet */
        .mycard .card-inside img{
            object-fit: cover;
            height: 100px;
        }
    }

    @media (max-width: 576px) {  /* smaller than smartphone */
        .mycard .card-inside img{
            object-fit: cover;
            height: 100px;
        }
    }

    .mycard {
        display: grid;
        grid-gap: 1em;
        grid-template-columns: auto 1fr;
        width: 100%;
        height: auto;
        position: relative;
        margin-bottom: 1em;
    }

    a {
        font-weight: 501;
    }


</style>
