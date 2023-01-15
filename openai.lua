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

-- Request completion from OpenAI, given provided model, prompt, temperature, and maximum tokens
function openai.complete(model, prompt, temp, tokens)
    -- Accessing private key in local .env file
    local cmplEnv = fs.open("/openai-lua/.env", "r")
    local cmplAuth = cmplEnv.readAll()
    cmplEnv.close()

    -- Posting to OpenAI using the private key
    local cmplPost = http.post("https://api.openai.com/v1/completions",
        '{"model": "' .. model .. '", "prompt": "' .. prompt .. '", "temperature": ' .. temp .. ', "max_tokens": ' .. tokens .. '}',
        { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. cmplAuth })
    local cmplOut = cmplPost.readAll() or false
    return cmplOut
end


return openai