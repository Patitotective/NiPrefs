# Package

version = "0.3.0"
author = "Patitotective"
description = "Store and manage preferences dynamically in a text file within table-like structure."
license = "MIT"
srcDir = "src"


# Dependencies

requires "nim >= 1.6.1"
requires "npeg >= 0.26.0"

task docs, "Generate documentation":
  exec "nim doc --git.url:https://github.com/Patitotective/niprefs --git.commit:main --project --outdir:docs src/niprefs.nim"
  exec "echo \"<meta http-equiv=\\\"Refresh\\\" content=\\\"0; url='niprefs.html'\\\" />\" >> docs/index.html"
