.model small
.stack 100h
.data	
	input db 1,2,3,4,5,6,7,8,9,10		
	LEN EQU 10
	
.code
main proc
mov ax, @data
mov ds, ax

mov cx, 0
mov si, offset input
loop_array: 
	cmp cl, LEN
	push cx
	jge end_loop
	
	push [si]
	
	call DNUM
	call PRINTINT	; passing return value from DNUM (in stack) to PRINTINT function.
	
	; code to print new lint
	mov ah, 02				
	mov dl, 13				
	int 21h				
	mov dl, 10				
	int 21h

	pop cx
	inc cl
	inc si
	jmp loop_array
	
end_loop:


mov ah, 4ch
int 21h
main endp

DNUM proc
	push bp
	mov bp, sp
	
	mov ax, 0
	mov ax, [bp+4]
	
	; comparing n=0
	cmp al, 0
	je first_condition

	; comparing n=1 or n=2
	cmp al, 1
	je second_condition
	cmp al, 2
	je second_condition
	
	; third condition, n>=3
	
	;calculating D(n-1)
	mov cx, 0
	mov cl, al
	sub cl, 1
	push cx
	call DNUM
	;calculating D(D(n-1)) 
	call DNUM
	;D(D(n-1)) is stored in STACK 
	
	;calculating D(n-2)
	mov bx, 0
	mov ax, [bp+4]
	mov bl, al
	sub bl, 2
	push bx 
	call DNUM
	;storing D(n-2) in bx
	pop bx
	
	;calculating D(n-1-D(n-2))
	mov ax, [bp+4]
	sub ax, 1
	sub ax, bx
	push ax 
	call DNUM
	;storing D(n-1-D(n-2)) in bx
	pop ax
	
	; calculating D(D(n-1))+D(n-1-D(n-2)) in AX
	pop cx	; getting value of  D(D(n-1)) from stack. (was reserved in stack at line (69-70)
	add ax, cx
	jmp end_DNUM
	
	first_condition:
		mov ax, 0
		jmp end_DNUM
		
	second_condition:
		mov ax, 1
		jmp end_DNUM
	
	end_DNUM:
		; preparing stack frame. storing return value before BP and return address and input value. 
		pop bx
		pop cx
		pop dx
		push ax
		push dx
		push cx
		push bx

pop bp
ret 2
DNUM endp 

PRINTINT proc
	push bp
	mov bp, sp
	
	mov cl, 0
	mov al, [bp+4]
	
	mov ah, 02
	mov dl, al
	add dl, '0'
	int 21h 
	
mov sp, bp
pop bp
ret 2
PRINTINT endp

 
end main
