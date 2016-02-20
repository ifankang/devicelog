#SingleInstance off
#NoTrayIcon
#IfWinActive ahk_class AutoHotkeyGUI
Hotkey, IfWinActive, %File%
Hotkey, ~Enter,ButtonSearch

StringRight, taun, A_yyyy, 2
IfNotExist, WatchLog4.ini
{
	IniWrite, \\goeboek1\(D) GOEBOEK1\LOG VOUCHA\2014\, WatchLog4.ini, Goeboek1, path
	IniWrite,\\goeboek2\(D) GOEBOEK2\LOG V4\, WatchLog4.ini, Goeboek2, path
}
IniRead, GB1, WatchLog4.ini, Goeboek1, path
IniRead, GB2, WatchLog4.ini, Goeboek2, path
;GB1=\\goeboek1\(D) GOEBOEK1\LOG VOUCHA\2013\
;GB2=\\goeboek2\(D) GOEBOEK2\LOG V4\

path=watchLogpath.txt
FileRead File2,%path%
IfNotExist %path%
{
	deviceGetLog(GB1,path)
	deviceGetLog(GB2,path)
	FileRead File2,%path%
}

StringReplace, File2, File2, `%taun`%,%taun% , All
StringReplace, File2, File2, `%a_dd`%,%a_dd% , All
StringReplace, File2, File2, `%a_mm`%,%a_mm% , All
StringReplace, File2, File2, `%a_yyyy`%,%a_yyyy% , All
; kemarin:=""
; a:=a_dd-1
; a=0%a%
; StringRight,kemarin,a,2
; kemarin=path%kemarin%.txt
; a:=""
; IfExist %kemarin%
	; FileDelete %kemarin%
; kemarin:=""

; updatePath:
File=%GB1%yahoo-AIRMAS-H2H-%a_yyyy%-%a_mm%-%a_dd%.log
; File2=%GB1%yahoo-AIRMAS-H2H-%a_yyyy%-%a_mm%-%a_dd%.log|%GB2%yahoo-AIRMAS2-H2H-%a_yyyy%-%a_mm%-%a_dd%.log|%GB2%yahoo-DCS-H2H-%a_yyyy%-%a_mm%-%a_dd%.log|%GB1%yahoo-AIRMAS3-H2H-%a_yyyy%-%a_mm%-%a_dd%.log|%GB2%three-THREE-ERA2-%taun%%a_mm%%a_dd%.log|%GB1%three-THREE-ERA1-%taun%%a_mm%%a_dd%.log|%GB1%esia-ESIA-AJK1-%taun%%a_mm%%a_dd%.log|%GB2%esia-ESIA-AJK2-%taun%%a_mm%%a_dd%.log|%GB1%dompetpulsa-DOMPUL01-%taun%%a_mm%%a_dd%.log|%GB2%dompetpulsa-DOMPUL02-%taun%%a_mm%%a_dd%.log|%GB1%dompetpulsa-DOMPUL03-%taun%%a_mm%%a_dd%.log|%GB2%dompetpulsa-DOMPUL04-%taun%%a_mm%%a_dd%.log|%GB1%dompetpulsa-DOMPUL05-%taun%%a_mm%%a_dd%.log|%GB1%sev-SEV-PRO1-%taun%%a_mm%%a_dd%.log|%GB2%sev-SEV-PRO2-%taun%%a_mm%%a_dd%.log|%GB1%sev-SEV-PRO3-%taun%%a_mm%%a_dd%.log|%GB2%sev-SEV-PRO4-%taun%%a_mm%%a_dd%.log|%GB1%sev-SEV-PRO5-%taun%%a_mm%%a_dd%.log|%GB1%fkios-FLEXI-SNL01-%taun%%a_mm%%a_dd%.log|%GB1%mkios-MKIOS-SIM01-%a_yyyy%-%a_mm%-%a_dd%.log|%GB2%mkios-MKIOS-SIM02-%a_yyyy%-%a_mm%-%a_dd%.log|%GB2%fkios-FLEXI-SNL02-%taun%%a_mm%%a_dd%.log|%GB1%fren-SMART-PMM01-%taun%%a_mm%%a_dd%.log|%GB2%fren-SMART-PMM02-%taun%%a_mm%%a_dd%.log

