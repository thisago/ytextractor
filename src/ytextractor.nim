#[
  Created at: 08/03/2021 19:58:57 Tuesday
  Modified at: 08/17/2021 12:37:47 PM Tuesday
]#

##[
  ytextractor
]##

import ytextractor/video; export video
import ytextractor/channel; export channel


when isMainModule and not defined js:
  # debug purposes
  from std/times import `$`
  import ytextractor/exports
  import std/json

  # var vid = initYoutubeVideo "jjEQ-yKVPMg".videoId
  # discard vid.update()
  # echo vid

  # echo extractVideo("https://www.youtube.com/watch?v=u8ZP9g-RKA8")

  # var chan = initYoutubeChannel "https://www.youtube.com/channel/UC3aGq0eFrvrjM4F1dLUo87A".channelId
  # var chan = initYoutubeChannel "https://www./channel/UC3aGq0eFrvrjM4F1dLUo87A".channelId
  var chan = initYoutubeChannel "https://www.youtube.com/channel/UCsBjURrPoezykLs9EqgamOA".channelId
  # var chan = initYoutubeChannel "UC3aGq0eFrvrjM4F1dLUo87A".channelId
  discard chan.update(home)
  writeFile "a.json", parseJson($channelJson(chan)).pretty
