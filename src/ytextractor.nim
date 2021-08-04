#[
  Created at: 08/03/2021 19:58:57 Tuesday
  Modified at: 08/04/2021 07:22:08 PM Wednesday
]#

##[
  ytextractor
]##

from std/times import DateTime, Duration, initDuration, now, parse
from std/json import parseJson, JsonNode, `{}`, getStr, getInt, getBool, newJObject, items
from std/strutils import find, parseInt, multiReplace
from std/strformat import fmt
from std/httpclient import newHttpClient, get, Http200, body, code, `==`, newHttpHeaders

when isMainModule:
  # debug purposes
  from std/times import `$`
  from std/json import `$`

type
  YoutubeVideo* = object
    status*: YoutubeVideoStatus
    code*: YoutubeVideoCode
    title*, description*: string
    thumbnail*, embed*: YoutubeVideoUrl
    publishDate*, uploadDate*: DateTime
    length*: Duration
    familyFriendly*, unlisted*: bool
    channel*: YoutubeVideoChannel
    views*: int
    category*: YoutubeVideoCategories
    likes*, dislikes*: int

  YoutubeVideoUrl* = object
    url*: string
    width*, height*: int
  YoutubeVideoChannel* = object
    url*, name*, id*: string
    subscribers*: int ## This value is not prescise, the Youtube round the value
    icons*: seq[YoutubeVideoUrl]
  YoutubeVideoCategories* {.pure.} = enum
    Unknown, FilmAndAnimation, AutosAndVehicles, Music, PetsAndAnimals, Sports,
    TravelAndEvents, Gaming, PeopleAndBlogs, Comedy, Entertainment,
    NewsAndPolitics, HowtoAndStyle, Education, ScienceAndTechnology,
    NonprofitsAndActivism
  YoutubeVideoCode* = distinct string
  YoutubeVideoStatus* = object
    lastUpdate*: DateTime
    error*: YoutubeVideoError
  YoutubeVideoError* {.pure.} = enum
    None, NotExist


proc parseCategory*(str: string): YoutubeVideoCategories =
  case str:
  of "Film & Animation": return FilmAndAnimation
  of "Autos & Vehicles": return AutosAndVehicles
  of "Music": return Music
  of "Pets & Animals": return PetsAndAnimals
  of "Sports": return Sports
  of "Travel & Events": return TravelAndEvents
  of "Gaming": return Gaming
  of "People & Blogs": return PeopleAndBlogs
  of "Comedy": return Comedy
  of "Entertainment": return Entertainment
  of "News & Politics": return NewsAndPolitics
  of "Howto & Style": return HowtoAndStyle
  of "Education": return Education
  of "Science & Technology": return ScienceAndTechnology
  of "Nonprofits & Activism": return NonprofitsAndActivism
  else: return Unknown

proc `$`*(code: YoutubeVideoCode): string =
  code.string

proc initYoutubeVideo*(code: YoutubeVideoCode): YoutubeVideo =
  ## Initialize a new `YoutubeVideo` instance
  YoutubeVideo(code: code)

proc getYtJsonData(
  code: YoutubeVideoCode
): tuple[ytInitialPlayerResponse: JsonNode, ytInitialData: JsonNode] =
  proc getVideoData(
    html: string
  ): tuple[ytInitialPlayerResponse: JsonNode, ytInitialData: JsonNode] =
    block ytInitialPlayerResponse:
      const
        startIndexFinder = "var ytInitialPlayerResponse = "
        endIndexFinder = "};"
      let
        startIndex = startIndexFinder.len + html.find startIndexFinder
        endIndex = startIndex + html[startIndex..^1].find endIndexFinder
      result.ytInitialPlayerResponse = html[startIndex..endIndex].parseJson
    block ytInitialData:
      const
        startIndexFinder = "var ytInitialData = "
        endIndexFinder = "};"
      let
        startIndex = startIndexFinder.len + html.find startIndexFinder
        endIndex = startIndex + html[startIndex..^1].find endIndexFinder
      result.ytInitialData = html[startIndex..endIndex].parseJson

  var client = newHttpClient()
  client.headers = newHttpHeaders({
    "accept-language": "en-US,en;q=0.9"
  })
  let res = client.get(fmt"https://www.youtube.com/watch?v={code}")
  if res.code == Http200:
    return res.body.getVideoData()

