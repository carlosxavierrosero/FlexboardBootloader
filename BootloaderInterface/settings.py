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
        self.set_border_width(10)

        table = Gtk.Table(1, 1, True)
        self.add(table)

        labelUSB = Gtk.Label()
        labelUSB.set_text("USB device")

        labelAddr = Gtk.Label()
        labelAddr.set_text("(*.elf) File Address")
        labelName1 = Gtk.Label()
        labelName1.set_text("Developed by Carlos X. Rosero & Manel Velasco")
        labelName2 = Gtk.Label()
        labelName2.set_text("DISTRIBUTED CONTROL SYSTEMS LAB - UPC")

        buttFile = list()
        for i in range(0, 5):
            chrt = Gtk.Button(label = "Select file address " + str(i))
            chrt.connect("clicked", getattr(self, "on_file_clicked" + str(i)))
            buttFile.append(chrt)

        buttUSB = list()
        for i in range(0, 5):
            chrt = Gtk.Button(label = "Select USB device " + str(i))
            chrt.connect("clicked", getattr(self, "on_USB_clicked" + str(i)))
            buttUSB.append(chrt)

        buttTest = list()
        for i in range(0, 5):
            chrt = Gtk.Button(label = "Test " + str(i))
            chrt.connect("clicked", getattr(self, "on_test_clicked" + str(i)))
            buttTest.append(chrt)

        buttApply = Gtk.Button(label = "Apply changes", use_underline = True)
        buttApply.connect("clicked", self.on_apply_clicked)

        buttClose = Gtk.Button("_Close", use_underline = True)
        buttClose.connect("clicked", self.on_close_clicked)

        buttSearch = Gtk.Button("Search for attached devices", use_underline = True)
        buttSearch.connect("clicked", self.on_search_clicked)

        serialBoot.loadConfig() #initializes ram positions in the serialBoot.py file

        self.usbPort = list()
        for i in range(0, 5):
            chrt = Gtk.Entry()
            text = serialBoot.callChangeUSB(str(i) + 'r') #reads stored ports
            chrt.set_text(text)
            self.usbPort.append(chrt)

        self.usbAddr = list()
        for i in range(0, 5):
            chrt = Gtk.Entry()
            text = serialBoot.callChangeAddress(str(i) + 'r') #reads stored addresses
            chrt.set_text(text)
            self.usbAddr.append(chrt)

        self.usbShow = Gtk.TextView()
        self.textBuffer = self.usbShow.get_buffer()
        self.textBuffer.set_text('')

        #let's assign location into the GUI

        table.attach(labelUSB, 0, 1, 0, 1)
        table.attach(labelAddr, 3, 6, 0, 1)

        for i in range(0, 5):
            table.attach(self.usbPort[i], 0, 1, i+1, i+2)

        for i in range(0, 5):
            table.attach(buttUSB[i], 1, 2, i+1, i+2)

        for i in range(0, 5):
            table.attach(buttTest[i], 2, 3, i+1, i+2)

        for i in range(0, 5):
            table.attach(self.usbAddr[i], 3, 6, i+1, i+2)

        for i in range(0, 5):
            table.attach(buttFile[i], 6, 7, i+1, i+2)

        table.attach(self.usbShow, 0, 3, 6, 12)
        table.attach(buttSearch, 3, 5, 6, 8)

        table.attach(buttApply, 6, 7, 8, 10)
        table.attach(buttClose, 6, 7, 10, 12)

        table.attach(labelName1, 4, 6, 10, 11)
        table.attach(labelName2, 4, 6, 11, 12)

    def on_file_clicked0(self, widget):
        self.on_file_clicked(0)

    def on_file_clicked1(self, widget):
        self.on_file_clicked(1)

    def on_file_clicked2(self, widget):
        self.on_file_clicked(2)

    def on_file_clicked3(self, widget):
        self.on_file_clicked(3)

    def on_file_clicked4(self, widget):
        self.on_file_clicked(4)

    def on_USB_clicked0(self, widget):
        self.on_USB_clicked(0)

    def on_USB_clicked1(self, widget):
        self.on_USB_clicked(1)

    def on_USB_clicked2(self, widget):
        self.on_USB_clicked(2)

    def on_USB_clicked3(self, widget):
        self.on_USB_clicked(3)

    def on_USB_clicked4(self, widget):
        self.on_USB_clicked(4)

    def on_close_clicked(self, button):
        Gtk.main_quit()

    def on_test_clicked0(self, widget):
        self.on_test_clicked(0)

    def on_test_clicked1(self, widget):
        self.on_test_clicked(1)

    def on_test_clicked2(self, widget):
        self.on_test_clicked(2)

    def on_test_clicked3(self, widget):
        self.on_test_clicked(3)

    def on_test_clicked4(self, widget):
        self.on_test_clicked(4)

    def on_apply_clicked(self, button):

        serialBoot.loadConfig() #initializes ram positions in the serialBoot.py file

        for i in range(0, 5):
            text = self.usbPort[i].get_text()
            a = serialBoot.callChangeUSB(str(i) + 'w' + text) #writes new USB ports
            if a == '': #function returns empty space if error
                self.usbPort[i].set_text('USBportAddress')

        for i in range(0, 5):
            text = self.usbAddr[i].get_text()
            a = serialBoot.callChangeAddress(str(i) + 'w' + text) #writes new elf file addresses
            if a == '': #function returns empty space if error
                self.usbAddr[i].set_text('NameOfFileToProgram.elf')

    def on_file_clicked(self, device):

        dialogFile = Gtk.FileChooserDialog("Select an *.elf file", self,
            Gtk.FileChooserAction.OPEN, (Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL,
            Gtk.STOCK_OPEN, Gtk.ResponseType.OK))

        self.add_filtersFile(dialogFile)

        response = dialogFile.run()
        if response == Gtk.ResponseType.OK:
            print("File selected: " + dialogFile.get_filename())
            self.usbAddr[device].set_text(dialogFile.get_filename())

        dialogFile.destroy()

    def on_USB_clicked(self, device):

        dialogUSB = Gtk.FileChooserDialog("Select an available port", self,
            Gtk.FileChooserAction.OPEN, (Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL,
            Gtk.STOCK_OPEN, Gtk.ResponseType.OK))

        self.add_filtersUSB(dialogUSB)

        response = dialogUSB.run()
        if response == Gtk.ResponseType.OK:
            print("File selected: " + dialogUSB.get_filename())
            self.usbPort[device].set_text(dialogUSB.get_filename())

        dialogUSB.destroy()

    def on_test_clicked(self, device):

        serialBoot.loadConfig() #initializes ram positions in the serialBoot.py file
        serialBoot.callBlinkLed(str(device)) #writes new USB ports

    def on_search_clicked(self, device):

        serialBoot.loadConfig() #initializes ram positions in the serialBoot.py file
        usbDevices = serialBoot.scanUSB()

        if len(usbDevices) != 0:
            text = ""
            for i in range(0, len(usbDevices)):
                text = text + usbDevices[i] + "\r\n"
            self.textBuffer.set_text(text)
        else:
            self.textBuffer.set_text('Has not been found any attached device!')

    def add_filtersFile(self, dialogFile):

        filter_elf = Gtk.FileFilter()
        filter_elf.set_name("*.elf files")
        filter_elf.add_pattern("*.elf")
        dialogFile.add_filter(filter_elf)

        filter_hex = Gtk.FileFilter()
        filter_hex.set_name("*.hex files")
        filter_hex.add_pattern("*.hex")
        dialogFile.add_filter(filter_hex)

        filter_any = Gtk.FileFilter()
        filter_any.set_name("Any files")
        filter_any.add_pattern("*")
        dialogFile.add_filter(filter_any)

    def add_filtersUSB(self, dialogUSB):

        filter_acm = Gtk.FileFilter()
        filter_acm.set_name("ttyACM")
        for i in range(0, 256):
            filter_acm.add_pattern("ttyACM" + str(i))
        dialogUSB.add_filter(filter_acm)

        filter_usb = Gtk.FileFilter()
        filter_usb.set_name("ttyUSB")
        for i in range(0, 256):
            filter_usb.add_pattern("ttyUSB" + str(i))
        dialogUSB.add_filter(filter_usb)

        filter_any = Gtk.FileFilter()
        filter_any.set_name("Any files")
        filter_any.add_pattern("*")
        dialogUSB.add_filter(filter_any)

if __name__ == "__main__":

    initFile()
    win = firstWindow()
    win.connect("delete-event", Gtk.main_quit)
    win.show_all()
    Gtk.main()
