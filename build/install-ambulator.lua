local shell = require("shell")
local internet = require("internet")
local filesystem = require("filesystem")

local github = "https://raw.githubusercontent.com/"
local name = "ambulator"
local repo = "justinbarrick/ambulator"
local branch = "jbarrick/installer"

local function oppm(cmd)
    shell.execute("oppm " .. cmd .. " " .. name)
end

local url = github .. repo .. "/" .. branch .. "/build/oppm.cfg"

local oppm_config = ""
for chunk in internet.request(url) do
    oppm_config = oppm_config .. chunk
end

local oppm_file = filesystem.open("/etc/oppm.cfg", "w")
oppm_file:write(string.format("%q", oppm_config))

filesystem.remove("/usr/bin/ambulator.lua")
filesystem.remove("/usr/bin/install-ambulator.lua")

oppm("uninstall")
oppm("install")
