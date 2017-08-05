<style lang="scss">
$ctlHeight:5em;
$ctlHeightTablet:3.5em;
$ctlHeightPhone:2em;
$barHeight:1.3em;

$breakpoint-tablet: 980px;
$breakpoint-phone: 640px;

@mixin max-screen($break-point) {
  @media screen and (max-width: $break-point) {
    @content;
  }
}

%ctlHeight {
  height: $ctlHeight;
  @include max-screen($breakpoint-tablet) {
    height: $ctlHeightTablet;
  }
  @include max-screen($breakpoint-phone) {
    height: $ctlHeightPhone;
  }
}

%ctlWidth {
  @extend %barcommon;
  width: $ctlHeight;
  @include max-screen($breakpoint-tablet) {
    width: $ctlHeightTablet;
  }
  @include max-screen($breakpoint-phone) {
    width: $ctlHeightPhone;
  }
}

.__ds-video {
  position: absolute;
  width: 100%;
  height: 100%;
  background-color: #000;
}

.back {
  @extend %ctlHeight;
  @extend %ctlWidth;
  color: #ccc;
  position: absolute;
  border: 5px solid #ccc;
  border-radius: 2em;
  background: #222;

  top: 5vh;
  left: 5vw;
}

.icon {
  width: 50%;
  height: 50%;
  margin: 25%;
}

.control {
  color: #ccc;
  position: absolute;
  bottom: 10vh;
  left: 5vw;
  width: 90vw;
  z-index: 5;

  %barcommon {
    @extend %ctlHeight;
    background: #222;
    border: 1px solid #000;
  }
  %btn {
    @extend %ctlWidth;
    cursor: pointer;
  }
  .btnLeft {
    @extend %btn;
    float: left;
  }
  .btnLeftR {
    @extend .btnLeft;
    border-radius: 6px 0 0 6px;
  }
  .btnRight {
    @extend %btn;
    float: right;
  }
  .btnRightR {
    @extend .btnRight;
    border-radius: 0 6px 6px 0;
  }
  .barInfo {
    @extend %barcommon;
    position: relative;
    width: auto;
    overflow: hidden;
  }
  .title {
    @include max-screen($breakpoint-phone) {
      font-size: 10px;
    }
    display: flex;
    align-items: center;
    position: absolute;
    height: 1em;
    top:0;
    bottom:0;
    left: 1em;
    margin: auto;
  }
  .progress {
    height: $barHeight;
    margin-bottom: $barHeight;
    cursor: pointer;
    background: #222;
    border-radius: $barHeight;

    span {
      height: $barHeight;
      display: block;
      border-radius: $barHeight;
    }
  }
  .timeBar {
    z-index: 10;
    width: 0;
    background: -webkit-linear-gradient(top, rgba(107, 204, 226, 1) 0%, rgba(29, 163, 208, 1) 100%);
    box-shadow: 0 0 7px rgba(107, 204, 226, .5);
  }
}

html,
body {
  margin: 0;
  padding: 0;
  background-color: #000;
  height: 100%;
}
</style>
<template>
  <div id="app" ref="app" class="__ds-video" v-on:mousemove="mouseMove">
    <video class="__ds-video" ref="video" v-on:dblclick="fullscreen">
      <source v-for="source in sources" :src="source.src">
      </source>
    </video>
    <div class="back" v-show="state.show" v-on:click="back" v-on:mouseover="enterControl" v-on:mouseleave="exitControl">
      <icon class="icon" name="arrow-left"></icon>
    </div>
    <div class="control" v-show="state.show">
      <div class="progress-bar" v-on:mousedown="updatebar" v-on:mouseover="enterControl" v-on:mouseleave="exitControl">
        <div class="progress" ref="progress">
          <span class="timeBar" v-bind:style="state.timeBar"></span>
        </div>
      </div>
      <div v-on:mouseover="enterControl" v-on:mouseleave="exitControl">
        <div class="btnLeftR" v-on:click="skip(-10)">
          <icon class="icon" name="step-backward"></icon>
        </div>
        <div class="btnLeft" v-on:click="play">
          <icon v-if="state.playing" class="icon" name="pause"></icon>
          <icon v-else class="icon" name="play"></icon>
        </div>
        <div class="btnLeft" v-on:click="skip(10)">
          <icon class="icon" name="step-forward"></icon>
        </div>
        <div class="btnRightR" v-on:click="fullscreen">
          <icon class="icon" name="compress" v-if="state.fullscreen"></icon>
          <icon class="icon" name="arrows-alt" v-else></icon>
        </div>
        <div class="btnRight">
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
        playing: false,
        controlling: false
      },
      tmp: {
        contrlHideTimer: null,
        clientX: 0,
        clientY: 0
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
      this.state.show = false
    }
    this.showController()
  },
  methods: {
    back() {
      window.history.back();
      return false;
    },
    play() {
      if (this.state.playing) {
        this.$video.pause()
      } else {
        this.$video.play()
      }
      this.state.playing = !this.$video.paused
    },
    mouseMove(e) {
      if (e.clientX == this.tmp.clientX && e.clientY == this.tmp.clientY) {
        return
      }
      this.tmp.clientX = e.clientX
      this.tmp.clientY = e.clientY
      this.showController()
    },
    showController() {
      this.state.show = true
      clearTimeout(this.tmp.contrlHideTimer)
      if (this.state.playing && !this.state.controlling) {
        this.tmp.contrlHideTimer = setTimeout(() => {
          this.state.show = false
        }, 2000)
      }
    },
    changewidth() {
      const percentage = this.$video.currentTime / this.$video.duration
      const position = 90 * percentage
      this.state.timeBar.width = position + "vw"
    },
    enterControl() {
      this.state.controlling = true
      clearTimeout(this.tmp.contrlHideTimer)
    },
    exitControl() {
      this.state.controlling = false
      clearTimeout(this.tmp.contrlHideTimer)
    },
    fullscreen() {
      if (this.state.fullscreen) {
        this.state.fullscreen = false
        const container = document
        if (container.exitFullscreen) {
          container.exitFullscreen()
        } else if (container.webkitCancelFullScreen) {
          container.webkitCancelFullScreen()
        } else if (container.mozCancelFullScreen) {
          container.mozCancelFullScreen()
        }
      } else {
        this.state.fullscreen = true
        const container = this.$refs.app
        if (container.requestFullscreen) {
          container.requestFullscreen()
        } else if (container.webkitRequestFullscreen) {
          container.webkitRequestFullscreen()
        } else if (container.mozRequestFullScreen) {
          container.mozRequestFullScreen()
        }
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