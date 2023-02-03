local openai = {}

--[[
?MODEL GUIDE (read more at https://beta.openai.com/docs/models)

*text-davinci-003:
Most capable GPT-3 model. Can do any task the other models can do,
often with higher quality, longer output and better instruction-following.
Also supports inserting completions within text.
[Good at: Complex intent, cause and effect, summarization for audience]

*text-curie-001:
Very capable, but faster and lower cost than Davinci.
[Good at: Language translation, complex classification, text sentiment, summarization]

*text-babbage-001:
Capable of straightforward tasks, very fast, and lower cost.
[Good at: Moderate classification, semantic search classification]

*text-ada-001:
Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
[Good at: Parsing text, simple classification, address correction, keywords]
]]


-- Authenticate API key with error handling
local function authenticate(path)
    --! Testing .env
    local isEnv = fs.exists(path, "r")
    if not isEnv then error("No .env found") end

    -- Accessing private key in local .env file
    local apiEnv = fs.open(path, "r")
    local apiAuth = apiEnv.readAll()

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
    if request.readAll() ~= "HTTP is working!\n" then
        error("HTTP failed! Please follow steps at...\n\n => https://tweaked.cc/guide/local_ips.html <=\n\nHyperlink available in openai-lua, at line 51")
    end
    -- => HTTP is working!
    request.close()

    -- Return error-checked API authentication key
    return apiAuth
end


-- Request completion from OpenAI, using provided model, prompt, temperature, and maximum tokens
function openai.complete(model, prompt, temp, tokens)
    -- Retrieving private API key
    local cmplKey = authenticate("/DavinCC/lib/openai-lua/.env")
    if not cmplKey then error("Error retrieving cmpl API key, reason not found :(") end

    -- Posting to OpenAI using the private key
    local cmplPost = http.post("https://api.openai.com/v1/completions",
    '{"model": "' .. model .. '", "prompt": "' .. prompt .. '", "temperature": ' .. temp .. ', "max_tokens": ' .. tokens .. '}',
    { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. cmplKey })
    
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
    local genKey = authenticate("/DALL-CC/lib/openai-lua/.env")
    if not genKey then error("Error retrieving gen API key, reason not found :(") end

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