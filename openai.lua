local openai = {}

-- Optional filter according to OpenAI usage policies:
--* https://platform.openai.com/docs/usage-policies/usage-policies
openai.isFilter = true
openai.flags = {}
openai.isFlagged = false

--[[
?MODEL GUIDE (read more at https://beta.openai.com/docs/models)

* gpt-3.5-turbo:
Turbo is the same model family that powers ChatGPT.
It is optimized for conversational chat input and output but does equally well on completions when compared with the Davinci model family.
Any use case that can be done well in ChatGPT should perform well with the Turbo model family in the API.

* davinci:
Most capable GPT-3 model. Can do any task the other models can do, often with higher quality.
[Good at: Complex intent, cause and effect, summarization for audience]

* curie:
Very capable, but faster and lower cost than Davinci.
[Good at: Language translation, complex classification, text sentiment, summarization]

* babbage:
Capable of straightforward tasks, very fast, and lower cost.
[Good at: Moderate classification, semantic search classification]

* ada:
Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
[Good at: Parsing text, simple classification, address correction, keywords]
]]


-- Authenticate API key with error handling
local function authenticate(path)
    --! Testing .env.env misunderstanding
    local isEnv = fs.exists(path .. ".env.env", "r")
    if isEnv then error("The template.env file was renamed incorrectly\nRename the file .env.env, to just .env") end

    --! Testing .env
    local isEnv = fs.exists(path .. ".env", "r")
    if not isEnv then error("No .env found") end

    -- Accessing private key in local .env file
    local apiEnv = fs.open(path .. ".env", "r")
    local apiAuth = apiEnv.readAll()

    -- Ensuring the key contains no common string errors
    apiAuth = string.gsub(apiAuth, "\n", "")
    apiAuth = string.gsub(apiAuth, " +", "")

    --! Testing template text
    local isTemplate = string.find(apiAuth, "PRIVATE%-API%-KEY%-HERE%-then%-rename%-to%-.env")
    if isTemplate then error("Template text left in .env") end

    --! Testing "sk-"
    local isKey = string.find(apiAuth:sub(1, 3), "sk%-")
    if not isKey then error("Incorrect API key (no 'sk-' prefix)") end

    --! Testing length
    if #apiAuth ~= 51 then error("Incorrect API key (too many or too few chars)") end

    -- Finished with file
    apiEnv.close()

    --! Testing HTTP
    local request = http.get("https://example.tweaked.cc")
    if not request then
        error("HTTP failed! Please follow steps at...\n\n => https://tweaked.cc/guide/local_ips.html <=\n\nHyperlink available in openai-lua, at line 51")
    end
    -- => HTTP is working!
    request.close()

    -- Return error-checked API authentication key
    return apiAuth
end


-- Tests against OpenAI usage policies
function openai.filter(input, key)
    key = key or authenticate("/DavinCC/lib/openai-lua/")
    local test = http.post("https://api.openai.com/v1/moderations",
    '{"input": "' .. input .. '"}',
    { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. key })

    -- Error handling on empty response
    if test then
        return test.readAll()
    else
        return false
    end
end


-- Checks for flagging
function openai.check(input, key)
    -- Check for filter option
    if openai.isFilter then
        local test = openai.filter(input, key)
        -- Check filter result
        if test then
            openai.flags = textutils.unserialiseJSON(test).results[1]
            openai.isFlagged = openai.flags.flagged
        end
    end
end


-- Request completion from OpenAI, using provided model, prompt, temperature, and maximum tokens
function openai.complete(model, prompt, temp, tokens)
    -- Retrieving private API key
    local cmplKey = authenticate("/DavinCC/lib/openai-lua/")
    if not cmplKey then error("Error retrieving cmpl API key, reason not found :(") end

    -- Check flagging status
    openai.check(prompt, cmplKey)
    if openai.isFlagged then
        return false
    end

    -- Posting to OpenAI using the private key
    local cmplPost
    if model == "gpt-3.5-turbo" or model == "gpt-4" or model == "gpt-4-32k" then
        -- Specialised post for chat format
        cmplPost = http.post("https://api.openai.com/v1/chat/completions",
        '{"model": "' .. model .. '", "messages": ' .. prompt .. ', "temperature": ' .. temp .. ', "max_tokens": ' .. tokens .. '}',
        { ["Content-Type"] = "application/json",["Authorization"] = "Bearer " .. cmplKey })
    else
        -- General post format for all other completions
        cmplPost = http.post("https://api.openai.com/v1/completions",
            '{"model": "' .. model .. '", "prompt": "' .. prompt .. '", "temperature": ' .. temp .. ', "max_tokens": ' .. tokens .. '}',
            { ["Content-Type"] = "application/json",["Authorization"] = "Bearer " .. cmplKey })
    end

    -- Error handling on empty response
    if cmplPost then
        return cmplPost.readAll()
    else
        return false
    end
end


-- Request image generation from OpenAI, using provided prompt, number, and size
function openai.generate(prompt, number, size)
    -- Retrieving private API key
    local genKey = authenticate("/DALL-CC/lib/openai-lua/")
    if not genKey then error("Error retrieving gen API key, reason not found :(") end

    -- Check flagging status
    openai.check(prompt, genKey)
    if openai.isFlagged then
        return false
    end

    -- Posting to OpenAI using the private key
    local genPost = http.post("https://api.openai.com/v1/images/generations",
    '{"prompt": "' .. prompt .. '", "n": ' .. number .. ', "size": "' .. size .. '"}',
    { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. genKey })

    -- Error handling on empty response
    if genPost then
        return genPost.readAll()
    else
        return false
    end
end


return openai