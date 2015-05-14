#include <.\base_complemento.h>   //special and interrupt routines inside
////////////////////////////////////////////////
void main()
{
   int1 flag = 0;
   
   porta = 0;//all ports are zero
   portb = 0;
   portc = 0;

   setup_adc_ports(no_analogs|vss_vdd); //digital functions selected
   setup_adc(adc_off); //internal rc oscillator disabled for adc
   setup_wdt(wdt_off); //watch dog timer disabled
   setup_timer_0(rtcc_off); //all timers disabled
   setup_timer_1(t1_disabled);
   setup_timer_2(t2_disabled,0,1);
   setup_timer_3(t3_disabled|t3_div_by_1);
   setup_comparator(nc_nc_nc_nc); //comparators disabled
   setup_vref(false); //no reference voltage in ra2
   setup_ccp1(ccp_off); //disable ccp1
   setup_ccp2(ccp_off); //disable ccp2
   enable_interrupts(int_rda); //uart rx interruption enabled
   enable_interrupts(global); //global interruptions enabled
   usb_cdc_init();
   usb_init(); //initialize hardware usb and wait for PC conection
 
   set_tris_a(0b00111111);
   set_tris_b(0b11111011);//rb2 output mclr dspic
   
   port_b_pullups(false);
   set_tris_c(0b10111111);
   
   stateDspic = running;
   counterReset = 0;  
   delay_ms(500);//wait for supply stabilization

   while(true)
   {
      usb_task();
      manage_conection();
 
      if (usb_cdc_kbhit())
      {
         data_rx_usb=usb_cdc_getc();//read buffer and save in data_rx
         printf("%c",data_rx_usb);//send through uart
         
         if (data_rx_usb == rstKeyword[0])
         {
            if (counterReset == 0)
               counterReset++;
         }
         else if (data_rx_usb == rstKeyword[1])
         {
            if (counterReset == 1)
               counterReset++;
            else
               counterReset = 0;
         }
         else if (data_rx_usb == rstKeyword[2])
         {
            if (counterReset == 2)
               counterReset++;
            else
               counterReset = 0;
         }
         else if (data_rx_usb == rstKeyword[3])
         {
            if (counterReset == 3)
               counterReset++;
            else
               counterReset = 0;
         }
         else if (data_rx_usb == rstKeyword[4] && counterReset == 4)//here, all requirements were met
         {
            counterReset = 0;
            flag = 0; //reset flag
            for(i = 0; i < 10000; i++) //wait for the next byte
            {
               if (usb_cdc_kbhit()) //if a new byte is received
               {
                  data_rx_usb = usb_cdc_getc();//read buffer and save in data_rx
                  printf("%c",data_rx_usb);//send through uart 
                  flag = 0;
                  break;
               }
               flag = 1;                            
            }
            if (flag == 1) //apply reset when no characters were received
            {
               stateDspic = stop;
               delay_ms(50);
               stateDspic = running;    
            }
         }
         else
            counterReset = 0;
         
      }
   }
}


