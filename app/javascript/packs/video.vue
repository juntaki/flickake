<style lang="scss">
$ctlHeight:7em;
$barHeight:1.6em;
$ctlRadius:1em;

.__ds-video {
  position: absolute;
  width: 100%;
  height: 100%;
  background-color: #000;
}

.control {
  color: #ccc;
  position: absolute;
  bottom: 10vh;
  left: 5vw;
  width: 90vw;
  z-index: 5;
}

.control .btn {
  width: $ctlHeight;
  height: $ctlHeight;

  background: #222;
  border: 1px solid #000;
  cursor: pointer;
}

.control .icon {
  width: $ctlHeight/2;
  height: $ctlHeight/2;
  margin: $ctlHeight/4;
}

.control .btnLeftRadius {
  border-radius: 6px 0 0 6px;
  float: left;
}

.control .btnLeft {
  float: left;
}

.control .barInfo {
  height: 2em;
  padding: ($ctlHeight - 2em)/2;
  background: #222;
  border: 1px solid #000;
  width: auto;
  overflow: hidden;
}

.control .title {
   font-size: 2em;
}

.control .sound {
  float: right;
}

.control .btnFS {
  float: right;
  border-radius: 0 6px 6px 0;
}

.progress {
  height: $barHeight;
  margin-bottom: $barHeight;
  cursor: pointer;
  background: #222;
  border-radius: $barHeight;
}

.progress span {
  height: $barHeight;
  display: block;
  border-radius: $barHeight;
}

.timeBar {
  z-index: 10;
  width: 0;
  background: -webkit-linear-gradient(top, rgba(107, 204, 226, 1) 0%, rgba(29, 163, 208, 1) 100%);
  box-shadow: 0 0 7px rgba(107, 204, 226, .5);
}

html,
body {
  margin: 0;
  padding: 0;
  background-color: #000;
  height: 100%;
  font-size: 10px;
}
</style>
<template>
  <div id="app" ref="app" class="__ds-video">
    <video class="__ds-video" ref="video"
     v-on:dblclick="fullscreen"
     v-on:keyup.space="play"
     >
      <source v-for="source in sources" :src="source.src">
      </source>
    </video>
    <div class="control">
      <div class="progress-bar">
        <div class="progress" ref="progress" v-on:mousedown="updatebar">
          <span class="timeBar" v-bind:style="state.timeBar"></span>
        </div>
      </div>
      <div class="btmControl">
        <div class="btnLeftRadius btn" v-on:click="skip(-10)">
          <icon class="icon" name="step-backward"></icon>
        </div>
        <div class="btnLeft btn" title="Play/Pause video" v-on:click="play">
          <icon v-if="state.playing" class="icon" name="pause"></icon>
          <icon v-else class="icon" name="play"></icon>
        </div>
        <div class="btnLeft btn" v-on:click="skip(10)">
          <icon class="icon" name="step-forward"></icon>
        </div>
        <div class="btnFS btn" title="Exit full screen" v-on:click="exitFullscreen" v-if="state.fullscreen">
          <icon class="icon" name="compress"></icon>
        </div>
        <div class="btnFS btn" title="Switch to full screen" v-on:click="fullscreen" v-else>
          <icon class="icon" name="arrows-alt"></icon>
        </div>
        <div class="sound btn" title="Mute/Unmute sound">
          <icon class="icon" name="volume-up"></icon>
        </div>
        <div class="barInfo">
          <div class="title">{{options.title}}</div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import 'vue-awesome/icons/play'
import 'vue-awesome/icons/pause'
import 'vue-awesome/icons/step-forward'
import 'vue-awesome/icons/step-backward'
import 'vue-awesome/icons/arrow-left'
import 'vue-awesome/icons/arrows-alt'
import 'vue-awesome/icons/compress'
import 'vue-awesome/icons/volume-off'
import 'vue-awesome/icons/volume-up'
import 'vue-awesome/icons/volume-down'
import Icon from 'vue-awesome/components/Icon'

export default {
  components: {
    Icon
  },
  props: {
    sources: Array,
    options: {
      default () {
        return {
          title: "Title",
          autoplay: false,
        }
      }
    }
  },
  data() {
    return {
      $video: null,
      seekbar: null,
      state: {
        timeBar: {
          width: "0vw"
        },
        fullscreen: false,
        show: true,
        playing: false
      }
    }
  },
  mounted() {
    this.$video = this.$refs.video
    this.$video.addEventListener('ended', (e) => {
      this.state.playing = false
      this.$video.pause()
    })
    this.seekbar = this.$refs.progress
    this.$video.addEventListener('timeupdate', (e) => {
      this.changewidth()
    })
    if (this.options.autoplay) {
      this.play()
    }

  },
  methods: {
    play() {
      this.state.playing = !this.state.playing
      if (this.state.playing) {
        this.$video.play()
      } else {
        this.$video.pause()
      }
    },
    changewidth() {
      const percentage = this.$video.currentTime / this.$video.duration
      const position = 90 * percentage
      this.state.timeBar.width = position + "vw"
    },
    fullscreen() {
      this.state.fullscreen = true
      const container = this.$refs.app
      if (container.requestFullscreen) {
        container.requestFullscreen()
      } else if (container.webkitRequestFullscreen) {
        container.webkitRequestFullscreen()
      } else if (container.mozRequestFullScreen) {
        container.mozRequestFullScreen()
      }
    },
    exitFullscreen() {
      this.state.fullscreen = false
      const container = document
      if (container.exitFullscreen) {
        container.exitFullscreen()
      } else if (container.webkitCancelFullScreen) {
        container.webkitCancelFullScreen()
      } else if (container.mozCancelFullScreen) {
        container.mozCancelFullScreen()
      }
    },
    updatebar(e) {
      var maxduration = this.$video.duration;
      var position = e.clientX - this.seekbar.getBoundingClientRect().left
      var percentage = 100 * position / this.seekbar.offsetWidth
      if (percentage > 100) {
        percentage = 100;
      }
      if (percentage < 0) {
        percentage = 0;
      }
      this.seek(maxduration * percentage / 100);
    },
    seek(value) {
      this.$video.currentTime = value;
      this.changewidth()
    },
    skip(value) {
      this.seek(this.$video.currentTime + value)
    }
  }
}
</script>