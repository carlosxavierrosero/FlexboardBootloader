#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
"""
Created on Tue May 13 13:05:56 2014

@author: carlos xavier rosero
         manel velasco garcía

python 2.7
"""

import sys

sys.path[0:0] = ['.', '..']

from elftools.elf.elffile import ELFFile
from progressbar import AnimatedMarker, Bar, BouncingBar, Counter, ETA, \
                        FileTransferSpeed, FormatLabel, Percentage, \
                        ProgressBar, ReverseBar, RotatingMarker, \
                        SimpleProgress, Timer

import binascii
import time
import serial
import os
import getopt


#COMMANDS
#global constants and definitions
class command:
    nack = 0x00
    ack = 0x01
    readPM = 0x02 #read program memory
    writePM = 0x03
    readEM = 0x04 #read eeprom memory
    writeEM = 0x05
    readCM = 0x06
    writeCM = 0x07
    runProg = 0x08
    readID = 0x09 #read device ID
    erasePM = 0x0a

#buffer size: 4096        
count = 0
Buffer = []
RowSize = 64*8
welcome = "DISTRIBUTED CONTROL SYSTEMS LAB. - UPC\r\nEvidence Flex Board - Bootloader Application - Version 1.0, October 2014\r\nDeveloped by CARLOS XAVIER ROSERO & MANEL VELASCO GARCIA\r\n"
usbPort = ''
fileAddr = ''

# 128k flash for the dsPIC33FJ256MC710
flashsize = 175104 * 2 #175104-->0x2ac00 (*2 'cause each location has only 1 byte instead of 2)


def helpMessage(typ):
    
    if typ == 0: #call from user interface      

        print '\r\n  help        Shows this menu' 
        print '  reset       Causes a hard reset and establishes connection to bootloader'
        print '  clear       Clears console screen'
        print '  run         Executes program loaded by user'
        print '  fileaddr    [r] Shows current assigned .elf or .hex to be programmed\r\n              [w] [filename] Sets a new target file'        
        print '  usbscan     Searches for available USB ports ' 
        print '  usbport     [r] Shows current assigned USB target\r\n              [w] [portname] Sets a new USB target'
        print '  erase       [a] Erases whole target flash memory\r\n              [0xXXXX] Erases only from 0xXXXX memory address (0x400 step length)'
        print '  program     [a] Programs whole target flash memory\r\n              [0xXXXX] Programs only from 0xXXXX memory address (0x400 step length)'
        print '  read        [a] Reads target flash memory\r\n              [0xXXXX] Reads 0xXXXX page (0x400 step length)'
        print '  exit        Exits the bootloader program\r\n'

    elif typ == 1: #call from console

        print '\r\nCOMMANDS AND EXTENSIONS\r\n'

        print '  -h       Shows this menu' 
        print '  -s       Causes a hard reset and establishes connection to bootloader'
        print '  -r       Executes program loaded by user'
        print '  -x       [r] Shows current assigned .elf or .hex to be programmed\r\n           [w][filename] Sets a new target file'        
        print '  -u       Searches for available USB ports ' 
        print '  -t       [r] Shows current assigned USB target\r\n           [w][portname] Sets a new USB target'
        print '  -e       [a] Erases whole target flash memory\r\n           [0xXXXX] Erases only from 0xXXXX memory address (0x400 step length)'
        print '  -p       [a] Programs whole target flash memory\r\n           [0xXXXX] Programs only from 0xXXXX memory address (0x400 step length)'
        print '  -d       [a] Reads target flash memory\r\n           [0xXXXX] Reads 0xXXXX page (0x400 step length)\r\n'


def asc2hex(value):
    
    if value >= 0x30 and value <= 0x39: #'0' to '9'
        return value - 0x30
    elif value >= 0x41 and value <= 0x46: #'A' to 'F'
        return value - 0x37
    elif value >= 0x61 and value <= 0x66: #'a' to 'f'
        return value - 0x57
    else:
        return 0x00


def changeUSB(portAddress, typ):
     
    global usbPort, fileAddr
    
    n = 1
    if typ == 0: #call from user interface      
        n = 2   
     
    portAddress = portAddress[n:len(portAddress)] #removes "w " part
    
    defaultConfig = open('configSerialBoot.config', 'w') #replaces existing file  
    defaultConfig.write(portAddress + '\n') #updates portAddress
    defaultConfig.write(fileAddr + '\n') #preserves previous hex or elf file address
    defaultConfig.close()
    usbPort = portAddress #updates portAddress in ram register
    print '\r\nNew USB port entered: ',
    print '"' + usbPort + '"' + '\r\n'


