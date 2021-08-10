#[
  Created at: 08/03/2021 19:58:57 Tuesday
  Modified at: 08/10/2021 03:31:29 PM Tuesday
]#

##[
  ytextractor
]##

import ytextractor/video; export video
# import ytextractor/channel; export channel

when isMainModule and not defined js:
  # debug purposes
  from std/times import `$`
  from std/json import `$`

  # var vid = initYoutubeVideo "jjEQ-yKVPMg".videoCode
  # discard vid.update()
  # echo vid

  echo extractVideo("_o2y1SxprA0")

  # echo extractChannel "UC3aGq0eFrvrjM4F1dLUo87A"
