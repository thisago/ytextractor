# Package

version       = "0.9.0"
author        = "Thiago Navarro"
description   = "Youtube data extractor"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.4"
requires "util"

# Javascript target
requires "ajax >= 0.1.1"

task genDocs, "Generate documentations":
  exec "rm -r docs; nim doc -d:usestd --git.commit:master --git.url:https://github.com/thisago/ytextractor --project -d:ssl --out:docs ./src/ytextractor.nim"
