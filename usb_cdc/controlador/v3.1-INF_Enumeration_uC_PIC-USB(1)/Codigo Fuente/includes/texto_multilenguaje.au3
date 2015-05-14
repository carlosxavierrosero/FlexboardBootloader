#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         Pedro - PalitroqueZ
                 palitroquez@gmail.com
 Script Function:
	Aquí se almacenan todas las cadenas de texto de la interfaz en el idioma inglés y español

#ce ----------------------------------------------------------------------------

Global $sNombreCategoriaDefault="Custom USB Devices"
Global $sVIDDefault="04D8"
Global $sPIDDefault="000B"
Global $sUbicacionDefault="DEVICE PICUSB"
Global $sDescripcionDefault="Microchip Custom USB Device"
Global $sFabricanteDefault="Microchip Technology, Inc."
Global $sVersionDefault="1.0.0.6"
Global $sFechaDefault="12/19/2007"
Global $sGUIDDEFAULT="{A503E2D3-A031-49DC-B684-C99085DBFE92}"
Global $sInstDiskDefault="Microchip Technology, Inc. Installation Disc"

Global $sForm1[2]=["v3.1 - INF Data Enumeration uC PIC-USB","v3.1 - INF Enumeración Datos uC PIC-USB"]
Global $smnuAcerca[2]=["A&bout","Ac&erca"]
Global $sGroup1[2]=["Configuration Frame - Don´t forget refill all field inputs box!", _
                    "Cuadro de Configuración - NO dejes ningún campo vacio"]
Global $sLabel1[2]=["Name Category:","Nombre Categoría:"]
Global $slblnota[2]=["-> Note!","-> ¡¡NOTA!!"]
Global $slblnotaInformacion[2]=["Information ","Información "]
Global $slblnotaMensaje[2]=[ _
            "This VID and PID is distribute by Microchip under Licence. " _
          & "To acquire a VID and PID with commercial purpose you must have " _
          & "a register approved by www.usb.org", _
            "Este VID y PID es proporcionado por la Microchip bajo su licencia." _
          & " Para obtener un VID y un PID con fines comerciales debe tener un registro APROBADO " _
		  & "por www.usb.org " _
          ]
          
Global $sLabel4[2]=["Location:","Ubicación"]
Global $slabel5[2]=["Description:","Descripción:"]
Global $slabel6[2]=["Manufacturer:","Fabricante:"]
Global $slabel7[2]=["Version:","Versión:"]
Global $sLabel8[2]=["Date:","Fecha:"]
Global $sGroup2[2]=["Transfer Type:", "Tipo de Transferencia:"]
Global $soptbulk[2]=["General Purpose mpusbapi.dll","Propósito General mpusbapi.dll"]
Global $sGroup3[2]=["Programming Language:","Lenguaje de Programación:"]
Global $scmdplantilla[2]=["See Preliminary Template","Ver Plantilla Preliminar"]
Global $scmdguardar[2]=["Save","Guardar"]
Global $schkguardarambos[2]=["Save both", "Guardar Ambos"]
Global $sGroup4[2]=["Generated GUID:","GUID Generado:"]
Global $scmdguid[2]=["Make new GUID","Generar nuevo GUID"]
Global $sGroup5[2]=["Name INSTDISK Personalized:","Nombre INSTDISK Personalizado:"]
Global $sGroup6[2]=["Use Icon","Usar Ícono"]
Global $scmddefecto[2]=["Data Default","Datos por Defecto"]
Global $sCampoVacio_Titulo[2]=["Note:","Nota:"]
Global $sCampoVacio_Mensaje[2]=["This Field Cannot be empty! ","¡Este campo no puede quedar vacio!"]


Global $sGuid1[2]=["Advice!","¡Aviso!"]
Global $sGuid2[2]=[ _
                    "This completing the edits fields with data default that come " _
                    & "the software from initiation and will lost date actual. You want continue?", _
                    "Esto Rellenará los campos con los datos por defecto que trae " _
					& "el programa originalmente, y se perderan los actuales. " _
					& "¿Desea continuar?" _
                    ]
Global $sGuid3[2]=[ _
                        "you want change CLASSGUID?"  & @CRLF _
                        & "when run file .inf make other branch in register configuration of windows" & @CRLF _
                        & "NOT recommended change this field if you is beginner" , _
                        "¿Desea cambiar el CLASSGUID? cuando ejecute el archivo .inf, " _
                        & "se creará otra rama en el registro de configuraciones de windows" & @CRLF _
                        & "No recomendado modificarlo si usted es novato"  _
                    ]
