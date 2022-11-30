// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import lottieWeb from "lottie-web";

const calculateTime = (secs) => {
  const minutes = Math.floor(secs / 60);
  const seconds = Math.floor(secs % 60);
  const returnedSeconds = seconds < 10 ? `0${seconds}` : `${seconds}`;
  return `${minutes}:${returnedSeconds}`;
}
let Hooks = {}
Hooks.AudioPlayer = {
  mounted() {
    const playIconEl = document.getElementById("play-icon")
    let state = 'play'
    const audioEl = document.getElementById("audio")
    const durationEl = document.getElementById("duration")
    const seekSlider = document.getElementById("seek-slider")
    const currentTimeEl = document.getElementById("current-time")
    const volumeSlider = document.getElementById("volume-slider")

    const animation = lottieWeb.loadAnimation({
      container: playIconEl,
      path: "https://maxst.icons8.com/vue-static/landings/animated-icons/icons/pause/pause.json",
      renderer: "svg",
      loop: false,
      autoplay: false,
      name: "play animation" 
    })

    animation.goToAndStop(14, true)

    playIconEl.addEventListener("click", () => {
      if (state == "play") {
        audioEl.play()
        animation.playSegments([14, 27], true)
        state = "pause"
      } else {
        audioEl.pause()
        animation.playSegments([0, 14], true)
        state = "play"
      }
    })

    const displayDuration = () => {
      durationEl.textContent = calculateTime(audioEl.duration)
    }

    const setSliderMax = () => {
      seekSlider.max = Math.floor(audioEl.duration)
    }

    seekSlider.addEventListener("input", () => {
      currentTimeEl.textContent = calculateTime(seekSlider.value)
    })

    seekSlider.addEventListener("change", () => {
      audioEl.currentTime = seekSlider.value
    })

    audioEl.addEventListener("timeupdate", () => {
      seekSlider.value = Math.floor(audioEl.currentTime)
      currentTimeEl.textContent = calculateTime(seekSlider.value)
    })

    volumeSlider.addEventListener("input", (e) => {
      const value = e.target.value

      audioEl.volume = value / 100
    })

    if (audioEl.readyState > 0) {
      displayDuration()
      setSliderMax()
    } else {
      audioEl.addEventListener("loadedmetadata", () => {
        displayDuration()
        setSliderMax()
      })
    }

    this.handleEvent("current_song", ({id}) => {
      document.getElementById("audio").src = "/stream/" + id
    })
  },
  updated() {
    const playIconEl = document.getElementById("play-icon")
    const audioEl = document.getElementById("audio")
    let state = "play"
    const durationEl = document.getElementById("duration")
    const seekSlider = document.getElementById("seek-slider")

    const displayDuration = () => {
      durationEl.textContent = calculateTime(audioEl.duration)
    }

    const setSliderMax = () => {
      seekSlider.max = Math.floor(audioEl.duration)
    }

    if (audioEl.readyState > 0) {
      displayDuration()
      setSliderMax()
    } else {
      audioEl.addEventListener("loadedmetadata", () => {
        displayDuration()
        setSliderMax()
      })
    }

    const animation = lottieWeb.loadAnimation({
      container: playIconEl,
      path: "https://maxst.icons8.com/vue-static/landings/animated-icons/icons/pause/pause.json",
      renderer: "svg",
      loop: false,
      autoplay: false,
      name: "play animation" 
    })

    animation.goToAndStop(14, true)

    playIconEl.addEventListener("click", () => {
      if (state == "play") {
        audioEl.play()
        animation.playSegments([14, 27], true)
        state = "pause"
      } else {
        audioEl.pause()
        animation.playSegments([0, 14], true)
        state = "play"
      }
    })

  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

