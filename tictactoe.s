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
#
#	$v0 	syscall parameter
#
#	$s0	current player
#	$s1	player1 symbol
#	$s2	player2 symbol
#	$s3
#	$s4
#	$s5
#	$s6
#	$s7	moves remaining
#
#		printboard
#		---------------
#	$s0	memmory address of start of board array
#
#		printboard_row
#		---------------
#	$s0	memory address of start of row
#
#		change_turns
#		---------------
#	$a0	current player
#	$a1	player 1
#	$a2	player 2
#
#		getinput
#		--------------
#	$v0	return value, the integer that the user entered
#


	.text
	.globl main

print_new_line:
	li 	$v0, 4
	la 	$a0, newline
	syscall
	jr	$ra

print_space:
	li 	$v0, 4
	la 	$a0, space
	syscall
	jr	$ra

print_board_up:  	# TODO - rename this to something more clear
	li 	$v0, 4
	la 	$a0, boardup	# load address of boardup into argument 0 for system call to print
	syscall
	jr	$ra

printboard_middle:
	addi	$sp, $sp -4	# adjust stack to
	sw	$ra, 0($sp)	# save return address

	li	$v0, 4
	la 	$a0, boardmiddle
	syscall
	jal	print_new_line

	lw	$ra, 0($sp)	# restore return address
	addi	$sp, $sp, 4
	jr 	$ra

printboard_row:

	addi 	$sp, $sp, -8	# make room on the stack to save reg $s0
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)	# add $s0 to the stack

	move 	$s0, $a0	# Move argument 0 (address of start of row) into $t0

	jal	print_space

	li 	$v0, 4		# this is set to tell the system call that it should print a char array
	move 	$a0, $s0	# load address of space 1 of row into argument 0 for system call to print
	syscall

	jal	print_space
	jal	print_board_up
	jal	print_space

	li 	$v0, 4		# this is set to tell the system call that it should print a char array
	addi 	$a0, $s0, 4	#space 2 of row
	syscall

	jal	print_space
	jal	print_board_up
	jal	print_space

	li 	$v0, 4		# this is set to tell the system call that it should print a char array
	addi 	$a0, $s0, 8	#space 3 of row
	syscall

	jal	print_new_line

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	addi 	$sp, $sp, 8

	jr	$ra

printboard:
	addi 	$sp, $sp, -8	# make room on the stack for Renturn address and save current value in $s0
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)

	move 	$s0, $a0	# move argument 0 into saved register $s0 as we will need this after other function calls
	jal	printboard_row
	jal	printboard_middle

	addi	$a0, $s0, 12  	# move address of start of row 2 into argument zero
	jal 	printboard_row
	jal	printboard_middle

	addi	$a0, $s0, 24 	# move address of start of row 3 into argumetn zero
	jal 	printboard_row

	lw	$ra, 0($sp)	#restore save zero and return address registers
	lw	$s0, 4($sp)
	addi	$sp, $sp, 8
	jr 	$ra		# return

getinput:

	la 	$a0, str_getmovepromt	# load address of getmoveprompt into arg 0 for system call
	li 	$v0, 4			# set it so system call will print char array
	syscall

	li 	$v0, 5			# set system call to input int
	syscall				# the inputed int will be stored in $v0
					# no need to move returned value as this func will return right after
	jr 	$ra			# return

playmove:
	addi 	$sp, $sp -8
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)

	move 	$s0, $a0	# placed current player agrument into saved reg 0
	jal 	getinput	# call getinput return value will be in $v0
	addi	$t3, $v0, -1	# set $t3 to the user input minus 1

				# calcuate the memmory index of the board array to change
	li 	$t1, 4		# set $t1 to 4
	mult 	$t3, $t1	# multiple user choice by 4
	mflo	$t2		# multiplication gets put into a special register move the results into $t2

	la	$t4, board	# load the address of board array into $t4

	add	$t2, $t2, $t4	# add the offset of user choice to the base address of the array

	sw	$s0, 0($t2)	# write the current player into the address in $t2

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	addi	$sp, $sp 8
	jr 	$ra		# return


changeturns:
		# $a0 = current_player
		# $a1 = player 1 symbol
		# $a2 = player 2 symbol

	beq 	$a0, $a1, current_player_is_player_one	#if current player = player1 goto current_player_is_one
	move	$v0, $a1	#return player 1
	j 	endif_current_player

current_player_is_player_one:
	move 	$v0, $a2	#return player 2

endif_current_player:
	jr	$ra				# return


print_display:

	addi	$sp, $sp -4
	sw	$ra, 0($sp)

	li 	$v0, 4		# set system call to print char array
	la 	$a0, str_title	# load address of title into arg 0 for system call
	syscall

	la	$v0, 4
	la 	$a0, str_legend

	syscall

	la 	$a0, key	#load start of board array into
	jal 	printboard	#call printboard(board_array)

	la	$v0, 4
	la	$a0, newline
	syscall

	la	$v0, 4
	la 	$a0, str_board
	syscall

	la 	$a0, board	#load start of board array into
	jal 	printboard	#call printboard(board_array)

	lw	$ra, 0($sp)
	addi	$sp, $sp 4

	jr	$ra
main:

	addi	$s7, $zero, 9   # int moves_remaining = 9

	la	$t1, playerx	# load memmory address of playerx into $t1
	lw	$s1, 0($t1)	# $s1 is player x
	la 	$t1, playero	# load memmory address of playero into $t1
	lw	$s2, 0($t1)	# $s2 is player o

	move	$s0, $s2	# $s0 is currentplayer & starts as X

loop:

	jal	print_display

	move	$a0, $s0 	# place current player into argument zero
	jal	playmove	# call function playmove(currentPlayer)

	addi 	$s7, $s7, -1	# moves_remaing = moves_remaining - 1

	ble	$s7, $zero, exitloop	# if moves_remaing <= 0 goto exit the loop

	move	$a0, $s0
	move	$a1, $s1
	move 	$a2, $s2
	jal	changeturns	# call function changeturns()
	move	$s0, $v0	# set current_player to return of changeturns()
	j	loop		# goto loop

exitloop:
	jal	print_display	# printboard(board[])

	li 	$v0, 10		# set system call to exit
	syscall


	.data
str_title:	.asciiz "\nTic Tac Toe\n\n"
str_legend:	.asciiz "\n   Legend\n"
str_board:	.asciiz "\n   Game\n"
space:		.asciiz " "
boardup:	.asciiz	"|"
newline:	.asciiz "\n"
boardmiddle:	.asciiz "---|---|---"

str_getmovepromt:	.asciiz "\nPlease enter a move: "

playerx:	.word 'X'
playero:	.word 'O'

board:		.word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
key:		.word '1', '2', '3', '4', '5', '6', '7', '8', '9'
