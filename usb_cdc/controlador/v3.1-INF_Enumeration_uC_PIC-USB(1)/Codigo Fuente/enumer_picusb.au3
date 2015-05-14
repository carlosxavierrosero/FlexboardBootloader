#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=perro7.ico
#AutoIt3Wrapper_outfile=enumer_picusb.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=Enjoy it!
#AutoIt3Wrapper_Res_Description=This software is useful to personalize the files mchpusb.inf, usb_desc_scope.h, mchpcdc.inf, usb_desc_cdc.h with data placed previously.
#AutoIt3Wrapper_Res_Fileversion=3.1.0.16
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Anybody is free of use, modify, improve how want this software and must be used NO lucre and ALWAYS maintain the original(s) author(s) name(s). In history record or sources codes from functions, procedures, modular codes you can include your authorship of the modification source code made respectively.
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=8202
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

AutoIt Version: 3.2.12.1
 Author:         Pedro - PalitroqueZ
                palitroquez@gmail.com
 
 Script Function:
 
 Automatización de Datos Enumeración USB

 Programa que permite configurar los descriptores y los archivos instaladores inf
 necesarios para enumerar los pic 18F4x5x y hacer posible las transferencias
 a través del puerto serie universal USB.

 En la primera versión se manejan 2 tipos de transferencias, la de propósito
 general como la define Microchip usando la biblioteca mpusbapi.dll[1] y su instalador
 mchpusb.inf y la emulación rs-232 mediante la clase CDC[2] con su instalador
 mchpcdc.inf

 En la parte de la programación del uC PIC, ambos usan unas funciones que provee
 el PIC C Compiler de la empresa CCS. En el caso [1] se gestiona con usb_desc_scope.h
 en el caso [2] se gestiona con usb_desc_cdc.h

 La idea es que el usuario pueda cambiar los datos, tales como el nombre del dispositivo,
 el fabricante, el Vendor ID, el Product ID, etc y el programa se encargue de modificar
 dichos datos en los archivos mencionados anterioriormente.

 -------------------------------------------------------------------------------
 Historial:
 ------------------------------------------------------------------------------------
 v3.1. 06-Mar-09

    - Arreglado un bug relacionado al sobrescribir un archivo mpchusb.inf
    - Se añadió la opción de escoger el tipo de ícono del dispositivo, si se quiere
      usar un ícono personalizado ó usar el predeterminado de windows (Win Vista)
    
 ------------------------------------------------------------------------------------
 v3.0 27-oct-08
 
  - Mudado el código fuente del Visual Basic 6.0 al AutoIT  con la iniciativa
   de apoyar al software libre ;-)
 
 - Actualizado para MCHPFSUSB v1.1.0.0 (June 23, 2008) que corresponde a la actualización de:
   - mchpusb.inf
   - mchpcdc.inf
   (para mayor información leer las release notes de MCHPFSUSB en www.microchip.com)

-  Añadida multitud de mejoras como comprobaciones de los textos, cambio total en la interfaz 
   de idioma Inglés <-> Español 
 ------------------------------------------------------------------------------------
 v2.0 01-feb-08

 - añadida nuevas opciones:
   - Crear una clase aparte solo para el dispositivo.
   - incluir un ícono a esa clase creada.
   - mejor estructuración de código fuente.
   - al cerrar el programa se guardan los datos de todos los campos.
   - al abrir el programa se cargan los datos de todos los campos, guardados
     con anterioridad.
 
 ------------------------------------------------------------------------------------
 v1.0 versión inicial 09-ene-08

 ------------------------------------------------------------------------------------
 Sobre los Derechos

 Cualquier persona es libre de usar, modificar, mejorar como quiera este
 software SIN fines de lucro y siempre y cuando conserve el/los nombre/s
 del/los autor/es original/es.
 
 En el historial ó en los codigos de las funciones, procedimientos a nivel
 de clase, modular o de formulario puede incluir la autoría y las modificaciones
 hechas respectivas.
 
 About copyright:
 
 Anybody is free of use, modify, improve how want this software and must be used
 NO lucre and ALWAYS maintain the original(s) author(s) name(s).
 
 In history record or sources codes from functions, procedures, modular codes you can
 include your authorship of the modification source code made respectively.
 
#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once 

;~ Opt("MustDeclareVars", 1) ; el equivalente a option explicit
Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC",1)		; evita que se produzca el evento close al teclear ESC
Opt("WinTextMatchMode",2)
;~ Opt("WinDetectHiddenText",1)
;Global $icono_perro = @TempDir & "\perro7.ico"
Global $icono_perro = @ScriptDir & "\perro7.ico"

fileinstall("perro7.ico",$icono_perro,1)

;al momento de compilar, debe estar perro7.ico en el script path

;~ #include <GUIConstants.au3>

