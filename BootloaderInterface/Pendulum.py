import Tkinter as tk
import tkMessageBox
import time
import random
import numpy
import rtMonitoring
import serialBoot

import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg

class gui():
    def __init__(self, master):

        self.referValue = tk.DoubleVar()
        self.usbPortVariable = tk.StringVar()
        self.currentPort = tk.StringVar()
        self.master = master
        self.initInterface()
        self.initStart()

    def initInterface(self):

        #buttons
        self.startButton = tk.Button(self.master, text='Start', width=8, command=self.startPlotting)
        self.stopButton = tk.Button(self.master, text='Stop', height=5, width=8, command=self.stopPlotting)
        self.closeButton = tk.Button(self.master, text='Close', width=8, command=self.quitGui)
        self.clearButton = tk.Button(self.master, text='Clear', width=8, command=self.clearAll)
        self.updateUsb = tk.Button(self.master, text="Update USB devices",
                                   height=1, width=13, command=self.updatePorts)
        self.calibButton = tk.Button(self.master, text="Calibrate",
                                   height=1, width=5, command=self.calibPendulum)


        #menus
        self.usbMenu = tk.OptionMenu(self.master, self.usbPortVariable, ())
        self.usbMenu.configure(height=1, width=11)
        self.updatePorts()

        #figures
        self.figure = plt.figure()
        self.ax1 = plt.subplot(311)
        self.ax1.grid(True)
        self.line1, = self.ax1.plot([], [], color=(0, 1, 0))
        plt.xlim(0, 100)
        plt.ylim(-2*numpy.pi, 2*numpy.pi)
        plt.title('ROD POSITION', fontsize=8)
        plt.ylabel('ANGLE [rad]')

        self.ax2 = plt.subplot(312)
        self.ax2.grid(True)
        self.line2, = self.ax2.plot([], [], color=(1, 0, 0))
        plt.xlim(0, 100)
        plt.ylim(0, 1.2)
        plt.ylabel('DISTANCE [m]')
        plt.title('CAR POSITION', fontsize=8)

        self.ax3 = plt.subplot(313)
        self.ax3.grid(True)
        self.line3, = self.ax3.plot([], [], color=(0, 0, 1))
        plt.xlim(0, 100)
        plt.ylim(-12, 12)
        plt.xlabel('SAMPLES')
        plt.ylabel('VOLTAGE [V]')
        plt.title('CONTROL ACTION', fontsize=8)

        self.canvas = FigureCanvasTkAgg(self.figure, master=self.master)

        #slides
        self.referSlide = tk.Scale(master=root, label="Reference [m]", variable=self.referValue,
                                   from_=0, to=1.2, sliderlength=50, length=650, resolution=0.01,
                                   orient=tk.HORIZONTAL)

        #locations over the layer
        self.canvas.get_tk_widget().grid(row=0, column=0, rowspan=6, columnspan=10)
        self.referSlide.grid(row=6, column=0, columnspan=10)
        self.startButton.grid(row=7, column=8)
        self.clearButton.grid(row=8, column=8)
        self.closeButton.grid(row=9, column=8)
        self.stopButton.grid(row=7, column=9, rowspan=3)
        self.updateUsb.grid(row=7, column=0)
        self.usbMenu.grid(row=8, column=0)
        self.calibButton.grid(row=7, column=1)

    def initStart(self):
        self.stopButton['state'] = 'disabled'
        self.clearButton['state'] = 'disabled'

        self.isPlotting = False
        self.valueX = 0 #reinitialize samples counter

    def clearAll(self):
        # plotting function: clear current, plot & redraw
        plt.clf()
        self.initInterface()
        self.initStart()

    def _resetOptionMenu(self, options, index=None):
        '''reset the values in the option menu
        if index is given, set the value of the menu to
        the option at the given index
        '''
        menu = self.usbMenu["menu"]
        menu.delete(0, "end")
        for string in options:
            menu.add_command(label=string,
                             command=lambda value=string:
                                  self.usbPortVariable.set(value))
        if index is not None:
            self.usbPortVariable.set(options[index])

    def updatePorts(self):
        '''Switch the option menu to display colors'''
        # self._resetOptionMenu(["1","2","3","4"], 0)

        serialBoot.loadConfig() #initializes ram positions in the serialBoot.py file
        usbDevices = serialBoot.scanUSB()

        if len(usbDevices) == 0:
            usbDevices = ['None']

        self._resetOptionMenu(usbDevices, 0)

    def startPlotting(self):

        self.currentPort = self.usbPortVariable.get() #takes selected port from usb option menu

        if self.currentPort != 'None':
            self.rxData = rtMonitoring.serialRead(self.currentPort, 18, 100, 'cXrC', 115200)
            self.startButton['state'] = 'disabled'
            self.stopButton['state'] = 'normal'
            self.clearButton['state'] = 'disabled'
            self.closeButton['state'] = 'disabled'
            self.calibButton['state'] = 'disabled'
            self.updateUsb['state'] = 'disabled'
            self.usbMenu['state'] = 'disabled'

            self.isPlotting = True
            self._plotting()
        else:
            tkMessageBox.showinfo("Warning", "A USB compatible device, has not been selected!")

    def stopPlotting(self):
        self.startButton['state'] = 'normal'
        self.stopButton['state'] = 'disabled'
        self.clearButton['state'] = 'normal'
        self.closeButton['state'] = 'normal'
        self.calibButton['state'] = 'normal'
        self.updateUsb['state'] = 'normal'
        self.usbMenu['state'] = 'normal'

        self.isPlotting = False
        rtMonitoring.serialRead.close(self.rxData) #close port

    def calibPendulum(self):
        pass

    def _plotting(self):

        while self.isPlotting:            
            # valueY = random.random() * 10  # random float between [0, 10)
            [state1, state2, control] = self.rxData.updateDataOnly()

            ## update plot
            # Update data (with the new _and_ the old points)
            self.line1.set_xdata(numpy.append(self.line1.get_xdata(), self.valueX))
            self.line1.set_ydata(numpy.append(self.line1.get_ydata(), state1))

            self.line2.set_xdata(numpy.append(self.line2.get_xdata(), self.valueX))
            self.line2.set_ydata(numpy.append(self.line2.get_ydata(), state2))

            self.line3.set_xdata(numpy.append(self.line3.get_xdata(), self.valueX))
            self.line3.set_ydata(numpy.append(self.line3.get_ydata(), control))

            self.valueX = self.valueX + 1

            #change scale
            if self.valueX == 80:
                self.ax1.axis([20, 120, -2*numpy.pi, 2*numpy.pi])
                self.ax2.axis([20, 120, 0, 1.2])
                self.ax3.axis([20, 120, -12, 12])
            elif self.valueX >= 100:
                if self.valueX%20 == 0:
                    self.ax1.axis([self.valueX-80, self.valueX+20, -2*numpy.pi, 2*numpy.pi])
                    self.ax2.axis([self.valueX-80, self.valueX+20, 0, 1.2])
                    self.ax3.axis([self.valueX-80, self.valueX+20, -12, 12])

            # We need to draw *and* flush
            self.figure.canvas.draw()
            self.figure.canvas.flush_events()  

    def quitGui(self):
        self.master.destroy()
        self.master.quit()


#######################################
######here starts the main program#####
#######################################
if __name__ == "__main__":
    root = tk.Tk()
    root.wm_title("Pendulum User Interface")

    app = gui(root)
    root.protocol('WM_DELETE_WINDOW', app.quitGui)
    root.mainloop()