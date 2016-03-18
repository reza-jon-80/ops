local function run(msg)
if msg.text == "!help" then
	return "Group Commands list :
 
1-banhammer list ^
 
!kick [username|id]
(کیک کردن شخص (حتی با ریپلی)

!ban [ username|id]
(بن کردن افراد (حتی با ریپلی)

!unban [id]
(انبن کردن افراد (همراه ایدی)

!kickinactive
حذف اعضای غیرغعال گروه

!kickme
خروج از گروه

2-Statistics list ^

!who
لیست+ایدی همه اعضا

!all
دریافت اطلاعات کلی گروه

!stats
امار کلی گروه

!modlist
لیست مدیران گروه

!banlist
لیست اعضا بن شده

3-Rate Member ^

!setowner [id]
(id ایجاد مدیر جدید (همراه 

!promote [username]
(ایجاد ادمین جدید (همراه ریپلی)

!demote [username]
(برکنار کردن ادمین (همراه ریپلی)

4-General changes ^

!setname [name]
ایجاد اسم جدید برای گروه

!setphoto
ایجاد عکس جدید برای پروفایل گروه

!set rules <text>
ایجاد قانون جدید برای گروه

!set about <text>
ایجاد درباره گروه

!setflood [value]
حساسیت به اسپم در گروه

5-View details ^

!about
درباره گروه

!rules
قوانین گروه

!settings
دیدن تنظیمات فعلی گروه

!help
لیست دستورات ربات

6-Security Group ^

!lock member 
قفل ورود اعضا جدید

!lock join
قفل ورود اعضا جدید توسط لینک

!lock name
قفل اسم گروه

!lock chat
قفل چت ممنوع

!lock ads
قفل تبلیغات

!lock leave
قفل خروج=بن گروه

!lock fosh
ممنوع کردن فحش

!lock chat
قفل چت ممنوع گروه

!antibot enable 
ورود ربات ها ممنوع

!antibot disable
ورود ربات ها ازاد

!unlock xxxx
[*name*leave*member]
[*fosh*ads]
[chat*join*photo]
باز کردن دستورات قفل شده

7-Fun time ^

!time country city
ساعت کشور مورد نظر

!loc country city
مشخصات کشور و شهر مورد نظر

!google
سرچ مطلب مورد نظر از گوگل
 
 !gps
 مکان کشور , شهر مورد نظر تحت گوگل
 
 !calc 3+1
 انجام محاسبات ریاضی

8-Service Provider ^

!newlink
ایجاد لینک جدید

!link
نمایش لینک گروه

!linkpv
فرستادن لینک گروه تو پیوی
(حتما شماره ربات را سیو کنید)

!invite username
اضافه کردن شخص تو گروه
(حتما شماره ربات را سیو کرده باشد)

9-Member Profile and Group ^
!owner
مدیر گروه

!id
ایدی شخص مورد نظر

!res [username]
در اوردن ایدی شخص مورد نظر

!info 
مخشصات فرد مورد نظر

!settings
تنظیمات فعلی گروه

10-filter word Mode ^

!filter set (word)
اضافه کردن کلمه جدید به لیست

!filter del (word)
حذف کلمه از لیست

!filter warn (word)
اخطار به کلمه فیتر شده

!filterlist
لیست کلمات فیلتر شده

11-bot number & support ^

!botnumber
دریافت شماره ربات

!support
دعوت سازنده ربات به گروه
(در صورت وجود مشکل)

!version
ورژن ربات

.شما میتوانید از ! و / استفاده کنید

channel: @mohammadarak

G00D LUCK ^_^"
end
if msg.text == "!realm help" then
	return "دستورات اتاق کنترل گروه:

!creategroup [اسم]
ساخت یک گروه با اسم دلخواه 

!createrealm [اسم]
ساخت یک اتاق کنترل

!setname [اسم]
تنظیم اسم ریلم

!setabout [متن] [ایدی گروه]
تنظیم درباره اتاق کنترل

!setrules [متن] [ایدی گروه]
تنظیم قوانین اتاق کنترل

!lock [تنظیمات] [ایدی گروه]
قفل یکی از تنظیمات گروه

!unlock [تنظیمات] [ایدی گروه]
باز کردن یکی از تنظیمات گروه

!wholist
دریافت لیست اعضای گروه/اتاق کنترل

!who
لیست اعضای گروه/اتاق کنترل به صورت فایل

!type
(دریافت تایپ گروه (گروه یا اتاق کنترل

!kill chat [ایدی گروه]
حذف یک گروه

!kill realm [ایدی ریلم]
حذف یک ریلم

!addadmin [ایدی فرد|یوزر عددی]
اضافه کردن ادمین به گروه

!removeadmin [ایدی فرد|یوزر عددی]
حذف کردن یک ادمین

!list groups
لیست تمام گروه های من به همراه ایدی

!list realms
لیست تمام ریلم های من به همراه ایدی

!log
دریافت اطلاعات کلی گروه یا ریلم

!broadcast [متن]
!broadcast سلام !
ارسال متن به تمام گروه ها
(فقط مخصوص سودو (ادمین اصلی

!bc [متن] [آیدی گروه]
!bc 123456789 سلام !
ارسال یک پیام به یک گروه مشخص توسط ایدی گروه

ch: @aviratgl"

end
end


return {
	description = "پلایگن راهنما", 
	usage = "chat with robot",
	patterns = {
	"^[!/]([Hh]elp)$",
	"^[!/]([Rr]ealm) ([Hh]elp)$",
		}, 
	run = run,
    --privileged = true,
	pre_process = pre_process
}
-- مدیر : @mohammadarak
-- ربات : @avirabot
-- هر گونه کپی برداری بدون ذکر منبع حرام است 
