#[
  Created at: 08/03/2021 19:58:57 Tuesday
  Modified at: 08/04/2021 11:52:57 PM Wednesday
]#

##[
  ytextractor
]##

from std/times import DateTime, Duration, initDuration, now, parse
from std/json import parseJson, JsonNode, `{}`, getStr, getInt, getBool,
    newJObject, items, hasKey
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
    thumbnails*: seq[YoutubeVideoUrl]
    embed*: YoutubeVideoUrl
    publishDate*, uploadDate*: DateTime
    length*: Duration
    familyFriendly*, unlisted*, private*, live*: bool
    channel*: YoutubeVideoChannel
    views*: int
    category*: YoutubeVideoCategories
    likes*, dislikes*: int
    keywords*: seq[string]

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
    None, NotExist, ParseError


proc parseCategory*(str: string): YoutubeVideoCategories =
  case str:
  of "Film & Animation": FilmAndAnimation
  of "Autos & Vehicles": AutosAndVehicles
  of "Music": Music
  of "Pets & Animals": PetsAndAnimals
  of "Sports": Sports
  of "Travel & Events": TravelAndEvents
  of "Gaming": Gaming
  of "People & Blogs": PeopleAndBlogs
  of "Comedy": Comedy
  of "Entertainment": Entertainment
  of "News & Politics": NewsAndPolitics
  of "Howto & Style": HowtoAndStyle
  of "Education": Education
  of "Science & Technology": ScienceAndTechnology
  of "Nonprofits & Activism": NonprofitsAndActivism
  else: Unknown

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

proc find(nodes: JsonNode; key: string): JsonNode =
  ## Gets an json array and returns a object
  ## If not found, returns a empty one
  result = newJObject()
  for node in nodes:
    if node.hasKey key:
      return node{key}

proc update*(self: var YoutubeVideo): bool =
  ## Update all `YoutubeVideo` data
  ## Returns `false` on error.
  result = true
  let
    jsonData = getYtJsonData(self.code)
    microformat = jsonData.ytInitialPlayerResponse{"microformat", "playerMicroformatRenderer"}
    videoDetails = jsonData.ytInitialPlayerResponse{"videoDetails"}
    contents = jsonData.ytInitialData{"contents"}

  if microformat.isNil:
    self.status.error = YoutubeVideoError.NotExist
    return false

  try:
    self.title = microformat{"title", "simpleText"}.getStr
    self.description = microformat{"description", "simpleText"}.getStr
    block thumbnail:
      for thumb in videoDetails{"thumbnail", "thumbnails"}:
        self.thumbnails.add YoutubeVideoUrl(
          url: thumb{"url"}.getStr,
          width: thumb{"width"}.getInt,
          height: thumb{"height"}.getInt,
        )
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
                                          "results", "results", "contents"}.
        find("videoSecondaryInfoRenderer"){"owner", "videoOwnerRenderer",
            "subscriberCountText", "accessibility", "accessibilityData", "label"}.
          getStr.multiReplace({
              "K": "000",
              "M": "000000",
              "B": "000000000",
              " subscribers": "",
              ".": ""
            }).parseInt

      block channelIcons:
        for icon in contents{"twoColumnWatchNextResults", "results", "results",
                            "contents"}.
          find("videoSecondaryInfoRenderer"){"owner", "videoOwnerRenderer",
              "thumbnail", "thumbnails"}:
          self.channel.icons.add YoutubeVideoUrl(
            url: icon{"url"}.getStr,
            width: icon{"width"}.getInt,
            height: icon{"height"}.getInt,
          )

    block likes:
      let data = contents{"twoColumnWatchNextResults", "results", "results",
                          "contents"}.
        find("videoPrimaryInfoRenderer"){"videoActions", "menuRenderer",
            "topLevelButtons"}
      proc get(data: JsonNode; i: int): int {.inline.} =
        data{i}{"toggleButtonRenderer", "defaultText", "accessibility",
                "accessibilityData", "label"}.
          getStr.multiReplace({
            ",": "",
            " likes": "",
            " dislikes": "",
            "No dislikes": "0",
            "No likes": "0"
          }).parseInt
      self.likes = data.get 0
      self.dislikes = data.get 1

    block keywords:
      if videoDetails.hasKey "keyword":
        for keyword in videoDetails{"keywords"}:
          self.keywords.add keyword.getStr

    self.private = videoDetails{"isPrivate"}.getBool
    self.live = videoDetails{"isLiveContent"}.getBool

    self.status.lastUpdate = now()
    self.status.error = YoutubeVideoError.None
  except:
    self.status.error = YoutubeVideoError.ParseError
    return false


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
  # var vid = initYoutubeVideo "jjEQ-yKVPMg".videoCode
  # discard vid.update()
  # echo vid

  echo extractVideo "_o2y1SxprA0"