def scanUSB(): #scan for available ports. return a list of tuples (num, name)

    available = []
    
    ports=('/dev/ttyACM', '/dev/ttyUSB', '/dev/ttyS')
    
    for j in range(3):
        for i in range(256):
            try:
            
                s = serial.Serial(ports[j] + '%d' %i)
                available.append((i, s.portstr))
                s.close()   # explicit close 'cause of delayed GC in java
            except serial.SerialException:
                pass

    if len(available) != 0:
        print "\r\nDevices found at:"
        for n,s in available:
            print "[%d]  %s" %(n,s)
    else:
        print "\r\nNo device attached has been found!"
                        
    print ""


def changeAddress(address,typ):

    global usbPort, fileAddr
    
    n = 1
    if typ == 0: #call from user interface      
        n = 2   

    address = address[n:len(address)] #removes "w " part

    if (address[len(address)-3] == 'e' and address[len(address)-2] == 'l' and
        address[len(address)-1] == 'f') or (address[len(address)-3] == 'h' and
        address[len(address)-2] == 'e' and address[len(address)-1] == 'x'):    
    
        defaultConfig = open('configSerialBoot.config', 'w') #replaces existing file  
        defaultConfig.write(usbPort + '\n') #preserves previous port
        defaultConfig.write(address + '\n') #updates hex file address
        defaultConfig.close()
        fileAddr = address #updates address in ram register   
        print '\r\nNew %s file address entered: ' %(fileAddr[len(address)-3]+
               fileAddr[len(address)-2]+fileAddr[len(address)-1]),
        print '"' + fileAddr + '"' + '\r\n'
    else:
        print '\r\nFile extension not accepted!\r\n'        


def loadConfig():
    
    global usbPort, fileAddr

    defaultConfig = open('configSerialBoot.config', 'r')

    usbPort = defaultConfig.readline()
    usbPort = usbPort[:-1] #removes last character
    
    fileAddr = defaultConfig.readline() 
    fileAddr = fileAddr[:-1] #removes last character
    
    defaultConfig.close()


def openPort(): #opens serial port

    ser = serial.Serial(port=usbPort,
                        baudrate=115200, parity=serial.PARITY_NONE,
                        stopbits=serial.STOPBITS_ONE)
    ser.open
    ser.isOpen    
    return ser


def closePort(ser): #closes serial port

    ser.close()


def searchCommand(inpt): #separates command and argument   

    spaceFound = False
    i = 0
    endCommand = 0
    sizeSpace = 0
    userCommand = ''
    userArgument = ''

    for i in range (0, len(inpt)):
        if spaceFound == False:
            if inpt[i] == ' ': #search space to isolate command from argument
                spaceFound = True #first space has been found
                endCommand = i
                sizeSpace = 1 #so far, one space
            else:
                endCommand=i+1
        else:
            if inpt[i] == ' ': #check more spaces
                sizeSpace = sizeSpace + 1
            else:
                break #spaces finished, starts argument

    userCommand = inpt[0:endCommand]
    if spaceFound == True:
        if len(inpt) > (endCommand+sizeSpace):
            userArgument = inpt[endCommand+sizeSpace : len(inpt)]
            succ = True
        else:
            succ = False
    else:
        succ = False
    return [succ, userCommand, userArgument]


def resetSys(): 

    print "\r\nResetting hardware...  ",
    ser = openPort()    
    Buffer = bytearray(['*','C','x','R','c'])                
    ser.write(Buffer)
    time.sleep(0.2)
        
    inputS = [] #initializes buffer    
    while ser.inWaiting() > 0: #neglects the trash code received
         inputS.append(ser.read(1)) #appends a new value into the buffer
    
    print "Done"

    print "\r\nSearching for a compatible device..."
    ser.write(bytearray([command.readID]))       
    time.sleep(0.2)
    
    inputS = [] #initializes buffer
    while ser.inWaiting() > 0:                 
        receive = hex(ord(ser.read(1))) #from received data to ascii hex representation
        data = int(receive, 16) #from ascii hex representation to number        
        inputS.append(data) #appends a new value into the buffer

    if inputS != '' and len(inputS) == 8:
        procId = hex((inputS[1] << 8) | inputS[0])
        devId = hex((inputS[5] << 8) | inputS[4])
            
        if procId == '0xbf' and devId == '0x3040':
            print "Evidence Flex Board has been detected - Processor ID", procId, "- Device ID", devId
            print ""
        else:
            print "No compatible device has been detected!\r\n"   
    else:
        print "No compatible device has been detected!\r\n"   
    closePort(ser)


