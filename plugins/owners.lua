local function lock_group_namemod(msg, data, target)
  local group_name_set = data[tostring(target)]['settings']['set_name']
  local group_name_lock = data[tostring(target)]['settings']['lock_name']
  if group_name_lock == '💙' then
    return 'اسم گروه در حال حاظر قفل می باشد'
  else
    data[tostring(target)]['settings']['lock_name'] = '💙'
    save_data(_config.moderation.data, data)
    rename_chat('chat#id'..target, group_name_set, ok_cb, false)
  return 'اسم گروه قفل شد'
  end
end

local function unlock_group_namemod(msg, data, target)
  local group_name_set = data[tostring(target)]['settings']['set_name']
  local group_name_lock = data[tostring(target)]['settings']['lock_name']
  if group_name_lock == '💔' then
    return 'اسم گروه در حال حاظر باز می باشد'
  else
    data[tostring(target)]['settings']['lock_name'] = '💔'
    save_data(_config.moderation.data, data)
  return 'اسم گروه باز شد'
  end
end

local function lock_group_floodmod(msg, data, target)
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == '💙' then
    return 'حساسیت ضد اسپم گروه قفل می باشد'
  else
    data[tostring(target)]['settings']['flood'] = '💙'
    save_data(_config.moderation.data, data)
  return 'حساسیت ضد اسپم گروه قفل شد'
  end
end

local function unlock_group_floodmod(msg, data, target)
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == '💔' then
    return 'حساسیت ضد اسپم گروه قفل نمی باشد'
  else
    data[tostring(target)]['settings']['flood'] = '💔'
    save_data(_config.moderation.data, data)
  return 'حساسیت ضد اسپم گروه باز شد'
  end
end

local function lock_group_membermod(msg, data, target)
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == '💙' then
    return 'اعضای گروه در حال حاظر قفل می باشد'
  else
    data[tostring(target)]['settings']['lock_member'] = '💙'
    save_data(_config.moderation.data, data)
  end
  return 'اعضای گروه قفل شدند'
end

local function unlock_group_membermod(msg, data, target)
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == '💔' then
    return 'اعضای گروه قفل نیستند'
  else
    data[tostring(target)]['settings']['lock_member'] = '💔'
    save_data(_config.moderation.data, data)
  return 'اعضای گروه باز شدند'
  end
end

local function unlock_group_photomod(msg, data, target)
  local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
  if group_photo_lock == '💔' then
      return 'عکس گروه قفل نمی باشد'
  else
      data[tostring(target)]['settings']['lock_photo'] = '💔'
      save_data(_config.moderation.data, data)
  return 'Group photo has been unlocked'
  end
end

local function show_group_settingsmod(msg, data, target)
    local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)] then
      if data[tostring(msg.to.id)]['settings']['flood_msg_max'] then
        NUM_MSG_MAX = tonumber(data[tostring(msg.to.id)]['settings']['flood_msg_max'])
        print('custom'..NUM_MSG_MAX)
      else 
        NUM_MSG_MAX = 5
      end
    end
    local settings = data[tostring(target)]['settings']
    local text = "تنظیمات گروه:\nLock اسم گروه: "..settings.lock_name.."\nLock عکس گروه: "..settings.lock_photo.."\nLock اعضای گروه: "..settings.lock_member.."\nحساسیت ضد اسپم: "..NUM_MSG_MAX
    return text
end

local function set_rules(target, rules)
  local data = load_data(_config.moderation.data)
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return 'قوانین تنظیم شد به:\n'..rules
end

local function set_description(target, about)
  local data = load_data(_config.moderation.data)
  local data_cat = 'description'
  data[tostring(target)][data_cat] = about
  save_data(_config.moderation.data, data)
  return 'درباره گروه تنظیم شد به:\n'..about
end

