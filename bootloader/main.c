//#include "p33FJ256MC710.h"
#include "p33Fxxxx.h"
#define COMMAND_NACK     0xff
#define COMMAND_ACK      0x01
#define COMMAND_READ_PM  0x02
#define COMMAND_WRITE_PM 0x03
#define COMMAND_WRITE_CM 0x07
#define COMMAND_RUN      0x08
#define COMMAND_READ_ID  0x09
#define COMMAND_ERASE_MEM 0x0a
#define COMMAND_BLINK_LED 0x0b

#define PM_ROW_SIZE         64*8
#define CM_ROW_SIZE         8
#define CONFIG_WORD_SIZE    1

#define PM_ROW_ERASE        0x4042
#define PM_ROW_WRITE        0x4001
#define CONFIG_WORD_WRITE   0X4000
#define yellowLed           LATBbits.LATB14

#define FCY             20000000
#define BRGVAL          10      //((FCY/BAUDRATE)/16)-1
#define delayBegin      2       //reset after reboot in seconds

#include <libpic30.h>

// External Oscillator

_FOSCSEL(FNOSC_PRIPLL);
// Clock Switching and Fail Safe Clock Monitor is disabled
// Primary (XT, HS, EC) Oscillator with PLL
_FOSC(OSCIOFNC_OFF & POSCMD_XT);
                                    // OSC2 Pin Function: OSC2 is Clock Output
                                    // Primary Oscillator Mode: XT Crystal

_FWDT(FWDTEN_OFF);                  // Watchdog Timer Enabled/disabled by user software
                                    // (LPRC can be disabled by clearing SWDTEN bit in RCON register
//_FPOR(PWRTEN_OFF);                // Turn off the power-up timers.
_FGS(GCP_OFF);                      // Disable Code Protection

typedef short          Word16;
typedef unsigned short UWord16;
typedef long           Word32;
typedef unsigned long  UWord32;

typedef union tuReg32
{
    UWord32 Val32;

    struct
    {
	UWord16 LW;
	UWord16 HW;
    }Word;

    char Val[4];
}uReg32;

extern UWord32 ReadLatch(UWord16, UWord16);
void PutChar(char);
void GetChar(char *);
void WriteBuffer(char *, int);
void ReadPM(char *, uReg32);
void WritePM(char *, uReg32);
void ConfigUart(void);
void ConfigTimer(void);

char Buffer[PM_ROW_SIZE*3 + 1];

