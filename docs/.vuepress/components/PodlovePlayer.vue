<template>
    <div>
        <div :id="`${this.toKebabCase(this.episode_fm.main_title + this.episode_fm.subtitle)}`">
        </div>
    </div>
</template>

<script>


export default {
    props: {
        episode_fm: Object,
        fixed: {
            type: String,
            default: 'auto'
        },
        theme: {
            type: String,
            default: "dark"
        },
        color: {
            type: String,
            default: "#0dcaf0"
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
        let podcast_page = this.$site.pages.filter(x => x.regularPath == this.$page.regularPath.replace(/\/episodes\/.*$/, "/"))
        podcast_page = podcast_page[0]
        let podcast_page_fm = podcast_page.frontmatter

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
                    },
                    fonts: {
                        ci: {
                            name: "RobotoBlack",
                            family: [
                            "RobotoBlack",
                            "Calibri",
                            "Candara",
                            "Arial",
                            "Helvetica",
                            "sans-serif"
                            ],
                            weight: 900,
                        },
                        regular: {
                            name: "FiraSansLight",
                            family: [
                            "FiraSansLight",
                            "Calibri",
                            "Candara",
                            "Arial",
                            "Helvetica",
                            "sans-serif"
                            ],
                            weight: 300,
                        },
                        bold: {
                            name: "FiraSansBold",
                            family: [
                            "FiraSansBold",
                            "Calibri",
                            "Candara",
                            "Arial",
                            "Helvetica",
                            "sans-serif"
                            ],
                            weight: 700,
                        }
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
                    id: "apple-podcasts",
                    service: podcast_page_fm.apple_podcast_url.replace(/^.*\/podcast\/.*\//, "") // https://podcasts.apple.com/podcast/[service]
                },
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
                    id: "pocket-casts",
                    service: podcast_page_fm.feed // feed
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
                    id: "podscout"
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


        let episode = {
            // Configuration Version
            version: 5,

            show: {
                title: podcast_page_fm.title,
                subtitle: podcast_page_fm.description,
                summary: podcast_page_fm.description,
                poster: podcast_page_fm.image,
                link: podcast_page.regularPath
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
            link: podcast_page.regularPath, //window.location.toString(),

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