local function run(msg, matches)
  if msg.to.type ~= 'chat' then
    local chat_id = matches[1]
    local receiver = get_receiver(msg)
    local data = load_data(_config.moderation.data)
    if matches[2] == 'ban' then
      local chat_id = matches[1]
      if not is_owner2(msg.from.id, chat_id) then
        return "شما مدیر اصلی این گروه نیستید"
      end
      if tonumber(matches[3]) == tonumber(our_id) then return false end
      local user_id = matches[3]
      if tonumber(matches[3]) == tonumber(msg.from.id) then 
        return "شما نمی توانید افراد را بن کنید"
      end
      ban_user(matches[3], matches[1])
      local name = user_print_name(msg.from)
      savelog(matches[1], name.." ["..msg.from.id.."] banned user ".. matches[3])
      return 'یوزر '..user_id..' بن شد'
    end
    if matches[2] == 'unban' then
    if tonumber(matches[3]) == tonumber(our_id) then return false end
      local chat_id = matches[1]
      if not is_owner2(msg.from.id, chat_id) then
        return "شما ادمین اصلی این گروه نیستید"
      end
      local user_id = matches[3]
      if tonumber(matches[3]) == tonumber(msg.from.id) then 
        return "شما نمی توانید افراد را آنبن کنید"
      end
      local hash =  'banned:'..matches[1]
      redis:srem(hash, user_id)
      local name = user_print_name(msg.from)
      savelog(matches[1], name.." ["..msg.from.id.."] unbanned user ".. matches[3])
      return 'یوزر '..user_id..' آنبن شد'
    end
    if matches[2] == 'kick' then
      local chat_id = matches[1]
      if not is_owner2(msg.from.id, chat_id) then
        return "شما مدیر اصلی این گروه نیستید"
      end
      if tonumber(matches[3]) == tonumber(our_id) then return false end
      local user_id = matches[3]
      if tonumber(matches[3]) == tonumber(msg.from.id) then 
        return "شما نمی توانید افراد را بن کنید"
      end
      kick_user(matches[3], matches[1])
      local name = user_print_name(msg.from)
      savelog(matches[1], name.." ["..msg.from.id.."] kicked user ".. matches[3])
      return 'یوزر '..user_id..' اخراج شد'
    end
    if matches[2] == 'clean' then
      if matches[3] == 'modlist' then
        if not is_owner2(msg.from.id, chat_id) then
          return "شما مدیر اصلی این گروه نیستید"
        end
        for k,v in pairs(data[tostring(matches[1])]['moderators']) do
          data[tostring(matches[1])]['moderators'][tostring(k)] = nil
          save_data(_config.moderation.data, data)
        end
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] cleaned modlist")
      end
      if matches[3] == 'rules' then
        if not is_owner2(msg.from.id, chat_id) then
          return "شما مدیر اصلی این گروه نیستید"
        end
        local data_cat = 'rules'
        data[tostring(matches[1])][data_cat] = nil
        save_data(_config.moderation.data, data)
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] cleaned rules")
      end
      if matches[3] == 'about' then
        if not is_owner2(msg.from.id, chat_id) then
          return "شما مدیر اصلی این گروه نیستید"
        end
        local data_cat = 'description'
        data[tostring(matches[1])][data_cat] = nil
        save_data(_config.moderation.data, data)
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] cleaned about")
      end
    end
    if matches[2] == "setflood" then
      if not is_owner2(msg.from.id, chat_id) then
        return "شما مدیر اصلی این گروه نیستید"
      end
      if tonumber(matches[3]) < 5 or tonumber(matches[3]) > 20 then
        return "عدد وارد شده اشتباه است باید بین 5 تا 20 باشد"
      end
      local flood_max = matches[3]
      data[tostring(matches[1])]['settings']['flood_msg_max'] = flood_max
      save_data(_config.moderation.data, data)
      local name = user_print_name(msg.from)
      savelog(matches[1], name.." ["..msg.from.id.."] set flood to ["..matches[3].."]")
      return 'حساسیت ضد اسپم تنظیم شد به '..matches[3]
    end
    if matches[2] == 'lock' then
      if not is_owner2(msg.from.id, chat_id) then
        return "شما مدیر اصلی این گروه نیستید"
      end
      local target = matches[1]
      if matches[3] == 'name' then
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] locked name ")
        return lock_group_namemod(msg, data, target)
      end
      if matches[3] == 'member' then
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] locked member ")
        return lock_group_membermod(msg, data, target)
      end
    end
    if matches[2] == 'unlock' then
      if not is_owner2(msg.from.id, chat_id) then
        return "شما ادمین اصلی این گروه نیستید"
      end
      local target = matches[1]
      if matches[3] == 'name' then
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] unlocked name ")
        return unlock_group_namemod(msg, data, target)
      end
      if matches[3] == 'member' then
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] unlocked member ")
        return unlock_group_membermod(msg, data, target)
      end
    end
    if matches[2] == 'new' then
      if matches[3] == 'link' then
        if not is_owner2(msg.from.id, chat_id) then
          return "شما ادمین اصلی این گروه نیستید"
        end
        local function callback (extra , success, result)
          local receiver = 'chat#'..matches[1]
          vardump(result)
          data[tostring(matches[1])]['settings']['set_link'] = result
          save_data(_config.moderation.data, data)
          return 
        end
        local receiver = 'chat#'..matches[1]
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] revoked group link ")
        export_chat_link(receiver, callback, true)
        return "لینک حدید ایجاد شد \n مدیر می تواند آن را دریافت کند"..matches[1].." get link"
      end
    end
    if matches[2] == 'get' then 
      if matches[3] == 'link' then
        if not is_owner2(msg.from.id, chat_id) then
          return "شما مدیر اصلی این گروه نیستید"
        end
        local group_link = data[tostring(matches[1])]['settings']['set_link']
        if not group_link then 
          return "اول لینک جدیدی ایجاد کنید"
        end
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] requested group link ["..group_link.."]")
        return "لینک گروه:\n"..group_link
      end
    end
    if matches[1] == 'changeabout' and matches[2] and is_owner2(msg.from.id, matches[2]) then
      local target = matches[2]
      local about = matches[3]
      local name = user_print_name(msg.from)
      savelog(matches[2], name.." ["..msg.from.id.."] has changed group description to ["..matches[3].."]")
      return set_description(target, about)
    end
    if matches[1] == 'changerules' and is_owner2(msg.from.id, matches[2]) then
      local rules = matches[3]
      local target = matches[2]
      local name = user_print_name(msg.from)
      savelog(matches[2], name.." ["..msg.from.id.."] has changed group rules to ["..matches[3].."]")
      return set_rules(target, rules)
    end
    if matches[1] == 'changename' and is_owner2(msg.from.id, matches[2]) then
      local new_name = string.gsub(matches[3], '_', ' ')
      data[tostring(matches[2])]['settings']['set_name'] = new_name
      save_data(_config.moderation.data, data)
      local group_name_set = data[tostring(matches[2])]['settings']['set_name']
      local to_rename = 'chat#id'..matches[2]
      local name = user_print_name(msg.from)
      savelog(matches[2], "Group {}  name changed to [ "..new_name.." ] by "..name.." ["..msg.from.id.."]")
      rename_chat(to_rename, group_name_set, ok_cb, false)
    end
    if matches[1] == 'loggroup' and matches[2] and is_owner2(msg.from.id, matches[2]) then
      savelog(matches[2], "------")
      send_document("user#id".. msg.from.id,"./groups/logs/"..matches[2].."log.txt", ok_cb, false)
    end
  end
end
return {
  patterns = {
    "^[!/]owners (%d+) ([^%s]+) (.*)$",
    "^[!/]owners (%d+) ([^%s]+)$",
    "^[!/](changeabout) (%d+) (.*)$",
    "^[!/](changerules) (%d+) (.*)$",
    "^[!/](changename) (%d+) (.*)$",
		"^[!/](loggroup) (%d+)$"
  },
  run = run
}
-- مدیر : @mohammadarak
-- ربات : @avirabot
-- هر گونه کپی برداری بدون ذکر منبع حرام است 
