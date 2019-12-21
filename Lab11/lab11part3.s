/*
//#define BLOCKSIZE 32
//void do_block (int n, int si, int sj, int sk, double *A, double
// *B, double *C)
 //{
 //for (int i = si; i < si+BLOCKSIZE; ++i)
 //for (int j = sj; j < sj+BLOCKSIZE; ++j)
 //{
 //double cij = C[i+j*n];/* cij = C[i][j] */
 //for( int k = sk; k < sk+BLOCKSIZE; k++ )
 //cij += A[i+k*n] * B[k+j*n];/* cij+=A[i][k]*B[k][j] */
 //C[i+j*n] = cij;/* C[i][j] = cij */
// }
// }
 
 //void dgemm (int n, double* A, double* B, double* C)
// {
 //for ( int sj = 0; sj < n; sj += BLOCKSIZE )
 //for ( int si = 0; si < n; si += BLOCKSIZE )
 //for ( int sk = 0; sk < n; sk += BLOCKSIZE )
 //do_block(n, si, sj, sk, A, B, C);
// }
// */
 
 
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
	
	//////////////////////// part 3 ////////////////////////
	// R0 --> sj
	// R1 --> si
	// R2 --> sk
	// R3 --> A[][]
	// R4 --> B[][]
	// R5 --> C[][]
	// R6 --> N1
	.equ N1, 16  //initialize N = 16 --> 2^4
	.equ BLOCK,	32
	
	
	MOV R0, #0  //sj = 0
	MOV R1, #0  //si = 0
	MOV R2, #0  //sk = 0
	LDR R6, =N1
	
degemm_first_for:
	CMP R0, R6
	BGE first_for_done
	B degemm_second_for

degemm_second_for:
	CMP R1, R6
	BGE degemm_second_for_done
	B degemm_third_for
	
degemm_third_for:
	CMP R2, R6
	BGE degemm_third_for_done
	ADD R2, R2, #BLOCK
	SUB sp, sp, #12
	
	STR R0, [sp, #0]
	STR R1, [sp, #4]
	STR R2, [sp, #8]	
	
	BL do_block
	B degemm_third_for
	
degemm_third_for_done:
	ADD R1, R1, #BLOCK
	B degemm_second_for
	
degemm_second_for_done:
	ADD R0, R0, #BLOCK
	B first_for_done
	/////////////////////////////////////////////////////////////////
	
	// R0 --> A
	// R1 --> B
	// R2 --> C
	// R3 --> i
	// R4 --> j
	// R5 --> k
	// D12 --> Cij
	// R7 --> A[i][k]
	// R8 --> B[k][j]
	// R9 --> C[i][j]
	// R10 --> after add result1
	// R11 --> after add result2
	// R12 --> after add result3
	
	// Reference: Chapter 3 of COD4e P250~253
	sum:
	.double 0.0

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

C: 
	.double 0.0

	
	
do_block:
	.equ N, 16  //initialize N = 16 --> 2^4

	LDR R3, [sp, #4]	//i = si
	LDR R4, [sp, #0] 	//j = sj
	LDR R5, [sp, #8]  	//k = sk
	ADD  sp, sp, #12
	LDR R0, =A
	LDR R1, =B
	LDR R2, =C
	LDR R10, =N

first_for:
	ADD R10, R3, #BLOCK
	ADD R10, R10, #1	   // i = i + 1
	CMP R3, R10		//	i < N ?
	BGE first_for_done
	B second_for
	
second_for:
	ADD R11, R4, #BLOCK
	ADD R11, R11, #1	  // j = j + 1
	CMP R4, R11		// j < N ?
	BGE second_for_done
	B third_for
	
third_for:
	ADD R12, R5, #BLOCK
	CMP R5, R12		//	k < N ?
	BGE third_for_done
	MUL R7, R3, R10    //i*size(row)
	ADD R7, R7, R5   //i*size(row) + k
	ADD R7, R0, R7, LSL #3;	//A[i][k] = i*size(row) + k
	.word 0xED970B00			//FLDD D0 [R7,#0]; D0 = 8 bytes of A[i][k]
	
	///////////////////////////////////////////////////
	
	MUL R8, R5, R10    //k*size(row)
	ADD R8, R8, R4   //k*size(row) + j
	ADD R8, R1, R8, LSL #3;	//B[k][j] = k*size(row) + j	
	.word 0xED981B00			//FLDD D1, [R8,#0]; D1 = 8 bytes of B[k][j]
	
	.word 0xEE202B01			//FMULD D2, D0, D1;  // A[i][k] * B[k][j] store in D2
	
	.word 0xEE3CCB02			//FADDD D12, D12, D2;  //Cij = Cij + A[i][k] * B[k][j]
	
	ADD R5, R5, #1   //k = k + 1
	
	B third_for
	
	
third_for_done:
	MUL R9, R3, R10    //i*size(row)
	ADD R9, R9, R4   //i*size(row) + j
	ADD R9, R0, R9, LSL #3;	//C[i][j] = i*size(row) + j
	.word 0xED99CB00			//FLDD D12, [R9,#0]; //C[i][j] = Cij **************not sure
	
	B second_for
	
	
second_for_done:
	
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






