Global $sCheckIcono[2]=[ _
                        "USB Icon default Windows?" , _
                         "¿Ícono USB predeterminado de Windows?" _
                       ]
;----------------------------------------------------------------------------------------------------------------
Global $sCaption_opc_avanz[2] = ["Options Advanced","Opciones Avanzadas"]
Global $sInformacion[2]=[ _
                            "This software is useful to personalize the files mchpusb.inf, usb_desc_scope.h, " _
                          & "mchpcdc.inf, usb_desc_cdc.h with data" & @CRLF _
                          & " placing previously." & @CRLF & @CRLF _
                          & "This software has been tested successfully in WinXP SP2 (32bits)"  & @CRLF _
                          & "and WinVista (32 bits) with a PIC18F4550 and working " & @CRLF _
						  & "with MCHPFSUSB Driver v1.1.0.0 - June 23, 2008." & @CRLF & @CRLF _ 
                          & "This software no must be used to lucre" & @CRLF & @CRLF _
						  & "Software written under AutoIT by Pedro - PalitroqueZ. palitroquez@gmail.com" , _
                          "Este software sirve para personalizar los archivos mchpusb.inf, usb_desc_scope.h, " _
                          & "mchpcdc.inf, usb_desc_cdc.h en base a los " & @CRLF _
                          & "datos configurados previamente." & @CRLF & @CRLF _
                          &  "Este programa ha sido probado exitosamente en WinXP SP2(32 bits)"  & @CRLF _
                          & "y WinVista (32 bits) con un PIC18F4550 y usa el Driver " & @CRLF _
						  & "MCHPFSUSB v1.1.0.0 - 23 Junio del 2008. "  & @CRLF & @CRLF _
                          & "Este programa debe usarse SIN fines de lucro." & @CRLF & @CRLF _
						  & "Programado bajo AutoIT por Pedro - PalitroqueZ.  palitroquez@gmail.com" _
                          ]

Global $sTTBClassname[2]=[ _
                          "Change string INSTDISK in mchpusb.inf to personalize your installer file", _
                          "Cambia la cadena INSTDISK en mchpusb.inf para personalizar su archivo instalador"  _
                         ]

Global $sTTBTitulo[2]=["Help","Ayuda"]
Global $sTTBVID[2]=[ _
                    "VID mean Vendor Identifier, must be written on Hexadecimal system. e.g. 0x04D8" , _
                    "VID significa Vendor Identifier, escribelo en sistema Hexadecimal. e.j. 0x04D8" _
                  ]
Global $sTTBPID[2]=[ _
                   "PID mean Product Identifier, must be written on Hexadecimal system. e.g. 0x000B", _
                   "PID significa Product Identifier, escribelo en sistema Hexadecimal. e.j. 0x000B" _
                  ]
Global $sTTBVersion[2]=[ _
                       "Version Format is AA.BB.CC.DD"  & @CRLF _
                       & "version number creation or updating installer file .inf" , _
                       "El formato es AA.BB.CC.DD" & @CRLF _
                       & "Número de la Versión de la creación ó actualización del archivo instalador .inf" _
                      ]
Global $sTTBFecha[2]=[ _
                    "Date Format is month/day/year. Date Creation or updating installer file .inf" & @CrLf _
                    & "in system no anglo, date format is day/month/year " _
                    & "this message is to people spanish :)" , _
                    "El formato es MES/DIA/AÑO." & @CrLf _
			        & "Fecha de la creación ó actualización del archivo instalador .inf" _
                    ]
Global $sTTBPlantilla[2]=[ _
                         "Show template in tab active", _
                         "Muestra la plantilla generada en la pestaña correspondiente" _
                         ]
Global $sTTBGuardar[2]=[ _
                       "save data configured previously in the selected files", _
                       "al clicar se guardará los datos configurados en los archivos seleccionados" _
                       ]
Global $sTTBGuardarambos[2]=[ _
                        "if Option is checked then you save data that show in both tabs in the selected files."  & @CrLf  _
                       & "option unchecked you save data show in tab active" , _
                        "si activa esta opción, se guardaran los datos" & @CrLf  _
                       & "previsualizados en ambas pestañas. " & @CrLf _
				       & "si la desactiva, se guardará los datos" & @CrLf  _
				       & "correspondiente a la pestaña activa" _
                       ]

