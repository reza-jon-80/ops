local helpers = require "OAuth.helpers"

local url = "http://pili.la/api.php"

local function run(msg, matches)
   local url_req = matches[1]

   local request = {
      url = url_req
   }

   local url = url .. "?" .. helpers.url_encode_arguments(request)

   local res, code = http.request(url)
   if code ~= 200 then
      return "متاسفم نمی توانم وصل شوم"
   end

   return res
end


return {
   description = "Shorten an URL with the awesome http://pili.la",
   usage = {
      "!pili [url]: Shorten the URL"
   },
   patterns = {
      "^!pili (https?://[%w-_%.%?%.:/%+=&]+)$"
   },
   run = run
}
-- مدیر : @mohammadarak
-- ربات : @avirabot
-- هر گونه کپی برداری بدون ذکر منبع حرام است 
