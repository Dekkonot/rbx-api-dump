--!strict

local HttpService = game:GetService("HttpService")

local GET_VERSION_URL = "https://setup.rbxcdn.com/versionQTStudio"
local GET_API_JSON_URL = "https://setup.rbxcdn.com/%s-API-Dump.json"

local REQUEST_FAILED_MESSAGE = "Request to fetch `%s` failed because: %s"
local BAD_RESULT_MESSAGE = "Request to fetch `%s` returned bad status code `%i` (expected `200`)"
local JSON_DECODE_FAILURE_MESSAGE = "Failed to decode API dump because: %s"

local ApiTypes = require(script.Parent.ApiTypes)

--- Sends a GET request to `url`. If the result is invalid, uses `what` to throw an appropriate error.
--- Otherwise, returns the body of the result.
local function fetch(url: string, what: string): string
	local got, result = pcall(HttpService.RequestAsync, HttpService, {
		Url = url,
		Method = "GET",
	})

	if not got then
		error(string.format(REQUEST_FAILED_MESSAGE, what, result), 3)
	elseif result.StatusCode ~= 200 then
		error(string.format(BAD_RESULT_MESSAGE, what, result.StatusCode), 3)
	end

	return result.Body
end

--- Fetches the API dump directly from Roblox. If the request is unsuccessful, an error is thrown.
local function fetchAPI(): ApiTypes.API
	local versionGuid = fetch(GET_VERSION_URL, "Roblox version GUID")
	local dump = fetch(string.format(GET_API_JSON_URL, versionGuid), "API dump")

	local decoded, apiDump = pcall(HttpService.JSONDecode, HttpService, dump)
	if not decoded then
		error(string.format(JSON_DECODE_FAILURE_MESSAGE, apiDump), 2)
	end

	return apiDump
end

return fetchAPI