Gui, Color, FF8040,FFFFFF
Gui, font, s8, Verdana
FileRead, Data, %File%
Gui, Add, ComboBox, gFileInput w500 ,%File2%
Gui, Add, Button, gButtonBrowse  w95 h25, Browse
Gui, Add, Button, gButtonGB1  yp xp+100 w45 h25, GB1
Gui, Add, Button, gButtonGB2  yp xp+50 w45 h25, GB2
Gui, Add, Button, gButtonNew  yp xp+50 w33 h25, New
Gui, Add, Edit,  -BackgroundTrans vTextData -Border ReadOnly yp+30 xp-200 w500 h500,
Gui, Add, Edit, vTextInput w430 h20,
Gui, Add, Checkbox, vResultCek yp+3 xp+435, Result
Gui, Add, Edit, vTextInput0 xp-435 yp+20 w500 h50,
Gui, Add, Button, gButtonSearch  w95 h25, &Search
Gui, Add, Button, vButtonNext  yp xp+100 w95 h25 +Disabled ,  Ne&xt
Gui, Add, Button, gGrepButton  yp xp+100 w45 h25, GREP
Gui, Add, Text,vText yp xp+150 w150 h25, 

GuiControl,, FileInput, %File%
Gui, Show,, %File%
WinGet Gui_ID, ID, A
SetTimer, ParseData, 500
CaseSensitive := false
Return



