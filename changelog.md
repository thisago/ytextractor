# Changelog

## Version 0.9.0 (Oct 9, 2022)

- Added captions extraction
  - Added tests

---

## Version 0.8.0 (Aug 23, 2022)

- Fixed channel extraction
- Added extraction for video badges at channel page
- Fixed tests

---

## Version 0.7.0 (Aug 22, 2022)

- Improved docs generation
- Fixed video extraction due dislikes removal
- Cleaning

---

## Version 0.6.4 (09/11/2021 00:02:35 Saturday)

- Added missing `json.len` import to `channel.nim`
- Added example url into `readme.md`
- Added [`examples/web/script/main.js`](examples/web/script/main.js) to example work
- Added `.gitattributes`

---

## Version 0.6.3 (08/20/2021 12:56:34 Friday)

- Added channel extraction example in `readme.md`
- Added `page` parameter in `channel.extractChannel`
- Fixed usage example of `readme.md`
- Removed useless import

---

## Version 0.6.2 (08/18/2021 19:11:49 Wednesday)

- Added channel example in `web`

---

## Version 0.6.1 (08/18/2021 18:54:47 Wednesday)

- Fixed tests
- Added test for more channel data

---

## Version 0.6.0 (08/17/2021 22:44:58 Tuesday)

- Added `YoutubePlaylistPreview` type
- Replaced the channel playlist preview from `table[string, seq[YoutubeChannelVideo]]`
- Fix crash on parse channel without header links and/or without highlighted video

---

## Version 0.5.1 (08/17/2021 14:41:47 Tuesday)

- Fixed readme checkbox

---

## Version 0.5.0 (08/17/2021 14:39:20 Tuesday)

- Changed the example of `video.$` to use `is` proc to verify type
- Changed cookie storage filename
- Added the given `page` to `channel.getUrl` generateed url
- Splitted all `channel` extracting to functions for call in correct pages
- Configured extracting for `home` page
- Rename `ExtractError.NotExist` error to `ExtractError.FetchError`
- Added channel home page videos
- Moved `video.YoutubeVideoId` to `base.YoutubeVideoId`
- Added a function to parse channel to JSON
- Added all missing channel data

---

## Version 0.4.1 (08/14/2021 23:25:42 Saturday)

- Fixed docs
- Generated docs

---

## Version 0.4.0 (08/14/2021 23:23:51 Saturday)

Incomplete update.

Mostly of `Moved` actions is to use in `channel` module too

- Url doc fix in `ytextractor/video.nim`
- Moved `video.YoutubeVideoError` to `base.ExtractError`
- Moved `video.YoutubeVideoStatus` to `base.ExtractStatus`
- Moved `video.find` to `base.findInJson`
- Removed test comment line in `video.extractVideo`
- Added a exception discarding to `base.parseYoutubeJson`
- Channel Extractor
  - Added url
    - Extractor (`channel.channelId`)
    - Validator (`channel.valid`)
    - Generator (`channel.genUrl`)
  - Extracted data
    - Name
    - Tags
    - Family safe
    - Description (about)
    - Subscribers
    - Hidden Subscribers (bool)
    - Banners
    - Icons
- Moved `ytextractor/video.nim` subscribers parsing to `base` module
- Fixed and added more extracted data to the `readme.md` features list
- Moved `video.YoutubeVideoUrl` to `base.UrlAndSize`
- Added cookie handling to Youtube not block
- Fixed tests
- Moved `ytextractor/base.nim` to `ytextractor/core/core.nim`
- Moved some types from `ytextractor/base.nim` to `ytextractor/core/types.nim`

---

## Version 0.3.2 (08/11/2021 15:03:21 Wednesday)

- Removed the "build status" shields from `readme.md`
- Added a length verification for video ID
- Added `InvalidId` error

---

## Version 0.3.1 (08/11/2021 13:13:29 Wednesday)

- Added missing `src/ytextractor`...
- Added some examples do docs

---

## Version 0.3.0 (08/10/2021 15:32:13 Tuesday)

- Renamed video `code` to `id`
- Added a task to generate docs
- Splitted all video extracting to another file
- Added compatibility with JS backend in browser
- Added optional proxy
- Changed the video data's `lastUpdate` to top in case of parse error show the last update time
- Fixed subs parsing

---

## Version 0.2.4 (08/08/2021 20:36:32 Sunday)

- Added user-agent to not be blocked
- Added a description to lib
- When lib is main module, an parsing error will stop program
- Reduced minimun Nim version to `1.2.2`

---

## Version 0.2.3 (08/08/2021 18:06:39 Sunday)

- Fixed keywords parsing
- Added keywords to tests
- Changed thumbnails length test to be more than 1 (not 0)
- Added test for `publishDate` and `uploadDate`

---

## Version 0.2.2 (08/07/2021 07:58:06 Saturday)

- Added `hiddenSubscribers` bool value to `channel`
- Fixed subs parsing, now if there's no value, set `hiddenSubscribers` to `true`

---

## Version 0.2.1 (08/05/2021 14:53:29 Thursday)

- Dynamic subs/likes/dislikes index finder
- Try statement to every parse, so in error will not crash the application
- Added `ParseError` for previous feature

---

## Version 0.2.0 (08/05/2021 14:17:36 Thursday)

- Added changelog
- Fixed subs parsing (added Million, Billion and comma)
- Added simple example in readme
- Added a detailed list of parsed data
