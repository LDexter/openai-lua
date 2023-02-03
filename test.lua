local path = "/DavinCC/lib/openai-lua/.env.env"

--! Testing .env
local isEnv = fs.exists(path, "r")
if not isEnv then error("No .env found") end

-- Accessing private key in local .env file
local apiEnv = fs.open(path, "r")
local apiAuth = apiEnv.readAll()

print(apiAuth:sub(1, 3))

-- Finished with file
apiEnv.close()