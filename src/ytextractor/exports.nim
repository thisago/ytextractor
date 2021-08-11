#[
  Created at: 08/09/2021 14:31:52 Monday
  Modified at: 08/10/2021 02:58:12 PM Tuesday
]#

import std/json
from times import DateTime, `$`
import ytextractor/video

proc `%`*[T: DateTime | YoutubeVideoId](v: T): JsonNode =
  % $v

{.push exportc.}

proc update*(self: var YoutubeVideo; proxy = "".cstring): bool =
  video.update(self, $proxy)
proc extractVideo*(url: cstring; proxy = "".cstring): YoutubeVideo =
  video.extractVideo($url, $proxy)
proc initYoutubeVideo*(id: YoutubeVideoId): YoutubeVideo =
  video.initYoutubeVideo id

proc getJson*(self: YoutubeVideo): cstring =
  cstring($(%* self))

{.pop.}
