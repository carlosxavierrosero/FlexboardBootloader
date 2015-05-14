#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         Pedro - PalitroqueZ
                palitroquez@gmail.com
 
 Script Function:
 
  Aquí van un conjunto de Funciones necesarias en el código principal. Cada una de ellas
  están descritas en su sección
 
   - vIniCializar_variables()
   - vCargar_datos_originales()
   - sSeparar_stringX($sNombre_dispositivo)
   - vGuardar_archivos($sCadena_datos,$sNombre_archivo,$sExtension, bBanderita) 
   - vGuardar_DATos_ini()
   - sTomar_nombre_icono($sPath_ruta)
   - _sCreateGUID()
   
   
#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;#include <Misc.au3>


Global $nombre_ini="enum_picusb.ini"

#cs**************************************************************************************
 vIniCializar_variables:
   cuando se abre el ejecutable, se busca los valores que se almacenaron en enum_picusb.ini
   y se cargan en los campos respectivos.
 
   datos de entrada: ninguno
   datos de salida: ninguno
#ce**************************************************************************************

Func vIniCializar_variables()
Local $hArchivo, $contador
    ;$ruta_config = "enum_picusb.ini"
	$hArchivo=FileOpen(@ScriptDir & "\" & $nombre_ini,0)
	if $hArchivo <> -1 Then
			GUICtrlSetData($txtnombre, FileReadLine($hArchivo,1))
			GUICtrlSetData($txtvid,FileReadLine($hArchivo,2))
			GUICtrlSetData($txtpid,FileReadLine($hArchivo,3))
			GUICtrlSetData($txtubicacion,FileReadLine($hArchivo,4))
			GUICtrlSetData($txtdescripcion,FileReadLine($hArchivo,5))
			GUICtrlSetData($txtfabricante,FileReadLine($hArchivo,6))
			GUICtrlSetData($txtversion,FileReadLine($hArchivo,7))
			GUICtrlSetData($txtfecha,FileReadLine($hArchivo,8))
			GUICtrlSetData($txtguid,FileReadLine($hArchivo,9))
			GUICtrlSetData($txtinstdisk,FileReadLine($hArchivo,10))
			$sNombre_icono=FileReadLine($hArchivo,11)
            $bIdioma=FileReadLine($hArchivo,12)
            $fBandera_Icono_predeterminado=int(FileReadLine($hArchivo,13))
            $fBandera_tipo_transferencia=int(FileReadLine($hArchivo,14))
            
            if $fBandera_tipo_transferencia== 1 Then
                GUICtrlSetState($optbulk,$GUI_CHECKED)
                GUICtrlSetState($optcdc,$GUI_UNCHECKED)
            Else
                GUICtrlSetState($optbulk,$GUI_UNCHECKED)
                GUICtrlSetState($optcdc,$GUI_CHECKED)
            EndIf
            cmdplantillaClick()

			if GUICtrlSetImage($Icon1,$sNombre_icono)=0 then 
				GUICtrlSetImage($Icon1,$sRuta_nombre_icono)
				$sNombre_icono="perro7.ico"
			EndIf
			$sRuta_nombre_icono= @ScriptDir & "\" & $sNombre_icono
            
            vChecar_Icono_Predeterminado()   

    else
		vCargar_datos_originales()
	EndIf
	FileClose($hArchivo)
    vActualizar_Cambio_Lenguaje()
    if $bIdioma==1 then
        mnuspanish_Click()
    Else
        mnuenglish_Click()
    EndIf
EndFunc

#cs**************************************************************************************
 vCargar_datos_originales:
  se encarga de rellenar los campos con los datos por defecto.
  datos de entrada: ninguno
  datos de salida: ninguno
#ce**************************************************************************************
Func vCargar_datos_originales()
    GUICtrlSetData($txtnombre, $sNombreCategoriaDefault)
	GUICtrlSetData($txtvid,$sVIDDefault)
	GUICtrlSetData($txtpid,$sPIDDefault)
	GUICtrlSetData($txtubicacion,$sUbicacionDefault)
	GUICtrlSetData($txtdescripcion,$sDescripcionDefault)
	GUICtrlSetData($txtfabricante,$sFabricanteDefault)
	GUICtrlSetData($txtversion,$sVersionDefault)
	GUICtrlSetData($txtfecha,$sFechaDefault)
	GUICtrlSetData($txtguid,$sGUIDDEFAULT)
	GUICtrlSetData($txtinstdisk,$sInstDiskDefault)
    GUICtrlSetState($ChkIcono,$GUI_CHECKED)
    GUICtrlSetState($optbulk,$GUI_CHECKED)
	GUICtrlSetState($optcdc,$GUI_UNCHECKED)
    
    $bIdioma=0
    $fBandera_Icono_predeterminado=1
    $fBandera_tipo_transferencia=1

	$sRuta_nombre_icono = $icono_perro
	$sNombre_icono="perro7.ico"
	GUICtrlSetImage($Icon1,$sRuta_nombre_icono)
    
    vChecar_Icono_Predeterminado()
    cmdplantillaClick()
EndFunc

#cs**************************************************************************************
 vChecar_Icono_Predeterminado:
  verifica el estado de selección de ícono (personalizado o predeterminado)
  y actualiza el control correspondiente.
  datos de entrada: ninguno
  datos de salida: ninguno
#ce**************************************************************************************
Func vChecar_Icono_Predeterminado()
    if $fBandera_Icono_predeterminado==1 Then
        GUICtrlSetState($ChkIcono,$GUI_CHECKED)
    Else
        GUICtrlSetState($ChkIcono,$GUI_UNCHECKED)
    EndIf
    ChkIcono_Click()
EndFunc

#cs**************************************************************************************
 sSeparar_stringX:
 
  separa el string de Nombre de Dispositivo en caracteres
  
  STRING2 es el nombre del dispositivo
  esta función separa la cadena string2 en caracteres que van de acuerdo como
  se escriben en la sección "start string descriptors" del .h correspondiente
  (usb_desc_scope.h ó usb_desc_cdc.h)
 
  datos de entrada: string del nombre del dispositivo
  datos de salida: caracteres individuales del nombre del dispositivo
#ce**************************************************************************************
Func sSeparar_stringX($sNombre_dispositivo)
Local $sLongitud_StringX,$sSeparar_nombre,$sStringX_cadenon,$iConta

	$sSeparar_nombre = ""
	$sLongitud_StringX = (StringLen($sNombre_dispositivo) + 1) * 2

	For $iConta = 1 To StringLen($sNombre_dispositivo)
		$sSeparar_nombre = $sSeparar_nombre & "         " & Chr(39) & _
		StringMid($sNombre_dispositivo, $iConta, 1) & Chr(39) & ",0," & @CRLF
	Next

	$sStringX_cadenon = _
		"         " & $sLongitud_StringX & ", //length of string index" & @CRLF _
		& "         USB_DESC_STRING_TYPE, //descriptor type 0x03 (STRING)" & @CRLF _
		& $sSeparar_nombre

	Return $sStringX_cadenon
EndFunc

#cs**************************************************************************************
	vGuardar_archivos($sCadena_datos,$sNombre_archivo,$sExtension)
		Se encarga de tomar las variables que iran en los archivos .inf
		y .h necesarios para la enumeración del pic
	
	datos de entrada: 
		- la cadena de datos que se desea guardar en los archivos
		- el nombre del archivo
		- la extensión del archivo
	datos de salida: ninguno
#ce**************************************************************************************

Func vGuardar_archivos($sCadena_datos,$sNombre_archivo,$sExtension, $fGuardar_Icono)
Local $hArchivo,$iSobreescribir_Archivo=1
        
        if $sDirectorio=="" Then
            $sGuardar_File=FileSaveDialog("Guardar Archivo como...",$sDirectorio,$sNombre_archivo _
									   & "(*." & $sExtension & ")",2+16,$sNombre_archivo & "." & $sExtension)
        
        Else
            $sDirectorio=$sGuardar_File
            $sGuardar_File=FileSaveDialog("Guardar Archivo como...",$sDirectorio,$sNombre_archivo _
									   & "(*." & $sExtension & ")",2+16,$sNombre_archivo & "." & $sExtension)
        EndIf
        
        If not @error then
			$hArchivo=FileOpen($sGuardar_File,2) 
			if $hArchivo <> -1 Then
				FileWrite($hArchivo,$sCadena_datos)
				FileClose($hArchivo)
			EndIf

        if $fGuardar_Icono==1 then
			if $sRuta_nombre_icono<>"" Then
				if ($fBandera_tipo_transferencia==1) and ($fBandera_Icono_predeterminado<>1) Then
					FileCopy($sRuta_nombre_icono, @ScriptDir & "\" & $sNombre_icono)
					; copia el ícono a la carpeta del script (sobreescribe si lo encuentra )
					FileCopy($sRuta_nombre_icono, _
					sTomar_ruta_FileSaveDialog_icono($sGuardar_File) & $sNombre_icono, _
													 $iSobreescribir_Archivo)
					; hace una copia en la carpeta donde se guardaran los nuevos archivos
				EndIf
			EndIf
		EndIf
        EndIf
		
EndFunc

#cs**************************************************************************************
	vGuardar_DATos_ini
		guarda en enum_picusb.ini, los ultimos datos introducidos en los campos correspondientes, 
		para su futura utilización
	
	datos de entrada: ninguno
	datos de salida: ninguno
#ce**************************************************************************************

Func vGuardar_DATos_ini()
	Local $hArchivo,$iSobreescribir_Archivo=1
	
	$hArchivo=FileOpen(@ScriptDir & "\enum_picusb.ini",2)
	if $hArchivo <> -1 Then
		FileWriteLine($hArchivo,GUICtrlRead($txtnombre))
		FileWriteLine($hArchivo,GUICtrlRead($txtvid))
		FileWriteLine($hArchivo,GUICtrlRead($txtpid))
		FileWriteLine($hArchivo,GUICtrlRead($txtubicacion))
		FileWriteLine($hArchivo,GUICtrlRead($txtdescripcion))
		FileWriteLine($hArchivo,GUICtrlRead($txtfabricante))
		FileWriteLine($hArchivo,GUICtrlRead($txtversion))
		FileWriteLine($hArchivo,GUICtrlRead($txtfecha))
		FileWriteLine($hArchivo,GUICtrlRead($txtguid))
		FileWriteLine($hArchivo,GUICtrlRead($txtinstdisk))
		FileWriteLine($hArchivo,String($sNombre_icono))
        FileWriteLine($hArchivo,String($bIdioma))
        FileWriteLine($hArchivo,String($fBandera_Icono_predeterminado))
        FileWriteLine($hArchivo,String(int($fBandera_tipo_transferencia)))
	EndIf
	FileClose($hArchivo)
	
	if $sRuta_nombre_icono<>"" Then
		FileCopy($sRuta_nombre_icono,@ScriptDir,$iSobreescribir_Archivo)
		; copia el ícono a la carpeta del script (sobreescribe si lo encuentra )
	EndIf
EndFunc

#cs**************************************************************************************
	sTomar_ruta_FileSaveDialog_icono
		toma la ruta generada por la función FileSaveDialog que se encuentra en
		la función vGuardar_archivos, esto se hace porque FileSaveDialog añade a la
		ruta, el nombre del archivo que se quiere guardar y entonces esa ruta coincide
		con el ícono que queremos guardar. En resumen sTomar_ruta_FileSaveDialog_icono
		SOLO toma la ruta generada en ese instante por FileSaveDialog
	
	datos de entrada: un string con la ruta + nombre archivo
	datos de salida: un string con la ruta
#ce**************************************************************************************
Func sTomar_ruta_FileSaveDialog_icono($sPath_ruta)
Local $t,$longitUd,$temp

$longitUd = StringLen($sPath_ruta)

For $t = 0 To $longitUd
    $temp = StringMid($sPath_ruta, ($longitUd - $t), 1)
    If $temp == "\" Then
		Return StringLeft($sPath_ruta,$longitUd -$t)
        $sPath_ruta = ""
        ExitLoop
    EndIf
Next
EndFunc

#cs**************************************************************************************
    sTomar_nombre_icono
    Descripción: Toma la ruta y nombre completo del ícono y devuelve unicamente 
    el nombre con su extensión del ícono
    Datos Entrada: un string con la ruta del archivo
    Datos Salida: un string con el nombre + extensión del archivo
#ce**************************************************************************************
Func sTomar_nombre_icono($sPath_ruta)
Local $t,$longitUd,$temp

$longitUd = StringLen($sPath_ruta)

For $t = 0 To $longitUd
    $temp = StringMid($sPath_ruta, ($longitUd - $t), 1)
    If $temp == "\" Then
		;$rutaXicono= StringLeft($sPath_ruta,$longitUd -$t)
        Return StringRight($sPath_ruta, $t)
        $sPath_ruta = ""
        ExitLoop
    EndIf
Next
EndFunc

#cs**************************************************************************************
 _sCreateGUID(); crea una nuevo GUID llamando a la API CoCreateGuid de ole32.dll
 datos de entrada: ninguno
 datos de salida: un string con el nuevo GUID generado
 
 Esta función fué posteada por SumTingWong en:
 http://www.autoitscript.com/forum/index.php?showtopic=11865&view=findpost&p=81918
#ce**************************************************************************************

Func _sCreateGUID()
    Local $GUIDSTRUCT
    Local $aDllRet
    Local $sGUID
    
    $GUIDSTRUCT = DllStructCreate("int;int;int;byte[8]")
    If Not @error Then
        $aDllRet = DllCall("ole32.dll", "long", "CoCreateGuid", "ptr", DllStructGetPtr($GUIDSTRUCT))
        If Not @error And $aDllRet[0] == 0 Then
            $aDllRet = DllCall("ole32.dll", "long", "StringFromGUID2", _
                "ptr", DllStructGetPtr($GUIDSTRUCT), _
                "wstr", "", _
                "int", 40)
            If Not @error And $aDllRet[0] > 0 Then $sGUID = $aDllRet[2]
        EndIf
        ;DllStructDelete($GUIDSTRUCT)    
    EndIf
    Return $sGUID
EndFunc
