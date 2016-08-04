# Tyler Decker
# 3 aug 2016
# Tic Tac Toe

#  
# Register use:
#
#  This register list does not include tempory regiesters
#
#		main			
#		----------------	
#	$a0	syscall parameter	
#	$a1
#	$a2
#	$a3

#	$v0 	syscall parameter
#	
#	$s1	current player
#	$s2	
#	$s3
#	$s4
#	$s5
#	$s6
#	$s7	moves remaining

#		printboard
#		---------------
#	$a0	memmory address of start of board array
#
#
#		getinput 
#		--------------
#	$v0	return value, the integer that the user entered
#
		

	.text
	.globl main
	
printboard:
					# **********
					# TODO:: this is aweful with repitition 
					# 	 figure out a way to make this less instructions
	
	move 	$s1, $a0		# move argument 0 into saved register 1
	
	li 	$v0, 4			# this is set to tell the system call that it should print a char array
	la 	$a0, space		# load address of space into argument 0 for system call to print
	syscall					
	
	move 	$a0, $s1		# load address of space 1 into argument 0 for system call to print
	syscall
	
	la 	$a0, space		
	syscall
	
	la 	$a0, boardup		# load address of boardup into argument 0 for system call to print	
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 4		#space 2
	syscall
	
	la 	$a0, space		
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 8		#space 3
	syscall
	
	la 	$a0, newline
	syscall
	
	la 	$a0, boardmiddle
	syscall
	
	la 	$a0, newline
	syscall
		
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 12	#space 4
	syscall
	
	la 	$a0, space
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 16	#space 5
	syscall
	
	la 	$a0, space
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 20   	#space 6
	syscall
	
	la 	$a0, newline
	syscall

	la 	$a0, boardmiddle
	syscall
		
	la 	$a0, newline
	syscall
		
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 24	#space 7
	syscall
	
	la 	$a0, space
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 28	#space 8
	syscall
	
	la 	$a0, space
	syscall
	
	la 	$a0, boardup
	syscall
	
	la 	$a0, space
	syscall
	
	addi 	$a0, $s1, 32   	#space 9
	syscall
	
	la 	$a0, newline
	syscall
	
	jr 	$ra		# return
	
getinput:
	
	la 	$a0, getmovepromt	# load address of getmoveprompt into arg 0 for system call
	li 	$v0, 4			# set it so system call will print char array
	syscall	
	
	li 	$v0, 5			# set system call to input int
	syscall				# the inputed int will be stored in $v0 
					# no need to move returned value as this func will return right after
	jr 	$ra			# return 
	
playmove:
	move 	$s3, $ra	# not the proper way to do this. 
				# Todo:: change this so that $sp is ajusted and $ra is stored on stack
				# and then moved back into $ra before jr is called
	move 	$s1, $a0
	jal 	getinput	# call getinput return value will be in $v0
	addi	$t3, $v0, -1	# set $t3 to the user input minus 1
	
				# calcuate the memmory index of the board array to change
	li 	$t1, 4		# set $t1 to 4
	mult 	$t3, $t1	# multiple user choice by 4
	mflo	$t2		# multiplication gets put into a special register move that results into $t2
	
	la	$t3, board	# load the address of board array into $t3
	
	add	$t2, $t2, $t3	# add the offset of user choice to the base address of the array
	
	sw	$s1, 0($t2)	# write the current player into the address in $t2
	
	jr 	$s3		# return
	

changeturns:

	beq 	$s4, $s5, currentPlayerIsX	# if current_player = X goto currentPlayerIsX
	move	$s4, $s5			# change current player to x
	j 	endif				# got endif
	
currentPlayerIsX:
	move 	$s4, $s6			# change current player to o
	
endif:
	jr	$ra				# return
		
main:

	li 	$v0, 4		# set system call to print char array
	la 	$a0, title	# load address of title into arg 0 for system call
	syscall
	
	addi	$s7, $zero, 9   # int moves_remaining = 9
	
	la	$t1, playerx
	lw	$s5, 0($t1)	# $s5 is global player x
	la 	$t1, playero
	lw	$s6, 0($t1)	# $s6 is global player o
				
				# TODO::  Chanage this so changeturns takes in 3 parameters. and then place $s5 into $a1, and $s6 into $a2 
	
	move	$s4, $s5	# $s4 is global currentplayer starts as X
	
	
	
loop:
	la 	$a0, board	#load start of board array into 
	
	jal 	printboard	#call printboard(board_array)
	
	
	move	$a0, $s4	# place current player into 
	jal	playmove	# call function playmove(currentPlayer)
	
	addi 	$s7, $s7, -1	# moves_remaing = moves_remaining - 1
	
	ble	$s7, $zero, exitloop	# if moves_remaing <= 0 goto exit the loop
	
	jal	changeturns	# call function changeturns()
	j	loop		# goto loop
	
exitloop:	
	la	$a0, board	# load address of board array to arg 0 for printboard()
	jal	printboard	# printboard(board[])
	

	li 	$v0, 10		# set system call to exit
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
