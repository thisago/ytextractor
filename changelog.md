<!--
  Created at: 08/05/2021 14:16:41 Thursday
  Modified at: 08/10/2021 03:32:13 PM Tuesday
-->

# Changelog

A verbose logging of every change.

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
