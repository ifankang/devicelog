#Persistent
#SingleInstance ,force
CoordMode, ToolTip, Screen 
;Menu, Tray, Icon, User32.dll, 5
CaseSensitive := false
TextInput=Thread|merespon/timeout|ClearCommError|EAtCommandError|function|GetSignalQuality|functioning
MaxSize=200000
batas:= 60
YangDibatasi = REPLEY-XL
;Thread|Penjual|merespon|GetSignalQuality|EAtCommandError|function|GetSignalQuality
ArrayCount = 0
count = 0
iniPath=DeviceLog.ini
IFnotExist deviceLog
	FileCreateDir deviceLog

logHasil = deviceLog/Log%a_dd%%a_mmm%%taun%.log 
FileAppend Start %A_Hour%:%A_Min%:%A_sec%`n,%logHasil%
SetTimer, lihatJam, 2000
SetTimer, cekThread, 2000
fileDelete logPath.txt
WinGet, Window, List
Loop %Window%
{
Id:=Window%A_Index%
WinGetTitle, TVar , % "ahk_id " Id
Window%A_Index%:=""
if(Tvar!="")
{
WinGetClass, class , %Tvar%
Winget ,nom,PID,%Tvar%
queryEnum := ComObjGet("winmgmts:").ExecQuery(""
        . "Select * from Win32_Process where ProcessId=" . nom)
        ._NewEnum()
    	; Get first matching process.
    	if queryEnum[process]
	{
		cmd := % process.CommandLine
	}
   	 else
        	MsgBox Process not found!


if(class="TFMain")
{

	log:=deviceGetLog(Tvar)
	IniWrite, %Tvar%, %iniPath%, %log%, nama
	IniWrite, %cmd%, %iniPath%, %log%, cmd
	IniWrite, %nom%, %iniPath%, %log%, pid
	if(log!="")
		fileAppend %log%`n, logPath.txt
}
	
}
}
Window:=cmd:=nom:=class:=Tvar:=queryEnum :=process :=Id:= ""