def runProg():

    print "\r\nStarting program...  ",
    ser = openPort()    
    Buffer = bytearray([command.runProg])
    ser.write(Buffer)  #sends reset command    
    time.sleep(0.1)         

    inputS = [] #initialize buffer        
    while ser.inWaiting() > 0:         
        inputS.append(ser.read(1)) #appends a new value into the buffer

    closePort(ser)
    
    if len(inputS) != 0: #avoids empty buffer   
    # no problem with what value comes
        print "Done"
    else:
        print "Program running, try using at first the reset command!"
    print ""


def readProgramMemory(readAddress,typ):
    
    ser = openPort()
    
    if typ == 1:
        print "\r\nEntered address: 0x%06x" %readAddress
    readAddress = readAddress - (readAddress % (RowSize * 2))
    
    if typ == 1:    
        print "Reading program memory at address 0x%06x..." %readAddress

    Buffer = bytearray([command.readPM, readAddress & 0xff,
             (readAddress >> 8) & 0xff, (readAddress >> 16) & 0xff])                
    ser.write(Buffer)        
    time.sleep(0.5)        

    inputS = [] #initialize buffer        
    while ser.inWaiting() > 0:         
        receive = hex(ord(ser.read(1))) #from received data to ascii hex representation
        data = int(receive, 16) #from ascii hex representation to number        
        inputS.append(data) #appends a new value into the buffer
    closePort(ser)

    retValue = 0
    
    if typ == 1:            
        print "%d bytes from memory locations have been received\r\n" % len(inputS)
        
        for i in range(0, (len(inputS)), 24):

            print "%06x: %02x%02x%02x %02x%02x%02x %02x%02x%02x %02x%02x%02x" %(
                    readAddress, inputS[i], inputS[i+1], inputS[i+2], inputS[i+3],
                    inputS[i+4], inputS[i+5], inputS[i+6], inputS[i+7], inputS[i+8],
                    inputS[i+9], inputS[i+10], inputS[i+11]),

            print "%02x%02x%02x %02x%02x%02x %02x%02x%02x %02x%02x%02x" %(
                    inputS[i+12], inputS[i+13], inputS[i+14], inputS[i+15],
                    inputS[i+16], inputS[i+17], inputS[i+18], inputS[i+19],
                    inputS[i+20], inputS[i+21], inputS[i+22], inputS[i+23])
            readAddress = readAddress + 16
            
        print ""
    
    elif typ == 0:
        retValue = inputS
    
    return retValue


def eraseProgramMemory(eraseAddress,allMem): #erases program memory (without bootloader part)

    if allMem == 0: 

        print "\r\nEntered address: 0x%06x" %eraseAddress
        eraseAddress = eraseAddress - (eraseAddress % (RowSize * 2))
            
        print "Clearing program memory from 0x%06x to 0x%06x...  " %(eraseAddress,eraseAddress+0x3ff),

        Buffer = bytearray([command.erasePM, eraseAddress & 0xFF,
                            (eraseAddress >> 8) & 0xFF, (eraseAddress >> 16) & 0xFF])
        ser = openPort()                
        ser.write(Buffer)        
        time.sleep(0.2)
        
        inputS = [] #initialize buffer        
        while ser.inWaiting() > 0:               
            inputS.append(ser.read(1)) #appends a new value into the buffer

        closePort(ser)
      
        if len(inputS) != 0: #avoids empty buffer    
            if inputS[0] == '\x01':
                print "Done"
            else:
                print "Error, trying to access a forbidden memory page!"
        else:
            print "Error, has not been detected any incoming message!"

    elif allMem == 1:

        print "\r\nClearing all program memory locations, please wait...  "

        pbar = ProgressBar(widgets=['Progress ', Percentage(),
                                    ' - ', Timer()], maxval=170).start()

        ser = openPort()
        
        flagError = 0
        
        for page in range (0, 171):
            
            pbar.update(page) #updates progressbar state
            
            if page == 1 or page == 2: #avoids to access to bootloader locations
                pass
            else:
                eraseAddress = page * 0x400
                Buffer = bytearray([command.erasePM, eraseAddress & 0xff,
                            (eraseAddress >> 8) & 0xff, (eraseAddress >> 16) & 0xff])                        
                ser.write(Buffer)
                time.sleep(0.2)
        
                inputS = [] #initialize buffer        
                while ser.inWaiting() > 0:               
                    inputS.append(ser.read(1)) #appends a new value into the buffer

                if len(inputS) != 0: #avoids empty buffer    
                    if inputS[0] == '\x01':
                        pass
                    else:
                        flagError = 1
                        break
                else:
                    flagError = 2
                    break               
        
        closePort(ser)
        pbar.finish()
        
        if flagError == 0: #no error
            print "Process has been completed successfully!"
        elif flagError == 1: #writing error
            print "Error at page from 0x%06x!" %eraseAddress
        elif flagError == 2:
            print "No response!"
            
    print "" 


