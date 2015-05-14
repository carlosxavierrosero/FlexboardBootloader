#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@authors: carlos xavier rosero
          manel velasco garcía

best performance tested with python 2.7.3, GCC 2.6.3, pyserial 2.5
"""
from __future__ import division
import math
import sys, serial, argparse, struct
from collections import deque

import matplotlib.pyplot as plt
import matplotlib.animation as animation

#use this part only with old versions of python and libraries
#tested specifically with python 2.6.5, GCC 4.4.3, serial 1.3.5
class adapt(serial.Serial):
    def write(self, data):
        super(self.__class__, self).write(str(data))

class serialRead:

    def __init__(self, usbPort, frameLen, maxLen, EOL, bauds):

        # open serial port

        self.ser = adapt(port=usbPort, baudrate=bauds, timeout=1, parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE)

        self.ser.open
        self.ser.isOpen

        self.ay1 = deque([0.0]*maxLen)
        self.ay2 = deque([0.0]*maxLen)
        self.ay3 = deque([0.0]*maxLen)

        self.maxLen = maxLen

        self.eol = EOL #end of line
        self.lenEol = len(self.eol) #length of the end of line

        self.frameLen = frameLen - self.lenEol

        self.factorFCY = 1/40e6 #1/Fcy
        self.factorROD = 2.0*math.pi/4096.0 #(2pi/1023holes)
        radius = 0.0375 #cm
        self.factorCAR = 2.0*math.pi*radius/4092.0
        self.factorCONTROL = 1

  # add to buffer
    def addToBuf(self, buf, val):
        if len(buf) < self.maxLen:
            buf.append(val)
        else:
            buf.pop()
            buf.appendleft(val)

    # update plot
    def update(self, frameNum, a1, a2, a3):

        try:
            line = bytearray()
            while True:
                c = self.ser.read(1)
                if c:
                    line.append(c)
                    if line[-self.lenEol:] == self.eol:
                        line = line[0:-self.lenEol] #removes EOF
                        break
                else:
                    break

            if self.frameLen == len(line):
                data = [int(val) for val in line[0:-4]] #except the last 4 elements

                time = (data[0]<<24 | data[1] << 16 | data[2] << 8 | data[3])*self.factorFCY
                state1 = (data[4]*256 + data[5])*self.factorROD - math.pi
                state2 = (data[7]*256 + data[8])*self.factorCAR

                control = struct.unpack('f', line[-4::]) #last 4 elements become float
                control = control[0] * self.factorCONTROL

                # print state1,
                # print state2,
                # print control

                # add data to buffer
                self.addToBuf(self.ay1, state1)
                self.addToBuf(self.ay2, state2)
                self.addToBuf(self.ay3, control)

                a1.set_data(range(self.maxLen), self.ay1)
                a2.set_data(range(self.maxLen), self.ay2)
                a3.set_data(range(self.maxLen), self.ay3)

            else:
                print 'Incorrect frame length!!!'
                self.ser.flush() #gets empty the serial port buffer

        except KeyboardInterrupt:
            print('Exiting...')


    # update data only
    def updateDataOnly(self):

        try:
            line = bytearray()
            while True:
                c = self.ser.read(1)
                if c:
                    line.append(c)
                    if line[-self.lenEol:] == self.eol:
                        line = line[0:-self.lenEol] #removes EOF
                        break
                else:
                    break

            if self.frameLen == len(line):
                data = [int(val) for val in line[0:-4]] #except the last 4 elements

                time = (data[0]<<24 | data[1] << 16 | data[2] << 8 | data[3])*self.factorFCY
                state1 = (data[4]*256 + data[5])*self.factorROD - math.pi
                state2 = (data[7]*256 + data[8])*self.factorCAR

                control = struct.unpack('f', line[-4::]) #last 4 elements become float
                control = control[0] * self.factorCONTROL

                return [state1, state2, control]

            else:
                print 'Incorrect frame length!!!'
                self.ser.flush() #gets empty the serial port buffer
                return [0, 0, 0]

        except KeyboardInterrupt:
            print('Exiting...')

    # clean up
    def close(self):
        # close serial
        self.ser.flush()
        self.ser.close()

def plotting(givenData):

    fig = plt.figure()

    ax1 = plt.subplot(311)
    ax1.grid(True)
    a1, = ax1.plot([0], [0], color=(0,1,0))
    plt.xlim(0, 100)
    plt.ylim(-2*math.pi, 2*math.pi)
    plt.title('ROD POSITION', fontsize=10)
    plt.ylabel('ANGLE [rad]')

    ax2 = plt.subplot(312)
    ax2.grid(True)
    a2, = ax2.plot([], [], color=(1,0,0))
    plt.xlim(0, 100)
    plt.ylim(0, 1.2)
    plt.ylabel('DISTANCE [m]')
    plt.title('CAR POSITION', fontsize=10)

    ax3 = plt.subplot(313)
    ax3.grid(True)
    a3, = ax3.plot([], [], color=(0,0,1))
    plt.xlim(0, 100)
    plt.ylim(-12, 12)
    plt.xlabel('TIME [sec]')
    plt.ylabel('VOLTAGE [V]')
    plt.title('CONTROL ACTION', fontsize=10)

    anim = animation.FuncAnimation(fig, givenData.update, fargs=(a1, a2, a3), interval=50)

    plt.show() # show plot


#######################################
######here starts the main program#####
#######################################
if __name__ == "__main__":

    testCarlos = serialRead('/dev/ttyACM0', 18, 100, 'cXrC', 115200)
    plotting(testCarlos)
    serialRead.close(testCarlos)
