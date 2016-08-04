# Tyler Decker
# 3 aug 2016
# Tic Tac Toe


	.text
	.globl main
	
printboard:
	
	move 	$s1, $a0
	
	lw 	$t1, 0($s1)
	
	li 	$v0, 4			
	la 	$a0, space
	syscall
	
	move 	$a0, $s1		#space 1
	syscall
	
	la 	$a0, space
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 4	#space 2
	syscall
	
	la 	$a0, space
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 8
	syscall
	
	la 	$a0, newline
	syscall
	
	la 	$a0, boardmiddle
	syscall
	
	la 	$a0, newline
	syscall
		
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 12	#space 3
	syscall
	
	la 	$a0, space
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 16	#space 4
	syscall
	
	la 	$a0, space
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 20   	#space 5
	syscall
	
	la 	$a0, newline
	syscall

	la 	$a0, boardmiddle
	syscall
		
	la 	$a0, newline
	syscall
		
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 24	#space 6
	syscall
	
	la 	$a0, space
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 28	#space 7
	syscall
	
	la 	$a0, space
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 32   	#space 8
	syscall
	
	la 	$a0, newline
	syscall
	jr 	$ra
	
getinput:
	
	la 	$a0, getmovepromt
	li 	$v0, 4
	syscall
	
	li 	$v0, 5
	syscall
	jr 	$ra
	
playmove:
	move 	$s3, $ra
	move 	$s1, $a0
	jal 	getinput
	addi	$t3, $v0, -1
	
	li 	$t1, 4
	mult 	$t3, $t1
	mflo	$t2
	
	la	$t3, board
	
	add	$t2, $t2, $t3
	
	sw	$s1, 0($t2)
	
	jr 	$s3
	

changeturns:

	beq 	$s4, $s5, currentPlayerIsX
	move	$s4, $s5
	j 	endif
	
currentPlayerIsX:
	move 	$s4, $s6
	
endif:
	jr	$ra
		
main:

	li 	$v0, 4
	la 	$a0, title
	syscall
	
	addi	$s7, $zero, 9
	
	la	$t1, playerx
	lw	$s5, 0($t1)	# $s5 is global player x
	la 	$t1, playero
	lw	$s6, 0($t1)	# $s6 is global player o
				
				# TODO::  Chanage this so changeturns takes in 3 parameters. and then place $s5 into $a1, and $s6 into $a2 
	
	move	$s4, $s5	# $s4 is global currentplayer starts as X
	
	
	
loop:
	la 	$a0, board	#load start of board array into 
	
	jal 	printboard	#call printboard
	
	
	move	$a0, $s4
	jal	playmove
	
	addi 	$s7, $s7, -1
	
	ble	$s7, $zero, exitloop
	
	jal	changeturns
	j	loop
	
exitloop:	
	la	$a0, board
	jal	printboard
	

	li 	$v0, 10
	syscall
	
	
	
	.data
title:		.asciiz "\nTic Tac Toe\n\n"
space:		.asciiz " "
boardup:	.asciiz	"|"
newline:	.asciiz "\n"
boardmiddle:	.asciiz "---|---|---"

getmovepromt:	.asciiz "\nPlease enter a move: "

playerx:	.word 'X'
playero:	.word 'O'

board:		.word '1', '2', '3', '4', '5', '6', '7', '8', '9'