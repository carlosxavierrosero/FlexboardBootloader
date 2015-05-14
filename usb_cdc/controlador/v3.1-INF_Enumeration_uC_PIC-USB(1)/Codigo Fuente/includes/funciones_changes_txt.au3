#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         Pedro - PalitroqueZ
                palitroquez@gmail.com
 Script Function:
    Aquí se gestiona los cambios de datos en los controles input, validando en todo momento que
    el caracter introducido en su correspondiente input

#ce ----------------------------------------------------------------------------

#include <WinAPI.au3>

Global $iCualForm[2]=[$Form1,$Form_Opciones_Avanzadas]

GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")

;*************************************************************************************************
; Detectar_Cambios_Control_Input()
; Datos de Entrada: el controlID que generó el mensaje de cambio (evento InputChange)
; Datos de Salida: Ninguno
; Descripción:
;   Aquí se selecciona el input que generó el evento change, comparando el ID
;   recibido con su ControlID conocido y además se le hace el tratamiento a la cadena
;   contenida en dicho input
;*************************************************************************************************
Func vDetectar_Cambios_Control_Input($nID_)
    switch $nID_
        case number(_WinAPI_GetDlgCtrlID(GUICtrlGetHandle($txtnombre)))
            vRevisarCampoVacio($txtnombre,$sNombreCategoriaDefault,0)
;-----------------------------------------------------------------------    
        case number(_WinAPI_GetDlgCtrlID(GUICtrlGetHandle($txtvid)))
            vDetectar_Hexa($txtvid)
            vRevisarCampoVacio($txtvid,$sVIDDefault,0)
;-----------------------------------------------------------------------    
        case number(_WinAPI_GetDlgCtrlID(GUICtrlGetHandle($txtpid)))
            vDetectar_Hexa($txtpid)
            vRevisarCampoVacio($txtpid,$sPIDDefault,0)
;-----------------------------------------------------------------------    
        case number(_WinAPI_GetDlgCtrlID(GUICtrlGetHandle($txtubicacion)))
            vRevisarCampoVacio($txtubicacion,$sUbicacionDefault,0) 
;-----------------------------------------------------------------------    
        case number(_WinAPI_GetDlgCtrlID(GUICtrlGetHandle($txtdescripcion)))
            vRevisarCampoVacio($txtdescripcion,$sDescripcionDefault,0)
;-----------------------------------------------------------------------    
        case number(_WinAPI_GetDlgCtrlID(GUICtrlGetHandle($txtfabricante)))
            vRevisarCampoVacio($txtfabricante,$sFabricanteDefault,0)
;-----------------------------------------------------------------------    
        case number(_WinAPI_GetDlgCtrlID(GUICtrlGetHandle($txtversion)))
            vRevisarCampoVersion()
            vRevisarCampoVacio($txtversion,$sVersionDefault,0)
;-----------------------------------------------------------------------    
        case number(_WinAPI_GetDlgCtrlID(GUICtrlGetHandle($txtfecha)))
            vRevisarCampoFecha()
            vRevisarCampoVacio($txtfecha,"12/19/2007",0)
;-----------------------------------------------------------------------    
        case number(_WinAPI_GetDlgCtrlID(GUICtrlGetHandle($txtguid)))
            vRevisarCampoGUID()
            vRevisarCampoVacio($txtguid,$sGUIDDEFAULT,1)
;-----------------------------------------------------------------------    
        case number(_WinAPI_GetDlgCtrlID(GUICtrlGetHandle($txtinstdisk)))
            vRevisarCampoVacio($txtinstdisk,$sInstDiskDefault,1)
    EndSwitch    
EndFunc    
;*************************************************************************************************
; vRevisarCampoVacio()
; Datos de Entrada: el controlID a tratar, El string por defecto y el nombre de la ventana
; Datos de Salida: Ninguno
; Descripción:
;   Aquí se controla que el input no contenga un string vacio,
;   en caso de no existir cadena, se rellena el input con el dato por defecto
;*************************************************************************************************
Func vRevisarCampoVacio($oInput, $sData_Default, $bNombre_Form)
    Local $sNombreForm1, $sNombreForm2
    Local $xypos1,$xypos2
   
    if $bNombre_Form==0 Then
        $sNombreForm=$sForm1[$bIdioma] ; $sForm1 -> FUNCIONA tambien
    Else
        $sNombreForm=$sCaption_opc_avanz[$bIdioma] ; $sCaption_opc_avanz -> FUNIONA tambien
    EndIf
    
    if GUICtrlRead($oInput)=="" Then
        GUISetState(@SW_LOCK,$iCualForm[$bNombre_Form])
        $xypos1=WinGetPos($sNombreForm)
        $xypos2=ControlGetPos($sNombreForm,"",$oInput)
        ToolTip($sCampoVacio_Mensaje[$bIdioma], $xypos1[0]+ $xypos2[0]+10, $xypos1[1]+$xypos2[1]+50,$sCampoVacio_Titulo[$bIdioma],2,1)

        Sleep(2000)
        GUICtrlSetData($oInput,$sData_Default)
        ToolTip("") 
        GUISetState(@SW_UNLOCK ,$iCualForm[$bNombre_Form])
    EndIf
