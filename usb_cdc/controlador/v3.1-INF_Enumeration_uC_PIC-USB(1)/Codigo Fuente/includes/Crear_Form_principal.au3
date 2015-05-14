#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Pedro - PalitroqueZ
                palitroquez@gmail.com
 Script Function:
	Creación del formulario princpial mas sus objetos internos

#ce ----------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>

Local $iLimiteInput=30

#Region ### START Koda GUI section ### Form=C:\en autoit\Form1.kxf
Global $Form1 = GUICreate($sForm1[$bIdioma],$iForm_cerrado-10, _
                         $iAltura_form,(@DesktopWidth-$iForm_cerrado)/2, _
						 (@DesktopHeight-$iAltura_form-50)/2)

GUISetIcon($icono_perro)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Group1 = GUICtrlCreateGroup($sGroup1[$bIdioma], 8, 8, 289, 185)
$Label1 = GUICtrlCreateLabel($sLabel1[$bIdioma], 24, 38, 135, 17 )
$txtnombre = GUICtrlCreateInput("",118, 36, 162, 21)
GUICtrlSetLimit($txtnombre, $iLimiteInput)
Local $Label2 = GUICtrlCreateLabel("V.I.D.", 24, 62, 31, 17)
$txtvid = GUICtrlCreateInput("04D8", 64, 60, 33, 21)
GUICtrlSetLimit($txtvid, 4) 	; to limit the entry to 3 chars
GUICtrlSetOnEvent($txtvid, "txtvidChange")
GUICtrlSetTip($txtvid, $sTTBVID[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
Local $Label3 = GUICtrlCreateLabel("P.I.D.", 112, 62, 31, 17)
$txtpid = GUICtrlCreateInput("000B", 152, 60, 33, 21)
GUICtrlSetLimit($txtpid, 4)
GUICtrlSetOnEvent($txtpid, "txtpidChange")
GUICtrlSetTip($txtpid, $sTTBPID[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
$lblnota = GUICtrlCreateLabel($slblnota[$bIdioma], 208, 64, 85, 17)
GUICtrlSetFont($lblnota, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor($lblnota, 0xFF0000)
GUICtrlSetOnEvent($lblnota, "lblnotaClick")
GUICtrlSetCursor ($lblnota, 0)

$Label4 = GUICtrlCreateLabel($sLabel4[$bIdioma], 24, 90, 63, 17)
$txtubicacion = GUICtrlCreateInput("mocho pic", 88, 86, 193, 21)
GUICtrlSetLimit($txtubicacion, $iLimiteInput)
$Label5 = GUICtrlCreateLabel($slabel5[$bIdioma], 24, 112, 63, 17)
$txtdescripcion = GUICtrlCreateInput("Familia de Dispositivos PIC18Fxx5x", 88, 110, 193, 21)
GUICtrlSetLimit($txtdescripcion, $iLimiteInput)

$Label6 = GUICtrlCreateLabel($slabel6[$bIdioma], 24, 136, 66, 17)
$txtfabricante = GUICtrlCreateInput("Microchip Technology, Inc.", 96, 134, 185, 21)
GUICtrlSetLimit($txtfabricante, $iLimiteInput)

$Label7 = GUICtrlCreateLabel($slabel7[$bIdioma], 24, 164, 42, 17)
$txtversion = GUICtrlCreateInput("1.0.0.0", 72, 162, 65, 21)
GUICtrlSetLimit($txtversion, 10)

GUICtrlSetTip($txtversion, $sTTBVersion[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
$Label8 = GUICtrlCreateLabel($sLabel8[$bIdioma], 152, 164, 37, 17)
$txtfecha = GUICtrlCreateInput("12/31/2007", 200, 162, 81, 21)
GUICtrlSetLimit($txtfecha, 10)

GUICtrlSetTip($txtfecha, $sTTBFecha[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup($sGroup2[$bIdioma], 312, 8, 161, 105)
$optbulk = GUICtrlCreateRadio($soptbulk[$bIdioma], 328, 24, 113, 49,$BS_MULTILINE)
GUICtrlSetOnEvent($optbulk, "optbulkClick")
$optcdc = GUICtrlCreateRadio("CDC - RS232", 328, 75, 97, 25)
GUICtrlSetOnEvent(-1, "optcdcClick")

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup($sGroup3[$bIdioma], 312, 120, 161, 73)
Local $optccs = GUICtrlCreateRadio("PIC C CCS", 328, 144, 97, 17)

GUICtrlCreateGroup("", -99, -99, 1, 1)
Local $Graphic1 = GUICtrlCreateGraphic(481, 8, 7, 481)
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0xFFFF00)

Local $Tab1 = GUICtrlCreateTab(8, 208, 465, 233)
GUICtrlSetOnEvent($Tab1, "Tab1Click")
GUICtrlSetResizing($Tab1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)

local $TabSheet1=GUICtrlCreateTabItem("TabSheet1")
local $TabSheet2=GUICtrlCreateTabItem("TabSheet2")
GUICtrlCreateTabItem("")

Local $txtmchusbapi = GUICtrlCreateEdit("", 16, 240, 449, 193,$WS_VSCROLL+$WS_HSCROLL+$ES_READONLY);,$WS_EX_TOPMOST+$WS_EX_CLIENTEDGE)
Local $txtusb_desc_scope = GUICtrlCreateEdit("", 16, 240, 449, 193,$WS_VSCROLL+$WS_HSCROLL+$ES_READONLY);,$WS_EX_TOPMOST+$WS_EX_CLIENTEDGE)
Local $txtmchpcdc = GUICtrlCreateEdit("", 16, 240, 449, 193,$WS_VSCROLL+$WS_HSCROLL+$ES_READONLY);,$WS_EX_TOPMOST+$WS_EX_CLIENTEDGE)
Local $txtusb_desc_cdc = GUICtrlCreateEdit("", 16, 240, 449, 193,$WS_VSCROLL+$WS_HSCROLL+$ES_READONLY);,$WS_EX_TOPMOST+$WS_EX_CLIENTEDGE)

$cmdplantilla = GUICtrlCreateButton($scmdplantilla[$bIdioma], 16, 464, 125, 25, 0)
GUICtrlSetOnEvent($cmdplantilla, "cmdplantillaClick")
GUICtrlSetTip($cmdplantilla, $sTTBPlantilla[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
$cmdguardar = GUICtrlCreateButton($scmdguardar[$bIdioma], 160, 464, 97, 25, 0)
GUICtrlSetOnEvent($cmdguardar, "cmdguardarClick")
GUICtrlSetTip($cmdguardar, $sTTBGuardar[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
$chkguardarambos = GUICtrlCreateCheckbox($schkguardarambos[$bIdioma], 280, 466, 89, 17,$BS_CENTER )

GUICtrlSetTip($chkguardarambos, $sTTBGuardarambos[$bIdioma],$sTTBTitulo[$bIdioma],1,1)


Local $mnuidioma = GUICtrlCreateMenu("Lan&guage")
$mnuacerca = GUICtrlCreateMenu($smnuAcerca[$bIdioma])
$mnuopcionesavanzadas = GUICtrlCreateMenuItem($sCaption_opc_avanz[$bIdioma], $mnuacerca)
GUICtrlSetOnEvent($mnuopcionesavanzadas, "mnuopcionesavanzadas_Click")
$mnuinfo = GUICtrlCreateMenuItem($slblnotaInformacion[$bIdioma], $mnuacerca)
Local $mnuspanish = GUICtrlCreateMenuItem("Spanish", $mnuidioma)
Local $mnuenglish = GUICtrlCreateMenuItem("English", $mnuidioma)
GUICtrlSetState($mnuenglish, $GUI_CHECKED)
GUICtrlSetOnEvent($mnuinfo, "mnuinfoClick")
GUICtrlSetOnEvent($mnuspanish, "mnuspanish_Click")
GUICtrlSetOnEvent($mnuenglish,"mnuenglish_Click")
GUISetState(@SW_SHOW)

#EndRegion ### END Koda GUI section ###
;****************************************************************

Func cmdplantillaClick()
if $fBandera_tipo_transferencia==1 Then
	GUICtrlSetData($TabSheet1,"mchpusb.inf")
	GUICtrlSetData($TabSheet2,"usb_desc_scope.h")
	if GUICtrlRead($Tab1)==0 Then
        vVisor_Edits(1)
		ControlSetText($sForm1,"",$txtmchusbapi,sCrear_mchusbapi(GUICtrlRead($txtnombre), _		
											GUICtrlRead($txtvid), GUICtrlRead($txtpid), _
											GUICtrlRead($txtversion), GUICtrlRead($txtfecha), _
											GUICtrlRead($txtdescripcion),GUICtrlRead($txtfabricante), _
											GUICtrlRead($txtguid),$sNombre_icono, _
											GUICtrlRead($txtinstdisk) _
											) _
					  ) 
	Else
        vVisor_Edits(2)
		ControlSetText($sForm1,"",$txtusb_desc_scope,sCrear_usb_desc_scope(GUICtrlRead($txtnombre), _
					                       GUICtrlRead($txtvid),GUICtrlRead($txtpid) _
																) _
					  )
	EndIf
Else
	GUICtrlSetData($TabSheet1,"mchpcdc.inf")
	GUICtrlSetData($TabSheet2,"usb_desc_cdc.h")
	If GUICtrlRead($Tab1)==0 Then
        vVisor_Edits(3)
		ControlSetText($sForm1,"",$txtmchpcdc,sCrear_mchpcdc(GUICtrlRead($txtnombre), _	
					                       GUICtrlRead($txtvid),GUICtrlRead($txtpid), _
										   GUICtrlRead($txtversion),GUICtrlRead($txtfecha), _
										   GUICtrlRead($txtdescripcion),GUICtrlRead($txtfabricante),GUICtrlRead($txtinstdisk) _
														 ) _
					   )
	Else
        vVisor_Edits(4)
		ControlSetText($sForm1,"",$txtusb_desc_cdc, sCrear_usb_desc_cdc(GUICtrlRead($txtnombre), _
					                       GUICtrlRead($txtvid),GUICtrlRead($txtpid) _
														      ) _
					   )
	EndIf
EndIf	
EndFunc
;************************************************************************************

Func lblnotaClick()
    MsgBox(64+8192,$slblnotaInformacion[$bIdioma],$slblnotaMensaje[$bIdioma])
EndFunc
;************************************************************************************

Func mnuinfoClick()
	Local $iIcono_inf_y_tarea_modal=64+8192
	MsgBox($iIcono_inf_y_tarea_modal,$slblnotaInformacion[$bIdioma],$sInformacion[$bIdioma])
EndFunc
;****************************************************************

Func optbulkClick()
	$fBandera_tipo_transferencia=1
	cmdplantillaClick()
EndFunc
;****************************************************************

Func optcdcClick()
	$fBandera_tipo_transferencia=0
	cmdplantillaClick()
EndFunc
;****************************************************************

Func Tab1Click()
	cmdplantillaClick()
EndFunc
;****************************************************************

Func cmdguardarClick()
Local $sDatos
$sDatos = ""
    If $fBandera_tipo_transferencia==1 Then ; la parte de mpusbapi
        If BitAnd(GUICtrlRead($chkguardarambos),$GUI_CHECKED)== 1 Then
            $sDatos = sCrear_mchusbapi( GUICtrlRead($txtnombre), _
										GUICtrlRead($txtvid), GUICtrlRead($txtpid), _
										GUICtrlRead($txtversion), GUICtrlRead($txtfecha), _
										GUICtrlRead($txtdescripcion),GUICtrlRead($txtfabricante), _
										GUICtrlRead($txtguid),$sNombre_icono, _
										GUICtrlRead($txtinstdisk) _
									)
            vGuardar_archivos($sDatos, "mchpusb", "inf",1)
            $sDatos = ""
            $sDatos = sCrear_usb_desc_scope(GUICtrlRead($txtnombre), _
					                       GUICtrlRead($txtvid),GUICtrlRead($txtpid) _
										)
            vGuardar_archivos($sDatos, "usb_desc_scope", "h",0)
        Else
			If GUICtrlRead($Tab1)==0 Then
				$sDatos = sCrear_mchusbapi( GUICtrlRead($txtnombre), _
											GUICtrlRead($txtvid), GUICtrlRead($txtpid), _
											GUICtrlRead($txtversion), GUICtrlRead($txtfecha), _
											GUICtrlRead($txtdescripcion),GUICtrlRead($txtfabricante), _
											GUICtrlRead($txtguid),$sNombre_icono, _
											GUICtrlRead($txtinstdisk) _
										)
				vGuardar_archivos($sDatos, "mchpusb", "inf",1)
			Else
				$sDatos=sCrear_usb_desc_scope(	GUICtrlRead($txtnombre), _
												GUICtrlRead($txtvid),GUICtrlRead($txtpid) _
										)
                 vGuardar_archivos($sDatos, "usb_desc_scope", "h",0)
			 EndIf
		EndIf
    Else ; va la parte de CDC
        If BitAnd(GUICtrlRead($chkguardarambos),$GUI_CHECKED)== 1 Then
            $sDatos = sCrear_mchpcdc(GUICtrlRead($txtnombre), _
					                GUICtrlRead($txtvid),GUICtrlRead($txtpid), _
									GUICtrlRead($txtversion),GUICtrlRead($txtfecha), _
									GUICtrlRead($txtdescripcion),GUICtrlRead($txtfabricante),GUICtrlRead($txtinstdisk) _
									)
            vGuardar_archivos($sDatos, "mchpcdc", "inf",0)
            $sDatos = ""
            $sDatos = sCrear_usb_desc_cdc(GUICtrlRead($txtnombre), _
										GUICtrlRead($txtvid),GUICtrlRead($txtpid) _
										)
			vGuardar_archivos($sDatos,"usb_desc_cdc","h",0)
        Else
            If GUICtrlRead($Tab1)==0 Then
				$sDatos = sCrear_mchpcdc(GUICtrlRead($txtnombre), _
										GUICtrlRead($txtvid),GUICtrlRead($txtpid), _
										GUICtrlRead($txtversion),GUICtrlRead($txtfecha), _
										GUICtrlRead($txtdescripcion),GUICtrlRead($txtfabricante),GUICtrlRead($txtinstdisk) _
										)
				vGuardar_archivos($sDatos, "mchpcdc", "inf",0)
			Else
				$sDatos = sCrear_usb_desc_cdc(GUICtrlRead($txtnombre), _
											GUICtrlRead($txtvid),GUICtrlRead($txtpid) _
											)   
				vGuardar_archivos($sDatos, "usb_desc_cdc", "h",0)
            EndIf
        EndIf
 EndIf
EndFunc
;****************************************************************

Func txtvidChange()
    GUICtrlSetData($txtvid,StringUpper(GUICtrlRead($txtvid)))
EndFunc
;****************************************************************

Func txtpidChange()
    GUICtrlSetData($txtpid,StringUpper(GUICtrlRead($txtpid)))
EndFunc
;****************************************************************

Func mnuopcionesavanzadas_Click()
    GUISetState(@SW_DISABLE,$Form1)
    GUISetState(@SW_SHOW,$Form_Opciones_Avanzadas)
EndFunc	
;****************************************************************

Func mnuenglish_Click()
    $bIdioma=0
    GUICtrlSetState($mnuenglish,$GUI_CHECKED)
    GUICtrlSetState($mnuspanish,$GUI_UNCHECKED)
    vActualizar_Cambio_Lenguaje()
EndFunc    

Func mnuspanish_Click()
    $bIdioma=1
    GUICtrlSetState($mnuspanish,$GUI_CHECKED)
    GUICtrlSetState($mnuenglish,$GUI_UNCHECKED)
    vActualizar_Cambio_Lenguaje()
EndFunc    

;****************************************************************
Func Form1Close()
	vGuardar_DATos_ini()
	Exit
EndFunc