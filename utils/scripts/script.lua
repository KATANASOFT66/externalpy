local hs = game:GetService("HttpService")
local BridgeUrl = "http://127.0.0.1:5000"
local ProcessID = game.JobId or "0000"
local resc = 3

local function nukedata(dta, typ, set)
	local timeout = 25
	local result, clock = nil, tick()

	dta = dta or ""
	typ = typ or "none"
	set = set or {}

	hs:RequestInternal({
		Url = BridgeUrl .. "/handle",
		Body = typ .. "\n" .. ProcessID .. "\n" .. hs:JSONEncode(set) .. "\n" .. dta,
		Method = "POST",
		Headers = {
			['Content-Type'] = "text/plain",
		}
	}):Start(function(success, body)
		result = body
		result['Success'] = success
	end)

	while not result do task.wait()
		if (tick() - clock > timeout) then
			break
		end
	end

	if not result or not result.Success then
		if resc <= 0 then
			warn("[ERROR]: Server not responding!")
			return ""
		else
			resc = resc - 1
		end
	else
		resc = 3
	end

	if result and result.StatusCode and result.StatusCode >= 400 then
        local errBody = result.Body
        pcall(function()
            local jsonErr = hs:JSONDecode(result.Body)
            if jsonErr.error then errBody = jsonErr.error end
        end)
		error(errBody, 2)
	end
	return result and result.Body or ""
end

-- Usage Example
nukedata("Hello form Lua", "print", {})
