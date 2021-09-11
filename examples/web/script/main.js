const
  urlEl = document.getElementById("url"),
  outEl = document.getElementById("out")

urlEl.value = "https://www.youtube.com/watch?v=Dx4eelwPGaQ"

const
  parseVideo = () => {
    const vidData = videoJson(extractVideo(urlEl.value, "https://api.allorigins.win/raw?url="))
    outEl.innerHTML = vidData
  },
  parseChannel = () => {
    const vidData = channelJson(extractChannel(urlEl.value, "home", "https://api.allorigins.win/raw?url="))
    outEl.innerHTML = vidData
  }

document.getElementById("parseVideo").addEventListener("click", parseVideo)
document.getElementById("parseChannel").addEventListener("click", parseChannel)
