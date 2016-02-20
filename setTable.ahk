resLamax:= A_ScreenWidth
resLamay:= A_ScreenHeight
cordBarux := (resBarux / resLamax) * cordLamax
cordBaruy := (resBaruy / resLamay) * cordLamay
/*
* Key:alt+a
*/
skanan()
{
	send {Shift down}
	mouseClick, WheelDown
	send {Shift up}
	sleep 100
}

skiri()
{
	send {Shift down}
	mouseClick, WheelUp
	send {Shift up}
	sleep 100
}

move(x)
{
	mouseMove x,310
	mouseClick ,left,,,,,D
}

mbawah()
{
	mouseGetPos x,y
	mouseMove x+10,y+10
}

matas()
{
	mouseGetPos x,y
	mouseMove x,y-10
	mouseClick ,left,,,,,U
}
Run "D:\Program Files\Voucha4 Admin\Admin.exe"
goto start
!a::
start:
WinWaitActive Voucha4 Admin
sleep 500
send f
KeyWait alt
IfWinActive, Voucha4 Admin
{
WinMaximize, Voucha4 Admin
WinMaximize, Voucha4 Admin
sleep 100
send {Ralt}Y1Y05
sleep 1000
ControlFocus ,Load,Voucha4
while(color != 0xFAF3EA){
ControlClick ,Load,Voucha4,,,2
sleep 1500
PixelGetColor, color, 430, 345,Slow
}
mouseClick left,210,580
sleep 1000

loop 5
{
	skiri()
}

skanan()
move(995)
mbawah()
skiri()
move(335)
matas()

move(657)
mbawah()
move(458)
matas()

skanan()
skanan()
move(1240)
mbawah()
skiri()
move(335)
matas()

skiri()
move(160)
mbawah()
move(840)
matas()

mouseClick left,769,310,2
sleep 1000
mouseClick left,589,310,2
sleep 1000
mouseClick left,409,310,2
sleep 1000
mouseClick left,289,310,2
sleep 1000
mouseClick left,199,310,2
sleep 1000

move(127)
move(31)
matas()

mouseClick left,193,310,2
sleep 1000
mouseClick left,633,185
mouseClick ,left,,,,,U
mouseClick left,210,580
}
exitApp

^a::
Reload
return