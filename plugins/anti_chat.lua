
antichat = {}-- An empty table for solving multiple kicking problem

do
local function run(msg, matches)
  if is_momod(msg) then -- Ignore mods,owner,admins
    return
  end
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)]['settings']['lock_chat'] then
    if data[tostring(msg.to.id)]['settings']['lock_chat'] == '💚' then
      if antichat[msg.from.id] == true then 
        return
      end
      send_large_msg("chat#id".. msg.to.id , "چت قفل نمی باشد")
      local name = user_print_name(msg.from)
      savelog(msg.to.id, name.." ["..msg.from.id.."] کیک شد چت قفل می باشد ")
      chat_del_user('chat#id'..msg.to.id,'user#id'..msg.from.id,ok_cb,false)
		  antichat[msg.from.id] = true
      return
    end
  end
  return
end
local function cron()
  antichat = {} -- Clear antichat table 
end
return {
  patterns = {
    "([\216-\219][\128-\191])"
    },
  run = run,
	cron = cron
}

end
-- مدیر : @mohammadarak
-- ربات : @avirabot
-- هر گونه کپی برداری بدون ذکر منبع حرام است 
