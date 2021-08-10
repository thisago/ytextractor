#!/bin/env -S nim --hints:off
#[
  Created at: 08/09/2021 14:05:42 Monday
  Modified at: 08/10/2021 02:09:06 PM Tuesday
]#

cd thisDir()
exec "nim js --out=script/ytextractor.js -d:release ../../src/ytextractor/exports.nim"
