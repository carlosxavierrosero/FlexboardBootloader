#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         Pedro - PalitroqueZ
                palitroquez@gmail.com
 Script Function:
	Creación de la ventana de opciones avanzadas

#ce ----------------------------------------------------------------------------

;~ ############ el otro formulario ###########################

#Region
global $Form_Opciones_Avanzadas=GUICreate($sCaption_opc_avanz[$bIdioma], 269,400,-1,-1,$WS_SYSMENU);,0x00000018) 
GUISetIcon($icono_perro)
GUISetOnEvent($GUI_EVENT_CLOSE, "FormOAClose")								
$Group4 = GUICtrlCreateGroup($sGroup4[$bIdioma], 6, 8, 249, 113)
$txtguid = GUICtrlCreateInput("{4D36E9AE-E325-11CE-BFC1-08002BE10318}", 14, 32, 233, 21)
GUICtrlSetLimit($txtguid, 38)
GUICtrlSetOnEvent($txtguid, "txtguidChange")
GUICtrlSetTip($txtguid, $sTTBGuid[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
$cmdguid = GUICtrlCreateButton($scmdguid[$bIdioma], 78, 72, 110, 25, 0)
GUICtrlSetOnEvent(-1, "cmdguidClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group5 = GUICtrlCreateGroup($sGroup5[$bIdioma], 6, 128, 249, 101)
$txtinstdisk = GUICtrlCreateInput("Microchip Technology, Inc. Installation Disc", 14, 165, 233, 21)
GUICtrlSetLimit($txtinstdisk, 45)
GUICtrlSetTip($txtinstdisk, $sTTBClassname[$bIdioma],$sTTBTitulo[$bIdioma],1,1)


GUICtrlCreateGroup("", -99, -99, 1, 1)
Local $ancho_grupo_icono=87,$alto_grupo_icono=87
$Group6 = GUICtrlCreateGroup($sGroup6[$bIdioma], 14, 272, $ancho_grupo_icono, $alto_grupo_icono)
Local $ancho_icono=32, $alto_icono=32
Global $Icon1 = GUICtrlCreateIcon($icono_perro , 0, 14+($ancho_grupo_icono-$ancho_icono)/2, 272+($alto_grupo_icono-$alto_icono)/2, $ancho_icono, $alto_icono) ;, BitOR($SS_NOTIFY,$WS_GROUP))

GUICtrlSetResizing (-1,$GUI_DOCKSIZE)

GUICtrlSetOnEvent(-1, "Icon1Click")
GUICtrlSetTip($Icon1, $sTTBIcono[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$cmddefecto = GUICtrlCreateButton($scmddefecto[$bIdioma], 134, 288, 89, 33, 0)
GUICtrlSetOnEvent(-1, "cmddefectoClick")
GUICtrlSetTip(-1, $sTTBDefecto,$sTTBTitulo,1,1)
$ChkIcono = GUICtrlCreateCheckbox($sCheckIcono[$bIdioma],16, 248, 220, 17)
GUICtrlSetOnEvent(-1, "ChkIcono_Click")
GUICtrlSetTip(-1, $sTTBchkIcono[$bIdioma],$sTTBTitulo[$bIdioma],1,1)

GUISetState(@SW_HIDE,$Form_Opciones_Avanzadas)

#EndRegion

;****************************************************************
Func cmddefectoClick()
	If MsgBox(4+48+8192,$sGuid1[$bIdioma],$sGuid2[$bIdioma]) = 6 Then
		vCargar_datos_originales()
	EndIf
EndFunc
;****************************************************************
Func txtguidChange()
    GUICtrlSetData($txtguid,StringUpper(GUICtrlRead($txtguid)))
EndFunc

;************************************************************************************
Func Icon1Click()
	Local $s, $iArchivo_y_ruta_debe_existir=1+2
	$s=FileOpenDialog("Buscar Ícono...",@ScriptDir & "\","Archivo de iconos (*.ico)", _
					  $iArchivo_y_ruta_debe_existir)

	if not @error then
		$sNombre_icono=sTomar_nombre_icono($s)
		GUICtrlSetImage($Icon1,$sNombre_icono)
		$sRuta_nombre_icono=$s
	EndIf
EndFunc

;****************************************************************
Func cmdguidClick()
	If MsgBox(4+48+8192,$sGuid1[$bIdioma],$sGuid3[$bIdioma]) == 6 Then
		GUICtrlSetData($txtguid,_sCreateGUID())
    EndIf
EndFunc

Func ChkIcono_Click()
    $fBandera_Icono_predeterminado=BitAnd(GUICtrlRead($ChkIcono),$GUI_CHECKED)
    if $fBandera_Icono_predeterminado==1 Then
        GUICtrlSetImage($Icon1,"setupapi.dll",20)
        GUICtrlSetState($Icon1,$GUI_DISABLE)
    Else
        GUICtrlSetState($Icon1,$GUI_ENABLE)
        GUICtrlSetImage($Icon1,$sNombre_icono)
    EndIf
EndFunc

Func FormOAClose()
	GUISetState(@SW_ENABLE,$Form1)
    GUISetState(@SW_HIDE,$Form_Opciones_Avanzadas)
    cmdplantillaClick()
EndFunc	