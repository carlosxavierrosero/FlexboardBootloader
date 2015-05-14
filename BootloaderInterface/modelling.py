#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Tue May 13 13:05:56 2014

@authors: carlos xavier rosero
          manel velasco garcía

best performance tested with python 2.7.3, GCC 2.6.3, pyserial 2.5
"""
from __future__ import division
import math, time, serial, struct
import matplotlib.pyplot as plt
import modelling

#use this part only with old versions of python and libraries
#tested specifically with python 2.6.5, GCC 4.4.3, serial 1.3.5
class adapt(serial.Serial):
    def write(self, data):
        super(self.__class__, self).write(str(data))

def openPort(porT, baud): #opens serial port

    #use this part, only with old python versions
    ##############
    ser = adapt(port=porT, baudrate=baud, parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE)
    #serial.Serial(port=usbPort,baudrate=115200, parity=serial.PARITY_NONE,stopbits=serial.STOPBITS_ONE)
    ###############

    ser.open
    ser.isOpen
    return ser

def closePort(ser): #closes serial port

    ser.close()

def readData(porT, timeD, frameLength, baud):

    ser = openPort(porT, baud)

    # time.sleep(int(timeD))
    inputS = bytearray() #initialize buffer

    for i in range(1, 1+timeD):
        time.sleep(1)
        while ser.inWaiting() > 0:
            inputS.append(ser.read(1)) #appends a new value into the buffer
        print timeD-i+1, #to show the time remaining
    print ''

    closePort(ser)

    print "%d bytes have been received" % len(inputS)

    #### takes time ###

    timeTable = []
    i = 0
    while i < len(inputS):
        if i+3 < len(inputS):
            timeTable.append(inputS[i] << 24 | inputS[i+1] << 16 | inputS[i+2] << 8 | inputS[i+3])
            i += frameLength
        else:
            i = len(inputS) #goes out

    factor = 1/40e6 #1/Fcy
    timeTable = [x*factor for x in timeTable]
    timeTableR = [x-timeTable[0] for x in timeTable] #normalized time

    #### takes state 1 ###
    stateTable = []
    i = 4
    while i < len(inputS):
        if i+1 < len(inputS):
            stateTable.append(inputS[i] << 8 | inputS[i+1])
            i += frameLength
        else:
            i = len(inputS) #goes out

    factor = 2.0*math.pi/4096.0 #(360º/1023holes)
    stateTable1 = [x*factor- math.pi for x in stateTable]

    #### takes state 2 ###
    stateTable = []
    i = 7
    while i < len(inputS):
        if i+1 < len(inputS):
            stateTable.append(inputS[i] << 8 | inputS[i+1])
            i += frameLength
        else:
            i = len(inputS) #goes out

    radius = 0.0375 #m
    factor = (2*math.pi*radius)/4092.0
    stateTable2 = [x*factor for x in stateTable]

    #### takes control ###
    controlTable = []
    i = 10
    print len(inputS)
    while i < len(inputS):
        if i+1 < len(inputS):
            c = struct.unpack('f', inputS[i:i+4]) #4 bytes become float (but inside of a tuple)
            c = c[0] #takes the value from the tuple
            controlTable.append(c)
            i += frameLength
        else:
            i = len(inputS) #goes out
    factor = 1.0
    controlTable = [x*factor for x in controlTable]

    return [timeTableR, stateTable1, stateTable2, controlTable]

def tValidation(timeData):

    delta = round((timeData[1] - timeData[0]), 3)
    for x in range(1, len(timeData)):
        timeData[x] = round((timeData[x-1] + delta), 3)

    return timeData

def saveData(timeData, state1, state2, control):

    if len(timeData) == len(state1) and len(timeData) == len(state2) and len(timeData) == len(control):

        fileName = "experiment_" + time.strftime("%Y%m%d") + time.strftime("_%I%M%S") + ".xav"

        #Open new data file
        f = open(fileName, "w")

        f.write('TIME\n')
        for x in range(0, len(timeData)):
            f.write(str(timeData[x]) + "\n")

        f.write('PENDULUM\n')
        for x in range(0, len(state1)):
            f.write(str(state1[x]) + "\n")

        f.write('CAR\n')
        for x in range(0, len(state2)):
            f.write(str(state2[x]) + "\n")

        f.write('CONTROL\n')
        for x in range(0, len(control)):
            f.write(str(control[x]) + "\n")

        f.close()


def plotting(timeData, state1, state2, control):

    print "TIME:"
    print timeData
    print "PENDULUM ANGLE:"
    print state1
    print "CAR POSITION:"
    print state2
    print "CONTROL ACTION:"
    print control

    if len(timeData) == 0:
        print "Data box is empty!!!"

    elif len(timeData) == len(state1) and len(timeData) == len(state2) and len(timeData) == len(control):

        print "Dimensions: TIME [%d], PENDULUM [%d], CAR [%d], CONTROL [%d]" % (len(timeData), len(state1), len(state2), len(control))

        fig = plt.figure()
        ax1 = fig.add_subplot(311)
        ax1.plot(timeData, state1)
        ax1.grid(True)
        plt.ylim(-2*math.pi, 2*math.pi)
        plt.title('ROD POSITION', fontsize=10)
        plt.ylabel('ANGLE [rad]')

        ax2 = fig.add_subplot(312, sharex=ax1)
        ax2.plot(timeData, state2)
        ax2.grid(True)
        plt.ylim(0, 1.2)
        plt.title('CAR POSITION', fontsize=10)
        plt.ylabel('DISTANCE [m]')

        ax3 = fig.add_subplot(313, sharex=ax2)
        ax3.plot(timeData, control)
        ax3.grid(True)
        plt.title('CONTROL ACTION', fontsize=10)
        plt.ylabel('VOLTAGE [V]')
        ax2.axhline(-15, color='red', lw=1)
        ax2.axhline(15, color='red', lw=1)

        plt.show()

    else:

        print 'Dimensions of the vectors do not match!!!'

#######################################
######here starts the main program#####
#######################################
if __name__=="__main__":

    [timeData, state1, state2, control] = readData('/dev/ttyACM0', 10, 18, 115200)
    timeData = tValidation(timeData) #I'm cheating with this vector, that's not a real validation
    plotting(timeData, state1, state2, control)
    saveData(timeData, state1, state2, control)

    # a = "file_" + time.strftime("%Y%m%d") + time.strftime("_%I%M%S") + ".csp"
