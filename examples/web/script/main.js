const
  urlEl = document.getElementById("url"),
  outEl = document.getElementById("out")
urlEl.value = "https://www.youtube.com/watch?v=4zRK0t4caOg"
const
  parseVideo = () => {
    const vidData = videoJson(extractVideo(urlEl.value, "https://corsproxy.io/?"))
    outEl.innerHTML = vidData
  },
  parseChannel = () => {
    const vidData = channelJson(extractChannel(urlEl.value, "home", "https://corsproxy.io/?"))
    outEl.innerHTML = vidData
  }
document.getElementById("parseVideo").addEventListener("click", parseVideo)
document.getElementById("parseChannel").addEventListener("click", parseChannel)