deviceGetLog(Title ,iniPath := "device.ini")
{
	StringRight, taun, A_yyyy, 2
	GB1 = \\Goeboek1\(D) GOEBOEK1\LOG VOUCHA\2014\
	GB3 = \\Goeboekz\LOG v4\
	tgl = -%taun%%a_mm%%a_dd%.log
	tgl2= -%a_yyyy%-%a_mm%-%a_dd%.log
	GB:=A_ComputerName="GOEBOEK1"?GB1:GB3
	loop, %GB%\*.log
	{
		StringRight, tang, A_LoopFileFullPath, 11
		StringRight, tang2, A_LoopFileFullPath, 15
		if(tang = tgl or tang2 = tgl2)
		{
			StringReplace, Title, Title, %A_Space%,`,, 
			StringReplace, Title, Title, -,`,, 
			StringReplace, Title, Title, `,`,,`,,All 
			Title := RegExReplace(Title, "i)sev,|REPLEY,|- Voucha4 SMS|Voucha4,|TSEL|,sms|ISAT,|,Indosat|,sev|XL,|FLEXI,|,Fkios|Mkios,|,mkios|,three|three,|esia,|,esia|Axis,|,Axis|Dompet|Pulsa|Messenger|Forwarder|Yahoo!|yahoo|H2H.", "") 
			IniRead, hasil, %iniPath%, %Title%, name
			;if A_LoopFileName contains %Title%
			StringReplace,Title,Title,`,,
			StringReplace,Title,Title,M301,M3-01
			;StringReplace,Title,Title,YM`,Client,YM%A_Space%Client
			filenamelog:= RegExReplace(A_LoopFilename, "i)sev,|REPLEY,|- Voucha4 SMS|Voucha4,|TSEL|,sms|ISAT,|,Indosat|,sev|XL,|FLEXI,|,Fkios|Mkios,|,mkios|,three|three,|esia,|,esia|Axis,|,Axis|Dompet|Pulsa|Messenger|Forwarder|Yahoo!|yahoo|H2H.", "")
			StringReplace,filenamelog,filenamelog,%tgl2%,
			StringReplace,filenamelog,filenamelog,%tgl%,
			StringReplace,filenamelog,filenamelog,-,
			; xx := DamerauLevenshteinDistance(filenamelog, Title)
			; if(xx<=5 && xx!="" && xx != 0)
			; msgbox %filenamelog% x %Title% = %xx%
			
			IfInString filenamelog, %Title%
			{
				;fileAppend %Title% x %filenamelog%`n, hasil.txt
				Title:=""
				return % A_LoopFileFullPath
			}
			IfInString Title, %filenamelog%
			{
				;fileAppend %Title% x %filenamelog%`n, hasil.txt
				Title:=""
				return % A_LoopFileFullPath
			}
		}

	}
}

Loop, Read, logPath.txt
{
    ArrayCount += 1  ; Keep track of how many items are in the array.
    File%ArrayCount% := A_LoopReadLine  ; Store this line in the next array element.
}
FileDelete, logPath.txt
; Read from the array:

#Persistent
SetTimer, start, 250
return

start:
Loop %ArrayCount%
{
    ; The following line uses the := operator to retrieve an array element:
     file := File%A_Index%  ; A_Index is a built-in variable.
	StringReplace, file, file, `%taun`%,%taun% , All
	StringReplace, file, file, `%a_dd`%,%a_dd% , All
	StringReplace, file, file, `%a_mm`%,%a_mm% , All
	;msgbox %file%
	
fileRead, data%A_Index%,  %file%
if ErrorLevel
msgbox %file% kosong
If (data%A_Index% <> Lastdata%A_Index%)
{
	IniRead, namaDevice, %iniPath%, %file%, nama
	jumlah:= count("Pesan terkirim",file)
	RegExMatch( namaDevice, "i)"YangDibatasi, x )
	If(x != "")
	{
		if(jumlah > batas){
			
			if(line%A_Index% <> "")
			IfNotInString line%A_Index%,stopped
			{	
				;MsgBox % line%A_Index%
				x:=jumlah-batas
				;msgbox Jumlah terkirim %namaDevice% melebihi limit %x%
				stopDevice(namaDevice)
				FileAppend %namaDevice% lebih batas,%logHasil%
			}
		}
		; else{
			; sisa:=batas-jumlah
			; MsgBox %namaDevice% mengirim %jumlah% sms, `nmasih sisa %sisa% sms `n %x%
		; }
	}
	
	
	;file:= File%A_Index%
	fileRead, w%A_Index%, %file%
	StringReplace, w%A_Index%, w%A_Index%, `r, , All
	StringReplace, w%A_Index%, w%A_Index%, `n, `n, UseErrorLevel
	l%A_Index% := ErrorLevel + 1
	baris%A_Index%:=RegExReplace(l%A_Index%, "\d{1,3}(?=(\d{3}|\d{6}|\d{9})(\D|$))","$0,")
	baris%A_Index%:=Round(l%A_Index%)-1
	fileReadline, line%A_Index%, %file% , baris%A_Index%
	RegExMatch( line%A_Index%, "i)"TextInput, hasil%A_Index% )
	if(hasil%A_Index% != "" )
	{
        SoundPlay, alert.wav
		IniRead, namaDevice, %iniPath%, %file%, nama
		WinActivate, %namaDevice%
		WinWaitActive, %namaDevice%
		sleep 1000
		ControlSend, ,F5,%namaDevice%
		MsgBox, 4, , % namaDevice "mati. Close?`n"line%A_Index% ,30
		IfMsgBox No
		{
    		Sleep 8000
			return
		}
		WinClose %namaDevice%
		WinWaitClose %namaDevice%
		
		fileAppend %namaDevice% di close gara2%A_Space%, %logHasil%
		fileAppend % line%A_Index%,%logHasil%
		fileAppend `n,%logHasil%
		Sleep 8000
		Reload
		;IniRead, hasil, %iniPath%, %file%, cmd
		;loop 4
			;StringReplace, hasil, hasil, ", , All
		;PostMessage, 0x111, 65306,,, PROGRAM3
		;sleep 500
		;Run %hasil%
		;sleep 1000
		;PostMessage, 0x111, 65306,,, PROGRAM3
		
		hasil%A_Index%:=
	}
		;;;;Jika Memory melebihi MaxSize 
		IniRead, namaDevice, %iniPath%, %file%, nama
		IniRead, hasil, %iniPath%, %file%, pid
		VMsize := GetProcessMemoryInfo(hasil)
		
		if(VMsize> MaxSize)
		{
			winactivate %namaDevice%
			msgbox,4,, %namaDevice% %VMsize%,10
			IfMsgBox No
			{
				sleep 8000		
				return
			}
			WinClose %namaDevice%
			WinWaitClose %namaDevice%
			fileAppend %namaDevice% di close gara2%A_Space%, %logHasil% 
			fileAppend VM Size:%VMsize%,%logHasil%
			fileAppend `n,%logHasil%
			Sleep 8000
			Reload
		}
		
		;;;jika jam melebihi MaxTime ga jadi karena yg dicek log yg baru nambah
		; logLine:= line%A_Index%
		; timeArr := GetTime(logLine)
		; ranges := GetTimeRange(timeArr)
		; minuteRange := ranges/60
		; hour := timeArr[1]
		; minute := timeArr[2]
		; second := timeArr[3]
		; msgbox %namaDevice% %hour%:%minute%:%second% `n %minuteRange% menit
		
		;;buat ToolTip
		temp:= line%A_Index%
		Menu, tray, tip, %namaDevice% %VMsize%KB`n%temp%
		GetKeyState, state, Alt
		if state = D
			ToolTip, %namaDevice% %VMsize%KB`n%temp%
		else
			SetTimer, RemoveToolTip, 5000
		
		
		
		
		
}
data:=data%A_Index%
Lastdata%A_Index%= %data%

}
return

lihatJam:
if (A_Min = 00 and A_Sec < 5)
{
	sleep 2000
	reload
}
if(A_Hour = 23 and A_sec <5)
{
	gosub deleteIni
}
;msgbox %A_Min%:%A_Sec%
return

deleteIni:
^F2::
IfExist, %inipath%
{
	;msgbox Now
	FileDelete, %iniPath%
	sleep 1000
	Reload
}
return

cekThread:
ifWinExist Error occurred
{
	WinActivate Error occurred
		IfWinActive
		{
			WinWaitActive Error occurred
			IfWinActive Error occurred
			parentTitle:=GetParentTitle()
			fileAppend %A_Hour%:%A_Min%:%A_sec% %parentTitle% di close karena thread creation error occured, %logHasil%
			WinGet, IDError , PID, A
			fileAppend `n,%logHasil%
			send {enter}
			sleep 1000
			WinGetTitle, parentTitle, ahk_pid %IDError%
			WinGetClass, kelas,%parentTitle%
			if(kelas=="TFMain")
			{
				FileAppend,%parentTitle%,waitToStart.txt
				WinClose,%parentTitle%
			}
		}
}
ifWinExist Application Error 
{
	WinActivate Application Error
		IfWinActive
		{
			WinWaitActive Application Error 
			WinGet, IDError , PID, A
			parentTitle:=GetParentTitle()
			send {enter}
			sleep 3000
			; WinWaitClose Application Error ;kalo app error banyak gabisa
			while(parentTitle=="Application Error")
				WinGetTitle, parentTitle, ahk_pid %IDError%
			WinGetClass, kelas,%parentTitle%
			;MsgBox % parentTitle
			fileAppend %A_Hour%:%A_Min%:%A_sec% %parentTitle% di close karena Application Error %IDError%, %logHasil% 
			fileAppend `n,%logHasil%
			if(kelas=="TFMain")
			{
				FileAppend,%parentTitle% `n,waitToStart.txt
				;msgbox %parentTitle% error
				WinClose,%parentTitle%
			}
		}
}
ifExist waitToStart.txt
{
	Loop{
		FileReadLine,titleDevice,waitToStart.txt,%A_Index%
		if ErrorLevel{
			break
		}
		ifWinExist %titleDevice%
		{
			WinActivate , %titleDevice%
			WinWaitActive, %titleDevice%
			if titleDevice Contains yahoo
				sleep 5000
			send {F5}
		}
	}
	FileDelete waitToStart.txt
}
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

