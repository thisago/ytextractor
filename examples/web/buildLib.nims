#!/bin/env -S nim --hints:off
#[
  Created at: 08/09/2021 14:05:42 Monday
  Modified at: 09/11/2021 12:04:52 AM Saturday
]#

cd thisDir()
exec "nim js --out=script/ytextractor.js -d:danger ../../src/ytextractor/exports.nim"