Global $sTTBGuid[2]=[ _
                    "with GUID, you can make a classGUID different "  & @CrLf _
                    & "to separate different device (make a new device usb)"  & @CrLf _
                    & "NOT recommended change this field if you is beginner", _
                    "Con la GUID se puede crear una classGUID aparte de manera de separar" & @CrLf _
                    & "el dispositivo de otros (crear una nuevo tipo de dispositivo)"  & @CrLf _
                    & "No recomendado modificarlo si usted es novato"  _
                   ]

Global $sTTBIcono[2]=[ _
                    "icon that will show in device administrator in windows."  & @CrLf _
                    & "Use icon USB default for Win Vista" , _
                    "ícono que se mostrará en el administrador de dispositivos."  & @CrLf _
                    & "Para Win Vista, usar ícono USB predeterminado" _
                    ]
Global $sTTBchkIcono[2]=[ _ 
                        "If you set option then devices will show USB icon default by Windows", _
                        "Si activa esta opción, el dispositivo mostrará el ícono de USB predeterminado por Windows" _
                        ]
Global $sTTBDefecto[2]=[ _
            "Refill all fields input with data that come for default at run sotware initially" , _
            "sirve para rellenar los campos con los datos que" & @CrLf  _
             &"venian por defecto. Se puede decir que es reiniciar" & @CrLf  _
			 & "los datos por defecto del programa" _
             ]

;************************************************************************************************                    
; 
;************************************************************************************************
Func vActualizar_Cambio_Lenguaje()
    
    WinSetTitle($sForm1[(not $bIdioma)],"",$sForm1[$bIdioma])
    WinSetTitle($sCaption_opc_avanz[(not $bIdioma)],"",$sCaption_opc_avanz[$bIdioma])
    GUICtrlSetData($Group1,$sGroup1[$bIdioma])
    GUICtrlSetData($Label1,$sLabel1[$bIdioma])
    GUICtrlSetData($lblnota,$slblnota[$bIdioma])
    GUICtrlSetData($label5,$slabel5[$bIdioma])
    GUICtrlSetData($label6,$slabel6[$bIdioma])
    GUICtrlSetData($label7,$slabel7[$bIdioma])
    GUICtrlSetData($mnuinfo,$slblnotaInformacion[$bIdioma])
    GUICtrlSetData($Label4,$sLabel4[$bIdioma])
    GUICtrlSetData($mnuacerca,$smnuAcerca[$bIdioma])
    GUICtrlSetData($mnuopcionesavanzadas,$sCaption_opc_avanz[$bIdioma])
    GUICtrlSetData($Label8,$sLabel8[$bIdioma])
    GUICtrlSetData($Group2,$sGroup2[$bIdioma])
    GUICtrlSetData($optbulk,$soptbulk[$bIdioma])
    GUICtrlSetData($Group3,$sGroup3[$bIdioma])
    GUICtrlSetData($cmdplantilla,$scmdplantilla[$bIdioma])
    GUICtrlSetData($cmdguardar,$scmdguardar[$bIdioma])
    GUICtrlSetData($chkguardarambos,$schkguardarambos[$bIdioma])

    GUICtrlSetData($Group4,$sGroup4[$bIdioma])
    GUICtrlSetData($cmdguid,$scmdguid[$bIdioma])
    GUICtrlSetData($Group5,$sGroup5[$bIdioma])
    GUICtrlSetData($Group6,$sGroup6[$bIdioma])
    GUICtrlSetData($cmddefecto,$scmddefecto[$bIdioma])
    GUICtrlSetData($ChkIcono,$sCheckIcono[$bIdioma])

    GUICtrlSetTip($txtvid, $sTTBVID[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($txtpid, $sTTBPID[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($txtversion, $sTTBVersion[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($txtfecha, $sTTBFecha[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($cmdplantilla, $sTTBPlantilla[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($cmdguardar, $sTTBGuardar[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($chkguardarambos, $sTTBGuardarambos[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($txtguid, $sTTBGuid[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($Icon1, $sTTBIcono[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($txtinstdisk, $sTTBClassname[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($ChkIcono, $sTTBchkIcono[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    GUICtrlSetTip($cmddefecto,$sTTBDefecto[$bIdioma],$sTTBTitulo[$bIdioma],1,1)
    
EndFunc    