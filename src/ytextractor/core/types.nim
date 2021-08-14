#[
  Created at: 08/14/2021 23:17:25 Saturday
  Modified at: 08/14/2021 11:21:56 PM Saturday
]#

##[
  types
  -----

  The base types of ytextractor
]##

from std/times import DateTime

type
  ExtractStatus* = object
    ## Status of parsing update
    lastUpdate*: DateTime
    error*: ExtractError
  ExtractError* {.pure.} = enum
    ## Parsing error
    None, NotExist, ParseError, InvalidId
  UrlAndSize* = object
    ## Stores thee url, width and height of image/frame
    url*: string
    width*, height*: int
  YoutubeVideoPreview* = object of RootObj
    ## Simple data of video extracted from channel

  YoutubeChannelId* = object
    ## Channel Id is a object
    id*: string
    kind*: YoutubeChannelIdKind
  YoutubeChannelIdKind* {.pure.} = enum
    ## The type of the channel id
    invalid, root, user, channel, c
  YoutubeChannelPreview* = object of RootObj
    ## Simple data of channel extracted from video
    id*: YoutubeChannelId
    name*: string
    subscribers*: int ## This value is not prescise, the Youtube round the value
    icons*: seq[UrlAndSize]
    hiddenSubscribers*: bool
