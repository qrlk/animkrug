require "lib.moonloader"

script_name("animkrug")
script_version("25.06.2022")
script_url("http://github.com/qrlk/animkrug")
script_description("Simple animlist binder based on imgui_piemenu. 5 + LMB - open menu. 5 + RMB - repeat last.")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("Этот скрипт перехватывает вылеты скрипта '"..target_name.." (ID: "..target_id..")".."' и отправляет их в систему мониторинга ошибок Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("скрипт "..target_name.." (ID: "..target_id..")".."завершил свою работу, выгружаемся через 60 секунд")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://1f82bacfb90643c0b9d955aab6c38b1a@o1272228.ingest.sentry.io/6529752" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/animkrug/master/version.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/animkrug"
    end
  end
end

local imgui = require 'imgui';
local pie = require 'imgui_piemenu';
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local pie_mode = imgui.ImBool(true)
local ffi = require 'ffi'

local pie_keyid = 0
local pie_elements =
{
  {
    name = 'Танец', action = function() end, next = {
      {name = 'Спокойный', action = function() last = "/animlist 0" sampSendChat(last) end, next = nil},
      {name = 'Хип-хоп 2', action = function() last = "/animlist 1" sampSendChat(last) end, next = nil},
      {name = 'Хип-хоп 3', action = function() last = "/animlist 2" sampSendChat(last) end, next = nil},
      {name = 'Хип-хоп 4', action = function() last = "/animlist 3" sampSendChat(last) end, next = nil},
      {name = 'Стриптиз', action = function() last = "/animlist 4" sampSendChat(last) end, next = nil},
      {name = 'Читать реп', action = function() last = "/animlist 44" sampSendChat(last) end, next = nil},
      {name = 'Танец 7', action = function() last = "/animlist 45" sampSendChat(last) end, next = nil}
    }
  },
  {
    name = 'Сидя', action = function() end, next = {
      {name = 'Руки за голову', action = function() last = "/animlist 20" sampSendChat(last) end, next = nil},
      {name = 'На стул', action = function() last = "/animlist 25" sampSendChat(last) end, next = nil},
      {name = 'Предложение', action = function() last = "/animlist 27" sampSendChat(last) end, next = nil},
      {name = 'Унитаз/руль', action = function() last = "/animlist 40" sampSendChat(last) end, next = nil},
      {name = 'Лицом к стулу', action = function() last = "/animlist 43" sampSendChat(last) end, next = nil},
    }
  },
  {
    name = 'Стоя', action = function() end, next = {
      {
        name = 'Круто', action = function() end, next = {
          {name = 'Курить', action = function() last = "/animlist 5" sampSendChat(last) end, next = nil},
          {name = 'Бита в руки', action = function() last = "/animlist 8" sampSendChat(last) end, next = nil},
          {name = 'Диллер 1', action = function() last = "/animlist 17" sampSendChat(last) end, next = nil},
          {name = 'Диллер 2', action = function() last = "/animlist 41" sampSendChat(last) end, next = nil},
          {name = 'Стена слева', action = function() last = "/animlist 39" sampSendChat(last) end, next = nil},
        },
      },
      {
        name = 'Забавное', action = function() end, next = {
          {name = 'Целится', action = function() last = "/animlist 18" sampSendChat(last) end, next = nil},
          {name = 'Шлепок справа', action = function() last = "/animlist 28" sampSendChat(last) end, next = nil},
          {name = 'Рукалицо', action = function() last = "/animlist 29" sampSendChat(last) end, next = nil},
          {name = 'Угрожать', action = function() last = "/animlist 30" sampSendChat(last) end, next = nil},
          {name = 'Фак руками', action = function() last = "/animlist 31" sampSendChat(last) end, next = nil},
        },
      },
      {
        name = 'Разное', action = function() end, next = {
          {name = 'Руки вверх', action = function() last = "/animlist 19" sampSendChat(last) end, next = nil},
          {name = 'Бег вправо', action = function() last = "/animlist 24" sampSendChat(last) end, next = nil},
          {name = 'Пьяный', action = function() last = "/animlist 26" sampSendChat(last) end, next = nil},
          {name = 'Защитная', action = function() last = "/animlist 37" sampSendChat(last) end, next = nil},
          {name = 'Скучно и одиноко?', action = function() last = "/animlist 38" sampSendChat(last) end, next = nil},
        },
      },
    }
  },
  {
    name = 'Лежа', action = function() end, next = {
      {
        name = 'На спине', action = function() end, next = {
          {name = 'Сон', action = function() last = "/animlist 14" sampSendChat(last) end, next = nil},
          {name = 'Прилег', action = function() last = "/animlist 16" sampSendChat(last) end, next = nil},
          {name = 'Бабочки', action = function() last = "/animlist 22" sampSendChat(last) end, next = nil},
          {name = 'Лёг прямо', action = function() last = "/animlist 21" sampSendChat(last) end, next = nil},
        },
      },
      {
        name = 'На руки', action = function() end, next = {
          {name = 'Быстро на спину', action = function() last = "/animlist 6" sampSendChat(last) end, next = nil},
          {name = 'Медленно на спину', action = function() last = "/animlist 7" sampSendChat(last) end, next = nil},
          {name = 'Тебе скучно и одиноко?', action = function() last = "/animlist 13" sampSendChat(last) end, next = nil},
        },
      },
      {
        name = 'Ломка', action = function() end, next = {
          {name = 'На левый 1', action = function() last = "/animlist 9" sampSendChat(last) end, next = nil},
          {name = 'На левый 2', action = function() last = "/animlist 12" sampSendChat(last) end, next = nil},
          {name = 'На правый 1', action = function() last = "/animlist 10" sampSendChat(last) end, next = nil},
          {name = 'На правый 2', action = function() last = "/animlist 11" sampSendChat(last) end, next = nil},
          {name = 'В коленях', action = function() last = "/animlist 15" sampSendChat(last) end, next = nil},
        },
      },
      {
        name = 'На пузико', action = function() end, next = {
          {name = 'Прилег', action = function() last = "/animlist 23" sampSendChat(last) end, next = nil},
          {name = 'Зомбу', action = function() last = "/animlist 42" sampSendChat(last) end, next = nil}
        },
      },
    }
  },
  {
    name = 'Читать реп', action = function() end, next = {
      {name = 'Диджей', action = function() last = "/animlist 32" sampSendChat(last) end, next = nil},
      {name = 'Размахивать', action = function() last = "/animlist 33" sampSendChat(last) end, next = nil},
      {name = 'Сзади))', action = function() last = "/animlist 34" sampSendChat(last) end, next = nil},
      {name = 'Читает 1', action = function() last = "/animlist 35" sampSendChat(last) end, next = nil},
      {name = 'Читает 2', action = function() last = "/animlist 36" sampSendChat(last) end, next = nil},
    }
  },

}
--[[

==ТАНЕЦ
0 - танец 1
1 - танец 2
2 - танец 3
3 - танец 4
4 - танец 5 стриптиз
44 - танец 6
45 - танец 7
==СИДЯ
20 - Сел, руки за голову, атака террористов
25 - сел на стул
27 - на колени
40 - сел на унитаз/за руль
43 - садишься вольяжно, лицом стоять к стулу

==СТОЯ
Типо круто
5 - курить
8 - типо бита в руках, размахиваешь
17 - Диллер
41 - хочешь писить?
39 - опираешься об что-то слева
Забавное
18 - Типо целишься правой рукой
28 - шлепок по жопе педу справа
29 - фейспалм
30 - угрожаешь кулаком
31 - фак руками показываешь
Разное
19 - Руки вверх
24 - странный бег вправо
26 - пьяный идёт в развалку
37 - руки в защитную позициюф
38 - тебе скучно и одиноко?


==ЛЕЖА
6 - быстро лечь на спину, опереться одной рукой
7 - медленно лечь на спину, опереться двумя руками, скрестить ноги
9 - ломает на левый бок
10 - дрожь на правый бок
11 - ломает на правый бок, на спину
12 - плохо, на левый бок
13 - тебе скучно и одиноко
14 - сон
15 - ломает на жопу
16 - Прилег на спину, ноги в коленях
21 - Лёг с прямой спиной, над зёмлей метр
22 - разлёгься на спине так, будто бабочек делаешь
23 - прилег на пузико
42 - падаешь на лицо, ползёшь как зомбу
]]
last = ""
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  while not string.find(sampGetCurrentServerName(), "Samp-Rp.Ru", 1, true) do wait(100) end

  -- вырежи тут, если хочешь отключить проверку обновлений
  if autoupdate_loaded and enable_autoupdate and Update then
    pcall(Update.check, Update.json_url, Update.prefix, Update.url)
  end
  -- вырежи тут, если хочешь отключить проверку обновлений

  ffi.cdef("bool SetCursorPos(int X, int Y);")
  while true do
    wait(0)
    if isKeyDown(0x35) then
      imgui.Process = true
      local sW, sH = getScreenResolution()
      ffi.C.SetCursorPos(sW / 2, sH / 2)
      while isKeyDown(0x35) do
        wait(0)
        if isKeyDown(2) then
          if last ~= "" then
            sampSendChat(last)
            wait(400)
          end
          break
        end
      end
    else
      imgui.Process = false
      imgui.ShowCursor = false
      --imgui.SetMouseCursor(imgui.MouseCursor.None)
    end
  end
end


function imgui.OnDrawFrame()
  if pie_mode.v then
    imgui.ShowCursor = true
    if imgui.IsMouseClicked(pie_keyid) then imgui.OpenPopup('PieMenu') end
    if pie.BeginPiePopup('PieMenu', pie_keyid) then
      for k, v in ipairs(pie_elements) do
        if v.next == nil then
          if pie.PieMenuItem(u8(v.name)) then v.action() end
        elseif type(v.next) == 'table' then
          drawPieSub(v)
        end
      end
      pie.EndPiePopup()
    end
  end
end

function drawPieSub(v)
  if pie.BeginPieMenu(u8(v.name)) then
    for i, l in ipairs(v.next) do
      if l.next == nil then
        if pie.PieMenuItem(u8(l.name)) then l.action() end
      elseif type(l.next) == 'table' then
        drawPieSub(l)
      end
    end
    pie.EndPieMenu()
  end
end

--style
function apply_custom_style()
  imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
  style.WindowRounding = 2.0
  style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
  style.ChildWindowRounding = 2.0
  style.FrameRounding = 2.0
  style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
  style.ScrollbarSize = 13.0
  style.ScrollbarRounding = 0
  style.GrabMinSize = 8.0
  style.GrabRounding = 1.0
  colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.TextDisabled] = ImVec4(0.50, 0.50, 0.50, 1.00)
  colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
  colors[clr.ChildWindowBg] = ImVec4(1.00, 1.00, 1.00, 0.00)
  colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
  colors[clr.ComboBg] = colors[clr.PopupBg]
  colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
  colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.FrameBg] = ImVec4(0.16, 0.29, 0.48, 0.54)
  colors[clr.FrameBgHovered] = ImVec4(0.26, 0.59, 0.98, 0.40)
  colors[clr.FrameBgActive] = ImVec4(0.26, 0.59, 0.98, 0.67)
  colors[clr.TitleBg] = ImVec4(0.04, 0.04, 0.04, 1.00)
  colors[clr.TitleBgActive] = ImVec4(0.16, 0.29, 0.48, 1.00)
  colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
  colors[clr.MenuBarBg] = ImVec4(0.14, 0.14, 0.14, 1.00)
  colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.53)
  colors[clr.ScrollbarGrab] = ImVec4(0.31, 0.31, 0.31, 1.00)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.51, 0.51, 0.51, 1.00)
  colors[clr.CheckMark] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.SliderGrab] = ImVec4(0.24, 0.52, 0.88, 1.00)
  colors[clr.SliderGrabActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.Button] = ImVec4(0.26, 0.59, 0.98, 0.40)
  colors[clr.ButtonHovered] = ImVec4(0, 0, 0, 1.00)
  colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
  colors[clr.Header] = ImVec4(0.26, 0.59, 0.98, 0.31)
  colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
  colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.Separator] = colors[clr.Border]
  colors[clr.SeparatorHovered] = ImVec4(0.26, 0.59, 0.98, 0.78)
  colors[clr.SeparatorActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
  colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
  colors[clr.ResizeGripActive] = ImVec4(0.26, 0.59, 0.98, 0.95)
  colors[clr.CloseButton] = ImVec4(0.41, 0.41, 0.41, 0.50)
  colors[clr.CloseButtonHovered] = ImVec4(0.98, 0.39, 0.36, 1.00)
  colors[clr.CloseButtonActive] = ImVec4(0.98, 0.39, 0.36, 1.00)
  colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
  colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
  colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
  colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
  colors[clr.TextSelectedBg] = ImVec4(0.26, 0.59, 0.98, 0.35)
  colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end