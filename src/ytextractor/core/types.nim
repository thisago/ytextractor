## The base types of ytextractor

from std/times import DateTime

type
  ExtractStatus* = object
    ## Status of parsing update
    lastUpdate*: DateTime
    error*: ExtractError
  ExtractError* {.pure.} = enum
    ## Parsing error
    None, FetchError, ParseError, InvalidId
  UrlAndSize* = object
    ## Stores thee url, width and height of image/frame
    url*: string
    width*, height*: int
  YoutubeVideoId* = distinct string
    ## Video Id is a distinct string just for disallow pass any string to parser
  YoutubeVideoPreview* = object of RootObj
    ## Simple data of video extracted from channel
    id*: YoutubeVideoId
    title*: string
    views*: int
    thumbnails*: seq[UrlAndSize]

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
  YoutubePlaylistPreview* = object of RootObj
    name*: string

proc `$`*(id: YoutubeVideoId): string =
  ## Convert `YoutubeVideoId` to `string`
  runnableExamples:
    echo $"Dx4eelwPGaQ".YoutubeVideoId is string
  id.string
