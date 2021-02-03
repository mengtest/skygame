local parse_core = require "core"
local parse_param = require "param"
local util = require "util"

------------------------------- readme -------------------------------------
local README = [[
sprotodump is a simple tool to convert sproto file to spb binary.

usage: lua sprotodump.lua <option> <sproto_file1 sproto_file2 ...> [[<out_option> <outfile>] ...] [namespace_option]

    option:
        -cs              dump to cSharp code file
        -spb             dump to binary spb  file
        -spb2            dump to binary spb  file from lua file
        -go              dump to go code file
        -md              dump to markdown file
        -lua             dump to lua table

    out_option:
        -d <dircetory>               dump to speciffic dircetory
        -o <file>                    dump to speciffic file
        -p <package name>            set package name(only cSharp code use)

    namespace_option:
        -namespace       add namespace to type and protocol
  ]]


------------------------------- module -------------------------------------
local module = {
  ["-cs"] = require "module.cSharp",
  ["-spb"] = require "module.spb",
  ["-spb2"] = require "module.spb",
  ["-go"] = require "module.go",
  ["-md"] = require "module.md",
  ["-lua"] = require "module.table",
}


------------------------------- param -------------------------------------
local param = parse_param(...)
if not param or not module[param.dump_type] then
  print(README)
  return
end

------------------------------- parser -------------------------------------
-- TODO
-- package.path = package.path..";../../../../../src/sproto/?.lua;"
package.path = package.path..";../../../sproto/?.lua;"
-- TODO

local function _gen_trunk_list(sproto_file, namespace)
  local trunk_list = {}
  for i,v in ipairs(sproto_file) do
    namespace = namespace and util.file_basename(v) or nil
    if param.dump_type == "-spb2" then
      local sproto = require(v)
      table.insert(trunk_list, {sproto, v, namespace})
    else
      table.insert(trunk_list, {util.read_file(v), v, namespace})
    end
  end
  return trunk_list
end

local m = module[param.dump_type]
local trunk_list = _gen_trunk_list(param.sproto_file, param.namespace)
local trunk, build = parse_core.gen_trunk(trunk_list)
m(trunk, build, param)
