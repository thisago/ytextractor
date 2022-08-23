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

suite "Youtube video":
  var videoData = initYoutubeVideo("https://www.youtube.com/watch?v=7on15IWC2u4".videoId)

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
  test "Channel id": check videoData.channel.id.id == "taofledermaus"
  test "Channel subscribers": check videoData.channel.subscribers > 1440000
  test "Channel hiddenSubscribers": check videoData.channel.hiddenSubscribers == false
  test "Channel icons": check videoData.channel.icons.len == 3
  test "Likes": check videoData.likes > 25
  test "Dislikes": check videoData.dislikes == 0 # disabled
  test "Keywords": check "12ga" in videoData.keywords

  test "Publish date": check $videoData.publishDate == "2021-07-05T00:00:00+00:00"
  test "Upload date": check $videoData.uploadDate == "2021-07-05T00:00:00+00:00"
