local openai = {}


-- Request text from OpenAI, given provided prompt, temperature, and maximum tokens
function openai.request(prompt, temp, tokens)
    -- Accessing private key in local .env file
    local cmplEnv = fs.open("/DavinCC/.env", "r")
    local cmplAuth = cmplEnv.readAll()
    cmplEnv.close()

    -- Posting to OpenAI using the private key
    local cmplPost = http.post("https://api.openai.com/v1/completions",
        '{"model": "text-davinci-003", "prompt": "' .. prompt .. '", "temperature": ' .. temp .. ', "max_tokens": ' .. tokens .. '}',
        { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. cmplAuth })
    return cmplPost.readAll()
end


return openai