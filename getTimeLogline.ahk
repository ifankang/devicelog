#Persistent
#SingleInstance ,force
CoordMode, ToolTip, Screen 
;Menu, Tray, Icon, User32.dll, 5
CaseSensitive := false
MaxTime=25 ;menit
;Thread|Penjual|merespon|GetSignalQuality|EAtCommandError|function|GetSignalQuality
ArrayCount = 0
count = 0
iniPath=DeviceLogTime.ini
IFnotExist deviceLog
	FileCreateDir deviceLog

logHasil = deviceLog/LogTimeRange%a_dd%%a_mmm%%taun%.log 
FileAppend Start %A_Hour%:%A_Min%:%A_sec%`n,%logHasil%

SetTimer, lihatJam, 2000
fileDelete logPath2.txt
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
		fileAppend %log%`n, logPath2.txt
}
	
}
}
Window:=cmd:=nom:=class:=Tvar:=queryEnum :=process :=Id:= ""

deviceGetLog(Title ,iniPath := "deviceTime.ini")
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
			; fileAppend %Title%`n, hasil.txt
			IniRead, hasil, %iniPath%, %Title%, name
			;if A_LoopFileName contains %Title%
			StringReplace,Title,Title,`,,
			StringReplace,Title,Title,M301,M3-01
			;StringReplace,Title,Title,YM`,Client,YM%A_Space%Client
			;StringReplace,Title,Title,YMClient,YM%A_Space%Client
			filenamelog:= RegExReplace(A_LoopFilename, "i)sev,|REPLEY,|- Voucha4 SMS|Voucha4,|TSEL|,sms|ISAT,|,Indosat|,sev|XL,|FLEXI,|,Fkios|Mkios,|,mkios|,three|three,|esia,|,esia|Axis,|,Axis|Dompet|Pulsa|Messenger|Forwarder|Yahoo!|yahoo|H2H.", "")
			StringReplace,filenamelog,filenamelog,%tgl2%,
			StringReplace,filenamelog,filenamelog,%tgl%,
			StringReplace,filenamelog,filenamelog,-,
			
			IfInString Title, %filenamelog%
			 {
				; FileAppend, Title %Title%  ada  namelog %filenamelog% `n, HASIL.txt
				 Title:=""
				 return % A_LoopFileFullPath
			 }
			IfInString filenamelog, %Title%
			{
				;FileAppend, namelog %filenamelog%  ada Title %Title% `n, HASIL.txt
				Title:=""
				return % A_LoopFileFullPath
			}
		}

	}
}

Loop, Read, logPath2.txt
{
    ArrayCount += 1  ; Keep track of how many items are in the array.
    File%ArrayCount% := A_LoopReadLine  ; Store this line in the next array element.
}
FileDelete, logPath2.txt
; Read from the array:

#Persistent
SetTimer, start, 500
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

;If (data%A_Index% <> Lastdata%A_Index%)
;{
	IniRead, namaDevice, %iniPath%, %file%, nama
	if(namaDevice == "ERROR")		
	{
		sleep 5000
		Reload
	}
	;file:= File%A_Index%
	fileRead, w%A_Index%, %file%
	StringReplace, w%A_Index%, w%A_Index%, `r, , All
	StringReplace, w%A_Index%, w%A_Index%, `n, `n, UseErrorLevel
	l%A_Index% := ErrorLevel + 1
	baris%A_Index%:=RegExReplace(l%A_Index%, "\d{1,3}(?=(\d{3}|\d{6}|\d{9})(\D|$))","$0,")
	baris%A_Index%:=Round(l%A_Index%)-1
	fileReadline, line%A_Index%, %file% , baris%A_Index%
	
	;ini diganti cek jam maxTime RegExMatch( line%A_Index%, "i)"TextInput, hasil%A_Index% )
	;;jika jam melebihi MaxTime ga jadi karena yg dicek log yg baru nambah
		logLine:= line%A_Index%
		timeArr := GetTime(logLine)
		ranges := GetTimeRange(timeArr)
		minuteRange := ranges/60
		hour := timeArr[1]
		minute := timeArr[2]
		second := timeArr[3]
		;msgbox %namaDevice% %hour%:%minute%:%second% `n %minuteRange% menit
		hasil%A_Index% = minuteRange
	if(hasil%A_Index% != "" )
	{
        if(minuteRange > MaxTime )
		{
			SoundPlay, alert.wav
			IniRead, namaDevice, %iniPath%, %file%, nama
			if(namaDevice == "ERROR")		
			{
				sleep 5000
				Reload
			}
			WinActivate, %namaDevice%
			WinWaitActive, %namaDevice%
			sleep 1000
			
			stopDevice(namaDevice)
			sleep 3000
			startDevice(namaDevice)
			
			fileAppend %namaDevice% di close gara2%A_Space%, %logHasil%
			fileAppend % line%A_Index%,%logHasil%
			fileAppend `n,%logHasil%
			Sleep 1000
		}
		
		;check windows hang
		winID := WinExist(namaDevice)
		if DllCall("IsHungAppWindow", "UInt", winID)
		{
			;MsgBox The %namaDevice% window appears to be hung.
			fileAppend %A_Hour%:%A_Min% %namaDevice% di close gara2 HANG`n, %logHasil%
			if DllCall("IsHungAppWindow", "UInt", winID)
				WinKill, %namaDevice%
		}
		;else{
			; MsgBox The %namaDevice% window appears to be not hung
		; }
			
		Menu, tray, tip, %namaDevice% `n %minuteRange% menit
		hasil%A_Index%:=
		
	}
		

}
return


lihatJam:
if (A_Min = 30 and A_Sec < 5)
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

^F3::
deleteIni:
IfExist, %inipath%
{
	;msgbox Now
	FileDelete, %iniPath%
	sleep 2000
	Reload
}
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;log to time function
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


; logLine1= [2015-12-02 09:57:54] Transaksi Anda telah diterima dan sedang diproses. Status transaksi Anda akan dikirim melalui SMS.
; logLine2= [2015-12-02 10:30:54] Transaksi Anda telah diterima dan sedang diproses. Status transaksi Anda akan dikirim melalui SMS.

; timeArr1 := GetTime(logLine1)
; timeArr2 := GetTime(logLine2)
; msgbox % GetTimeRange(timeArr1)


	; hour := timeArr[1]
    ; minute := timeArr[2]
    ; second := timeArr[3]
; MsgBox,  %hour% %minute% %second%

startDevice(namaDevice){
	WinActivate %namaDevice%
	WinWaitActive %namaDevice%
	send {F5}
	sleep 100
	WinMinimize, %namaDevice%
}

stopDevice(namaDevice){
	WinActivate %namaDevice%
	WinWaitActive %namaDevice%
	send {F10 2}
	sleep 100
}
