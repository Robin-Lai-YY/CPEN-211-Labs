//r0 *numbers
//r1 key
//r2 startIndex
//r3 endIndex
//r8 NumCalls

//r4 middleIndex
//r5 keyIndex
//r6 numbers[middleIndex]
//r13 stack pointer
//r14 link register



.globl binary_search
binary_search:
	SUB sp, sp, #32
	STR r5, [sp, #28] //keyIndex #28
	STR r4, [sp, #24] //middleIndex #24
	STR lr, [sp, #20] //link register
	STR r3, [sp, #16] //;endIndex
	STR r2, [sp, #12]  //;startIndex
	STR r1, [sp, #8]  //;key
	STR r0, [sp, #4]  //;*numbers
	STR r8, [sp, #0] //;NumCalls

	SUB r4, r3, r2   //middle = r4 = endIndex - startIndex
	ADD r4, r2, r4, LSR#1  //;r4 = middleIndex = startIndex + (r4)/2
	STR r4, [sp, #24] //;store middle to #24
	
	//LDR r8, [sp, #0]  //;read NumCalls
	
	ADD r8, r8, #1     //;NumCalls = NumCalls + 1
	STR r8, [sp, #0] //;store NumCalls to #0
	
	//LDR r3, [sp, #16]  //;read endIndex
	//LDR r2, [sp, #12]   //;read startIndex
	
	CMP r2, r3  //compare startIndex and endIndex
	BGT B1    //;if(startIndex > endIndex) go L1

	LDR r6, [r0, r4, LSL #2]  //;put the value of numbers[middleIndex] to r6
	
	CMP r6, r1  //comapre r6(numbers[middleIndex]) to key
	
	BEQ B2   //;else if (numbers[middleIndex] == key)
	
	BGT B3   //;else if (numbers[middleIndex] > key)

	BLT B4   //;else if (numbers[middleIndex] < key)

	B B5     //; go return state

B1:
	MOV r9, #-1
	MOV r0, r9 // why it is 0 after compiling ??? and also why r0 instead other register??? Credit: ss9 from Prof.Tor page 82
	
	LDR r8, [sp, #0] //;NumCalls
	LDR r0, [sp, #4]  //;*numbers	
	LDR r1, [sp, #8]  //;key
	LDR r2, [sp, #12]  //;startIndex
	LDR r3, [sp, #16] //;endIndex
	LDR lr, [sp, #20] //link register
	LDR r4, [sp, #24] //middleIndex #24
	LDR r5, [sp, #28] //keyIndex #28
	ADD sp, sp, #32
	MOV pc, lr 

B2:
	LDR r4, [sp, #24] //middle
	MOV r5, r4  //;put the value for middleIndex(r4,#24) to keyindex(#28)
	MOV r9, r5 
	B B5
	
B3:
	SUB r4, r4, #1     //;middleIndex = middleIndex - 1
	MOV r3, r4         //;r3:endIndex   r4:middleIndex  r4 --> r3		
	BL binary_search
	B B5
	
B4:
	ADD r4, r4, #1     //;middleIndex = middleIndex + 1
	MOV r2, r4         //;r2:startIndex   r4:middleIndex  r4 --> r2		
	BL binary_search
	B B5
	
B5:	
	
	//MOV r7, r5 //keep the value of r0
	
	MVN r8, r8   //;r8 = -r8
	ADD r8, r8, #1;
	
	
	MOV r6, r8  //numbers[middleIndex] = -NumCalls
	
	
	LDR r8, [sp, #0] //;NumCalls
	LDR r0, [sp, #4]  //;*numbers	
	LDR r1, [sp, #8]  //;key
	LDR r2, [sp, #12]  //;startIndex
	LDR r3, [sp, #16] //;endIndex
	LDR lr, [sp, #20] //link register
	LDR r4, [sp, #24] //middleIndex #24
	LDR r5, [sp, #28] //keyIndex #28
	
	ADD sp, sp, #32
	
	MOV r0, r9 
	
	
	MOV pc, lr
	
	
























