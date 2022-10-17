## Parser for "https://www.youtube.com/watch?v=VIDEOID"

{.experimental: "codeReordering".}

from std/times import DateTime, Duration, initDuration, now
from std/json import JsonNode, items, hasKey, `{}`, getStr, getInt, getBool
from std/strformat import fmt
from std/strutils import parseInt, multiReplace, find, strip, split, join

from pkg/util/forStr import timestampToSec

import ytextractor/core/core
from ytextractor/channel import channelId

import ytextractor/core/types; export types

type
  YoutubeVideo* = object of YoutubeVideoPreview
    ## Youtube video object
    status*: ExtractStatus
    description*: string
    embed*: UrlAndSize
    publishDate*, uploadDate*: DateTime
    length*: Duration
    familyFriendly*, unlisted*, private*, live*: bool
    channel*: YoutubeChannelPreview
    category*: YoutubeVideoCategories
    likes*, dislikes*: int
    keywords*: seq[string]
    captions*: seq[YoutubeVideoCaption] ## Expires
  YoutubeVideoCaption* = object
    translatable*: bool
    langCode*, langName*, url*, kind*: string
  YoutubeVideoCategories* {.pure.} = enum
    ## Youtube video categories
    Unknown, FilmAndAnimation, AutosAndVehicles, Music, PetsAndAnimals, Sports,
    TravelAndEvents, Gaming, PeopleAndBlogs, Comedy, Entertainment,
    NewsAndPolitics, HowtoAndStyle, Education, ScienceAndTechnology,
    NonprofitsAndActivism

proc parseCategory*(str: string): YoutubeVideoCategories =
  ## Parses the category to `YoutubeVideoCategories`
  runnableExamples:
    doAssert parseCategory("People & Blogs") == YoutubeVideoCategories.PeopleAndBlogs
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

proc initYoutubeVideo*(id: YoutubeVideoId): YoutubeVideo =
  ## Initialize a new `YoutubeVideo` instance
  YoutubeVideo(id: id)

proc htmlUpdate*(self: var YoutubeVideo; html: string): bool {.discardable.}  =
  ## Update all `YoutubeVideo` data
  ## Returns `false` on error.
  ##
  ## .. code-block:: nim
  ##   var vid = initYoutubeVideo("Dx4eelwPGaQ".videoId)
  ##   if not vid.update():
  ##     echo "Error to update: " & $vid.status.error
  ##   echo vid
  result = true

  if not self.id.valid:
    self.status.error = ExtractError.InvalidId
    return false

  let
    jsonData = html.parseYoutubeJson()
    microformat = jsonData.ytInitialPlayerResponse{"microformat", "playerMicroformatRenderer"}
    videoDetails = jsonData.ytInitialPlayerResponse{"videoDetails"}
    contents = jsonData.ytInitialData{"contents"}

  if microformat.isNil:
    self.status.error = ExtractError.FetchError
    return false

  self.status.lastUpdate = now()

  try:
    self.title = microformat{"title", "simpleText"}.getStr
    self.description = microformat{"description", "simpleText"}.getStr
    
    block captions:
      for capt in jsonData.ytInitialPlayerResponse{"captions", "playerCaptionsTracklistRenderer", "captionTracks"}:
        self.captions.add YoutubeVideoCaption(
          langCode: capt{"languageCode"}.getStr,
          langName: capt{"name", "simpleText"}.getStr,
          translatable: capt{"isTranslatable"}.getBool,
          kind: capt{"kind"}.getStr,
          url: capt{"baseUrl"}.getStr & "&fmt=json3",
        )

    block thumbnail:
      for thumb in videoDetails{"thumbnail", "thumbnails"}:
        self.thumbnails.add UrlAndSize(
          url: thumb{"url"}.getStr,
          width: thumb{"width"}.getInt,
          height: thumb{"height"}.getInt,
        )
    block embed:
      let data = microformat{"embed"}
      self.embed.url = data{"iframeUrl"}.getStr
      self.embed.width = data{"width"}.getInt
      self.embed.height = data{"height"}.getInt
    self.publishDate = times.parse(microformat{"publishDate"}.getStr, "yyyy-MM-dd")
    self.uploadDate = times.parse(microformat{"uploadDate"}.getStr, "yyyy-MM-dd")
    self.length =
      initDuration(seconds = microformat{"lengthSeconds"}.getStr.parseInt)
    self.views = microformat{"viewCount"}.getStr.parseInt
    self.familyFriendly = microformat{"isFamilySafe"}.getBool
    self.unlisted = microformat{"isUnlisted"}.getBool
    self.category = microformat{"category"}.getStr.parseCategory
    block channel:
      self.channel.id = microformat{"ownerProfileUrl"}.getStr.channelId
      self.channel.name = microformat{"ownerChannelName"}.getStr

      let subs = contents{"twoColumnWatchNextResults", "results", "results",
                          "contents"}.
        findInJson("videoSecondaryInfoRenderer"){"owner", "videoOwnerRenderer",
            "subscriberCountText", "simpleText"}.
          getStr.parseSubs

      if subs.len == 0:
        self.channel.hiddenSubscribers = true
      else:
        self.channel.subscribers = subs.parseInt

      block channelIcons:
        for icon in contents{"twoColumnWatchNextResults", "results", "results",
                            "contents"}.
          findInJson("videoSecondaryInfoRenderer"){"owner", "videoOwnerRenderer",
              "thumbnail", "thumbnails"}:
          self.channel.icons.add UrlAndSize(
            url: icon{"url"}.getStr,
            width: icon{"width"}.getInt,
            height: icon{"height"}.getInt,
          )

    block likes:
      let data = contents{"twoColumnWatchNextResults", "results", "results",
                          "contents"}.
        findInJson("videoPrimaryInfoRenderer"){"videoActions", "menuRenderer",
            "topLevelButtons"}
      proc get(data: JsonNode; i: int): int {.inline.} =
        let s = data{i}{"toggleButtonRenderer", "defaultText", "accessibility",
                "accessibilityData", "label"}.getStr.multiReplace({
                                                ",": "",
                                                " likes": "",
                                                " dislikes": "",
                                                "No dislikes": "0",
                                                "No likes": "0"
                                              })
        if s.len > 0:
          result = s.parseInt
      self.likes = data.get 0
      self.dislikes = data.get 1

    block keywords:
      if videoDetails.hasKey "keywords":
        for keyword in videoDetails{"keywords"}:
          self.keywords.add keyword.getStr

    self.private = videoDetails{"isPrivate"}.getBool
    self.live = videoDetails{"isLiveContent"}.getBool

    self.status.error = ExtractError.None
  except:
    self.status.error = ExtractError.ParseError
    echo "Error: " & getCurrentExceptionMsg()
    return false


