<template>
    <div class="shikwasa-player">
    </div>
</template>

<script>
import Shikwasa from 'shikwasa'

export default {
    props: {
        episode_title: String,
        episode_author: String,
        episode_mp3: String,
        episode_img: String,
        fixed: {
            type: String,
            value: 'auto'
        },
        theme: {
            type: String,
            value: "dark"
        },
        color: {
            type: String,
            value: "#4F83BD"
        }
    },
    data() {
        return {
            player: null
        };
    },
    mounted() {
        console.log("loaded!")
        console.log("finding player div: " + document.querySelector('.shikwasa-player'))
        this.player = new Shikwasa({
            container: () => document.querySelector('.shikwasa-player'),
            audio: {
                title: this.episode_title,
                artist: this.episode_author,
                cover: this.episode_img,
                src: this.episode_mp3,
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
        console.log("destroying the page!!!")
        this.player.pause()
    }/*,
    methods: {
        
    },

    computed: {

    }
    */
};
</script>
<style>

</style>
