local function run(msg, matches)
    if is_owner(msg) then
        return
    end
    local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)] then
        if data[tostring(msg.to.id)]['settings'] then
            if data[tostring(msg.to.id)]['settings']['imoji'] then
                lock_imoji = data[tostring(msg.to.id)]['settings']['imoji']
            end
        end
    end
    local chat = get_receiver(msg)
    local user = "user#id"..msg.from.id
    if lock_imoji == "yes" then
        send_large_msg(chat, 'به دلیل ارسال ایموجی فیس اخراج شد')
        chat_del_user(chat, user, ok_cb, true)
    end
end
 
return {
  patterns = {
    "😀(.*)",
    "😬(.*)",
    "😁(.*)",
    "😂(.*)",
    "😃(.*)",
    "😄(.*)",
    "😅(.*)",
    "😆(.*)",
    "😇(.*)",
    "😉(.*)",
    "🙂(.*)",
    "😊(.*)",
    "🙃(.*)",
    "☺️(.*)",
    "😋(.*)",
    "😌(.*)",
    "😍(.*)",
    "😘(.*)",
    "😗(.*)",
    "😙(.*)",
    "😚(.*)",
    "😜(.*)",
    "😛(.*)",
    "😝(.*)",
    "🤑(.*)",
    "🤓(.*)",
    "😎(.*)",
    "🤗(.*)",
    "🤔(.*)",
    "😒(.*)",
    "😑(.*)",
    "😐(.*)",
    "😶(.*)",
    "😏(.*)",
    "😕(.*)",
    "😔(.*)",
    "😡(.*)",
    "😠(.*)",
    "😟(.*)",
    "😳(.*)",
    "😞(.*)",
    "🙁(.*)",
    "☹️(.*)",
    "😣(.*)",
    "😖(.*)", 
    "😫(.*)",
    "😩(.*)",
    "😤(.*)",
    "😧(.*)",
    "😦(.*)",
    "😯(.*)",
    "😨(.*)",
    "😱(.*)",
    "😮(.*)",
    "😢(.*)",
    "😥(.*)",
    "😪(.*)",
    "️😓(.*)",
    "😭(.*)",
    "😵(.*)",
    "😲(.*)",
    "😴(.*)",
    "️🤕(.*)",
    "🤒(.*)",
    "😷(.*)",
    "🤐(.*)",

  },
  run = run
}
-- مدیر : @mohammadarak
-- ربات : @avirabot
-- هر گونه کپی برداری بدون ذکر منبع حرام است 
