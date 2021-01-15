<template>
    <div>
        <div :id="`${this.toKebabCase(this.episode_fm.main_title + this.episode_fm.subtitle)}`"
             :data-variant="player_size">
        </div>
        <!-- 
        <iframe width="100%" height="166" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/951610453&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"></iframe><div style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;"><a href="https://soundcloud.com/calvinball-radio" title="Calvinball" target="_blank" style="color: #cccccc; text-decoration: none;">Calvinball</a> · <a href="https://soundcloud.com/calvinball-radio/calvinball-other-timeline-2-the-boohbah-centipede" title="Calvinball Other Timeline #2 - The boohbah centipede" target="_blank" style="color: #cccccc; text-decoration: none;">Calvinball Other Timeline #2 - The boohbah centipede</a></div>
        -->
    </div>
</template>

<script>


export default {
    props: {
        episode_fm: Object,
        episode_link:{
            type: String,
            default: ""
        },
        player_size:{
            type: String,
            default: "xl"
        }
    },
    data() {
        return {
            player: null
        };
    },
    beforeMount() {

    },
    mounted() {
        // The kebab-case-ification of the CSS class allows to create multiple players on the same page. 
        // You never know...
        let id = `#${this.toKebabCase(this.episode_fm.main_title + this.episode_fm.subtitle)}`
        
        let episode_link = this.$page.regularPath
        let show_link = this.$page.regularPath.replace(/\/episodes\/.*$/, "/")

        if (this.episode_link != "") {
            episode_link = this.episode_link
            show_link = episode_link.replace(/\/episodes\/.*$/, "/")
        }

        let podcast_page = this.$site.pages.filter(x => x.regularPath == show_link)
        podcast_page = podcast_page[0]
        let podcast_page_fm = podcast_page.frontmatter
        let podcast_key = show_link.replace(/.*\/podcasts\//, "").replace("\/", "");

        let config = {
                version: 5,
                // player asset base path, falls back to ./
                base: "/@podlove/web-player/",
                // activeTab: "chapters", // default active tab, can be set to [chapters, files, share, playlist]
                theme: {
                    tokens: {
                    brand: "#166255",
                    brandDark: "#166255",
                    brandDarkest: "#1A3A4A",
                    brandLightest: "#E5EAECFF",
                    shadeDark: "#807E7C",
                    shadeBase: "#807E7C",
                    contrast: "#000",
                    alt: "#fff"
                    }
                },

                "subscribe-button": {
                    feed: podcast_page_fm.feed, // Rss feed
                    /**
                     * Clients
                     * - list of supported podcast clients on android, iOS, Windows, OSX
                     * - only available clients on the used os/platform are shown
                     * - order in list determines rendered order
                     */
                clients: [
                {
                    id: "antenna-pod"
                },
                {
                    id: "beyond-pod"
                },
                {
                    id: "castro"
                },
                {
                    id: "clementine"
                },
                // {
                //   id: "deezer",
                //   service: "" https://www.deezer.com/en/show/[service]
                // },
                {
                    id: "downcast"
                },
                /*
                {
                    id: "google-podcasts",
                    service: podcast_page_fm.feed // feed
                },*/
                {
                    id: "gpodder"
                },
                {
                    id: "itunes"
                },
                {
                    id: "i-catcher"
                },
                {
                    id: "instacast"
                },
                {
                    id: "overcast"
                },
                {
                    id: "player-fm"
                },
                {
                    id: "pocket-casts"
                },
                {
                    id: "pod-grasp"
                },
                {
                    id: "podcast-addict"
                },
                {
                    id: "podcast-republic"
                },
                {
                    id: "podcat"
                },
                {
                    id: "rss-radio"
                },
                // {
                //   id: "soundcloud",
                //   service: "", // https://soundcloud.com/[service]
                // },
                // {
                //   id: "spotify",
                //   service: "", // https://open.spotify.com/show/[service]
                // },
                // {
                //   id: "stitcher",
                //   service: "" // https://www.stitcher.com/podcast/[service]
                // },
                // {
                //   id: "youtube",
                //   service: "" // https://www.youtube.com/channel/[service]
                // },
                {
                    id: "rss"
                }
                ]
                },
                // playlist: playlist,
                share: {
                    channels: [
                    "facebook",
                    "twitter",
                    "mail",
                    "link"
                    ],
                    // share outlet, if not provided embed snippet is not available
                    // outlet: "/share.html",
                    sharePlaytime: true
                }
            }

            if(podcast_page_fm.apple_podcast_url != null)
            {
                let item_apple = {
                    id: "apple-podcasts",
                    service: podcast_page_fm.apple_podcast_url.replace(/^.*\/podcast\/.*\//, "") // https://podcasts.apple.com/podcast/[service]
                }
                config['subscribe-button'].clients.push(item_apple)
            }
            if(podcast_page_fm.spotify_url != null)
            {
                let item_spotify = {
                    id: "spotify",
                    service: podcast_page_fm.spotify_url.replace(/^.*\/show\//, "") // https://podcasts.apple.com/podcast/[service]
                }
                config['subscribe-button'].clients.push(item_spotify)
            }

        if (this.$podloveTheme[podcast_key] != null)
        {
            // console.log(config.theme)
            config.theme = this.$podloveTheme[podcast_key].theme
            // console.log(this.$podloveTheme[podcast_key].theme)
        }

        let episode = {
            // Configuration Version
            version: 5,

            show: {
                title: podcast_page_fm.title,
                subtitle: podcast_page_fm.description,
                summary: podcast_page_fm.description,
                poster: podcast_page_fm.image,
                link: show_link
            },

            /**
             * Episode related Information
             */
            title: `${this.episode_fm.main_title} - ${this.episode_fm.subtitle}`,
            subtitle: `${this.episode_fm.subtitle}`,
            summary: "",
            // ISO 8601 DateTime format, this is capable of adding a time offset, see https://en.wikipedia.org/wiki/ISO_8601
            publicationDate: this.episode_fm.date,
            poster: this.episode_fm.image,
            // ISO 8601 Duration format ([hh]:[mm]:[ss].[sss]), capable of add ing milliseconds, see https://en.wikipedia.org/wiki/ISO_8601
            duration: this.episode_fm.duration,
            link: episode_link,

            /**
             * Audio Assets
             * - media Assets played by the audio player
             * - format support depends on the used browser (https://en.wikipedia.org/wiki/HTML5_audio#Supported_audio_coding_formats)
             * - also supports HLS streams
             *
             * Asset
             * - url: absolute path to media asset
             * - size: file size in  byte
             * - (title): title to be displayed in download tab
             * - mimeType: media asset mimeType
             */
            audio: [
                {
                url: this.episode_fm.episode_mp3,
                size: "?",
                title: "MP3 Audio (mp3)",
                mimeType: "audio/mpeg"
                }
            ],

            files: [

            ],

            /**
             * Files
             * - list of files available for download
             * - if no files are present, audio assets will be used as downloads
             *
             * Asset
             * - url: absolute path to media asset
             * - size: file size in  byte
             * - title: title to be displayed in download tab
             * - (mimeType): media asset mimeType
             */

            /**
             * Chapters:
             * - can be a plain list or a reference to a json file
             * - if present chapters tab will be available
             */


            };
        import('@podlove/web-player/embed').then(module => {
            podlovePlayer(id, episode, config)
         } );

    },
    methods: {
        toKebabCase(str) {
        return str && str.match(/[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+/g)
            .map(x => x.toLowerCase())
            .join('-');
        }
    },
    beforeDestroy() {
    }
};
</script>
<style>

</style>