def sendData(progMemory, progAddress, allMem):
    
    if allMem == 0: #will program only the desired page

        print "\r\nEntered address: 0x%06x" %progAddress
        progAddress = progAddress - (progAddress % (RowSize * 2))
            
        print "Programming memory from 0x%06x to 0x%06x...  " %(
                progAddress,progAddress+0x3ff),
      
        page = progAddress / 0x400
        
        #here, check if this page is empty
        
        blank = 1       
        for i in range(0, RowSize*2):
            if progMemory[page][i] != 0xffff:
                blank = 0
        
        ser = openPort()
      
        if blank == 1: #empty page
            Buffer = bytearray([command.erasePM, progAddress & 0xff,
                              (progAddress >> 8) & 0xff, (progAddress >> 16) & 0xff])        
       
        elif blank == 0: #filled page
            Buffer = bytearray([command.writePM, progAddress & 0xff,
                            (progAddress >> 8) & 0xff, (progAddress >> 16) & 0xff])        
                      
            ser.write(Buffer) #sends address             
            
            Buffer = bytearray([])             
            
            for i in range(0, RowSize*2,2): #total ammount of data: 1536 bytes
            #only 3 bytes per location, 4th is always 0 
                Buffer.append((progMemory[page][i] >> 8) & 0xff)   
                Buffer.append(progMemory[page][i] & 0xff)     
                Buffer.append((progMemory[page][i+1] >> 8) & 0xff)                 

        ser.write(Buffer)        
        time.sleep(0.2)
        
        inputS = [] #initialize buffer        
        while ser.inWaiting() > 0:               
            inputS.append(ser.read(1)) #appends a new value into the buffer

        closePort(ser)
      
        if len(inputS) != 0: #avoids empty buffer    
            if inputS[0] == '\x01':
                print "Done"
            else:
                print "Error, trying to access a forbidden memory page!"
        else:
            print "Error, has not been detected any incoming message!"

    elif allMem == 1: #will program all memory pages

        print "\r\nProgramming all memory locations, please wait...  "

        pbar = ProgressBar(widgets=['Progress ', Percentage(),
                                    ' - ', Timer()], maxval=170).start()

        ser = openPort()
        
        flagError = 0
        
        for page in range (0,171):        

            pbar.update(page) #updates progressbar state
            
            if page == 1 or page == 2: #avoids the access to bootloader locations
                pass                
                #print "Bootloader at page %02d, skipped!" %page                   
            else:
                progAddress = page * 0x400

                blank = 1       
                for i in range(0, RowSize*2):
                    if progMemory[page][i] != 0xffff:
                        blank = 0
                
                ser = openPort()
              
                if blank == 1: #empty page
                    #print "Erasing page %03d of 170, from 0x%06x to 0x%06x...  " %(
                    #      page, (page*0x400), (page*0x400)+0x3ff),                   
                    Buffer = bytearray([command.erasePM, progAddress & 0xff,
                                       (progAddress >> 8) & 0xff,
                                       (progAddress >> 16) & 0xff])        
               
                elif blank == 0: #filled page
                    #print "Programming page %03d of 170, from 0x%06x to 0x%06x...  " %(
                    #      page, (page*0x400), (page*0x400)+0x3ff),
                    Buffer = bytearray([command.writePM, progAddress & 0xff,
                                       (progAddress >> 8) & 0xff,
                                       (progAddress >> 16) & 0xff])        
                              
                    ser.write(Buffer) #sends address             
                    
                    Buffer = bytearray([])             
                    
                    for i in range(0, RowSize*2,2): #total ammount of data: 1536 bytes
                    #only 3 bytes per location, 4th is always 0 
                        Buffer.append((progMemory[page][i] >> 8) & 0xff)   
                        Buffer.append(progMemory[page][i] & 0xff)     
                        Buffer.append((progMemory[page][i+1] >> 8) & 0xff)                

                ser.write(Buffer) #sends data           
                time.sleep(0.2)
        
                inputS = [] #initialize buffer        
                while ser.inWaiting() > 0:               
                    inputS.append(ser.read(1)) #appends a new value into the buffer

                if len(inputS) != 0: #avoids empty buffer    
                    if inputS[0] == '\x01':
                        pass
                    else:
                        flagError = 1
                        break
                else:
                    flagError = 2
                    break         
                
        closePort(ser)
        pbar.finish()        
        
        if flagError == 0: #no error
            print "Process has been completed successfully!"
        elif flagError == 1: #writing error
            print "Error at page from 0x%06x!" %progAddress
        elif flagError == 2:
            print "No response!"

    print ""     

        
