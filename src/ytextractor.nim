#[
  Created at: 08/03/2021 19:58:57 Tuesday
  Modified at: 08/14/2021 11:22:47 PM Saturday
]#

##[
  ytextractor
]##

import ytextractor/video; export video
import ytextractor/channel; export channel
import ytextractor/core/types; export types

when isMainModule and not defined js:
  # debug purposes
  from std/times import `$`

  # var vid = initYoutubeVideo "jjEQ-yKVPMg".videoId
  # discard vid.update()
  # echo vid

  # echo extractVideo("https://www.youtube.com/watch?v=u8ZP9g-RKA8")

  # var chan = initYoutubeChannel "https://www.youtube.com/channel/UC3aGq0eFrvrjM4F1dLUo87A".channelId
  var chan = initYoutubeChannel "https://www./channel/UC3aGq0eFrvrjM4F1dLUo87A".channelId
  # var chan = initYoutubeChannel "UC3aGq0eFrvrjM4F1dLUo87A".channelId
  discard chan.update(home)
  # discard chan.update()
  echo chan
