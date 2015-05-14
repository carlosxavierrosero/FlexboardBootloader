#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:  Pedro PalitroqueZ - palitroquez@gmail.com

 Script Function:
	función: Crear_usb_desc_scope
	permite crear los datos pertenecientes al archivo usb_desc_scope.h 
	datos de entrada: 
	 - nombre del dispositivo
	 - V.I.D
	 - P.I.D
	datos de salida:
	 un string con los datos actualizados
#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Func sCrear_usb_desc_scope($sNombre_dispositivo,$sVid,$sPid)

Local $sCadenon

$sCadenon = "///////////////////////////////////////////////////////////////////////////" & @CRLF _
& "////                         usb_desc_scope.h                          ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// An example set of device / configuration descriptors for use with ////" & @CRLF _
& "//// the USB Bulk demo (see ex_usb_scope.c)                            ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "///////////////////////////////////////////////////////////////////////////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// Version History:                                                  ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// July 13th, 2005:                                                  ////" & @CRLF _
& "////   Endpoint descriptor works if USB_EP1_TX_SIZE is 16bits          ////" & @CRLF _
& "////   Endpoint descriptor works if USB_EP1_RX_SIZE is 16bits          ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// June 20th, 2005:                                                  ////" & @CRLF _
& "////   18fxx5x Initial release.                                        ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// March 21st, 2005:                                                 ////" & @CRLF _
& "////   EP 0x01 and EP 0x81 now use USB_EP1_TX_SIZE and USB_EP1_RX_SIZE ////" & @CRLF _
& "////      to define max packet size, to make it easier for dynamically ////" & @CRLF _
& "////      changed code.                                                ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// June 24th, 2002: Cleanup                                          ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// May 6th, 2003: Fixed non-HID descriptors pointing to faulty       ////"
;'-----------------------------
$sCadenon = $sCadenon & @CRLF _
& "////                strings                                            ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// August 2nd, 2002: Initial Public Release                          ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "///////////////////////////////////////////////////////////////////////////" & @CRLF _
& "////        (C) Copyright 1996,2005 Custom Computer Services           ////" & @CRLF _
& "//// This source code may only be used by licensed users of the CCS    ////" & @CRLF _
& "//// C compiler.  This source code may only be distributed to other    ////" & @CRLF _
& "//// licensed users of the CCS C compiler.  No other use,              ////" & @CRLF _
& "//// reproduction or distribution is permitted without written         ////" & @CRLF _
& "//// permission.  Derivative programs created using this software      ////" & @CRLF _
& "//// in object code form are not restricted in any way.                ////" & @CRLF _
& "///////////////////////////////////////////////////////////////////////////" & @CRLF & @CRLF _
& "#IFNDEF __USB_DESCRIPTORS__" & @CRLF _
& "#DEFINE __USB_DESCRIPTORS__" & @CRLF & @CRLF _
& "#include <usb.h>" & @CRLF & @CRLF
;'-------------------------
$sCadenon = $sCadenon & _
"//////////////////////////////////////////////////////////////////" & @CRLF _
& "///" & @CRLF _
& "///   start config descriptor" & @CRLF _
& "///   right now we only support one configuration descriptor." & @CRLF _
& "///   the config, interface, class, and endpoint goes into this array." & @CRLF _
& "///" & @CRLF _
& "//////////////////////////////////////////////////////////////////" & @CRLF & @CRLF _
& "   #DEFINE USB_TOTAL_CONFIG_LEN      32 //config+interface+class+endpoint" & @CRLF & @CRLF _
& "   //configuration descriptor" & @CRLF _
& "   char const USB_CONFIG_DESC[] = {" & @CRLF _
& "   //config_descriptor for config index 1" & @CRLF _
& "         USB_DESC_CONFIG_LEN,     //length of descriptor size" & @CRLF _
& "         USB_DESC_CONFIG_TYPE,         //constant CONFIGURATION (0x02)" & @CRLF _
& "         USB_TOTAL_CONFIG_LEN,0,  //size of all data returned for this config" & @CRLF _
& "         1,      //number of interfaces this device supports" & @CRLF _
& "         0x01,                //identifier for this configuration.  (IF we had more than one configurations)" & @CRLF _
& "         0x00,                //index of string descriptor for this configuration" & @CRLF _
& "         0xC0,                //bit 6=1 if self powered, bit 5=1 if supports remote wakeup (we don't), bits 0-4 reserved and bit7=1" & @CRLF _
& "         0x32,                //maximum bus power required (maximum milliamperes/2)  (0x32 = 100mA)" & @CRLF & @CRLF
;'-----------------------
$sCadenon = $sCadenon & _
"   //interface descriptor 0 alt 0" & @CRLF _
& "         USB_DESC_INTERFACE_LEN,  //length of descriptor" & @CRLF _
& "         USB_DESC_INTERFACE_TYPE,      //constant INTERFACE (0x04)" & @CRLF _
& "         0x00,                //number defining this interface (IF we had more than one interface)" & @CRLF _
& "         0x00,                //alternate setting" & @CRLF _
& "         2,       //number of endpoints, not counting endpoint 0." & @CRLF _
& "         0xFF,                //class code, FF = vendor defined" & @CRLF _
& "         0xFF,                //subclass code, FF = vendor" & @CRLF _
& "         0xFF,                //protocol code, FF = vendor" & @CRLF _
& "         0x00,                //index of string descriptor for interface" & @CRLF & @CRLF _
& "   //endpoint descriptor" & @CRLF _
& "         USB_DESC_ENDPOINT_LEN, //length of descriptor" & @CRLF _
& "         USB_DESC_ENDPOINT_TYPE,     //constant ENDPOINT (0x05)" & @CRLF _
& "         0x81,              //endpoint number and direction (0x81 = EP1 IN)" & @CRLF _
& "         0x02,              //transfer type supported (0 is control, 1 is iso, 2 is bulk, 3 is interrupt)" & @CRLF _
& "         USB_EP1_TX_SIZE & 0xFF,USB_EP1_TX_SIZE >> 8,         //maximum packet size supported" & @CRLF _
& "         0x01,              //polling interval in ms. (for interrupt transfers ONLY)" & @CRLF & @CRLF
;'---------------------
$sCadenon = $sCadenon & _
"   //endpoint descriptor" & @CRLF _
& "         USB_DESC_ENDPOINT_LEN, //length of descriptor" & @CRLF _
& "         USB_DESC_ENDPOINT_TYPE,     //constant ENDPOINT (0x05)" & @CRLF _
& "         0x01,              //endpoint number and direction (0x01 = EP1 OUT)" & @CRLF _
& "         0x02,              //transfer type supported (0 is control, 1 is iso, 2 is bulk, 3 is interrupt)" & @CRLF _
& "         USB_EP1_RX_SIZE & 0xFF,USB_EP1_RX_SIZE >> 8,         //maximum packet size supported" & @CRLF _
& "         0x01,              //polling interval in ms. (for interrupt transfers ONLY)" & @CRLF & @CRLF _
& "  };" & @CRLF & @CRLF _
& "   //****** BEGIN CONFIG DESCRIPTOR LOOKUP TABLES ********" & @CRLF _
& "   //since we can't make pointers to constants in certain pic16s, this is an offset table to find" & @CRLF _
& "   //  a specific descriptor in the above table." & @CRLF & @CRLF _
& "   //NOTE: DO TO A LIMITATION OF THE CCS CODE, ALL HID INTERFACES MUST START AT 0 AND BE SEQUENTIAL" & @CRLF _
& "   //      FOR EXAMPLE, IF YOU HAVE 2 HID INTERFACES THEY MUST BE INTERFACE 0 AND INTERFACE 1" & @CRLF _
& "   #define USB_NUM_HID_INTERFACES   0" & @CRLF & @CRLF _
& "   //the maximum number of interfaces seen on any config" & @CRLF _
& "   //for example, if config 1 has 1 interface and config 2 has 2 interfaces you must define this as 2" & @CRLF _
& "   #define USB_MAX_NUM_INTERFACES   1" & @CRLF & @CRLF _
& "   //define how many interfaces there are per config.  [0] is the first config, etc." & @CRLF _
& "   const char USB_NUM_INTERFACES[USB_NUM_CONFIGURATIONS]={1};" & @CRLF & @CRLF _
& "   #if (sizeof(USB_CONFIG_DESC) != USB_TOTAL_CONFIG_LEN)" & @CRLF _
& "      #error USB_TOTAL_CONFIG_LEN not defined correctly" & @CRLF _
& "   #endif" & @CRLF & @CRLF & @CRLF
;'---------------------------------------
$sCadenon = $sCadenon & _
"//////////////////////////////////////////////////////////////////" & @CRLF _
& "///" & @CRLF _
& "///   start device descriptors" & @CRLF _
& "///" & @CRLF _
& "//////////////////////////////////////////////////////////////////" & @CRLF & @CRLF _
& "   //device descriptor" & @CRLF _
& "   char const USB_DEVICE_DESC[] ={" & @CRLF _
& "         USB_DESC_DEVICE_LEN,          //the length of this report" & @CRLF _
& "         0x01,                //constant DEVICE (0x01)" & @CRLF _
& "         0x10,0x01,           //usb version in bcd" & @CRLF _
& "         0x00,                //class code (if 0, interface defines class.  FF is vendor defined)" & @CRLF _
& "         0x00,                //subclass code" & @CRLF _
& "         0x00,                //protocol code" & @CRLF _
& "         USB_MAX_EP0_PACKET_LENGTH,   //max packet size for endpoint 0. (SLOW SPEED SPECIFIES 8)" & @CRLF _
& "         0x" & StringRight($sVid, 2) & ",0x" & StringLeft($sVid, 2) & ",           //vendor id (0x04D8 is Microchip)" & @CRLF _
& "         0x" & StringRight($sPid, 2) & ",0x" & StringLeft($sPid, 2) & ",           //product id" & @CRLF _
& "         0x00,0x01,           //device release number" & @CRLF _
& "         0x01,                //index of string description of manufacturer. therefore we point to string_1 array (see below)" & @CRLF _
& "         0x02,                //index of string descriptor of the product" & @CRLF _
& "         0x00,                //index of string descriptor of serial number" & @CRLF _
& "         USB_NUM_CONFIGURATIONS   //number of possible configurations" & @CRLF _
& "   };" & @CRLF & @CRLF & @CRLF
;'-----------------------------
$sCadenon = $sCadenon & _
"//////////////////////////////////////////////////////////////////" & @CRLF _
& "///" & @CRLF _
& "///   start string descriptors" & @CRLF _
& "///   String 0 is a special language string, and must be defined.  People in U.S.A. can leave this alone." & @CRLF _
& "///" & @CRLF _
& "///   You must define the length else get_next_string_character() will not see the string" & @CRLF _
& "///   Current code only supports 10 strings (0 thru 9)" & @CRLF _
& "///" & @CRLF _
& "//////////////////////////////////////////////////////////////////" & @CRLF & @CRLF _
& "//the offset of the starting location of each string." & @CRLF _
& "//offset[0] is the start of string 0, offset[1] is the start of string 1, etc." & @CRLF _
& "const char USB_STRING_DESC_OFFSET[]={0,4,12};" & @CRLF & @CRLF _
& "#define USB_STRING_DESC_COUNT sizeof(USB_STRING_DESC_OFFSET)" & @CRLF & @CRLF
;'-----------------------
$sCadenon = $sCadenon & _
"char const USB_STRING_DESC[]={" & @CRLF _
& "   //string 0" & @CRLF _
& "         4, //length of string index" & @CRLF _
& "         USB_DESC_STRING_TYPE, //descriptor type 0x03 (STRING)" & @CRLF _
& "         0x09,0x04,   //Microsoft Defined for US-English" & @CRLF _
& "   //string 1" & @CRLF _
& "         8, //length of string index" & @CRLF _
& "         USB_DESC_STRING_TYPE, //descriptor type 0x03 (STRING)" & @CRLF _
& "         'C',0," & @CRLF _
& "         'C',0," & @CRLF _
& "         'S',0," & @CRLF _
& "   //string 2" & @CRLF
$sCadenon = $sCadenon & sSeparar_stringX($sNombre_dispositivo) & @CRLF _
& "};" & @CRLF & @CRLF & @CRLF _
& "#ENDIF"

Return $sCadenon
EndFunc


