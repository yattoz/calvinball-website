<template>
    <div>
        <div class="shikwasa-player">
        </div>
    </div>
</template>

<script>
import Shikwasa from 'shikwasa'

export default {
    props: {
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
        this.player = new Shikwasa({
            container: () => document.querySelector('.shikwasa-player'),
            audio: {
                title: `${this.$frontmatter.main_title} - ${this.$frontmatter.subtitle}`,
                artist: this.$frontmatter.author,
                cover: this.$frontmatter.image,
                src: this.$frontmatter.episode_mp3,
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
    beforeDestroy() {
        this.player.pause()
    }
};
</script>
<style>

.shikwasa-player {
    margin-bottom: 1em;
}
</style>
