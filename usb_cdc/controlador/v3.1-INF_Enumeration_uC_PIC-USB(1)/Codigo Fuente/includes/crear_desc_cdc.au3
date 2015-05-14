#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Func sCrear_usb_desc_cdc($sNombre_dispositivo,$sVid,$sPid)

Local $sCadenon

$sCadenon = _
"///////////////////////////////////////////////////////////////////////////" & @CRLF _
& "////                         usb_desc_cdc.h                            ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// An example set of device / configuration descriptors for use with ////" & @CRLF _
& "//// CCS's CDC Virtual COM Port driver (see usb_cdc.h)                 ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// Two examples are provided:                                        ////" & @CRLF _
& "////      ex_usb_serial.c                                              ////" & @CRLF _
& "////      ex_usb_serial2.c                                             ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "///////////////////////////////////////////////////////////////////////////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// Version History:                                                  ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "//// 10/28/05:                                                         ////" & @CRLF _
& "////    Bulk endpoint sizes updated to allow more than 255 byte        ////" & @CRLF _
& "////    packets.                                                       ////" & @CRLF _
& "////    Changed device to USB 1.10                                     ////" & @CRLF _
& "////                                                                   ////" & @CRLF _
& "///////////////////////////////////////////////////////////////////////////" & @CRLF _
& "////        (C) Copyright 1996,2005 Custom Computer Services           ////" & @CRLF _
& "//// This source code may only be used by licensed users of the CCS    ////" & @CRLF
;'--------------------
$sCadenon = $sCadenon _
& "//// C compiler.  This source code may only be distributed to other    ////" & @CRLF _
& "//// licensed users of the CCS C compiler.  No other use,              ////" & @CRLF _
& "//// reproduction or distribution is permitted without written         ////" & @CRLF _
& "//// permission.  Derivative programs created using this software      ////" & @CRLF _
& "//// in object code form are not restricted in any way.                ////" & @CRLF _
& "///////////////////////////////////////////////////////////////////////////" & @CRLF & @CRLF _
& "#IFNDEF __USB_DESCRIPTORS__" & @CRLF _
& "#DEFINE __USB_DESCRIPTORS__" & @CRLF & @CRLF _
& "#include <usb.h>" & @CRLF & @CRLF & @CRLF _
& "//////////////////////////////////////////////////////////////////" & @CRLF _
& "///" & @CRLF _
& "///   start config descriptor" & @CRLF _
& "///   right now we only support one configuration descriptor." & @CRLF _
& "///   the config, interface, class, and endpoint goes into this array." & @CRLF _
& "///" & @CRLF _
& "//////////////////////////////////////////////////////////////////" & @CRLF & @CRLF _
& "   #DEFINE USB_TOTAL_CONFIG_LEN      67  //config+interface+class+endpoint+endpoint (2 endpoints)" & @CRLF & @CRLF _
& "   const char USB_CONFIG_DESC[] = {" & @CRLF _
& "   //IN ORDER TO COMPLY WITH WINDOWS HOSTS, THE ORDER OF THIS ARRAY MUST BE:" & @CRLF _
& "      //    config(s)" & @CRLF _
& "      //    interface(s)" & @CRLF _
& "      //    class(es)" & @CRLF _
& "      //    endpoint(s)" & @CRLF & @CRLF
;'--------------------
$sCadenon = $sCadenon _
& "   //config_descriptor for config index 1" & @CRLF _
& "         USB_DESC_CONFIG_LEN, //length of descriptor size          ==0" & @CRLF _
& "         USB_DESC_CONFIG_TYPE, //constant CONFIGURATION (CONFIGURATION 0x02)     ==1" & @CRLF _
& "         USB_TOTAL_CONFIG_LEN,0, //size of all data returned for this config      ==2,3" & @CRLF _
& "         2, //number of interfaces this device supports       ==4" & @CRLF _
& "         0x01, //identifier for this configuration.  (IF we had more than one configurations)      ==5" & @CRLF _
& "         0x00, //index of string descriptor for this configuration      ==6" & @CRLF _
& "         0xC0, //bit 6=1 if self powered, bit 5=1 if supports remote wakeup (we don't), bits 0-4 unused and bit7=1         ==7" & @CRLF _
& "         0x32, //maximum bus power required (maximum milliamperes/2)  (0x32 = 100mA)  ==8" & @CRLF & @CRLF _
& "   //interface descriptor 0 (comm class interface)" & @CRLF _
& "         USB_DESC_INTERFACE_LEN, //length of descriptor      =9" & @CRLF _
& "         USB_DESC_INTERFACE_TYPE, //constant INTERFACE (INTERFACE 0x04)       =10" & @CRLF _
& "         0x00, //number defining this interface (IF we had more than one interface)    ==11" & @CRLF _
& "         0x00, //alternate setting     ==12" & @CRLF _
& "         1, //number of endpoints   ==13" & @CRLF _
& "         0x02, //class code, 02 = Comm Interface Class     ==14" & @CRLF _
& "         0x02, //subclass code, 2 = Abstract     ==15" & @CRLF _
& "         0x01, //protocol code, 1 = v.25ter      ==16" & @CRLF _
& "         0x00, //index of string descriptor for interface      ==17" & @CRLF & @CRLF
;'--------------------
$sCadenon = $sCadenon _
& "   //class descriptor [functional header]" & @CRLF _
& "         5, //length of descriptor    ==18" & @CRLF _
& "         0x24, //dscriptor type (0x24 == )      ==19" & @CRLF _
& "         0, //sub type (0=functional header) ==20" & @CRLF _
& "         0x10,0x01, //      ==21,22 //cdc version" & @CRLF & @CRLF _
& "   //class descriptor [acm header]" & @CRLF _
& "         4, //length of descriptor    ==23" & @CRLF _
& "         0x24, //dscriptor type (0x24 == )      ==24" & @CRLF _
& "         2, //sub type (2=ACM)   ==25" & @CRLF _
& "         2, //capabilities    ==26  //we support Set_Line_Coding, Set_Control_Line_State, Get_Line_Coding, and the notification Serial_State." & @CRLF & @CRLF _
& "   //class descriptor [union header]" & @CRLF _
& "         5, //length of descriptor    ==27" & @CRLF _
& "         0x24, //dscriptor type (0x24 == )      ==28" & @CRLF _
& "         6, //sub type (6=union)    ==29" & @CRLF _
& "         0, //master intf     ==30  //The interface number of the Communication or Dat a Cl ass interface, designated as the masteror controlling interface for the union." & @CRLF _
& "         1, //save intf0      ==31  //Interface number of first slave or associated interface in the union. *" & @CRLF & @CRLF _
& "   //class descriptor [call mgmt header]" & @CRLF _
& "         5, //length of descriptor    ==32" & @CRLF _
& "         0x24, //dscriptor type (0x24 == )      ==33" & @CRLF _
& "         1, //sub type (1=call mgmt)   ==34" & @CRLF _
& "         0, //capabilities          ==35  //device does not handle call management itself" & @CRLF _
& "         1, //data interface        ==36  //interface number of data class interface" & @CRLF & @CRLF
;'--------------------
$sCadenon = $sCadenon _
& "   //endpoint descriptor" & @CRLF _
& "         USB_DESC_ENDPOINT_LEN, //length of descriptor                   ==37" & @CRLF _
& "         USB_DESC_ENDPOINT_TYPE, //constant ENDPOINT (ENDPOINT 0x05)          ==38" & @CRLF _
& "         USB_CDC_COMM_IN_ENDPOINT | 0x80, //endpoint number and direction" & @CRLF _
& "         0x03, //transfer type supported (0x03 is interrupt)         ==40" & @CRLF _
& "         USB_CDC_COMM_IN_SIZE,0x00, //maximum packet size supported                  ==41,42" & @CRLF _
& "         250,  //polling interval, in ms.  (cant be smaller than 10)      ==43" & @CRLF & @CRLF _
& "   //interface descriptor 1 (data class interface)" & @CRLF _
& "         USB_DESC_INTERFACE_LEN, //length of descriptor      =44" & @CRLF _
& "         USB_DESC_INTERFACE_TYPE, //constant INTERFACE (INTERFACE 0x04)       =45" & @CRLF _
& "         0x01, //number defining this interface (IF we had more than one interface)    ==46" & @CRLF _
& "         0x00, //alternate setting     ==47" & @CRLF _
& "         2, //number of endpoints   ==48" & @CRLF _
& "         0x0A, //class code, 0A = Data Interface Class     ==49" & @CRLF _
& "         0x00, //subclass code      ==50" & @CRLF _
& "         0x00, //protocol code      ==51" & @CRLF _
& "         0x00, //index of string descriptor for interface      ==52" & @CRLF & @CRLF
;'--------------------
$sCadenon = $sCadenon _
& "   //endpoint descriptor" & @CRLF _
& "         USB_DESC_ENDPOINT_LEN, //length of descriptor                   ==60" & @CRLF _
& "         USB_DESC_ENDPOINT_TYPE, //constant ENDPOINT (ENDPOINT 0x05)          ==61" & @CRLF _
& "         USB_CDC_DATA_OUT_ENDPOINT, //endpoint number and direction (0x02 = EP2 OUT)       ==62" & @CRLF _
& "         0x02, //transfer type supported (0x02 is bulk)         ==63" & @CRLF _
& "//         make8(USB_CDC_DATA_OUT_SIZE,0),make8(USB_CDC_DATA_OUT_SIZE,1), //maximum packet size supported                  ==64, 65" & @CRLF _
& "         USB_CDC_DATA_OUT_SIZE & 0xFF, (USB_CDC_DATA_OUT_SIZE >> 8) & 0xFF, //maximum packet size supported                  ==64, 65" & @CRLF _
& "         250,  //polling interval, in ms.  (cant be smaller than 10)      ==66" & @CRLF & @CRLF _
& "   //endpoint descriptor" & @CRLF _
& "         USB_DESC_ENDPOINT_LEN, //length of descriptor                   ==53" & @CRLF _
& "         USB_DESC_ENDPOINT_TYPE, //constant ENDPOINT (ENDPOINT 0x05)          ==54" & @CRLF _
& "         USB_CDC_DATA_IN_ENDPOINT | 0x80, //endpoint number and direction (0x82 = EP2 IN)       ==55" & @CRLF _
& "         0x02, //transfer type supported (0x02 is bulk)         ==56" & @CRLF _
& "//         make8(USB_CDC_DATA_IN_SIZE,0),make8(USB_CDC_DATA_IN_SIZE,1), //maximum packet size supported                  ==57, 58" & @CRLF _
& "         USB_CDC_DATA_IN_SIZE & 0xFF, (USB_CDC_DATA_IN_SIZE >> 8) & 0xFF, //maximum packet size supported                  ==64, 65" & @CRLF _
& "         250,  //polling interval, in ms.  (cant be smaller than 10)      ==59" & @CRLF _
& "   };" & @CRLF & @CRLF _
& "   //****** BEGIN CONFIG DESCRIPTOR LOOKUP TABLES ********" & @CRLF _
& "   //since we can't make pointers to constants in certain pic16s, this is an offset table to find" & @CRLF _
& "   //  a specific descriptor in the above table." & @CRLF & @CRLF _
& "   //the maximum number of interfaces seen on any config" & @CRLF _
& "   //for example, if config 1 has 1 interface and config 2 has 2 interfaces you must define this as 2" & @CRLF _
& "   #define USB_MAX_NUM_INTERFACES   2" & @CRLF & @CRLF
;'--------------------
$sCadenon = $sCadenon _
& "   //define how many interfaces there are per config.  [0] is the first config, etc." & @CRLF _
& "   const char USB_NUM_INTERFACES[USB_NUM_CONFIGURATIONS]={2};" & @CRLF & @CRLF _
& "   //define where to find class descriptors" & @CRLF _
& "   //first dimension is the config number" & @CRLF _
& "   //second dimension specifies which interface" & @CRLF _
& "   //last dimension specifies which class in this interface to get, but most will only have 1 class per interface" & @CRLF _
& "   //if a class descriptor is not valid, set the value to 0xFFFF" & @CRLF _
& "   const int16 USB_CLASS_DESCRIPTORS[USB_NUM_CONFIGURATIONS][USB_MAX_NUM_INTERFACES][4]=" & @CRLF _
& "   {" & @CRLF _
& "   //config 1" & @CRLF _
& "      //interface 0" & @CRLF _
& "         //class 1-4" & @CRLF _
& "         18,23,27,32," & @CRLF _
& "      //interface 1" & @CRLF _
& "         //no classes for this interface" & @CRLF _
& "         0xFFFF,0xFFFF,0xFFFF,0xFFFF" & @CRLF _
& "   };" & @CRLF & @CRLF _
& "   #if (sizeof(USB_CONFIG_DESC) != USB_TOTAL_CONFIG_LEN)" & @CRLF _
& "      #error USB_TOTAL_CONFIG_LEN not defined correctly" & @CRLF _
& "   #endif" & @CRLF & @CRLF & @CRLF
;'--------------------
$sCadenon = $sCadenon _
& "//////////////////////////////////////////////////////////////////" & @CRLF _
& "///" & @CRLF _
& "///   start device descriptors" & @CRLF _
& "///" & @CRLF _
& "//////////////////////////////////////////////////////////////////" & @CRLF & @CRLF _
& "   const char USB_DEVICE_DESC[USB_DESC_DEVICE_LEN] ={" & @CRLF _
& "      //starts of with device configuration. only one possible" & @CRLF _
& "         USB_DESC_DEVICE_LEN, //the length of this report   ==0" & @CRLF _
& "         0x01, //the constant DEVICE (DEVICE 0x01)  ==1" & @CRLF _
& "         0x10,0x01, //usb version in bcd  ==2,3" & @CRLF _
& "         0x02, //class code. 0x02=Communication Device Class ==4" & @CRLF _
& "         0x00, //subclass code ==5" & @CRLF _
& "         0x00, //protocol code ==6" & @CRLF _
& "         USB_MAX_EP0_PACKET_LENGTH, //max packet size for endpoint 0. (SLOW SPEED SPECIFIES 8) ==7" & @CRLF _
& "         0x" & StringRight($sVid, 2) & ",0x" & StringLeft($sVid, 2) & ", //vendor id (0x04D8 is Microchip, or is it 0x0461 ??)  ==8,9" & @CRLF _
& "         0x" & StringRight($sPid, 2) & ",0x" & StringLeft($sPid, 2) & ", //product id   ==10,11" & @CRLF _
& "         0x00,0x01, //device release number  ==12,13" & @CRLF _
& "         0x01, //index of string description of manufacturer. therefore we point to string_1 array (see below)  ==14" & @CRLF _
& "         0x02, //index of string descriptor of the product  ==15" & @CRLF _
& "         0x00, //index of string descriptor of serial number  ==16" & @CRLF _
& "         USB_NUM_CONFIGURATIONS  //number of possible configurations  ==17" & @CRLF _
& "   };" & @CRLF & @CRLF & @CRLF
;'--------------------
$sCadenon = $sCadenon _
& "//////////////////////////////////////////////////////////////////" & @CRLF _
& "///" & @CRLF _
& "///   start string descriptors" & @CRLF _
& "///   String 0 is a special language string, and must be defined.  People in U.S.A. can leave this alone." & @CRLF _
& "///" & @CRLF _
& "///   You must define the length else get_next_string_character() will not see the string" & @CRLF _
& "///   Current code only supports 10 strings (0 thru 9)" & @CRLF _
& "///" & @CRLF _
& "//////////////////////////////////////////////////////////////////" & @CRLF & @CRLF _
& "//the offset of the starting location of each string.  offset[0] is the start of string 0, offset[1] is the start of string 1, etc." & @CRLF _
& "char USB_STRING_DESC_OFFSET[]={0,4,12};" & @CRLF & @CRLF
;'--------------------
$sCadenon = $sCadenon _
& "char const USB_STRING_DESC[]={" & @CRLF _
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
& "};" & @CRLF & @CRLF _
& "#ENDIF"

Return $sCadenon
EndFunc