proc update*(self: var YoutubeVideo): bool =
  ## Update all `YoutubeVideo` data
  ## Returns `false` on error.
  result = true
  let
    jsonData = getYtJsonData(self.code)
    microformat = jsonData.ytInitialPlayerResponse{"microformat", "playerMicroformatRenderer"}
    contents = jsonData.ytInitialData{"contents"}
  writeFile "out", $jsondata

  if microformat.isNil:
    self.status.error = YoutubeVideoError.NotExist
    return false

  self.title = microformat{"title", "simpleText"}.getStr
  self.description = microformat{"description", "simpleText"}.getStr
  block thumbnail:
    let data = microformat{"thumbnail", "thumbnails"}{0}
    self.thumbnail.url = data{"url"}.getStr
    self.thumbnail.width = data{"width"}.getInt
    self.thumbnail.height = data{"height"}.getInt
  block embed:
    let data = microformat{"embed"}
    self.embed.url = data{"iframeUrl"}.getStr
    self.embed.width = data{"width"}.getInt
    self.embed.height = data{"height"}.getInt
  self.publishDate = microformat{"publishDate"}.getStr.parse("yyyy-MM-dd")
  self.uploadDate = microformat{"uploadDate"}.getStr.parse("yyyy-MM-dd")
  self.length =
    initDuration(seconds = microformat{"lengthSeconds"}.getStr.parseInt)
  self.views = microformat{"viewCount"}.getStr.parseInt
  self.familyFriendly = microformat{"isFamilySafe"}.getBool
  self.unlisted = microformat{"isUnlisted"}.getBool
  self.category = microformat{"category"}.getStr.parseCategory
  block channel:
    self.channel.url = microformat{"ownerProfileUrl"}.getStr
    self.channel.id = microformat{"externalChannelId"}.getStr
    self.channel.name = microformat{"ownerChannelName"}.getStr

    self.channel.subscribers = contents{"twoColumnWatchNextResults",
                  "results", "results", "contents"}{1}{
                  "videoSecondaryInfoRenderer", "owner",
                  "videoOwnerRenderer",
                  "subscriberCountText", "accessibility",
                  "accessibilityData", "label"}.
      getStr.multiReplace({"K": "000"," subscribers": ""}).parseInt

    block channelIcons:
      for icon in contents{"twoColumnWatchNextResults", "results", "results",
                          "contents"}{1}{"videoSecondaryInfoRenderer",
                          "owner", "videoOwnerRenderer", "thumbnail",
                          "thumbnails"}:
        self.channel.icons.add YoutubeVideoUrl(
          url: icon{"url"}.getStr,
          width: icon{"width"}.getInt,
          height: icon{"height"}.getInt,
        )

  block likes:
    let data = contents{"twoColumnWatchNextResults", "results", "results",
                        "contents"}{0}{"videoPrimaryInfoRenderer",
                        "videoActions", "menuRenderer", "topLevelButtons"}
    proc get(data: JsonNode; i: int): int {.inline.} =
      data{0}{"toggleButtonRenderer", "defaultText", "accessibility",
              "accessibilityData", "label"}.
        getStr.multiReplace({
          ",": "",
          " likes": "",
          " dislikes": ""
        }).parseInt
    self.likes = data.get 0
    self.dislikes = data.get 1


  self.status.lastUpdate = now()
  self.status.error = YoutubeVideoError.None

proc videoCode*(url: string): YoutubeVideoCode =
  const
    startIndexFinder = "v="
    endIndexFinder = "&"
  var startIndex = url.find startIndexFinder
  if startIndex > -1: inc startIndex, startIndexFinder.len
  else: return url.YoutubeVideoCode

  var endIndex = startIndex + url[startIndex..^1].find endIndexFinder

  if endIndex == startIndex - 1: endIndex = url.len - 1
  return url[startIndex..endIndex].YoutubeVideoCode

proc extractVideo*(video: string): YoutubeVideo =
  ## Extract all data from youtube video.
  ##
  ## `video` can be the video URL or code
  ##
  ## Just an alias of:
  ## .. code-block:: nim
  ##   var vid = initVideo("jjEQ-yKVPMg".videoCode)
  ##   vid.update()
  result = initYoutubeVideo(video.videoCode)
  discard result.update()


when isMainModule:
  var vid = initYoutubeVideo "jjEQ-yKVPMg".YoutubeVideoCode
  discard vid.update()
  echo vid

  echo extractVideo("_o2y1SxprA0")
