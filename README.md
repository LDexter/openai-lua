# openai-lua

###### An OpenAI Lua API

_Currently still reliant on CC:Tweaked libraries, with full independance planned to enable other Lua environments..._

## Used By [DavinCC](https://github.com/LDexter/DavinCC) For Conversations

### Provides The Following OpenAI Models:

- text-davinci-003
- text-curie-001
- text-babbage-001
- text-ada-001

### API Setup:

1. Sign-in and access your [private API key](https://beta.openai.com/account/api-keys)
2. Paste the API key into `template.env`, replacing the sample key
3. Rename template.env to just .env

Now your key will not be publicised through git.

### Usage:

Check out `examples.lua` for sample code that prompts Davinci and prints the reply text.