int main(void)
{
// Configure Oscillator to operate the device at 40Mhz= 20MIPS
// Fosc= Fin*M/(N1*N2), Fcy=Fosc/2
// Fosc= 4M*40(2*2)=40Mhz for 4M input clock

    PLLFBD=40;              // M=40
    CLKDIVbits.PLLPOST=0;   // N1=2
    CLKDIVbits.PLLPRE=0;    // N2=2
    OSCTUN=0;               // Tune FRC oscillator, if FRC is used

    RCONbits.SWDTEN=0;            /* Disable Watch Dog Timer*/
    
    while(OSCCONbits.LOCK!=1) {}; /* Wait for PLL to lock*/

    ConfigTimer();
    ConfigUart();

    TRISBbits.TRISB14 = 0; //configure pin as output
    yellowLed=1; //turns on yellow led
   
    while(1)
    {
        char Command;

        GetChar(&Command);

	switch(Command)
	{
            case COMMAND_READ_PM: /*tested*/
            {
                uReg32 SourceAddr;

                GetChar(&(SourceAddr.Val[0]));
		GetChar(&(SourceAddr.Val[1]));
		GetChar(&(SourceAddr.Val[2]));
		SourceAddr.Val[3]=0;
		ReadPM(Buffer, SourceAddr);
		WriteBuffer(Buffer, PM_ROW_SIZE*3);
		break;
            }
            
            case COMMAND_ERASE_MEM:
            {
                uReg32 SourceAddr;
                int addr;
                char temp;

		GetChar(&(SourceAddr.Val[0]));
		GetChar(&(SourceAddr.Val[1]));
		GetChar(&(SourceAddr.Val[2]));
		SourceAddr.Val[3]=0;               

                if((SourceAddr.Word.HW == 0 && SourceAddr.Word.LW == 0x400) ||
                   (SourceAddr.Word.HW == 0 && SourceAddr.Word.LW == 0x800))
                {
                    /*It is not allowed to erase pages from 0x400 and from 0x800
                    (bootloader's place)*/
                    PutChar(COMMAND_NACK); /* Send error flag */
                }
                else
                {
                    if(SourceAddr.Word.HW == 0 && SourceAddr.Word.LW == 0)
                    {
                        /*When trying to delete page 0, bootloader's reset vector
                        overlies, the rest of memory is erased*/
                        ReadPM(Buffer, SourceAddr); //reads program memory at page 0

                        /*changes order (order in data buffer is inverted than actual)*/
                        temp = Buffer[0];
                        Buffer[0] = Buffer[2];
                        Buffer[2] = temp;
                        
                        temp = Buffer[3];
                        Buffer[3] = Buffer[5];
                        Buffer[5] = temp;

                        /*preserves bootloader's reset vector (first 6 locations)*/

                        for(addr = 6; addr < PM_ROW_SIZE*3; addr++)
                        {                           
                            Buffer[addr] = 0xff;
                        }

                        Erase(SourceAddr.Word.HW,SourceAddr.Word.LW,PM_ROW_ERASE);
                        WritePM(Buffer, SourceAddr); /* reprogram page 0*/
                    }
                    else
                    {
                        Erase(SourceAddr.Word.HW,SourceAddr.Word.LW,PM_ROW_ERASE);
                    }
                    PutChar(COMMAND_ACK); /* sends Acknowledgment */
                }

 		break;              
            }
            
            case COMMAND_WRITE_PM: /* tested */
            {
                uReg32 SourceAddr;
		int    addr;
                char Buffer1[PM_ROW_SIZE*3 + 1];

		GetChar(&(SourceAddr.Val[0]));
		GetChar(&(SourceAddr.Val[1]));
		GetChar(&(SourceAddr.Val[2]));
		SourceAddr.Val[3]=0;

		for(addr = 0; addr < PM_ROW_SIZE*3; addr++)
		{
                    GetChar(&(Buffer[addr])); /*takes data from uart buffer*/
                }
                
                if((SourceAddr.Word.HW == 0  && SourceAddr.Word.LW == 0x400) ||
                   (SourceAddr.Word.HW == 0  && SourceAddr.Word.LW == 0x800))
                {
                    /*It is not allowed to write to pages from 0x400 and from 0x800
                    (bootloader's place)*/
                    PutChar(COMMAND_NACK); /* sends error flag */
                }
                else
                {
                    /*here, goes inside only if it tries to access the page 0*/
                    if(SourceAddr.Word.HW == 0 && SourceAddr.Word.LW == 0)
                    {
                        ReadPM(Buffer1, SourceAddr); //reads program memory at page 0

                        /*preserves bootloader's reset vector (first 6 locations)*/
                        /*changes order (order in data buffer is inverted than actual)*/
                        Buffer[0] = Buffer1[2];
                        Buffer[1] = Buffer1[1];
                        Buffer[2] = Buffer1[0];
                        Buffer[3] = Buffer1[5];
                        Buffer[4] = Buffer1[4];
                        Buffer[5] = Buffer1[3];
                    }

                    Erase(SourceAddr.Word.HW,SourceAddr.Word.LW,PM_ROW_ERASE);
                    WritePM(Buffer, SourceAddr);		/*program page */
                    PutChar(COMMAND_ACK);			/*Send Acknowledgment */
                }
 		break;
            }

            case COMMAND_READ_ID: /*tested*/
            {
                uReg32 SourceAddr;
                uReg32 Temp;

                SourceAddr.Val32 = 0xFF0000;
		Temp.Val32 = ReadLatch(SourceAddr.Word.HW, SourceAddr.Word.LW);
		WriteBuffer(&(Temp.Val[0]), 4);
		SourceAddr.Val32 = 0xFF0002;
		Temp.Val32 = ReadLatch(SourceAddr.Word.HW, SourceAddr.Word.LW);
		WriteBuffer(&(Temp.Val[0]), 4);
		break;
            }

            case COMMAND_WRITE_CM: /*This function has not been implemented*/
            {
                int Size;
		for(Size = 0; Size < CM_ROW_SIZE*3;)
		{
                    GetChar(&(Buffer[Size++]));
                    GetChar(&(Buffer[Size++]));
                    GetChar(&(Buffer[Size++]));
                    PutChar(COMMAND_ACK); /*Send Acknowledgment */
		}
                break;
            }

            /*case COMMAND_RESET:
            {
		uReg32 SourceAddr;
		int    Size;
		uReg32 Temp;

                for(Size = 0, SourceAddr.Val32 = 0xF80000; Size < CM_ROW_SIZE*3;
                    Size +=3, SourceAddr.Val32 += 2)
                {
                    if(Buffer[Size] == 0)
                    {
                        Temp.Val[0]=Buffer[Size+1];
			Temp.Val[1]=Buffer[Size+2];
                        WriteLatch(SourceAddr.Word.HW, SourceAddr.Word.LW,
                                   Temp.Word.HW, Temp.Word.LW);
                        WriteMem(CONFIG_WORD_WRITE);
                    }
		}

		RunProg();
                break;
            }*/

            case COMMAND_RUN:
            {
                yellowLed = 0;
                PutChar(COMMAND_ACK);
                RunProg();
                break;
            }

            case COMMAND_BLINK_LED:
            {
                unsigned char i, j;
                PutChar(COMMAND_ACK); //command received

                yellowLed = 0;
                __delay_ms(200);

                for(j=0; j<2; j++)
                {
                    for(i=0; i<6; i++)
                    {
                        yellowLed = ~yellowLed;
                        __delay_ms(100);
                    }

                    for(i=0; i<6; i++)
                    {
                        yellowLed = ~yellowLed;
                        __delay_ms(300);
                    }
                }
                __delay_ms(200);
                yellowLed = 1;

                break;
            }

            default:
                PutChar(COMMAND_NACK);
		break;
	}
    }
}