def sendElfFile(progAddress, allMem): #takes information from elf file and send through USB

    print "\r\nReading data from ELF file",fileAddr   

    with open(fileAddr, 'r') as f:
        
        # get the data
        elffile = ELFFile(f)
        
        print  '\r\nSECTIONS FOUND IN FILE:\r\n'
        
        #prints all the sections found        
        for s in elffile.iter_sections():
            print "[%d]  %s  %s  start addr:0x%06x  size:%d  offs:%d" %(
                    s.header['sh_name'], s.name, s.header['sh_type'],
                    s.header['sh_addr'], s.header['sh_size'],
                    s.header['sh_offset'])
        print ""

        # prepares the memory
        #flashMemory = bytearray(flashsize)
        flashMemory = bytearray([])
        
        #fills the bytearray with 0xff
        for i in range(0, flashsize):
            flashMemory.append(0xff)
      
        for s in elffile.iter_sections():         
            if (s.header['sh_type'] == 'SHT_PROGBITS' and  s.header['sh_addr'] < 0xf80000):
                addr = s.header['sh_addr']
                
                if s.name == '.const':
                    addr = addr - 0x8000 #eliminates an error, I don't know why
                    
                size = s.header['sh_size']
                val = s.data()               
                print '%s section from 0x%06x to 0x%06x appended to file' %(s.name, addr, (addr - 1 + size/2))

                flashMemory[addr*2 : addr*2 + size] = val
  
        #creates an array with proper format
        progMemory = [[0xffff for x in xrange(RowSize*2)] for x in xrange(171)] #171 #512*2*171=175104-->0x2ac00

        for i in xrange(0, 171):
            a = i * 0x400 * 2
            for j in xrange (0, RowSize*2):
                progMemory[i][j] = (flashMemory[a + j*2] << 8) | flashMemory[a + j*2 + 1]

        #sends data
        sendData(progMemory, progAddress, allMem)


def sendHexFile(progAddress, allMem): #takes ascii information from hex file and translates to numerical one

    print "\r\nReading data from HEX file...",fileAddr            
    
    file = open(fileAddr, 'r')
        
    fileRaw = file.read() #takes information from file
    
    file.close() #closes opened file
    
    fileRawHex = []
    for i in range(0, len(fileRaw)):
        data = hex(ord(fileRaw[i])) #from received data to ascii hex representation
        fileRawHex.append(int(data, 16)) #from ascii hex representation to number   
        
    countLF = 0
    for i in range(0, len(fileRawHex)): #counts number of lines into the hex file
        if fileRawHex[i] == 0x0a:
            countLF = countLF + 1
        
    mat = [[] for x in range(countLF)] #creates countLF times an empty array
        
    #here, takes in order, the information from .hex file        
    addr = 1        
    for i in range(0, countLF): #fills each array with lines from hex file
        acc1 = (asc2hex(fileRawHex[addr]) << 4) | asc2hex(fileRawHex[addr + 1])           
        mat[i].append(acc1) #number of data bytes (element 0 of mat[i])          
        acc1 = (asc2hex(fileRawHex[addr + 2]) << 4) | asc2hex(fileRawHex[addr + 3])
        acc2 = (asc2hex(fileRawHex[addr + 4]) << 4) | asc2hex(fileRawHex[addr + 5])
        mat[i].append((acc1 << 8) | acc2) #starting address of the data record  
                                          #(element 1 of mat[i])             
        acc1 = (asc2hex(fileRawHex[addr + 6]) << 4) | asc2hex(fileRawHex[addr + 7])
        mat[i].append(acc1) #record type (element 2 of mat[i])              

        if mat[i][0] != 0:
            for j in range(addr + 8, addr + 8 + 2*mat[i][0], 4): #data 
                acc1 = (asc2hex(fileRawHex[j]) << 4) | asc2hex(fileRawHex[j + 1])              
                acc2 = (asc2hex(fileRawHex[j + 2]) << 4) | asc2hex(fileRawHex[j + 3])
                mat[i].append((acc1 << 8) | acc2)
                lastAddr = j + 3 #saves last address (depends on quantity of data, always changing)
        else:
            lastAddr = addr + 7
            
        #print lastAddr           
        acc1 = (asc2hex(fileRawHex[lastAddr + 1]) << 4) | asc2hex(fileRawHex[lastAddr + 2]) 
        mat[i].append(acc1) #two's complement of the preceding line (checksum)       
            
        addr = lastAddr + 5 #address of the first value in the next line
    