ParseData:
FileRead, Data, %File%
If (Data <> LastData)
{
	GuiControl,, TextData, %Data%
	GuiControl Focus, TextData
	ControlGetFocus Edit2, ahk_id %Gui_ID%
	ControlSend Edit2, ^{End}, ahk_id %Gui_ID%
	GuiControl Focus, TextInput
	gui,Submit, NoHide
	FileRead, w, %File%
	StringReplace, w, w, `r, , All
	StringReplace, w, w, `n, `n, UseErrorLevel
	l := ErrorLevel + 1
	baris:=RegExReplace(l, "\d{1,3}(?=(\d{3}|\d{6}|\d{9})(\D|$))","$0,") ;hitung line
	baris:=Round(l)-1
	FileReadLine, line,%File% , baris
	RegExMatch( line, "i)"TextInput, hasil )
	if(hasil != "")		;(hasil= TextInput )
	{
        	SoundPlay, alert.wav 
		TrayTip,, %line%
		line:=RegExReplace(line, "\[((?>.)*(>])*)\]", "")
		GuiControl,, TextInput0, %line%
		RegExMatch( line, "i)berhasil|GAGAL|ditolak|salah|sukses|SUKSES|proses|menjual", result )
		GuiControl, , Text,%hasil% : %result% 
		ControlGetFocus Edit2, ahk_id %Gui_ID%
		ControlSend Edit2, ^{End}, ahk_id %Gui_ID%
		Loop 6
		{
   			Gui Flash
    			Sleep 5
		}
        	Sleep 2000
		ControlFocus Edit4
		ControlSend edit4,{Home}^+{End}
        	TrayTip
		hasil:=
	}
		;msgbox %hasil% %TextInput%
}
LastData=%Data%
Return

ButtonBrowse:
sleep 100
Gui +OwnDialogs
FileSelectFile, File, 3,%A_WorkingDir%, Open a LOG File, log Documents (*.txt;*.log),
if File =
{
	msgbox No Selected File!!
	return
}
gui,Submit, NoHide
GuiControl,, FileInput, %File%
Gui, Show,, %File%
GuiControl,, FileInput, %File%
Gui, Show,, %File%
return

ButtonGB1:
sleep 100
FileSelectFolder, GB1 , \\Goeboek1,0,Goeboek1 Log Path
GB1=%GB1%\
;InputBox, GB1, Goeboek1 Log Path,,,320, 100,,,,,%GB1%
if ErrorLevel
    return
IniWrite, %GB1%, WatchLog4.ini, Goeboek1, path
Reload
return


ButtonGB2:
sleep 100
FileSelectFolder, GB2 , \\Goeboekz,0,Goeboek2 Log Path

GB2=%GB2%\
;InputBox, GB2, Goeboek2 Log Path,,,320, 100,,,,,%GB2%
if ErrorLevel
    return
IniWrite, %GB2%, WatchLog4.ini, Goeboek2, path
Reload
return

ButtonSearch:
gui, Submit , NoHide
FileRead, w, %File%
StringReplace, w, w, `r, , All
StringReplace, w, w, `n, `n, UseErrorLevel
l := ErrorLevel + 1
bariss:=RegExReplace(l, "\d{1,3}(?=(\d{3}|\d{6}|\d{9})(\D|$))","$0,") ;hitung line
bariss:=Round(l)
GuiControl,, TextInput0,
GuiControl, , Text,
cont:
Loop
{
	FileReadLine, line,%File% , bariss
	GuiControl,Disable, ButtonNext
	bariss--
	if(bariss=0)
	{
		;MsgBox Cannot find "%BACKUP%"
		GuiControl, , Text,Tidak DiTemukan
		GuiControl,Disable, ButtonNext
		break
	}
	RegExMatch( line, "i)"TextInput, hasil )
	
	BACKUP:=TextInput
	if ResultCek = 1
	{
	RegExMatch( line, "i)berhasil|GAGAL|ditolak|salah|sukses|SUKSES|proses|menjual", result )
	if(hasil != "" && result != "")
	{	
		GuiControl,, TextInput0, %line%
		ControlGetFocus Edit2, ahk_id %Gui_ID%
		ControlSend Edit2, ^{End}, ahk_id %Gui_ID%
		GuiControl, , Text,%hasil% : %result% 
		hasil:=
		GuiControl,Enable, ButtonNext
		ControlFocus Edit4
		ControlSend edit4,{Home}^+{End}
		break
	}
	}
	else
	{
		if(hasil != "")
		{
			GuiControl,, TextInput0, %line%
			ControlGetFocus Edit2, ahk_id %Gui_ID%
			ControlSend Edit2, ^{End}, ahk_id %Gui_ID%
			hasil:=
			GuiControl,Enable, ButtonNext
			ControlFocus Edit4
			ControlSend edit4,{Home}^+{End}
			break
		}
	}
}
Return


ButtonNext:
gui, Submit , NoHide
GuiControl,Disable, ButtonNext
bariss--
gosub cont
return

FileInput:
ControlGet, File, Choice, ,ComboBox1
gui,Submit, NoHide
GuiControl,, FileInput, %File%
File2=%File2%|%File%
Gui, Color, FF8040
FileRead, Data, %File%
Gui, Show,, %File%
return

GrepButton:

reg=[^\r]{0,}%TextInput%[^\r]{0,}
grep(Data,reg, hasil)
GuiControl,, TextInput0, %hasil%
hasil:=
GuiControl,Enable, ButtonNext
ControlFocus Edit4
ControlSend edit4,{Home}^+{End}
return

GuiClose:
ExitApp
deviceGetLog(GB,outputFile)
{
	StringRight, taun, A_yyyy, 2
	tgl = -%taun%%a_mm%%a_dd%.log
	tgl2= -%a_yyyy%-%a_mm%-%a_dd%.log
	loop, %GB%*.log
	{
		StringRight, tang, A_LoopFileFullPath, 11
		StringRight, tang2, A_LoopFileFullPath, 15
		if(tang = tgl)
		{
			StringReplace,pat,A_LoopFileFullPath,%tang%,-`%taun`%`%a_mm`%`%a_dd`%.log
			fileAppend %pat%|, %outputFile%
		}
		if(tang2 = tgl2)
		{
			StringReplace,pat,A_LoopFileFullPath,%tang2%,-`%a_yyyy`%-`%a_mm`%-`%a_dd`%.log
			fileAppend %pat%|, %outputFile%
		}
	}
}

grep(h, n, ByRef v, s = 1, e = 0, d = "") {
	v =
	StringReplace, h, h, %d%, , All
	Loop
		If s := RegExMatch(h, n, c, s)
			p .= d . s, s += StrLen(c), v .= d . (e ? c%e% : c)
		Else Return, SubStr(p, 2), v := SubStr(v, 2)
}

ButtonNew:
run %A_ScriptFullPath%
return