<template>
    <div>
        <div :class="`${this.toKebabCase(this.episode_fm.title + this.episode_fm.subtitle)}`">
        </div>
    </div>
</template>

<script>
import Shikwasa from 'shikwasa'

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
    mounted() {
        // console.log(`.${this.toKebabCase(this.episode_fm.title + this.episode_fm.subtitle)}`)

        // The kebab-case-ification of the CSS class allows to create multiple players on the same page. 
        // You never know...
        this.player = new Shikwasa({
            container: () => document.querySelector(`.${this.toKebabCase(this.episode_fm.title + this.episode_fm.subtitle)}`),
            audio: {
                title: `${this.episode_fm.title} - ${this.episode_fm.subtitle}`,
                artist: this.episode_fm.author,
                cover: this.episode_fm.image,
                src: this.episode_fm.episode_mp3,
            },
            fixed: {
                type: this.fixed,
                position: 'bottom',
            },
            theme: this.theme,
            themeColor: this.color,
            download: true
        })
    },
    methods: {
        toKebabCase(str) {
        return str && str.match(/[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+/g)
            .map(x => x.toLowerCase())
            .join('-');
        }
    },
    beforeDestroy() {
        this.player.pause()
    }
};
</script>
<style>

</style>