#    print "\r"
#    for i in range(0, countLF):
#        for j in range(0,len(mat[i])):
#            print "%06x" % mat[i][j], 
#        print "\r"

    #here, starts information formatting 
    lba = 0 #linear base address
        
    #scans record type and makes changes in addresses
    for i in range(0, countLF):
        if mat[i][2] == 0: #data record?             
            #adds lba to data record offset and divide by two
            mat[i][1] = (mat[i][1] + lba) / 2        

        elif mat[i][2] == 1: #end of file record?               
            pass
            
        elif mat[i][2] == 4: #extended address record?
            lba=mat[i][3] #takes upper linear base address (ulba)          
            lba=lba << 16 #lba= ulba(16bits)|0x00(16bits)                            
            #print "%08x" %lba
        else:
            print "Unknown hex record type!"

#    print "\r"
#    for i in range(0, countLF):
#        for j in range(0,len(mat[i])):
#            print "%06x" % mat[i][j], 
#        print "\r"

    #creates and initializes virtual memory maps

    #171*512 matrix filled with 0xffff    
    progMemory = [[0xffff for x in xrange(RowSize*2)] for x in xrange(171)] #171 #512*2*171=175104-->0x2ac00
    configMemory = [0xffff for x in xrange(12)]
    
    #stores data taken from hex file, into new memory matrices
    for i in range(0, len(mat)):       
        if mat[i][2] == 0: #data record?             

            if mat[i][1] < (512*171): #if address is into the program memory
                mAddr = mat[i][1] // (RowSize*2) #row  (int division)
                nAddr = mat[i][1] % (RowSize*2) #column (modulo)                      
                
                if mAddr < 171 and (nAddr+(mat[i][0])) < (RowSize*2):
#                    print mat[i][1]                
#                    print mAddr,
#                    print nAddr,                
                
                    for j in range(0, (mat[i][0])/2):
                        progMemory[mAddr][nAddr+j] = mat[i][3+j] #saves in program memory buffer
#                        print j,                    
#                        print "%x" %progMemory[mAddr][nAddr+j],
#                    print ""
                else:
                     print "Hex record decoding error at 0x%x!" % mat[i][1]
                     
            elif mat[i][1] >= 0xf80000: #if address is into the configuration registers
                mAddr = (mat[i][1] - 0xf80000)/2 #row                     
#                print mAddr,              
                
                for j in range(0, (mat[i][0])/2):
                    configMemory[mAddr+j] = mat[i][3+j] #saves in config memory buffer
#                    print "%x" %configMemory[mAddr+j]
#                print ""
            else:
                print "Unknown hex record type!"           
                      
        elif mat[i][2] == 1: #end of file record?               
            pass          
        elif mat[i][2] == 4: #extended address record?
            pass
        else:
            print "Unknown hex record type!"                        

#    print "\r"
#    m=3
#    for i in range(0, len(progMemory[m]),8):
#        print "%04x:" %(i+m*0x400),
#        for j in range(0,8):
#            print "%04x" % progMemory[m][i+j], 
#        print "\r"

    #sends data
    sendData(progMemory, progAddress, allMem)


#######################################
##########calls to subroutines
#######################################

