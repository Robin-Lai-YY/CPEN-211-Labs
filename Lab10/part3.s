/*  This is the copy and the original file name is "interrupt_example.s" */
				
				.include	"address_map_arm.s"
				.include	"interrupt_ID.s"

/* ********************************************************************************
 * This program demonstrates use of interrupts with assembly language code. 
 * The program responds to interrupts from the pushbutton KEY port in the FPGA.
 *
 * The interrupt service routine for the pushbutton KEYs indicates which KEY has 
 * been pressed on the HEX0 display.
 ********************************************************************************/
 my_array:   .word 0
 CHAR_FLAG:  .word 0
 CHAR_BUFFER: .word 0

				.section .vectors, "ax"

				B 			_start					// reset vector
				B 			SERVICE_UND				// undefined instruction vector
				B 			SERVICE_SVC				// software interrrupt vector
				B 			SERVICE_ABT_INST		// aborted prefetch vector
				B 			SERVICE_ABT_DATA		// aborted data vector
				.word 	0							// unused vector
				B 			SERVICE_IRQ				// IRQ interrupt vector
				B 			SERVICE_FIQ				// FIQ interrupt vector

				.text
				.global	_start
_start:		
				/* Set up stack pointers for IRQ and SVC processor modes */
				MOV		R1, #0b11010010					// interrupts masked, MODE = IRQ
				MSR		CPSR_c, R1							// change to IRQ mode
				LDR		SP, =A9_ONCHIP_END - 3			// set IRQ stack to top of A9 onchip memory
				/* Change to SVC (supervisor) mode with interrupts disabled */
				MOV		R1, #0b11010011					// interrupts masked, MODE = SVC
				MSR		CPSR, R1								// change to supervisor mode
				LDR		SP, =DDR_END - 3					// set SVC stack to top of DDR3 memory

				BL			CONFIG_GIC							// configure the ARM generic interrupt controller

				// write to the pushbutton KEY interrupt mask register
				LDR		R0, =KEY_BASE						// pushbutton KEY base address
				MOV		R1, #0xF								// set interrupt mask bits
				STR		R1, [R0, #0x8]						// interrupt mask register is (base + 8)

				// enable IRQ interrupts in the processor
				MOV		R0, #0b01010011					// IRQ unmasked, MODE = SVC
				MSR		CPSR_c, R0
				
				/////////////////////////////////////////////////////////
				LDR R0, =0xFFFEC600 
				LDR R3, =100000000   //100000000 = 200MHz
				STR R3, [R0]
				MOV R3, #0b111 //E,I,A = 1
				STR R3, [R0, #0x8] //Prescalar value				
				/////////////////////////////////////////////////////////
				
			    /////////////////////////////////////////////////////////part 3 start
				LDR R0, =JTAG_UART_BASE   //0xFF201000
				MOV R1, #1                //RE --> 1
				STR R1, [R0, #0x4]        			
			    /////////////////////////////////////////////////////////part 3 end
								
IDLE:
				/////////////////////////////////////////////////////////part 3 start
				LDR R5, =CHAR_FLAG
				LDR R6, [R5]
				CMP   R6, #1     //compare with 1 and CHAR_FLAG
				BNE   IDLE             	//if the value of CHAR_FLAG is 1, go next. If it is not, looooooooooop
				LDR   R7, =CHAR_BUFFER      
				LDR   R0, [R7]			//bridge: r7: CHAR_BUFFER---->R0
				BL    PUT_JTAG          // call PUT_JTAG fuction
				MOV   R8, #0
				STR   R8, [R5]          //set the value of CHAR_FLAG to 0
				B IDLE
				/////////////////////////////////////////////////////////part 3 end
				
		//Credit: handout from Lab 10. Thanks Prof.Tor
PUT_JTAG: 		LDR R1, =0xFF201000 // JTAG UART base address
				LDR R2, [R1, #4] // read the JTAG UART control register
				LDR R3, =0xFFFF
				ANDS R2, R2, R3 // check for write space
				BEQ END_PUT // if no space, ignore the character
				STR R0, [R1] // send the character
END_PUT: 		BX LR

/* Define the exception service routines */

/*--- Undefined instructions --------------------------------------------------*/
SERVICE_UND:
    			B SERVICE_UND 
 
/*--- Software interrupts -----------------------------------------------------*/
SERVICE_SVC:			
    			B SERVICE_SVC 

/*--- Aborted data reads ------------------------------------------------------*/
SERVICE_ABT_DATA:
    			B SERVICE_ABT_DATA 

/*--- Aborted instruction fetch -----------------------------------------------*/
SERVICE_ABT_INST:
    			B SERVICE_ABT_INST 
 
/*--- IRQ ---------------------------------------------------------------------*/
SERVICE_IRQ:
    			PUSH		{R0-R7, LR}
    
    			/* Read the ICCIAR from the CPU interface */
    			LDR		R4, =MPCORE_GIC_CPUIF
    			LDR		R5, [R4, #ICCIAR]				// read from ICCIAR
			
FPGA_IRQ1_HANDLER:
    			CMP		R5, #KEYS_IRQ
				//////////////////////////////////
				BEQ RECOGNIZES
				CMP R5, #MPCORE_PRIV_TIMER_IRQ
				BEQ DISPLAY_LED
				CMP R5, #80 //#JTAG_IRQ 
				BEQ KEY_BOARD
				/////////////////////////////////
UNEXPECTED:	BNE		UNEXPECTED    					// if not recognized, stop here
 
DISPLAY_LED:	LDR R8, =LEDR_BASE
				LDR R9, =my_array
				LDR R10, [R9]
				ADD R10, R10, #1
				STR R10, [R9, #0]
				STR R10, [R8, #0]
				B EXIT_IRQ
			 ////////////////////////////////////////
KEY_BOARD:  	LDR R0, =JTAG_UART_BASE  //0xFF201000
				LDR R1, =CHAR_BUFFER
				LDR R2, =CHAR_FLAG
				LDR R3, [R0]               
				STR R3, [R1]              // bridge: r3: R0--->R1
				MOV R6, #1
				STR R6, [R2]                // CHAR_FLAG ---> 1
				B EXIT_IRQ 
		//////////////////////////////////////
RECOGNIZES:	BL KEY_ISR
			B EXIT_IRQ
EXIT_IRQ:
    			/* Write to the End of Interrupt Register (ICCEOIR) */
    			STR		R5, [R4, #ICCEOIR]			// write to ICCEOIR
    
    			POP		{R0-R7, LR}
    			SUBS		PC, LR, #4

/*--- FIQ ---------------------------------------------------------------------*/
SERVICE_FIQ:
    			B			SERVICE_FIQ 

				.end   