EndFunc    
;*************************************************************************************************
; vDetectar_Hexa()
; Datos de Entrada: el controlID a tratar
; Datos de Salida: Ninguno
; Descripción:
;   Aquí se controla que la cadena introducida del control input sea un número hexadecimal
;   y además se mantiene el cursor de texto (caret) donde el usuario lo dejó en el último tecleo
;*************************************************************************************************
Func vDetectar_Hexa($oInput_)
local $sCadena1, $sCadena2, $conta, $iPosicionCursor
        $sCadena1=GUICtrlRead($oInput_)
        if StringIsXDigit($sCadena1)=0 Then
            for $conta=1 to StringLen($sCadena1)
                $sCadena2=StringMid($sCadena1,$conta,1)
                if StringIsXDigit($sCadena2)=0 Then
                    $iPosicionCursor=$conta-1
                    GUICtrlSetData($oInput_,StringRegExpReplace($sCadena1,$sCadena2,""))
                    Send("{HOME}")
                    if $iPosicionCursor<>0 Then
                        Send("{RIGHT " & $iPosicionCursor & "}")
                    EndIf
                    ExitLoop
                EndIf
            Next
        EndIf
EndFunc    
;*************************************************************************************************
; vRevisarCampoGUID()
; Datos de Entrada: ninguno
; Datos de Salida: Ninguno
; Descripción:
;   Aquí se controla que la cadena introducida del control $txtguid contenga numeros hexadecimales
;   y que sea permitido los caracteres "{" "}" y "-", Además se mantiene el cursor de texto (caret) 
;   donde el usuario lo dejó en el último tecleo.
;*************************************************************************************************
Func vRevisarCampoGUID()
local $sCadena1, $sCadena2, $iPosicionCursor
Local $cAbrirLLave1="{"
Local $cCerrarLLave1="}"
Local $cGuion="-"
        $sCadena1=GUICtrlRead($txtguid)
        if StringIsXDigit($sCadena1)=0 Then
            for $conta=1 to StringLen($sCadena1)
                $sCadena2=StringMid($sCadena1,$conta,1)
                if StringIsXDigit($sCadena2)=0 Then
                    if( $sCadena2<>$cAbrirLLave1 And _
                        $sCadena2<>$cCerrarLLave1 And _
                        $sCadena2<>$cGuion _
                      ) Then
                        $iPosicionCursor=$conta-1
                        GUICtrlSetData($txtguid,StringRegExpReplace($sCadena1,$sCadena2,""))
                        Send("{HOME}")
                        if $iPosicionCursor<>0 Then
                            Send("{RIGHT " & $iPosicionCursor & "}")
                        EndIf
                        ExitLoop   
                    EndIf        
                EndIf 
            Next
        EndIf
EndFunc    
;*************************************************************************************************
; vRevisarCampoFecha()
; Datos de Entrada: ninguno
; Datos de Salida: Ninguno
; Descripción:
;   Aquí se controla que la cadena introducida del control $txtfecha contenga numeros y
;   sea permitido el caracter "/", Además se mantiene el cursor de texto (caret) 
;   donde el usuario lo dejó en el último tecleo.
;*************************************************************************************************
Func vRevisarCampoFecha()
local $sCadena1, $sCadena2, $iPosicionCursor, $iCaracter
        $sCadena1=GUICtrlRead($txtfecha)
            for $conta=1 to StringLen($sCadena1)
                $sCadena2=StringMid($sCadena1,$conta,1)
                $iCaracter=Asc($sCadena2)
                if ($iCaracter < 0x2F Or $iCaracter > 0x39) Then
                    GUICtrlSetData($txtfecha,StringRegExpReplace($sCadena1,$sCadena2,""))
                    $iPosicionCursor=$conta-1
                    Send("{HOME}")
                    if $iPosicionCursor<>0 Then
                        Send("{RIGHT " & $iPosicionCursor & "}")
                    EndIf
                    ExitLoop
                EndIf
            Next
EndFunc    
;*************************************************************************************************
; vRevisarCampoVersion()
; Datos de Entrada: ninguno
; Datos de Salida: Ninguno
; Descripción:
;   Aquí se controla que la cadena introducida del control $txtversion contenga numeros y
;   sea permitido el caracter ".", Además se mantiene el cursor de texto (caret) 
;   donde el usuario lo dejó en el último tecleo.
;*************************************************************************************************
Func vRevisarCampoVersion()
local $sCadena1, $sCadena2, $iPosicionCursor, $iCaracter
Local $cPunto=0x2E  ; correponde al punto decimal "."
        $sCadena1=GUICtrlRead($txtversion)
            for $conta=1 to StringLen($sCadena1)
                $sCadena2=StringMid($sCadena1,$conta,1)
                $iCaracter=Asc($sCadena2)
                if ($iCaracter <> $cPunto and ($iCaracter<0x30 Or $iCaracter>0x39)) then
                    GUICtrlSetData($txtversion,StringRegExpReplace($sCadena1,$sCadena2,""))
                    $iPosicionCursor=$conta-1
                    Send("{HOME}")
                    if $iPosicionCursor<>0 Then
                        Send("{RIGHT " & $iPosicionCursor & "}")
                    EndIf
                    ExitLoop
                EndIf
            Next
EndFunc    
;*************************************************************************************************
;   la Función MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam) es una adaptación del 
;   código original posteado por MrCreatoR en el hilo
;    http://www.autoitscript.com/forum/index.php?showtopic=57795&view=findpost&p=437460
;*************************************************************************************************
Func MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam)
    Local $nNotifyCode = BitShift($wParam, 16)
    Local $nID = BitAND($wParam, 0xFFFF)
    Local $hCtrl = $lParam

    if $nNotifyCode==$EN_CHANGE then
        vDetectar_Cambios_Control_Input($nID)
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc

