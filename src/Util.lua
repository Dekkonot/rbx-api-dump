--!nonstrict

type Dictionary<T> = { [string]: T }
type Array<T> = { [number]: T }

local BAD_MEMBER_TYPE_MESSAGE = "Unexpected member type `%s` (expected `Property`, `Function`, `Event`, or `Callback`)"

local ApiTypes = require(script.Parent.ApiTypes)

local Util = {}

-- This function is, to my knowledge, impossible to make in a strict environment, because there's no way to refine table types.
-- If we had `as`, it wouldn't be a problem, but as it stands we have to live with this solution.
function Util.filterSecurity(security, filter: Dictionary<boolean>): boolean
	if type(security) == "string" then
		return filter[security]
	else
		return (filter[security.Read] or filter[security.Write])
	end
end

function Util.filterTags(tags: Array<string>?, filter: Dictionary<boolean>): boolean
	if tags then
		for _, tag in ipairs(tags) do
			if filter[tag] then
				return true
			end
		end
	end
	return false
end

function Util.lookupify(tbl: Array<string>?): Dictionary<boolean>
	local newTbl: Dictionary<boolean> = {}
	if tbl then
		for _, v in ipairs(tbl) do
			newTbl[v] = true
		end
	end
	return newTbl
end

-- As before, there's no way to refine table types at the moment, so this has to be unstrict.
-- Despite that, it's perfectly type safe, so I feel comfortable putting it into production.
-- It just lets us be a bit more specific with the returns of functions like `getProperty`.
function Util.cloneMember(member: ApiTypes.Member): ApiTypes.Property | ApiTypes.Function | ApiTypes.Event | ApiTypes.Callback
	local memberType = member.MemberType
	if memberType == "Property" then
		local newMember: ApiTypes.Property = {
			Category = member.Category,
			MemberType = memberType,
			Name = member.Name,
			Security = member.Security,
			Serialization = member.Serialization,
			ValueType = member.ValueType,
			Tags = member.Tags,
		}
		return newMember
	elseif memberType == "Function" then
		local newMember: ApiTypes.Function = {
			MemberType = memberType,
			Name = member.Name,
			Parameters = member.Parameters,
			ReturnType = member.ReturnType,
			Security = member.Security,
			Tags = member.Tags,
		}
		return newMember
	elseif memberType == "Event" then
		local newMember: ApiTypes.Event = {
			MemberType = memberType,
			Name = member.Name,
			Parameters = member.Parameters,
			Security = member.Security,
			Tags = member.Tags
		}
		return newMember
	elseif memberType == "Callback" then
		local newMember: ApiTypes.Callback = {
			MemberType = memberType,
			Name = member.Name,
			Parameters = member.Parameters,
			ReturnType = member.ReturnType,
			Security = member.Security,
			Tags = member.Tags,
		}
		return newMember
	else
		error(string.format(BAD_MEMBER_TYPE_MESSAGE, memberType), 2)
	end	
end

return Util