#include <GuiTab.au3>
#Include <GuiEdit.au3>

Global $bIdioma
Global $Icon1, $sGuardar_File, $sDirectorio=""
local const $iForm_cerrado=489  ;484   
local const $iForm_abierto=753  ;753
Global $fBandera_tipo_transferencia
Global $fBandera_guardar_ambos=False
Global $fBandera=True
Global $fBandera_Icono_predeterminado
local $iAltura_form=516
Local $sVistapreliminar
Global $sNombre_icono, $sRuta_nombre_icono
Global $txtnombre,$txtvid,$txtpid,$txtubicacion,$txtdescripcion
Global $txtfabricante,$txtversion,$txtfecha,$txtguid
Global $txtclassname,$txtclassdesc,$txtinstdisk
Global $Group1,$Label1,$lblnota,$Label5,$Label6
Global $Label7,$mnuinfo,$Label4,$mnuacerca,$mnuopcionesavanzadas
Global $Label8,$Group2,$optbulk,$ChkIcono
Global $Group3,$cmdplantilla,$cmdguardar,$chkguardarambos
Global $Group4,$Group5,$cmdguid,$Group6,$cmddefecto
Global $optcdc

#include "includes\texto_multilenguaje.au3"

#include "includes\crear_mchusbapi.au3"
#include "includes\crear_desc_scope.au3"
#include "includes\crear_mchpcdc.au3"
#include "includes\crear_desc_cdc.au3"
#include "includes\crear_funciones_generales.au3"
#include "includes\Crear_Form_principal.au3"
#include "includes\Crear_Form_secundario.au3"
#include "includes\funciones_changes_txt.au3"

;****************************************************************
vMain()
;****************************************************************
Func vMain()
    GUICtrlSetState($optccs,$GUI_CHECKED)

	vIniCializar_variables()
	GUICtrlSetData($TabSheet1,"mchpusb.inf")
	GUICtrlSetData($TabSheet2,"usb_desc_scope.h")
    vVisor_Edits(0)
	cmdplantillaClick()
EndFunc

;****************************************************************
While 1
  Sleep(100)   ; ciclo eterno en espera de ejecución de eventos
WEnd
  
;****************************************************************
; Función vVisor_Edits
; datos de entrada: un entero que de ser válido es un número de 0 a 4
; datos de salida: ninguno
;
; Descripción:
; Esta Función sirve para no perder el enfoque de los 4 Edits que se muestran sobre
; los tab, sin esta función, al esconder la ventana principal y volverla aparecer
; los edits txtmchusbapi, txtusb_desc_scope, txtmchpcdc y txtusb_desc_cdc
; no muestran el texto contenidos en ellos, siendo la única solución
; clicar sobre ellos para que muestren su contenido.
; con vVisor_Edits se resuelve este problema y el texto siempre será
; visible.
; nota: se esconden los edits que no interesan según sea el caso seleccionado
;****************************************************************
Func vVisor_Edits($iCual_txt)
    Sleep(100)
    Select
        Case $iCual_txt=0
            GUICtrlSetState($txtmchusbapi,$GUI_HIDE)
            GUICtrlSetState($txtusb_desc_scope,$GUI_HIDE)
            GUICtrlSetState($txtmchpcdc,$GUI_HIDE)
            GUICtrlSetState($txtusb_desc_cdc,$GUI_HIDE)
        Case $iCual_txt=1
            GUICtrlSetState($txtmchusbapi,$GUI_SHOW)
            GUICtrlSetState($txtusb_desc_scope,$GUI_HIDE)
            GUICtrlSetState($txtmchpcdc,$GUI_HIDE)
            GUICtrlSetState($txtusb_desc_cdc,$GUI_HIDE)
        Case $iCual_txt=2
            GUICtrlSetState($txtmchusbapi,$GUI_HIDE)
            GUICtrlSetState($txtusb_desc_scope,$GUI_SHOW)
            GUICtrlSetState($txtmchpcdc,$GUI_HIDE)
            GUICtrlSetState($txtusb_desc_cdc,$GUI_HIDE)            
        Case $iCual_txt=3
            GUICtrlSetState($txtmchusbapi,$GUI_HIDE)
            GUICtrlSetState($txtusb_desc_scope,$GUI_HIDE)
            GUICtrlSetState($txtmchpcdc,$GUI_SHOW)
            GUICtrlSetState($txtusb_desc_cdc,$GUI_HIDE)            
        Case $iCual_txt=4
            GUICtrlSetState($txtmchusbapi,$GUI_HIDE)
            GUICtrlSetState($txtusb_desc_scope,$GUI_HIDE)
            GUICtrlSetState($txtmchpcdc,$GUI_HIDE)
            GUICtrlSetState($txtusb_desc_cdc,$GUI_SHOW)            
    EndSelect
EndFunc