proc update*(self: var YoutubeVideo; proxy = ""): bool {.discardable.}  =
  ## Update all `YoutubeVideo` data
  ## Returns `false` on error.
  ##
  ## .. code-block:: nim
  ##   var vid = initYoutubeVideo("Dx4eelwPGaQ".videoId)
  ##   if not vid.update():
  ##     echo "Error to update: " & $vid.status.error
  ##   echo vid
  let html = fetch(fmt"{proxy}https://www.youtube.com/watch?v={self.id}")
  self.htmlUpdate html

proc videoId*(url: string): YoutubeVideoId =
  ## Parses the video ID from url
  ## If gave a code instead url, it will return itself
  runnableExamples:
    doAssert $"https://www.youtube.com/watch?v=jjEQ-yKVPMg".videoId == "jjEQ-yKVPMg"
    doAssert $"jjEQ-yKVPMg".videoId == "jjEQ-yKVPMg"
  var id = ""
  block:
    const
      startIndexFinder = "v="
      endIndexFinder = "&"
    var startIndex = url.find startIndexFinder
    if startIndex > -1:
      inc startIndex, startIndexFinder.len
    else:
      id = url
      break

    var endIndex = startIndex + url[startIndex..^1].find endIndexFinder
    if endIndex == startIndex - 1:
      endIndex = url.len - 1
    id = url[startIndex..endIndex]
  result = id.strip.YoutubeVideoId

proc valid*(id: YoutubeVideoId): bool =
  ## Checks if this `YoutubeVideoId` instance is a valid youtube id
  ##
  ## Currently is just checking the length, but later will be added more checks
  runnableExamples:
    doAssert "invalid".YoutubeVideoId.valid == false
    doAssert "   Dx4eelwPGaQ".YoutubeVideoId.valid == false
    doAssert "Dx4eelwPGaQ".YoutubeVideoId.valid
  proc check(id: string): bool =
    result = true
    if id.len != 11: return false

  let strId = $id
  result = check(strId) and
           check(strId.strip)

proc extractVideo*(url: string; proxy = ""): YoutubeVideo =
  ## Extract all data from youtube video.
  ##
  ## `url` can be the video URL or id
  ##
  ## Just an alias of:
  ##
  ## .. code-block:: nim
  ##   var vid = initYoutubeVideo("jjEQ-yKVPMg".videoId)
  ##   discard vid.update():
  ## **Example:**
  ##
  ## .. code-block:: nim
  ##   var vid = extractVideo("jjEQ-yKVPMg")
  ##   echo vid
  result = initYoutubeVideo(url.videoId)
  discard result.update(proxy)

