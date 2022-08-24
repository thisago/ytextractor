#? stdtmpl(subsChar = '$', metaChar = '#', emit = "f.write")
# from std/os import splitFile, `/`, execShellCmd; from std/strutils import replace; import strformat
# let filename = (block:
#   let (dir, name, _) = splitFile currentSourcePath(); dir / name.replace("_", "."))
# var f = open(filename, fmReadWrite)
#
## To generate the js file, just run `nim r examples/web/script/main_js.nim`
#
# const sel = "document.querySelector"
# const qid = "document.getElementById"
# const evt = "addEventListener"
# const html = "innerHTML"
# const echo = "console.log"
# const corsProxy = "https://api.allorigins.win/raw?url="
#
const
  urlEl = $qid("url"),
  outEl = $qid("out")
#
urlEl.value = "https://www.youtube.com/watch?v=4zRK0t4caOg"
#
const
  parseVideo = () => {
    const vidData = videoJson(extractVideo(urlEl.value, corsProxy))
    outEl.$html = vidData
  },
  parseChannel = () => {
    const vidData = channelJson(extractChannel(urlEl.value, "home", corsProxy))
    outEl.$html = vidData
  }
#
$qid("parseVideo").$evt("click", parseVideo)
$qid("parseChannel").$evt("click", parseChannel)
