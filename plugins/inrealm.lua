-- data saved to moderation.json
-- check moderation plugin
do

local function create_group(msg)
        -- superuser and admins only (because sudo are always has privilege)
        if is_sudo(msg) or is_realm(msg) and is_admin(msg) then
                local group_creator = msg.from.print_name
                create_group_chat (group_creator, group_name, ok_cb, false)
                return 'گروه [ '..string.gsub(group_name, '_', ' ')..' ] ساخته شد'
        end
end

local function create_realm(msg)
        -- superuser and admins only (because sudo are always has privilege)
        if is_sudo(msg) or is_realm(msg) and is_admin(msg) then
                local group_creator = msg.from.print_name
                create_group_chat (group_creator, group_name, ok_cb, false)
                return 'ریلم [ '..string.gsub(group_name, '_', ' ')..' ] ساخته شد'
        end
end


local function killchat(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local chat_id = "chat#id"..result.id
  local chatname = result.print_name
  for k,v in pairs(result.members) do
    kick_user_any(v.id, result.id)     
  end
end

local function killrealm(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local chat_id = "chat#id"..result.id
  local chatname = result.print_name
  for k,v in pairs(result.members) do
    kick_user_any(v.id, result.id)     
  end
end

local function get_group_type(msg)
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
    if not data[tostring(msg.to.id)]['group_type'] then
     return 'نوع گروه مشخص نیست'
    end
     local group_type = data[tostring(msg.to.id)]['group_type']
     return group_type
  else 
     return 'گروه پیدا نشد'
  end 
end

local function callbackres(extra, success, result)
--vardump(result)
  local user = result.id
  local name = string.gsub(result.print_name, "_", " ")
  local chat = 'chat#id'..extra.chatid
  send_large_msg(chat, user..'\n'..name)
  return user
end

local function set_description(msg, data, target, about)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local data_cat = 'description'
        data[tostring(target)][data_cat] = about
        save_data(_config.moderation.data, data)
        return 'درباره گروه تنظیم شد به:\n'..about
end
 
local function set_rules(msg, data, target)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local data_cat = 'rules'
        data[tostring(target)][data_cat] = rules
        save_data(_config.moderation.data, data)
        return 'قوانین گروه تنظیم شد به:\n'..rules
end
-- lock/unlock group name. bot automatically change group name when locked
local function lock_group_name(msg, data, target)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
        if group_name_lock == '💚' then
            return 'گروه در حال حاظر قفل می باشد'
        else
            data[tostring(target)]['settings']['lock_name'] = '💚'
                save_data(_config.moderation.data, data)
                rename_chat('chat#id'..target, group_name_set, ok_cb, false)
        return 'نام گروه قفل شد'
        end
end
 
local function unlock_group_name(msg, data, target)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
        if group_name_lock == '❤️' then
            return 'گروه در حال حاظر باز می باشد'
        else
            data[tostring(target)]['settings']['lock_name'] = '❤️'
            save_data(_config.moderation.data, data)
        return 'گروه باز شد'
        end
end
--lock/unlock group member. bot automatically kick new added user when locked
local function lock_group_member(msg, data, target)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
        if group_member_lock == '💚' then
            return 'اعضای گروه در حال حاظر قفل می باشد'
        else
            data[tostring(target)]['settings']['lock_member'] = '💚'
            save_data(_config.moderation.data, data)
        end
        return 'افراد گروه قفل شدند'
end
 
local function unlock_group_member(msg, data, target)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
        if group_member_lock == '❤️' then
            return 'افراد گروه قفل نمی باشند'
        else
            data[tostring(target)]['settings']['lock_member'] = '❤️'
            save_data(_config.moderation.data, data)
        return 'افراد گروه باز شدند'
        end
end
 
--lock/unlock group photo. bot automatically keep group photo when locked
local function lock_group_photo(msg, data, target)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
        if group_photo_lock == '💚' then
            return 'عکس گروه در حال حاظر قفل می باشد'
        else
            data[tostring(target)]['settings']['set_photo'] = 'waiting'
            save_data(_config.moderation.data, data)
        end
        return 'حالا عکس جدید گروه را برایم ارسال کن'
end
 
local function unlock_group_photo(msg, data, target)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
        if group_photo_lock == '❤️' then
            return 'عکس گروه قفل نمی باشد'
        else
            data[tostring(target)]['settings']['lock_photo'] = '❤️'
            save_data(_config.moderation.data, data)
        return 'عکس گروه باز شد'
        end
end
 
local function lock_group_flood(msg, data, target)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local group_flood_lock = data[tostring(target)]['settings']['flood']
        if group_flood_lock == '💚' then
            return 'حساسیت ضد اسپم گروه قفل می باشد'
        else
            data[tostring(target)]['settings']['flood'] = '💚'
            save_data(_config.moderation.data, data)
        return 'حساسیت ضد اسپم گروه قفل شد'
        end
end
 
local function unlock_group_flood(msg, data, target)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local group_flood_lock = data[tostring(target)]['settings']['flood']
        if group_flood_lock == '❤️' then
            return 'حسایت ضد اسپم گروه قفل نمی باشد'
        else
            data[tostring(target)]['settings']['flood'] = '❤️'
            save_data(_config.moderation.data, data)
        return 'حسایت ضداسپم گروه باز شد'
        end
end
-- show group settings
local function show_group_settings(msg, data, target)
    local data = load_data(_config.moderation.data, data)
    if not is_admin(msg) then
        return "فقط مخصوص مدیران می باشد"
    end
    local settings = data[tostring(target)]['settings']
    local text = "تنظیمات گروه:\nقفل اسم گروه: "..settings.lock_name.."\nقفل عکس گروه : "..settings.lock_photo.."\nقفل ورود اعضا : "..settings.lock_member
    return text
end

local function returnids(cb_extra, success, result)
 
        local receiver = cb_extra.receiver
    local chat_id = "chat#id"..result.id
    local chatname = result.print_name
    local text = 'افراد در '..string.gsub(chatname,"_"," ")..' ('..result.id..'):'..'\n'..''
    for k,v in pairs(result.members) do
    	if v.print_name then
        	local username = ""
        	text = text .. "- " .. string.gsub(v.print_name,"_"," ") .. "  (" .. v.id .. ") \n"
        end
    end
    send_large_msg(receiver, text)
        local file = io.open("./groups/lists/"..result.id.."memberlist.txt", "w")
        file:write(text)
        file:flush()
        file:close()
end
 
local function returnidsfile(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local chat_id = "chat#id"..result.id
    local chatname = result.print_name
    local text = 'افراد در '..string.gsub(chatname,"_"," ")..' ('..result.id..'):'..'\n'..''
    for k,v in pairs(result.members) do
    	if v.print_name then
        	local username = ""
        	text = text .. "- " .. string.gsub(v.print_name,"_"," ") .. "  (" .. v.id .. ") \n"
        end
    end
        local file = io.open("./groups/lists/"..result.id.."memberlist.txt", "w")
        file:write(text)
        file:flush()
        file:close()
        send_document("chat#id"..result.id,"./groups/lists/"..result.id.."memberlist.txt", ok_cb, false)
end
 
local function admin_promote(msg, admin_id)
        if not is_sudo(msg) then
        return "دسترسی شما عیر مجاز می باشد"
    end
        local admins = 'admins'
        if not data[tostring(admins)] then
                data[tostring(admins)] = {}
                save_data(_config.moderation.data, data)
        end
        if data[tostring(admins)][tostring(admin_id)] then
                return admin_name..' در حال حاظر مدیر می باشد'
        end
        data[tostring(admins)][tostring(admin_id)] = admin_id
        save_data(_config.moderation.data, data)
        return admin_id..' مدیر شد'
end

local function admin_demote(msg, admin_id)
    if not is_sudo(msg) then
        return "دسترسی شما غیر مجاز می باشد"
    end
    local data = load_data(_config.moderation.data)
        local admins = 'admins'
        if not data[tostring(admins)] then
                data[tostring(admins)] = {}
                save_data(_config.moderation.data, data)
        end
        if not data[tostring(admins)][tostring(admin_id)] then
                return admin_id..' مدیر نمی باشد'
        end
        data[tostring(admins)][tostring(admin_id)] = nil
        save_data(_config.moderation.data, data)
        return admin_id..' از لیست مدیران حذف شد'
end
 
local function admin_list(msg)
    local data = load_data(_config.moderation.data)
        local admins = 'admins'
        if not data[tostring(admins)] then
        data[tostring(admins)] = {}
        save_data(_config.moderation.data, data)
        end
        local message = 'لیست مدیر های ریلم:\n'
        for k,v in pairs(data[tostring(admins)]) do
                message = message .. '- (at)' .. v .. ' [' .. k .. '] ' ..'\n'
        end
        return message
end
 
local function groups_list(msg)
    local data = load_data(_config.moderation.data)
        local groups = 'groups'
        if not data[tostring(groups)] then
                return 'شما گروهی ندارید'
        end
        local message = 'List of groups:\n'
        for k,v in pairs(data[tostring(groups)]) do
                local settings = data[tostring(v)]['settings']
                for m,n in pairs(settings) do
                        if m == 'set_name' then
                                name = n
                        end
                end
                local group_owner = "مدیری وجود ندارد"
                if data[tostring(v)]['set_owner'] then
                        group_owner = tostring(data[tostring(v)]['set_owner'])
                end
                local group_link = "لینکی وجود ندارد"
                if data[tostring(v)]['settings']['set_link'] then
			group_link = data[tostring(v)]['settings']['set_link']
		end

                message = message .. '- '.. name .. ' (' .. v .. ') ['..group_owner..'] \n {'..group_link.."}\n"
             
               
        end
        local file = io.open("./groups/lists/groups.txt", "w")
        file:write(message)
        file:flush()
        file:close()
        return message
       
end
local function realms_list(msg)
    local data = load_data(_config.moderation.data)
        local realms = 'realms'
        if not data[tostring(realms)] then
                return 'شما ریلمی ندارید'
        end
        local message = 'لیست ریلم ها:\n'
        for k,v in pairs(data[tostring(realms)]) do
                local settings = data[tostring(v)]['settings']
                for m,n in pairs(settings) do
                        if m == 'set_name' then
                                name = n
                        end
                end
                local group_owner = "مدیری وجود ندارد"
                if data[tostring(v)]['admins_in'] then
                        group_owner = tostring(data[tostring(v)]['admins_in'])
		end
                local group_link = "لینکی وجود ندارد"
                if data[tostring(v)]['settings']['set_link'] then
			group_link = data[tostring(v)]['settings']['set_link']
		end
                message = message .. '- '.. name .. ' (' .. v .. ') ['..group_owner..'] \n {'..group_link.."}\n"
        end
        local file = io.open("./groups/lists/realms.txt", "w")
        file:write(message)
        file:flush()
        file:close()
        return message
end
local function admin_user_promote(receiver, member_username, member_id)
        local data = load_data(_config.moderation.data)
        if not data['admins'] then
                data['admins'] = {}
                save_data(_config.moderation.data, data)
        end
        if data['admins'][tostring(member_id)] then
                return send_large_msg(receiver, member_username..' در حال حاظر مدیر می باشد')
        end
        data['admins'][tostring(member_id)] = member_username
        save_data(_config.moderation.data, data)
        return send_large_msg(receiver, '@'..member_username..' مدیر شد')
end
 
local function admin_user_demote(receiver, member_username, member_id)
    local data = load_data(_config.moderation.data)
        if not data['admins'] then
                data['admins'] = {}
                save_data(_config.moderation.data, data)
        end
        if not data['admins'][tostring(member_id)] then
                return send_large_msg(receiver, member_username..' یک مدیر نمی باشد')
        end
        data['admins'][tostring(member_id)] = nil
        save_data(_config.moderation.data, data)
        return send_large_msg(receiver, 'Admin '..member_username..' از لیست مدیران حذف شد')
end

 
local function username_id(cb_extra, success, result)
   local mod_cmd = cb_extra.mod_cmd
   local receiver = cb_extra.receiver
   local member = cb_extra.member
   local text = 'یوزر @'..member..' دز این گروه'
   for k,v in pairs(result.members) do
      vusername = v.username
      if vusername == member then
        member_username = member
        member_id = v.id
        if mod_cmd == 'addadmin' then
            return admin_user_promote(receiver, member_username, member_id)
        elseif mod_cmd == 'removeadmin' then
            return admin_user_demote(receiver, member_username, member_id)
        end
      end
   end
   send_large_msg(receiver, text)
end

local function set_log_group(msg)
  if not is_admin(msg) then
    return 
  end
  local log_group = data[tostring(groups)][tostring(msg.to.id)]['log_group']
  if log_group == '💚' then
    return 'لوگ گروه در حال حاظر تنظیم شده است'
  else
    data[tostring(groups)][tostring(msg.to.id)]['log_group'] = '💚'
    save_data(_config.moderation.data, data)
    return 'لوگ گروه تنظیم شد'
  end
end

local function unset_log_group(msg)
  if not is_admin(msg) then
    return 
  end
  local log_group = data[tostring(groups)][tostring(msg.to.id)]['log_group']
  if log_group == '❤️' then
    return 'لوگ گروه در حال حاظر غیر فعال است'
  else
    data[tostring(groups)][tostring(msg.to.id)]['log_group'] = '❤️'
    save_data(_config.moderation.data, data)
    return 'لوگ گروه غیر فعال شد'
  end
end

local function help()
  local help_text = tostring(_config.help_text_realm)
  return help_text
end

function run(msg, matches)
    --vardump(msg)
   	local name_log = user_print_name(msg.from)
       if matches[1] == 'log' and is_owner(msg) then
		savelog(msg.to.id, "فایل لوگ توسط مدیر ایجاد شد")
		send_document("chat#id"..msg.to.id,"./groups/"..msg.to.id.."log.txt", ok_cb, false)
        end

	if matches[1] == 'who' and is_momod(msg) then
		local name = user_print_name(msg.from)
		savelog(msg.to.id, name.." ["..msg.from.id.."] requested member list ")
		local receiver = get_receiver(msg)
		chat_info(receiver, returnidsfile, {receiver=receiver})
	end
	if matches[1] == 'wholist' and is_momod(msg) then
		local name = user_print_name(msg.from)
		savelog(msg.to.id, name.." ["..msg.from.id.."] requested member list in a file")
		local receiver = get_receiver(msg)
		chat_info(receiver, returnids, {receiver=receiver})
	end

    if matches[1] == 'creategroup' and matches[2] then
        group_name = matches[2]
        group_type = 'group'
        return create_group(msg)
    end
    
    if not is_sudo(msg) or not is_admin(msg) and not is_realm(msg) then
		return  --Do nothing
	end

    if matches[1] == 'createrealm' and matches[2] then
        group_name = matches[2]
        group_type = 'realm'
        return create_realm(msg)
    end

    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
	if matches[2] then if data[tostring(matches[2])] then
		local settings = data[tostring(matches[2])]['settings']
		if matches[1] == 'setabout' and matches[2] then
			local target = matches[2]
		    local about = matches[3]
		    return set_description(msg, data, target, about)
		end
		if matches[1] == 'setrules' then
		    rules = matches[3]
			local target = matches[2]
		    return set_rules(msg, data, target)
		end
		if matches[1] == 'lock' then --group lock *
			local target = matches[2]
		    if matches[3] == 'name' then
		        return lock_group_name(msg, data, target)
		    end
		    if matches[3] == 'member' then
		        return lock_group_member(msg, data, target)
		    end
		    if matches[3] == 'photo' then
		        return lock_group_photo(msg, data, target)
		    end
		    if matches[3] == 'flood' then
		        return lock_group_flood(msg, data, target)
		    end
		end
		if matches[1] == 'unlock' then --group unlock *
			local target = matches[2]
		    if matches[3] == 'name' then
		        return unlock_group_name(msg, data, target)
		    end
		    if matches[3] == 'member' then
		        return unlock_group_member(msg, data, target)
		    end
		    if matches[3] == 'photo' then
		    	return unlock_group_photo(msg, data, target)
		    end
		    if matches[3] == 'flood' then
		        return unlock_group_flood(msg, data, target)
		    end
		end
		if matches[1] == 'settings' and data[tostring(matches[2])]['settings'] then
			local target = matches[2]
		    return show_group_settings(msg, data, target)
		end

                if matches[1] == 'setname' and is_realm(msg) then
                    local new_name = string.gsub(matches[2], '_', ' ')
                    data[tostring(msg.to.id)]['settings']['set_name'] = new_name
                    save_data(_config.moderation.data, data)
                    local group_name_set = data[tostring(msg.to.id)]['settings']['set_name']
                    local to_rename = 'chat#id'..msg.to.id
                    rename_chat(to_rename, group_name_set, ok_cb, false)
                    savelog(msg.to.id, "ریلم { "..msg.to.print_name.." }  نام تغییر یافت به [ "..new_name.." ] توسط "..name_log.." ["..msg.from.id.."]")
                end
		if matches[1] == 'setgpname' and is_admin(msg) then
		    local new_name = string.gsub(matches[3], '_', ' ')
		    data[tostring(matches[2])]['settings']['set_name'] = new_name
		    save_data(_config.moderation.data, data)
		    local group_name_set = data[tostring(matches[2])]['settings']['set_name']
		    local to_rename = 'chat#id'..matches[2]
		    rename_chat(to_rename, group_name_set, ok_cb, false)
                    savelog(msg.to.id, "گروه { "..msg.to.print_name.." }  نام تغییر یافت به [ "..new_name.." ] توسط "..name_log.." ["..msg.from.id.."]")
		end

	    end 
        end
    	if matches[1] == 'help' and is_realm(msg) then
      		savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /help")
     		return help()
    	end
              if matches[1] == 'set' then
                if matches[2] == 'loggroup' then
                   savelog(msg.to.id, name_log.." ["..msg.from.id.."] تنظیم به عنان فایل لوگ")
                  return set_log_group(msg)
                end
              end
                if matches[1] == 'kill' and matches[2] == 'chat' then
                  if not is_admin(msg) then
                     return nil
                  end
                  if is_realm(msg) then
                     local receiver = 'chat#id'..matches[3]
                     return modrem(msg),
                     print("Closing Group: "..receiver),
                     chat_info(receiver, killchat, {receiver=receiver})
                  else
                     return 'گروه: خطا '..matches[3]..' پیدا نشد' 
                    end
                 end
                if matches[1] == 'kill' and matches[2] == 'realm' then
                  if not is_admin(msg) then
                     return nil
                  end
                  if is_realm(msg) then
                     local receiver = 'chat#id'..matches[3]
                     return realmrem(msg),
                     print("Closing realm: "..receiver),
                     chat_info(receiver, killrealm, {receiver=receiver})
                  else
                     return 'ریلم: خطا '..matches[3]..' پیدا نشد' 
                    end
                 end
		if matches[1] == 'chat_add_user' then
		    if not msg.service then
		        return "آیا تو می خواهی مرا بخندانی؟"
		    end
		    local user = 'user#id'..msg.action.user.id
		    local chat = 'chat#id'..msg.to.id
		    if not is_admin(msg) then
				chat_del_user(chat, user, ok_cb, true)
			end
		end
		if matches[1] == 'addadmin' then
			if string.match(matches[2], '^%d+$') then
				local admin_id = matches[2]
				print("user "..admin_id.." به لیست مدیران اضافه شد")
				return admin_promote(msg, admin_id)
			else
			local member = string.gsub(matches[2], "@", "")
				local mod_cmd = "addadmin"
				chat_info(receiver, username_id, {mod_cmd= mod_cmd, receiver=receiver, member=member})
			end
		end
		if matches[1] == 'removeadmin' then
			if string.match(matches[2], '^%d+$') then
				local admin_id = matches[2]
				print("user "..admin_id.." از لیست مدیران حذف شد")
				return admin_demote(msg, admin_id)
			else
			local member = string.gsub(matches[2], "@", "")
				local mod_cmd = "removeadmin"
				chat_info(receiver, username_id, {mod_cmd= mod_cmd, receiver=receiver, member=member})
			end
		end
		if matches[1] == 'type'then
                        local group_type = get_group_type(msg)
			return group_type
		end
		if matches[1] == 'list' and matches[2] == 'admins' then
			return admin_list(msg)
		end
		if matches[1] == 'list' and matches[2] == 'groups' then
                  if msg.to.type == 'chat' then
			groups_list(msg)
		        send_document("chat#id"..msg.to.id, "./groups/lists/groups.txt", ok_cb, false)	
			return "لیست گروه ایجاد شد" --group_list(msg)
                   elseif msg.to.type == 'user' then 
                        groups_list(msg)
		        send_document("user#id"..msg.from.id, "./groups/lists/groups.txt", ok_cb, false)	
			return "لیست گروه ایجاد شد" --group_list(msg)
                  end
		end
		if matches[1] == 'list' and matches[2] == 'realms' then
                  if msg.to.type == 'chat' then
			realms_list(msg)
		        send_document("chat#id"..msg.to.id, "./groups/lists/realms.txt", ok_cb, false)	
			return "لیست ریلم ایجاد شد" --realms_list(msg)
                   elseif msg.to.type == 'user' then 
                        realms_list(msg)
		        send_document("user#id"..msg.from.id, "./groups/lists/realms.txt", ok_cb, false)	
			return "لیست ریلم ایجاد شد" --realms_list(msg)
                  end
		end
   		 if matches[1] == 'res' and is_momod(msg) then 
      			local cbres_extra = {
        			chatid = msg.to.id
     			}
      			local username = matches[2]
      			local username = username:gsub("@","")
      			savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /res "..username)
      			return res_user(username,  callbackres, cbres_extra)
    end
end



return {
  patterns = {
    "^[!/](creategroup) (.*)$",
    "^[!/](createrealm) (.*)$",
    "^[!/](setabout) (%d+) (.*)$",
    "^[!/](setrules) (%d+) (.*)$",
    "^[!/](setname) (.*)$",
    "^[!/](setgpname) (%d+) (.*)$",
    "^[!/](setname) (%d+) (.*)$",
        "^[!/](lock) (%d+) (.*)$",
    "^[!/](unlock) (%d+) (.*)$",
    "^[!/](setting) (%d+)$",
        "^[!/](wholist)$",
        "^[!/](who)$",
        "^[!/](type)$",
    "^[!/](kill) (chat) (%d+)$",
    "^[!/](kill) (realm) (%d+)$",
    "^[!/](addadmin) (.*)$", -- sudoers only
    "^[!/](removeadmin) (.*)$", -- sudoers only
    "^[!/](list) (.*)$",
        "^[!/](log)$",
        "^[!/](help)$",
        "^!!tgservice (.+)$",
  },
  run = run
}
end
-- مدیر : @mohammadarak
-- ربات : @avirabot
-- هر گونه کپی برداری بدون ذکر منبع حرام است 
