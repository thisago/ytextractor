#[
  Created at: 08/04/2021 16:25:48 Wednesday
  Modified at: 08/18/2021 06:00:08 PM Wednesday
]#

##[
  test Video
]##

import unittest
from std/times import initDuration, `$`
from std/strutils import contains

import ytextractor

var videoData = initYoutubeVideo("https://www.youtube.com/watch?v=7on15IWC2u4".videoId)

suite "Youtube video":
  test "Video Id": check "7on15IWC2u4" == $videoData.id
  test "Get data":
    check videoData.update()
    check videoData.status.error == ExtractError.None
  test "Video title":
    check videoData.title == "🔴 The Gun that Eats EVERYTHING"
  test "Views": check videoData.views > 170
  test "Video length": check videoData.length == initDuration(minutes = 8, seconds = 14)
  test "Description": check "shotgun" in videoData.description
  test "Thumbnails":
    check videoData.thumbnails.len > 1
  test "Embed":
    check videoData.embed.url == "https://www.youtube.com/embed/7on15IWC2u4"
    check videoData.embed.width == 1280
    check videoData.embed.height == 720

  test "Family friendly": check videoData.familyFriendly == true
  test "Unlisted": check videoData.unlisted == false
  test "Private": check videoData.private == false
  test "Live": check videoData.live == false

  test "Category": check videoData.category == YoutubeVideoCategories.ScienceAndTechnology
  test "Channel name": check videoData.channel.name == "TAOFLEDERMAUS"
  test "Channel id": check videoData.channel.id.id == "@taofledermaus"
  test "Channel subscribers": check videoData.channel.subscribers > 1440000
  test "Channel hiddenSubscribers": check videoData.channel.hiddenSubscribers == false
  test "Channel icons": check videoData.channel.icons.len == 3
  test "Likes": check videoData.likes > 25
  test "Keywords": check "12ga" in videoData.keywords

  test "Publish date": check $videoData.publishDate == "2021-07-05T00:00:00+00:00"
  test "Upload date": check $videoData.uploadDate == "2021-07-05T00:00:00+00:00"

  test "Captions url":
    for capt in videoData.captions:
      check capt.langCode.len >= 2
      check capt.langName.len >= 5
      check "api/timedtext" in capt.url
      check capt.kind.len >= 2

suite "Youtube video captions":
  var captions = initYoutubeCaptions()
  test "Get data":
    check captions.update videoData.captions[0].url
    check captions.status.error == ExtractError.None
  test "Words":
    check captions.texts.len == 1217
  test "captionsBySeconds":
    let toSec = captions.texts.captionsBySeconds
    check toSec.len == 184
    check toSec[0].text == "in this video we're going to explain"
    check toSec[^1].second == 492
  
