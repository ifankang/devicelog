X:=0
Y:=0
WinGet, Window, List

Loop %Window%
{

Id:=Window%A_Index%

WinGetTitle, TVar , % "ahk_id " Id

WinGetClass ,class,%Tvar%

if(class=="TFMain")	;;;if(TVar != " " || TVar != "Webserver" || TVar != " "|| TVar != "TeamViewer Panel (minimized)")
{
	if(Tvar="")
		continue
	WinActivate %Tvar%
	WinWaitActive %Tvar%,,3
	if ErrorLevel
	{
  	  	;MsgBox, WinWait -%Tvar%-
		X:=X-150
		if(X<0)
		{
			X:=0
		}
		Tvar=%Tvar%
	}
	;MsgBox %X% %Y%
	Sleep 400
	WinMove %Tvar%,,X,Y,500,(768-15)/2	;1080,636
	X:=X+150
	sleep 500
	if(X+200>1366 && Y == 0)
	{
		
			x:=0
			Y:=(768-15)/2 ;768-636-15
	}
	if(X+200>1366 && Y== (768-15)/2)	;768-636-15)
	{
		
			x:=0
			Y:=(768-15)/4
	}
	if(X+200>1366 && Y== (768-15)/4)
	{
		
			x:=0
			Y:=0
	}
}
Window%A_Index%:=TVar ; array
tList.=TVar "`n" ;list
}

MsgBox,4, ,%tList% `n Cascade?
IfMsgBox Yes
PostMessage, 0x111, 403, 0,, ahk_class Shell_TrayWnd
else
return
