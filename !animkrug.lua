script_name("animkrug")
script_version("22.08.2021")
script_url("http://github.com/qrlk/animkrug")
script_description("Simple animlist binder based on imgui_piemenu. 5 + LMB - open menu. 5 + RMB - repeat last.")

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
    name = '�����', action = function() end, next = {
      {name = '���������', action = function() last = "/animlist 0" sampSendChat(last) end, next = nil},
      {name = '���-��� 2', action = function() last = "/animlist 1" sampSendChat(last) end, next = nil},
      {name = '���-��� 3', action = function() last = "/animlist 2" sampSendChat(last) end, next = nil},
      {name = '���-��� 4', action = function() last = "/animlist 3" sampSendChat(last) end, next = nil},
      {name = '��������', action = function() last = "/animlist 4" sampSendChat(last) end, next = nil},
      {name = '������ ���', action = function() last = "/animlist 44" sampSendChat(last) end, next = nil},
      {name = '����� 7', action = function() last = "/animlist 45" sampSendChat(last) end, next = nil}
    }
  },
  {
    name = '����', action = function() end, next = {
      {name = '���� �� ������', action = function() last = "/animlist 20" sampSendChat(last) end, next = nil},
      {name = '�� ����', action = function() last = "/animlist 25" sampSendChat(last) end, next = nil},
      {name = '�����������', action = function() last = "/animlist 27" sampSendChat(last) end, next = nil},
      {name = '������/����', action = function() last = "/animlist 40" sampSendChat(last) end, next = nil},
      {name = '����� � �����', action = function() last = "/animlist 43" sampSendChat(last) end, next = nil},
    }
  },
  {
    name = '����', action = function() end, next = {
      {
        name = '�����', action = function() end, next = {
          {name = '������', action = function() last = "/animlist 5" sampSendChat(last) end, next = nil},
          {name = '���� � ����', action = function() last = "/animlist 8" sampSendChat(last) end, next = nil},
          {name = '������ 1', action = function() last = "/animlist 17" sampSendChat(last) end, next = nil},
          {name = '������ 2', action = function() last = "/animlist 41" sampSendChat(last) end, next = nil},
          {name = '����� �����', action = function() last = "/animlist 39" sampSendChat(last) end, next = nil},
        },
      },
      {
        name = '��������', action = function() end, next = {
          {name = '�������', action = function() last = "/animlist 18" sampSendChat(last) end, next = nil},
          {name = '������ ������', action = function() last = "/animlist 28" sampSendChat(last) end, next = nil},
          {name = '��������', action = function() last = "/animlist 29" sampSendChat(last) end, next = nil},
          {name = '��������', action = function() last = "/animlist 30" sampSendChat(last) end, next = nil},
          {name = '��� ������', action = function() last = "/animlist 31" sampSendChat(last) end, next = nil},
        },
      },
      {
        name = '������', action = function() end, next = {
          {name = '���� �����', action = function() last = "/animlist 19" sampSendChat(last) end, next = nil},
          {name = '��� ������', action = function() last = "/animlist 24" sampSendChat(last) end, next = nil},
          {name = '������', action = function() last = "/animlist 26" sampSendChat(last) end, next = nil},
          {name = '��������', action = function() last = "/animlist 37" sampSendChat(last) end, next = nil},
          {name = '������ � �������?', action = function() last = "/animlist 38" sampSendChat(last) end, next = nil},
        },
      },
    }
  },
  {
    name = '����', action = function() end, next = {
      {
        name = '�� �����', action = function() end, next = {
          {name = '���', action = function() last = "/animlist 14" sampSendChat(last) end, next = nil},
          {name = '������', action = function() last = "/animlist 16" sampSendChat(last) end, next = nil},
          {name = '�������', action = function() last = "/animlist 22" sampSendChat(last) end, next = nil},
          {name = '˸� �����', action = function() last = "/animlist 21" sampSendChat(last) end, next = nil},
        },
      },
      {
        name = '�� ����', action = function() end, next = {
          {name = '������ �� �����', action = function() last = "/animlist 6" sampSendChat(last) end, next = nil},
          {name = '�������� �� �����', action = function() last = "/animlist 7" sampSendChat(last) end, next = nil},
          {name = '���� ������ � �������?', action = function() last = "/animlist 13" sampSendChat(last) end, next = nil},
        },
      },
      {
        name = '�����', action = function() end, next = {
          {name = '�� ����� 1', action = function() last = "/animlist 9" sampSendChat(last) end, next = nil},
          {name = '�� ����� 2', action = function() last = "/animlist 12" sampSendChat(last) end, next = nil},
          {name = '�� ������ 1', action = function() last = "/animlist 10" sampSendChat(last) end, next = nil},
          {name = '�� ������ 2', action = function() last = "/animlist 11" sampSendChat(last) end, next = nil},
          {name = '� �������', action = function() last = "/animlist 15" sampSendChat(last) end, next = nil},
        },
      },
      {
        name = '�� ������', action = function() end, next = {
          {name = '������', action = function() last = "/animlist 23" sampSendChat(last) end, next = nil},
          {name = '�����', action = function() last = "/animlist 42" sampSendChat(last) end, next = nil}
        },
      },
    }
  },
  {
    name = '������ ���', action = function() end, next = {
      {name = '������', action = function() last = "/animlist 32" sampSendChat(last) end, next = nil},
      {name = '�����������', action = function() last = "/animlist 33" sampSendChat(last) end, next = nil},
      {name = '�����))', action = function() last = "/animlist 34" sampSendChat(last) end, next = nil},
      {name = '������ 1', action = function() last = "/animlist 35" sampSendChat(last) end, next = nil},
      {name = '������ 2', action = function() last = "/animlist 36" sampSendChat(last) end, next = nil},
    }
  },

}
--[[

==�����
0 - ����� 1
1 - ����� 2
2 - ����� 3
3 - ����� 4
4 - ����� 5 ��������
44 - ����� 6
45 - ����� 7
==����
20 - ���, ���� �� ������, ����� �����������
25 - ��� �� ����
27 - �� ������
40 - ��� �� ������/�� ����
43 - �������� ��������, ����� ������ � �����

==����
���� �����
5 - ������
8 - ���� ���� � �����, ������������
17 - ������
41 - ������ ������?
39 - ���������� �� ���-�� �����
��������
18 - ���� �������� ������ �����
28 - ������ �� ���� ���� ������
29 - ��������
30 - ��������� �������
31 - ��� ������ �����������
������
19 - ���� �����
24 - �������� ��� ������
26 - ������ ��� � ��������
37 - ���� � �������� ��������
38 - ���� ������ � �������?


==����
6 - ������ ���� �� �����, ��������� ����� �����
7 - �������� ���� �� �����, ��������� ����� ������, ��������� ����
9 - ������ �� ����� ���
10 - ����� �� ������ ���
11 - ������ �� ������ ���, �� �����
12 - �����, �� ����� ���
13 - ���� ������ � �������
14 - ���
15 - ������ �� ����
16 - ������ �� �����, ���� � �������
21 - ˸� � ������ ������, ��� ����� ����
22 - �������� �� ����� ���, ����� ������� �������
23 - ������ �� ������
42 - ������� �� ����, ������ ��� �����
]]
last = ""
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  while not string.find(sampGetCurrentServerName(), "Samp-Rp.Ru", 1, true) do wait(100) end
  update("http://qrlk.me/dev/moonloader/animkrug/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/qrlk.mods", "animkrugchangelog")
  openchangelog("animkrugchangelog", "http://qrlk.me/changelog/animkrug")
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
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
function update(php, prefix, url, komanda)
  komandaA = komanda
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  local ffi = require 'ffi'
  ffi.cdef[[
	int __stdcall GetVolumeInformationA(
			const char* lpRootPathName,
			char* lpVolumeNameBuffer,
			uint32_t nVolumeNameSize,
			uint32_t* lpVolumeSerialNumber,
			uint32_t* lpMaximumComponentLength,
			uint32_t* lpFileSystemFlags,
			char* lpFileSystemNameBuffer,
			uint32_t nFileSystemNameSize
	);
	]]
  local serial = ffi.new("unsigned long[1]", 0)
  ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
  serial = serial[0]
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
  if thisScript().name == "ADBLOCK" then
    if mode == nil then mode = "unsupported" end
    php = php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&m='..mode..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version
  else
    php = php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version
  end
  downloadUrlToFile(php, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            if info.changelog ~= nil then
              changelogurl = info.changelog
            end
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix, komanda)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('��������� %d �� %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('�������� ���������� ���������.')
                      if komandaA ~= nil then
                        sampAddChatMessage((prefix..'���������� ���������! ��������� �� ���������� - /'..komandaA..'.'), color)
                      end
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'���������� ������ ��������. �������� ���������� ������..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': ���������� �� ���������.')
            end
          end
        else
          print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function openchangelog(komanda, url)
  sampRegisterChatCommand(komanda,
    function()
      lua_thread.create(
        function()
          if changelogurl == nil then
            changelogurl = url
          end
          sampShowDialog(222228, "{ff0000}���������� �� ����������", "{ffffff}"..thisScript().name.." {ffe600}���������� ������� ���� changelog ��� ���.\n���� �� ������� {ffffff}�������{ffe600}, ������ ���������� ������� ������:\n        {ffffff}"..changelogurl.."\n{ffe600}���� ���� ���� ���������, �� ������ ������� ��� ������ ����.", "�������", "��������")
          while sampIsDialogActive() do wait(100) end
          local result, button, list, input = sampHasDialogRespond(222228)
          if button == 1 then
            os.execute('explorer "'..changelogurl..'"')
          end
        end
      )
    end
  )
end
