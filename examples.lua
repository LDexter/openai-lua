-- Importing library
local openai = require("openai")

-- Completion arguments
local model = "text-davinci-003"
local prompt = "Say this is a test"
local temp = 0
local tokens = 10

-- Generate and print reply
local replyJSON = openai.complete(model, prompt, temp, tokens)
local replyText = textutils.unserialiseJSON(replyJSON)
print(replyText["choices"][1]["text"])