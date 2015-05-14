#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:  Pedro PalitroqueZ - palitroquez@gmail.com

 Script Function:
	Template AutoIt script.

 Derechos de Uso:
	Este programa se rigexxxxxxxx
	es de libre uso, cualquiera puede hacerle modificaciones, PERO SIN FINES DE LUCRO

#ce ----------------------------------------------------------------------------

Func sCrear_mchusbapi($sNombre_dispositivo, $sVid, $sPid, _
					  $sVersion, $sFecha, $sDescripcion, _
                      $sFabricante, $sGUID, $sIconoS, _
                      $txtinstdisk)
Local $sCadenon
Local $Linea_icono_pre1, $Linea_icono_pre2,$Linea_icono_pre3
Local $sNada="" & @CRLF & @CRLF
if $fBandera_Icono_predeterminado==1 then
    $Linea_icono_pre1=$sNada
    $Linea_icono_pre2="HKR,,Icon,," & chr(34) & "-20" & Chr(34) & @CRLF & @CRLF 
    $Linea_icono_pre3="CopyFiles = DriverCopyFiles" & @CRLF & @CRLF
    $Linea_icono_pre4=$sNada
    $Linea_icono_pre5=$sNada
Else
    $Linea_icono_pre1="icono_device=11" & @CRLF & @CRLF
    $Linea_icono_pre2="HKR,,EnumPropPages32,," & Chr(34) & $sIconoS & ",0" & Chr(34) & @CRLF & @CRLF 
    $Linea_icono_pre3="CopyFiles = DriverCopyFiles,icono_device" & @CRLF & @CRLF
    $Linea_icono_pre4="[icono_device]" & @CRLF & $sIconoS & ",,,2" & @CRLF & @CRLF 
    $Linea_icono_pre5= $sIconoS & "=1" & @CRLF & @CRLF
EndIf

$sCadenon = "; Installation file for Microchip's Custom USB Driver" & @CRLF _
& "; Copyright (C) 2007 by Microchip Technology, Inc." & @CRLF _
& "; All rights reserved" & @CRLF & @CRLF _
& "[Version]" & @CRLF _
& "Signature=$Windows NT$" & @CRLF _
& "Class=CustomUSBDevice" & @CRLF _
& "ClassGuid=" & $sGUID & @CRLF & @CRLF _
& "Provider=%MFGNAME%" & @CRLF _
& "CatalogFile=%MFGFILENAME%.cat" & @CRLF _
& "DriverVer=" & $sFecha & "," & $sVersion & @CRLF & @CRLF _
& "[Manufacturer]" & @CRLF _
& "%MFGNAME%=DeviceList,ntamd64" & @CRLF & @CRLF _
& "[DestinationDirs]" & @CRLF _
& "DefaultDestDir=12" & @CRLF _
& $Linea_icono_pre1



$sCadenon = $sCadenon _
& "[SourceDisksNames]" & @CRLF _
& "1=%INSTDISK%,,," & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[ClassInstall32]" & @CRLF _
& "AddReg=ClassInstall_AddReg" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[ClassInstall_AddReg]" & @CRLF _
& "HKR,,,,%DEVICEMANAGERCATEGORY%" & @CRLF _
&  $Linea_icono_pre2

$sCadenon = $sCadenon _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";  Windows 2000/XP/Vista 32 Section" & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF & @CRLF _
& "[DriverInstall]" & @CRLF _
& $Linea_icono_pre3

$sCadenon = $sCadenon _
& "[DriverCopyFiles]" & @CRLF _
& "%MFGFILENAME%.sys,,,2" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& $Linea_icono_pre4

$sCadenon = $sCadenon _
& "[DriverInstall.Services]" & @CRLF _
& "AddService=MCHPUSB,2,DriverService" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DriverService]" & @CRLF _
& "ServiceType=1" & @CRLF _
& "StartType=3" & @CRLF _
& "ErrorControl=1" & @CRLF _
& "ServiceBinary=%12%\%MFGFILENAME%.sys" & @CRLF

$sCadenon = $sCadenon _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";  Windows XP/Vista 64 Section" & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF & @CRLF _
& "[DriverInstall64]" & @CRLF _  
& "CopyFiles=DriverCopyFiles64"  & @CRLF & @CRLF 

$sCadenon = $sCadenon _
& "[DriverCopyFiles64]" & @CRLF _
& "%MFGFILENAME%64.sys,,,2" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DriverInstall64.Services]" & @CRLF _
& "AddService=MCHPUSB,2,DriverService64" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DriverService64]" & @CRLF _
& "ServiceType=1" & @CRLF _
& "StartType=3" & @CRLF _
& "ErrorControl=1" & @CRLF _
& "ServiceBinary=%12%\%MFGFILENAME%64.sys" & @CRLF & @CRLF

$sCadenon = $sCadenon _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";  Vendor and Product ID Definitions" & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF _
& "; When developing your custom USB device, the VID and PID used in the PC side" & @CRLF _
& "; application program and the firmware on the microcontroller must match." & @CRLF _
& "; Modify the below line to use your VID and PID.  Use the format as shown below." & @CRLF _
& "; Note: One INF file can be used for multiple devices with different VID and PIDs." & @CRLF _
& "; For each supported device, append " & chr(34) &  ",USB\VID_xxxx&PID_yyyy"  & chr(34) & "to the end of the line." & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF _
& "[DeviceList]" & @CRLF _
& "%DESCRIPTION%=DriverInstall, USB\VID_" & $sVid & "&PID_" & $sPid & @CRLF & @CRLF

$sCadenon = $sCadenon _
& "[DeviceList.ntamd64]" & @CRLF _
& "%DESCRIPTION%=DriverInstall64, USB\VID_" & $sVid & "&PID_" & $sPid & @CRLF & @CRLF

$sCadenon = $sCadenon _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";  String Definitions" & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";Modify these strings to customize your device" & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF & @CRLF _
& "[Strings]" & @CRLF _
& "DEVICEMANAGERCATEGORY=" & Chr(34) & $sNombre_dispositivo & Chr(34) & @CRLF _
& "MFGFILENAME= " & Chr(34) & "mchpusb" & Chr(34) & @CRLF _
& "MFGNAME=" & Chr(34) & $sFabricante & Chr(34) & @CRLF _
& "INSTDISK=" & Chr(34) & $txtinstdisk & Chr(34) & @CRLF _
& "DESCRIPTION=" & Chr(34) & $sDescripcion & Chr(34) & @CRLF & @CRLF ;_

$sCadenon = $sCadenon _
& ";------------------------------------------------------------------------------"  & @CRLF _
& ";  Source Files"  & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF _
& ";The source file name prefixes need to be the same name as the string MFGFILENAME" & @CRLF _
& ";above" & @CRLF _
& ";------------------------------------------------------------------------------" & @CRLF & @CRLF _
& "[SourceDisksFiles]" & @CRLF _
& "mchpusb.sys=1" & @CRLF _
& "mchpusb64.sys=1" & @CRLF _
& $Linea_icono_pre5

Return $sCadenon
EndFunc



