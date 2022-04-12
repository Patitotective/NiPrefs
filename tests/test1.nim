# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import std/[unittest, strutils]
import niprefs

const path = "Prefs/Prefs/settings.niprefs"

let defaultPrefs = toPrefs {
  lang: "en",
  dark: true,
  keybindings: [],
  users: {:},
  test: {
    c: [-1, 2, [3, {d: 4}], 5.2, -45.9d],
    b: ['d', 'e', 0x034, {3..7}]
  }, 
  chars: {'a'..'g', 's'},
  bytes: {0, 8..16},
  scheme: {
    background: "#000000",
    font: {
      size: 15,
      family: "UbuntuMono",
      color: "#73D216"
    }
  }
}

var prefs = initPrefs(defaultPrefs, path)
prefs.overwrite()

test "can read":
  check prefs.content == prefs.table

test "can write":
  prefs["lang"] = "es"
  prefs.table["lang"] = "es".toPrefs

  prefs["scheme/font/size"] = 20
  prefs.table["scheme"]["font"]["size"] = 20.toPrefs

  check prefs.content == prefs.table

test "can write many":
  prefs.writeMany(toPrefs({"dark": false, "scheme/background": "#CF3030"}))
  
  prefs.table["dark"] = false.toPrefs
  prefs.table["scheme"]["background"] = "#CF3030".toPrefs
  
  check prefs.content == prefs.table

test "can remove":
  prefs.del("lang")
  prefs.table.del("lang")

  prefs.del("scheme/font/size")
  prefs.table["scheme"]["font"].del("size")

  check prefs.content == prefs.table

test "contains and len":
  check ("keybindings" in prefs) == ("keybindings" in prefs.table)
  check prefs.len == prefs.table.len

test "can parse":
  let text = """
  lang="en"
  dark=true
  float32=13f
  float64=69d
  scheme=>
    background="#ffffff"
    font="#000000"
  """.dedent()

  let content = toPrefs({
    "lang": "en", 
    "dark": true, 
    "float32": 13f,
    "float64": 69d,
    "scheme": {
      "background": "#ffffff", 
      "font": "#000000"
    }
  }).getObject()

  check text.parsePrefs() == content

test "can do stuff with nodes":
  var node = prefs["test"]

  node["c"][1] = 3
  node["c"][2] = newPInt(4)
  node["c"].add 5
  node["c"].add -6.newPInt()

  for i in node["c"]:
    discard

  for k, v in node:
    discard

  check node["c"] == toPrefs([-1, 3, 4, 5.2, -45.9, 5, -6])
  check "c" in node

test "can overwrite":
  prefs.table["lang"] = "en".toPrefs
  prefs.overwrite("lang")

  prefs.table["scheme"]["font"]["family"] = "UbuntuMono".toPrefs
  prefs.overwrite("scheme/font/family")

  check prefs.content == prefs.table

  prefs.overwrite(toPrefs({"theme": "dark"}).getObject())
  prefs.table = toPrefs({"theme": "dark"}).getObject()

  check prefs.content == prefs.table
