<style lang="scss">
$ctlHeight: 70px;
$ctlHeightTablet: 50px;
$ctlHeightPhone: 30px;
$barHeight: 15px;

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
  cursor: pointer;
  color: #ccc;
  position: absolute;
  border: 3px solid #ccc;
  border-radius: 50%;
  background: #222;
  top: 5vh;
  left: 5vw;
}

.icon {
  width: 50%;
  height: 50%;
  margin: 25%;
}

$controlBorder: 1px;

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
    border: $controlBorder solid #000;
  }
  %btn {
    @extend %ctlWidth;
    cursor: pointer;
    position: relative;
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
  .volume {
    @extend %ctlWidth;
    position: absolute;
    height: 2*$ctlHeight;
    top: -2*($ctlHeight + $controlBorder);
    @include max-screen($breakpoint-tablet) {
      top: -2*($ctlHeightTablet + $controlBorder);
      height: 2*$ctlHeightTablet;
    }
    right: -$controlBorder;
    border-radius: 6px;
    cursor: default;
  }
  .volumeBar {
    display: flex;
    align-items: center;
    position: absolute;
    top: 0;
    bottom: 0;
    right: 0;
    left: 0;
    margin: auto;
    width: 5px;
    cursor: pointer;
    background: #fff;
    height: 1.5*$ctlHeight;
    @include max-screen($breakpoint-tablet) {
      height: 1.5*$ctlHeightTablet;
    }
  }
  .volumeFill {
    position: absolute;
    background: royalblue;
    bottom: 0px;
    width: 5px;
    height: 100%;
  }
  .volumeTab {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    left: -7.5px;
    margin: auto;
    position: absolute;
    z-index: 10;
    background: royalblue;
    top: 0px;
  }
  .progress {
    height: $barHeight;
    margin-bottom: $barHeight;
    cursor: pointer;
    background: #222;
    border-radius: $barHeight;
    overflow: hidden;
  }
  .timeBar {
    height: $barHeight;
    display: block;
    border-radius: $barHeight;
    z-index: 10;
    width: 0;
    background: royalblue;
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
        <div class="btnRight" @mouseover="showVolume" @mouseleave="clearVolume">
          <icon class="icon" name="volume-up"></icon>
          <div class="volume" @mousedown="startDragVolume" @touchstart="startDragVolume" @mousemove="onDragVolume" @touchmove="onDragVolume"
            @mouseup="stopDragVolume" @touchend="stopDragVolume" @mouseleave="stopDragVolume" v-show="state.volumeShow" @click.stop="clickVolume">
            <div class="volumeBar" ref="volume">
              <div class="volumeFill" v-bind:style="state.volumeFill"></div>
              <span class="volumeTab" v-bind:style="state.volumeBar"></span>
            </div>
          </div>
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
      volumebar: null,
      state: {
        timeBar: {
          width: "0vw"
        },
        volumeBar: {
          top: "0px"
        },
        volumeFill: {
          height: "100%"
        },
        fullscreen: false,
        show: true,
        volumeShow: false,
        playing: false,
        controlling: false
      },
      tmp: {
        contrlDragVolume: false,
        contrlHideTimer: null,
        contrlVolHideTimer: null,
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
    this.volumebar = this.$refs.volume
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
      const maxduration = this.$video.duration;
      const position = e.clientX - this.seekbar.getBoundingClientRect().left
      const percentage = 100 * position / this.seekbar.offsetWidth
      if (percentage > 100) {
        percentage = 100;
      }
      if (percentage < 0) {
        percentage = 0;
      }
      this.seek(maxduration * percentage / 100);
    },
    showVolume() {
      this.state.volumeShow = true
      clearTimeout(this.tmp.contrlVolHideTimer)
    },
    clearVolume() {
      clearTimeout(this.tmp.contrlVolHideTimer)
      this.tmp.contrlVolHideTimer = setTimeout(() => {
        this.state.volumeShow = false
      }, 2000)
    },
    startDragVolume() {
      this.tmp.contrlDragVolume = true
    },
    stopDragVolume() {
      this.tmp.contrlDragVolume = false
    },
    onDragVolume(e) {
      if (this.tmp.contrlDragVolume == false) {
        return
      }
      this.clickVolume(e)
    },
    clickVolume(e) {
      const position = e.clientY - this.volumebar.getBoundingClientRect().top
      const percentage = 100 * position / this.volumebar.offsetHeight
      if (percentage > 100) {
        percentage = 100;
      }
      if (percentage < 0) {
        percentage = 0;
      }
      this.state.volumeBar.top = (this.volumebar.offsetHeight * percentage / 100 - 10) + "px"
      this.state.volumeFill.height = (this.volumebar.offsetHeight * (1 - percentage / 100)) + "px"
    },
    seek(value) {
      this.$video.currentTime = value;
      this.changewidth()
    },
    changewidth() {
      const percentage = this.$video.currentTime / this.$video.duration
      const position = 90 * percentage
      this.state.timeBar.width = position + "vw"
    },
    skip(value) {
      this.seek(this.$video.currentTime + value)
    }
  }
}
</script>