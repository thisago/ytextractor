<!--
  Created at: 08/05/2021 14:16:41 Thursday
  Modified at: 08/07/2021 07:58:43 AM Saturday
-->

# Changelog

A verbose logging of every change.

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
