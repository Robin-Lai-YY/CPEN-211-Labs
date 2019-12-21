sum: .double 0.0

A:
	.double 1.1 
	.double 1.2
	.double 1.3
	.double 1.4

B: 
	.double 1.4
	.double 1.3
	.double 1.2
	.double 1.1

C:  .double 0.1
	.double 0.2
	.double 0.3
	.double 0.4



.text
.global _start
_start:
	BL CONFIG_VIRTUAL_MEMORY
	// Step 1-3: configure PMN0 to count cycles
	MOV R0, #0 // Write 0 into R0 then PMSELR
	MCR p15, 0, R0, c9, c12, 5 // Write 0 into PMSELR selects PMN0
	MOV R1, #0x11 // Event 0x11 is CPU cycles
	MCR p15, 0, R1, c9, c13, 1 // Write 0x11 into PMXEVTYPER (PMN0 measure CPU cycles)
	
	// Step 4: enable PMN0
	mov R0, #1 // PMN0 is bit 0 of PMCNTENSET  00001 = 1
	MCR p15, 0, R0, c9, c12, 1 // Setting bit 0 of PMCNTENSET enables PMN0
	
	
	//////////////////////// part 1 //////////////////////// Structure same above
	MOV R0, #1 // Write 1 into R0 then PMSELR
	MCR p15, 0, R0, c9, c12, 5 // Write 1 into PMSELR selects PMN1
	MOV R1, #0x6 // Event 0x6 is Number of load instructions executed (counted if condition code passed)
	MCR p15, 0, R1, c9, c13, 1 // Write 0x6 into PMXEVTYPER (PMN1 measure number og load instruction)
	
	//enable PMN1
	mov R0, #2 // PMN0 is bit 0 of PMCNTENSET 00010 = 2
	MCR p15, 0, R0, c9, c12, 1 // Setting bit 1 of PMCNTENSET enables PMN1
	
	MOV R0, #2 // Write 2 into R0 then PMSELR
	MCR p15, 0, R0, c9, c12, 5 // Write 2 into PMSELR selects PMN2
	MOV R1, #0x3 // Event 0x3 is Level 1 data cache misses
	MCR p15, 0, R1, c9, c13, 1 // Write 0x3 into PMXEVTYPER (PMN2 measure cache misses)
	
	//enable PMN2
	mov R0, #4 // PMN0 is bit 0 of PMCNTENSET 00100 = 4
	MCR p15, 0, R0, c9, c12, 1 // Setting bit 2 of PMCNTENSET enables PMN2
	//////////////////////// part 1 ////////////////////////
	
	
	// Step 5: clear all counters and start counters
	mov r0, #3 // bits 0 (start counters) and 1 (reset counters)
	MCR p15, 0, r0, c9, c12, 0 // Setting PMCR to 3
	
	//////////////////////// part 2 ////////////////////////
	// R0 --> A
	// R1 --> B
	// R2 --> C
	// R3 --> i
	// R4 --> j
	// R5 --> k
	// R6 --> sum constant
	// D12 --> sum
	// R7 --> A[i][k]
	// R8 --> B[k][j]
	// R9 --> C[i][j]
	// R10 --> N
	
	// Reference: Chapter 3 of COD4e P250~253
	.equ N, 16  //initialize N = 16 --> 2^4

	
	
	
	LDR R0, =A
	LDR R1, =B
	LDR R2, =C
	MOV R3, #0   //i = 0
	MOV R4, #0	 //j = 0
	MOV R5, #0   //k = 0
	LDR R10, =N
first_for:
	CMP R3, R10		//	i < N ?
	BGE first_for_done
	B second_for
	
second_for:
	CMP R4, R10		// j < N ?
	BGE second_for_done
	LDR r6, =sum
	.word 0xED96CB00	//fldd D12, [R6, #0]
	B third_for
	
third_for:
	CMP R5, R10		//	k < N ?
	BGE third_for_done
	MUL R7, R3, R10    //i*size(row)
	ADD R7, R7, R5   //i*size(row) + k
	ADD R7, R0, R7, LSL #3;	//A[i][k] = i*size(row) + k
	.word 0xED970B00   //FLDD D0 [R7,#0]; D0 = 8 bytes of A[i][k]
	
	///////////////////////////////////////////////////	
	MUL R8, R5, R10    //k*size(row)
	ADD R8, R8, R4   //k*size(row) + j
	ADD R8, R1, R8, LSL #3;	//B[k][j] = k*size(row) + j	
	.word 0xED981B00		//FLDD D1, [R8,#0]; D1 = 8 bytes of B[k][j]
	
	.word 0xEE202B01			//FMULD D2, D0, D1;  // A[i][k] * B[k][j] store in D2
	
	.word 0xEE3CCB02			//FADDD D12, D12, D2;  //sum = sum + A[i][k] * B[k][j]
	
	ADD R5, R5, #1   //k = k + 1
	
	B third_for
	
	
third_for_done:
	MOV R5, #0   //initizalized k for next loop
	MUL R9, R3, R10    //i*size(row)
	ADD R9, R9, R4   //i*size(row) + j
	ADD R9, R2, R9, LSL #3;	//C[i][j] = i*size(row) + j
	.word 0xED99CB00		//FLDD D12, [R9,#0]; //C[i][j] = sum **************not sure
	ADD R4, R4, #1	  // j = j + 1
	B second_for
	
	
second_for_done:
	MOV R4, #0 	//initizalized j for next loop
	ADD R3, R3, #1	   // i = i + 1
	B first_for	
	
	first_for_done:
	//////////////////////// part 2 ////////////////////////
	// Step 7: stop counters
	mov r0, #0
	MCR p15, 0, r0, c9, c12, 0 // Write 0 to PMCR to stop counters
	// Step 8-10: Select PMN0 and read out result into R3
	mov r0, #0 // PMN0
	MCR p15, 0, R0, c9, c12, 5 // Write 0 to PMSELR
	MRC p15, 0, R3, c9, c13, 2 // Read PMXEVCNTR into R3
	
	
	//////////////////////// part 1 //////////////////////// structure same above
	mov r0, #1 // PMN1
	MCR p15, 0, R0, c9, c12, 5 // Write 1 to PMSELR
	MRC p15, 0, R11, c9, c13, 2 // Read PMXEVCNTR into R11
	
	mov r0, #2 // PMN2
	MCR p15, 0, R0, c9, c12, 5 // Write 2 to PMSELR
	MRC p15, 0, R12, c9, c13, 2 // Read PMXEVCNTR into R12
	//////////////////////// part 1 ////////////////////////
	
	
	
end: b end // wait here
























