#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Func sCrear_mchpcdc($sNombre_dispositivo,$sVid,$sPid, _
					$sVersion,$sFecha,$sDescripcion, _
					$sFabricante,$txtinstdisk)
Local $sCadenon

$sCadenon = @CRLF _
& "; Windows USB CDC ACM Setup File" & @CRLF _
& "; Copyright (c) 2000 Microsoft Corporation" & @CRLF _
& "; Copyright (C) 2007 Microchip Technology Inc." & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[Version]" & @CRLF _
& "Signature = " & Chr(34) & "$Windows NT$" & Chr(34) & @CRLF _
& "Class = Ports" & @CRLF _
& "ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}" & @CRLF _
& "Provider=%MFGNAME% " & @CRLF _
& "LayoutFile = layout.inf" & @CRLF _
& "CatalogFile=%MFGFILENAME%.cat" & @CRLF _
& "DriverVer=" & $sFecha & "," & $sVersion & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[Manufacturer]" & @CRLF _
& "%MFGNAME%=DeviceList, NTamd64" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DestinationDirs]" & @CRLF _
& "DefaultDestDir = 12" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";   Windows 2000/XP/Vista-32bit Sections" & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF & @CRLF

$sCadenon = $sCadenon & _
"[DriverInstall.nt]" & @CRLF _
& "include=mdmcpq.inf" & @CRLF _
& "CopyFiles=DriverCopyFiles.nt" & @CRLF _
& "AddReg=DriverInstall.nt.AddReg " & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DriverCopyFiles.nt]" & @CRLF _
& "usbser.sys,,,0x20" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DriverInstall.nt.AddReg]" & @CRLF _
& "HKR,,DevLoader,,*ntkern" & @CRLF _
& "HKR,,NTMPDriver,,%DRIVERFILENAME%.sys " & @CRLF _
& "HKR,,EnumPropPages32,," & Chr(34) & "MsPorts.dll,SerialPortPropPageProvider" & Chr(34) & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DriverInstall.nt.Services]" & @CRLF _
& "AddService=usbser, 0x00000002, DriverService.nt" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DriverService.nt] " & @CRLF _
& "DisplayName=%SERVICE%" & @CRLF _
& "ServiceType=1" & @CRLF _
& "StartType=3" & @CRLF _
& "ErrorControl=1" & @CRLF _
& "ServiceBinary=%12%\%DRIVERFILENAME%.sys " & @CRLF & @CRLF

$sCadenon = $sCadenon _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";  Vista-64bit Sections" & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DriverInstall.NTamd64] " & @CRLF _
& "include=mdmcpq.inf" & @CRLF _
& "CopyFiles=DriverCopyFiles.NTamd64" & @CRLF _
& "AddReg=DriverInstall.NTamd64.AddReg " & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DriverCopyFiles.NTamd64]" & @CRLF _
& "%DRIVERFILENAME%.sys,,,0x20" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DriverInstall.NTamd64.AddReg] " & @CRLF _
& "HKR,,DevLoader,,*ntkern " & @CRLF _
& "HKR,,NTMPDriver,,%DRIVERFILENAME%.sys " & @CRLF _
& "HKR,,EnumPropPages32,," & chr(34) & "MsPorts.dll,SerialPortPropPageProvider" & chr(34) & @CRLF & @CRLF 

$sCadenon = $sCadenon _
& "[DriverInstall.NTamd64.Services] " & @CRLF _
& "AddService=usbser, 0x00000002, DriverService.NTamd64" & @CRLF & @CRLF 

$sCadenon = $sCadenon _
& "[DriverService.NTamd64] " & @CRLF _
& "DisplayName=%SERVICE% " & @CRLF _
& "ServiceType=1" & @CRLF _
& "StartType=3" & @CRLF _
& "ErrorControl=1" & @CRLF _
& "ServiceBinary=%12%\%DRIVERFILENAME%.sys " & @CRLF  & @CRLF  & @CRLF 

$sCadenon = $sCadenon _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";  Vendor and Product ID Definitions" & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF _
& "; When developing your USB device, the VID and PID used in the PC side" & @CRLF _
& "; application program and the firmware on the microcontroller must match." & @CRLF _
& "; Modify the below line to use your VID and PID.  Use the format as shown below." & @CRLF _
& "; Note: One INF file can be used for multiple devices with different VID and PIDs." & @CRLF _
& "; For each supported device, append " & chr(34) & ",USB\VID_xxxx&PID_yyyy" & chr(34) & " to the end of the line." & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF

$sCadenon = $sCadenon _
& "[SourceDisksFiles]" & @CRLF _
& "[SourceDisksNames]" & @CRLF _
& "[DeviceList]" & @CRLF _
& "%DESCRIPTION%=DriverInstall, USB\VID_" & $sVid & "&PID_" & $sPid & @CRLF & @CRLF _

$sCadenon = $sCadenon _
& "[DeviceList.NTamd64] " & @CRLF _
& "%DESCRIPTION%=DriverInstall, USB\VID_" & $sVid & "&PID_" & $sPid  & @CRLF  & @CRLF & @CRLF

$sCadenon = $sCadenon _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";  String Definitions" & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";Modify these strings to customize your device"  & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF

$sCadenon = $sCadenon _
& "[Strings]" & @CRLF _
& "MFGFILENAME=" & chr(34) & "mchpcdc" & chr(34) & @CRLF _
& "DRIVERFILENAME =" & chr(34) & "usbser" & chr(34) & @CRLF _
& "MFGNAME=" & Chr(34) & $sFabricante & Chr(34) & @CRLF _
& "INSTDISK=" & chr(34) & $txtinstdisk & chr(34) & @CRLF _
& "DESCRIPTION=" & Chr(34) & $sDescripcion & Chr(34) & @CRLF _
& "SERVICE=" & Chr(34) & "USB RS-232 Emulation Driver" & Chr(34)  & @CRLF & @CRLF  & @CRLF _

Return $sCadenon
EndFunc