GetParentTitle() {
Chi_ID:=WinExist("A")
Par_ID:=DllCall("GetParent",UInt,Chi_ID)
IfWinNotExist, ahk_id %Par_ID%
  Par_ID:=Chi_ID
WinGetTitle, Par_Title, ahk_id %Par_ID%
Return Par_Title
}

GetProcessMemoryInfo( pname )
{
Process, Exist, %pname%
pid := Errorlevel
 
; get process handle
hProcess := DllCall( "OpenProcess", UInt, 0x10|0x400, Int, false, UInt, pid )
 
; get memory info
VarSetCapacity( memCounters, 40, 0 )
DllCall( "psapi.dll\GetProcessMemoryInfo", UInt, hProcess, UInt, &memCounters, UInt, 40 )
DllCall( "CloseHandle", UInt, hProcess )
 
list = cb,PageFaultCount,PeakWorkingSetSize,WorkingSetSize,QuotaPeakPagedPoolUsage
,QuotaPagedPoolUsage,QuotaPeakNonPagedPoolUsage,QuotaNonPagedPoolUsage
,PagefileUsage,PeakPagefileUsage
 
n=0
Loop, Parse, list, `,
{
n+=4
SetFormat, Float, 0.0 ; round up K
this := A_Loopfield
this := NumGet( memCounters, (A_Index = 1 ? 0 : n-4), "UInt") / 1024
 
; omit cb
If A_Index != 1
info .= A_Loopfield . ": " . this . " K" . ( A_Loopfield != "" ? "`n" : "" )
}
 