def callChangeUSB(userArgument, typ):
    
    if userArgument[0] == 'r':
        if len(userArgument) == 1:           
            print '\r\nPort selected: ', 
            print '"' + usbPort + '"' + '\r\n'
        else:
            print '\r\nNo argument required!\r\n'

    elif userArgument[0] == 'w':
        if len(userArgument) > 1:            
            if typ == 0: #call from user interface
                if userArgument[1] == ' ':               
                    if len(userArgument) > 2: #at least 1 character
                        changeUSB(userArgument, typ)
                    else:
                        print '\r\nArgument too short!\r\n'                               
                else:
                    print '\r\nDoes not appear the space!\r\n'

            elif typ == 1: #call from console
                changeUSB(userArgument, typ)
        else:
            print '\r\nPort description lost!\r\n'
    else:
        print '\r\nWrong argument format!\r\n'


def callChangeAddress(userArgument, typ):
    
    if userArgument[0] == 'r':               
        print '\r\nAddress stored: ', 
        print '"' + fileAddr + '"' + '\r\n'

    elif userArgument[0] == 'w':
        if len(userArgument) > 1:
            
            if typ == 0: #call from user interface
                if userArgument[1] == ' ':               
                    if len(userArgument) > 6: #at least 1 character
                        changeAddress(userArgument, typ)
                    else:
                        print '\r\nArgument too short!\r\n'                               
                else:
                    print '\r\nDoes not appear the space!\r\n'

            elif typ == 1: #call from console
                if len(userArgument) > 5: #at least 1 character
                    changeAddress(userArgument, typ)
                else:
                    print '\r\nArgument too short!\r\n'            
        else:
            print '\r\nAddress description lost!\r\n'
    else:
        print '\r\nWrong argument format!\r\n'


def callProgram(userArgument):
           
    if len(userArgument) >= 1:
        if (userArgument[0] == '0' and userArgument[1] == 'x'):               
            # the program ensures only ascii numbers are entered
            error = True
            num = []
            for i in range (2, len(userArgument)):
                n = int(hex(ord(userArgument[i])), 16)
                if ((n >= 0x30 and n <= 0x39) or (n >= 0x41 and n <= 0x46)
                    or (n >= 0x61 and n <= 0x66)): #0 to 9, A to F, a to f
                    error = False #no format error
                    num.append(asc2hex(n)) #changes to values
                else:
                    error = True #format error, breaks
                    break                    
                                         
            if error == False: #whether the characters are entered correctly
                address = 0
                m = len(userArgument) - 2
                for i in range (0, m):
                    address = address | (num[i] << 4*(m-i-1))                              
                                
                if (fileAddr[len(fileAddr)-3] == 'h' and fileAddr[len(fileAddr)-2] == 'e' and
                    fileAddr[len(fileAddr)-1] == 'x'):
                    sendHexFile(address,0) #0->only the address will be programmed
                else:
                    sendElfFile(address,0) #0->only the address will be programmed   
            else:
                print '\r\nWrong argument format!\r\n'
                
        elif userArgument[0] == 'a':
                            
            if (fileAddr[len(fileAddr)-3] == 'h' and fileAddr[len(fileAddr)-2] == 'e' and
                fileAddr[len(fileAddr)-1] == 'x'):
                sendHexFile(0,1) #1->all memory will be programmed
            else:
                sendElfFile(0,1) #1->all memory will be programmed                                                    
        else:
            print '\r\nWrong argument format!\r\n'
    else:
        print '\r\nWrong argument format!\r\n'    


def callErase(userArgument):

    if len(userArgument) >= 1:
        if (userArgument[0] == '0' and userArgument[1] == 'x'):               
            # the program ensures only ascii numbers are entered
            error = True
            num = []
            for i in range (2, len(userArgument)):
                n = int(hex(ord(userArgument[i])), 16)
                if ((n >= 0x30 and n <= 0x39) or (n >= 0x41 and n <= 0x46)
                    or (n >= 0x61 and n <= 0x66)): #0 to 9, A to F, a to f
                    error = False #no format error
                    num.append(asc2hex(n)) #changes to values
                else:
                    error = True #format error, breaks
                    break                    
                             
            if error == False: #whether the characters are entered correctly
                address = 0
                m = len(userArgument) - 2
                for i in range (0, m):
                    address = address | (num[i] << 4*(m-i-1))
                eraseProgramMemory(address,0) #0->only the address will be erased
            else:
                print '\r\nWrong argument format!\r\n'
    
        elif userArgument[0] == 'a':
            eraseProgramMemory(0,1) #1->all memory will be erased
        else:
            print '\r\nWrong argument format!\r\n'
    else:
        print '\r\nWrong argument format!\r\n'

   