void GetChar(char * ptrChar)
{
    while(1)
    {
	/* if timer expired, signal to application to jump to user code */
	if(IFS0bits.T3IF == 1)
	{
            * ptrChar = COMMAND_RUN;
            break;
	}

        /* check for receive errors */
	if(U1STAbits.FERR == 1)
	{
            continue;
	}

	/* must clear the overrun error to keep uart receiving */
	if(U1STAbits.OERR == 1)
	{
            U1STAbits.OERR = 0;
            continue;
	}

	/* get the data */
	if(U1STAbits.URXDA == 1)
	{
            T2CONbits.TON=0; /* Disable timer countdown */
            * ptrChar = U1RXREG;
            break;
	}
    }
}

void ReadPM(char * ptrData, uReg32 SourceAddr)
{
    int    Size;
    uReg32 Temp;

    for(Size = 0; Size < PM_ROW_SIZE; Size++)
    {
        Temp.Val32 = ReadLatch(SourceAddr.Word.HW, SourceAddr.Word.LW);

	ptrData[0] = Temp.Val[2];;
	ptrData[1] = Temp.Val[1];;
	ptrData[2] = Temp.Val[0];;

	ptrData = ptrData + 3;

	SourceAddr.Val32 = SourceAddr.Val32 + 2;
    }
}

void WriteBuffer(char * ptrData, int Size)
{
    int DataCount;

    for(DataCount = 0; DataCount < Size; DataCount++)
    {
        PutChar(ptrData[DataCount]);
    }
}

void PutChar(char Char)
{
    while(!U1STAbits.TRMT);
    U1TXREG = Char;
}

void WritePM(char * ptrData, uReg32 SourceAddr)
{
    int    Size,Size1;
    uReg32 Temp;
    uReg32 TempAddr;
    uReg32 TempData;

    for(Size = 0,Size1=0; Size < PM_ROW_SIZE; Size++)
    {
        Temp.Val[0]=ptrData[Size1+0];
	Temp.Val[1]=ptrData[Size1+1];
	Temp.Val[2]=ptrData[Size1+2];
	Temp.Val[3]=0;
	Size1+=3;

        WriteLatch(SourceAddr.Word.HW, SourceAddr.Word.LW,Temp.Word.HW,Temp.Word.LW);

	/* Device ID errata workaround: Save data at any address that has LSB 0x18 */
	if((SourceAddr.Val32 & 0x0000001F) == 0x18)
	{
            TempAddr.Val32 = SourceAddr.Val32;
            TempData.Val32 = Temp.Val32;
	}

	if((Size !=0) && (((Size + 1) % 64) == 0))
	{
	    /* Device ID errata workaround: Reload data at address with LSB of 0x18 */
	    WriteLatch(TempAddr.Word.HW, TempAddr.Word.LW,TempData.Word.HW,TempData.Word.LW);

            WriteMem(PM_ROW_WRITE);
	}
        SourceAddr.Val32 = SourceAddr.Val32 + 2;
    }
}

void ConfigUart(void)
{
    U1MODEbits.STSEL = 0;   //1-stop bit
    U1MODEbits.PDSEL = 0;   //No Parity, 8-data bits
    U1MODEbits.ABAUD = 0;   //Autobaud Disabled

    U1MODEbits.BRGH=0;      //1 = BRG generates 4 clocks per bit period (4x baud clock,
			    //High-Speed mode)
                            //0 = BRG generates 16 clocks per bit period (16x baud clock,
                            //Standard mode)

    U1BRG = BRGVAL;         //BRGVAL=((FCY/BITRATE1)/16)-1 //With BRGH=0-->Slow Bitrate
                            //BRGVAL=((FCY/BITRATE1)/4)-1  //With BRGH=1-->Fast Bitrate
    // Enable UART Rx and Tx
    U1MODEbits.UARTEN = 1;  //Enable UART
    U1STAbits.UTXEN = 1;    //Enable UART Tx
}

void ConfigTimer(void)
{
    uReg32 delay;
    T2CONbits.T32 = 1; /* to increment every instruction cycle */
    IFS0bits.T3IF = 0; /* Clear the Timer3 Interrupt Flag */
    IEC0bits.T3IE = 0; /* Disable Timer3 Interrupt Service Routine */

    /* Convert seconds into timer count value */
    delay.Val32 = ((UWord32)(FCY)) * ((UWord32)(delayBegin));
    PR3 = delay.Word.HW;
    PR2 = delay.Word.LW;

    /* Enable Timer */
    T2CONbits.TON=1;
}