proc extractVideoHtml*(vid, html: string): YoutubeVideo =
  ## Extract all data from youtube video HTML
  ## 
  ## The `vid` is to get the video ID
  result = initYoutubeVideo(vid.videoId)
  discard result.update html

type
  YoutubeVideoChapters* = seq[tuple[second: int; name: string]]

proc parseChapters*(desc: string): YoutubeVideoChapters =
  ## Parse the chapters from description
  for line in desc.split "\n":
    var parts = line.strip.split " "
    if parts.len >= 2:
      let sec = timestampToSec parts[0]
      parts.delete 0
      if sec != -1:
        result.add (
          second: sec,
          name: parts.join " "
        )

when isMainModule:
  # let desc = "What are YouTube chapters? How are they different from timestamps? How to add chapters to YouTube videos? If you are confused and want to learn how to use the new YouTube feature, watch this video where Jan from @So geht YouTube discusses all of these topics. \n\n▬ Contents of this video  ▬▬▬▬▬▬▬▬▬▬\n\n0:00 - Intro\n0:10 - YouTube Chapters\n0:45 - What are YouTube chapters?\n1:17 - How to add chapter markers?\n2:42 - When are changes updated?\n3:02 - How to disable chapters?\n3:21 - Are chapters available in my country?\n\n\nYou probably know this problem: it’s hard to keep the attention of viewers, especially with longer videos. There might be a part later in the video that is interesting to viewers but how should they know? This is where the new YouTube chapter markers can help.\n\nWhat are YouTube chapters?\n\nChapters are generated based on the timestamps that creators include in their video's description.\nTimestamps have pretty much always been on YouTube. But what's new is that you can see certain parts of a video once you hover over the timeline of a video. This feature has been tested for some time and is now officially rolled out to everyone. \n\nHow do I add chapter markers to my videos? \n\n1) You need to add timestamps to your description. You can do this while uploading your video or later when editing it. It’s possible to add timestamps directly on YouTube or you can use tubics video editor (sign up for a 14-day free trial here: https://app.tubics.com/sign-up). The structure for timestamps is the following: \n\n00:XX - Text\n00:XX - Text \n00:XX - Text\n\nIt's very important that you put the zero timestamp first. Otherwise, it's not going to work. This needs to be the first timestamp! \n\nThese are the exact timestamps when each chapter starts. You can put little dashes afterward or you can just do a single space. This doesn't matter because YouTube will just take the text afterward.\n\n2) Update changes on YouTube. \nOnce you open a video on YouTube, you will see the chapters. \n\nWhen are changes updated? \n\nUsually immediately after you made them. If they don't update immediately, YouTube says that they will update in the next 24 hours. If they don't, make sure you formatted your timestamps correctly. \n\nCan I disable YouTube chapters? \n\nYes, you can! Just change the first time code from zero seconds to something else.\n\nAre chapter markers available in every country? \n\nAccording to YouTube, yes, they are. They are available in every country and every language. Warning! The chapter text will only be in the language of the creator. They are not going to be translated.\n\n▬ About tubics ▬▬▬▬▬▬▬▬▬▬▬▬\n\n#tubics is a Video Marketing software that helps businesses and YouTube creators to rank their videos better on search engines like YouTube and Google. This works in a similar way to search engine optimization (SEO) for websites, but just for YouTube videos. Users receive concrete suggestions for optimizing their videos and can implement them directly in the software.\n\nWhy tubics? Companies and creators invest a lot of money and time in their YouTube channels. Yet many are struggling with low video views. Better video metadata helps to make the video easier to find and thus reach more viewers.\n\nSign up free at https://www.tubics.com\n\n\n▬ More Videos  ▬▬▬▬▬▬▬▬▬▬▬▬\n\nSubscribe to @tubics : https://goo.gl/u73XvP\nAll tubics videos: https://goo.gl/cgGiDX\nJan's @So geht YouTube  Channel: https://goo.gl/4HNJUw\n\n\n▬ Social Media ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n\n► Facebook: https://www.facebook.com/tubicsteam/\n► LinkedIn: https://www.linkedin.com/company/tubics\n\n\n▬ Imprint ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n\nImprint: https://goo.gl/DHpT3E"
  # echo desc.parseChapters

  import std/httpclient
  let client = newHttpClient()
  extractVideoHtml 
