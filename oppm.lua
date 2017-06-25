local io = require("io")
local os = require("os")

local oppm_file = io.open("/etc/oppm.cfg")
local raw_config = oppm_file:read("*a")

local function error(message)
    print(message)
    print()
    print(raw_config)
    os.exit(1)
end

local oppm_config = loadstring("return " .. raw_config)
if oppm_config == nil then
    error("Could not parse oppm config.")
end

oppm_config = oppm_config()
if oppm_config == nil then
    error("Could not parse oppm config.")
end

if oppm_config.path == nil then
    error("Path must be set in oppm config!")
end

if oppm_config.repos == nil then
    error("Repos not set in oppm config!")
end

for repo, repo_data in pairs(oppm_config.repos) do
    if repo_data == nil then
        error("Empty repo in oppm config!")
    end

    for name, package in pairs(repo_data) do
        if package.name ~= name then
            error("Package name mismatch: " .. package.name or "" .. " != " .. name or "")
        end

        if package.description == nil then
            error("Package has no description.")
        end

        if package.authors == nil then
            error("Package has no authors.")
        end

        if package.hidden == nil then
            error("Package has no hidden setting.")
        end

        if package.repo == nil then
            error("Missing repo in package.")
        end
    end
end

print("oppm configuration valid!")