def callRead(userArgument):
    
    if len(userArgument) > 1:
        if (userArgument[0] == '0' and userArgument[1] == 'x'):               
            # the program ensures only ascii numbers are entered
            error = True
            num = []
            for i in range (2, len(userArgument)):
                n = int(hex(ord(userArgument[i])), 16)
                if ((n >= 0x30 and n <= 0x39) or (n >= 0x41 and n <= 0x46)
                    or (n >= 0x61 and n <= 0x66)): #0 to 9, A to F, a to f
                    error = False #no format error
                    num.append(asc2hex(n)) #changes to values
                else:
                    error = True #format error, breaks
                    break                    
                             
            if error == False: #whether the characters are entered correctly
                address = 0
                m = len(userArgument) - 2
                for i in range (0, m):
                    address = address | (num[i] << 4*(m-i-1))
                readProgramMemory(address,1) #1->prints messages
            else:
                print '\r\nWrong argument format!\r\n'
        else:
            print '\r\nWrong argument format!\r\n'
    else:
        print '\r\nWrong argument format!\r\n'

#######################################
##########here starts the main program
#######################################

loadConfig() #reads configuration
#firstly, check number of arguments in the calling

if len(sys.argv) == 1: #if there is only 1 argument

    os.system("clear")   
    print welcome

    input=1

    while 1 :
    
        input = raw_input(">> ") # gets keyboard input
        #input = input.lower() # changes to lowercase the command typed

        [flagArg,userCommand,userArgument] = searchCommand(input) #separates command and argument
        userCommand = userCommand.lower() # changes to lowercase the command typed
        
        if flagArg == False: #no argument found
            if userCommand != '': #command found (here only commands without arguments)
                if userCommand == 'exit':
                    print '\r\nSee you!!!\r\n'
                    exit(2)
                
                elif userCommand == 'help':
                    helpMessage(0)
           
                elif userCommand == 'run':
                    runProg()
                
                elif userCommand == 'usbscan':
                    scanUSB()

                elif userCommand == 'clear':
                    os.system("clear")      
                    print welcome
                
                elif userCommand == 'reset':
                    resetSys()                
                else:
                    if (userCommand == 'usbport' or userCommand == 'fileaddr'                
                        or userCommand == 'read' or userCommand == 'erase'
                        or userCommand == 'program'):
                        print "\r\nMissing argument\r\n"
                    else:
                        print "\r\nCommand not found\r\n"

        else: #argument found (here only commands with arguments)
            if userCommand == 'usbport':           
                callChangeUSB(userArgument, 0)

            elif userCommand == 'fileaddr':           
                callChangeAddress(userArgument, 0)
 
            elif userCommand == 'read':
                callRead(userArgument)
            
            elif userCommand == 'program':
                callProgram(userArgument)

            elif userCommand == 'erase':
                callErase(userArgument)
            else:
                print "\r\nCommand not found\r\n"
      
else: #if there is more than 1 argument
    
    argum = sys.argv[1:] #takes the argument list from the second element

    option = ''
    
    try:
        opts, args = getopt.getopt(argum, "hsrue:p:t:x:d:", ["eraseOpt=",
                                          "progOpt=", "portOpt=", "fileOpt=",
                                          "readOpt="])
    except getopt.GetoptError:
        print 'error'
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print ''
            print welcome,
            helpMessage(1)
            
        elif opt == '-s':
            print 'RESET',
            resetSys() 

        elif opt == '-r':
            print 'RUN',
            runProg()
            sys.exit(2)

        elif opt == '-u':
            print 'SCAN FOR USB PORTS',
            scanUSB()
            
        elif opt in ("-e", "--eraseOpt"):
            print 'ERASE',
            callErase(arg)
            
        elif opt in ("-p", "--progOpt"):
            print 'PROGRAM',
            callProgram(arg)
            
        elif opt in ("-t", "--portOpt"):
            print 'USB PORT',
            callChangeUSB(arg, 1) #call from console
            
        elif opt in ("-x", "--fileOpt"):
            print 'HEX OR ELF FILE ADDRESS'
            callChangeAddress(arg, 1) #call from console

        elif opt in ("-d", "--readOpt"):
            print 'READ',
            callRead(arg)

#TODO
#programar excepciones con try
#agregar comando de cambio de nombre del puerto usb
#depurar el código (crear subrutinas en secuencias repetidas)
#replantearse qué hacer con la memoria de configuraciòn (fusibles)

