# openai-lua

###### An OpenAI Lua API

_Currently still reliant on CC:Tweaked libraries, with full independance planned to enable other Lua environments..._

## Used By [DavinCC](https://github.com/LDexter/DavinCC) For Conversations

### Provides The Following OpenAI Models:

- gpt-4
- gpt-4-32k
- gpt-3.5-turbo
- text-davinci-003
- text-curie-001
- text-babbage-001
- text-ada-001

### API Setup:

1. Run `git clone https://github.com/LDexter/openai-lua.git`
2. Sign-in and access your [private API key](https://beta.openai.com/account/api-keys)
3. Paste the API key into `template.env`, replacing the sample key
4. Rename template.env to just .env

Now your key will not be publicised through git.

### Usage:

Check out `examples.lua` for sample code that prompts Davinci and prints the reply text.
