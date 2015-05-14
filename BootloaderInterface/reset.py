#!/usr/bin/env python
from gi.repository import Gtk
import os
import serialBoot


#first configurations initialization
def initFile():

    selfName = os.path.basename(__file__) #script's self location
    selfPath = os.path.realpath(__file__) #script's self name

    if selfPath.endswith(selfName): #removes script's name from path
        selfPath = selfPath[:-len(selfName)]

    os.chdir(selfPath) #sets current directory in order to access the config file
    #os.system("./serialBoot.py -h")

class firstWindow(Gtk.Window):

    def __init__(self):
        Gtk.Window.__init__(self, title="Evidence Flex Board - Bootloader Application - Version 1.1")
        self.set_border_width(20)

        grid = Gtk.Grid()
        self.add(grid)


        labelChoose = Gtk.Label()
        labelChoose.set_text("Choose the device to reset")

        buttReset = list()
        for i in range(0, 5):
            chrt = Gtk.Button(label = str(i))
            chrt.connect("clicked", getattr(self, "on_reset_clicked" + str(i)))
            buttReset.append(chrt)

        self.buttClose = Gtk.Button("\r\nClose\r\n", use_underline = True)
        self.buttClose.connect("clicked", self.on_close_clicked)

        #let's assign location into the GUI

        grid.attach(labelChoose, 0, 0, 5, 1)

        grid.attach(buttReset[0], 0, 1, 1, 2)
        for i in range(1, 5):
            grid.attach_next_to(buttReset[i], buttReset[i-1], Gtk.PositionType.RIGHT, 1, 2)

        grid.attach(self.buttClose, 0, 3, 5, 1)

    def on_reset_clicked0(self, widget):
        self.on_reset_clicked(0)

    def on_reset_clicked1(self, widget):
        self.on_reset_clicked(1)

    def on_reset_clicked2(self, widget):
        self.on_reset_clicked(2)

    def on_reset_clicked3(self, widget):
        self.on_reset_clicked(3)

    def on_reset_clicked4(self, widget):
        self.on_reset_clicked(4)

    def on_close_clicked(self, button):
        Gtk.main_quit()

    def on_reset_clicked(self, device):
        serialBoot.loadConfig() #initializes ram positions in the serialBoot.py file
        serialBoot.callResetSys(str(device))
        serialBoot.callRunProg(str(device))

if __name__ == "__main__":

    initFile()
    win = firstWindow()
    win.connect("delete-event", Gtk.main_quit)
    win.show_all()
    Gtk.main()