; Return "[" . pid . "] " . pname . "`n`n" . info ; for everything
; Return WorkingSetSize := NumGet( memCounters, 12, "UInt" ) / 1024 . " K" ; what Task Manager shows
Return PagefileUsage := NumGet( memCounters, 32, "UInt" ) / 1024 ; what Task Manager shows
}

;buat intung keyword
count(keyWord,File){
		FileRead, w, %File%
		StringReplace, w, w, %keyWord%, %keyWord%, UseErrorLevel
		l := ErrorLevel
		return l
}

startDevice(namaDevice){
	WinActivate %namaDevice%
	WinWaitActive %namaDevice%
	send {F5}
	sleep 100
}

stopDevice(namaDevice){
	WinActivate %namaDevice%
	WinWaitActive %namaDevice%
	send {F10 2}
	sleep 100
}

GetTime(logLine){
	patern = [0-9]{2,}:[0-9]{2,}:[0-9]{2,}
	RegExMatch( logLine, "i)"patern, time )
	If(time != "")
	{
		timeArr := StrSplit(time, ":")
		return timeArr
	}else{
		return ""
	}
}

GetTimeRange(timeArr1){
	hour1 := timeArr1[1]
    minute1 := timeArr1[2]
    second1 := timeArr1[3]
	hour2 := A_Hour
    minute2 := A_Min
    second2 := A_Sec
	
	time1 := (hour1 * 60 * 60) + (minute1 * 60) + (second1)
	time2 := (hour2 * 60 * 60) + (minute2 * 60) + (second2)
	hour3 := hour2 - hour1
	range := time2 - time1
	
	return range
}

/*
	Function: DamerauLevenshteinDistance
		Performs fuzzy string searching, see <http://en.wikipedia.org/wiki/Damerau-Levenshtein_distance>

	License:
		- Version 1.0 <http://www.autohotkey.net/~polyethene/#levenshtein>
		- Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
*/
DamerauLevenshteinDistance(s, t) {
	StringLen, m, s
	StringLen, n, t
	If m = 0
		Return, n
	If n = 0
		Return, m
	d0_0 = 0
	Loop, % 1 + m
		d0_%A_Index% = %A_Index%
	Loop, % 1 + n
		d%A_Index%_0 = %A_Index%
	ix = 0
	iy = -1
	Loop, Parse, s
	{
		sc = %A_LoopField%
		i = %A_Index%
		jx = 0
		jy = -1
		Loop, Parse, t
		{
			a := d%ix%_%jx% + 1, b := d%i%_%jx% + 1, c := (A_LoopField != sc) + d%ix%_%jx%
				, d%i%_%A_Index% := d := a < b ? a < c ? a : c : b < c ? b : c
			If (i > 1 and A_Index > 1 and sc == tx and sx == A_LoopField)
				d%i%_%A_Index% := d < c += d%iy%_%ix% ? d : c
			jx++
			jy++
			tx = %A_LoopField%
		}
		ix++
		iy++
		sx = %A_LoopField%
	}
	Return, d%m%_%n%
}

