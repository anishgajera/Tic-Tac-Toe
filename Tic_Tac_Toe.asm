# Bitmap Project 
# Written by Anish Gajera on 04/05/2022 for CS 2340.002
# Tic-Tac-Toe Game

# This game uses the bitmap display and keyboard simulator to allow the user to play a game of Tic-Tac-Toe
# The following "diagram" shows which keys can be used to play the game (diagram of TTT Grid):
# Numeric keypad (on most keyboards, if not on your computer, you can still play same way using keys above character keys)
#  7 | 8 | 9
# -----------
#  4 | 5 | 6
# -----------
#  1 | 2 | 3

# set up and connect the bitmap display to MIPS accordingly
# set up and connect the keyboard/MMIO simulator to MIPS accordingly
# load in initial values for height, width, memory, and the colors
# width of bitmap screen (256 / 4 = 64)
.eqv	WIDTH 64
# height of bitmap screen
.eqv	HEIGHT 64
# memory address of a pixel in bitmap screen
.eqv	MEM 0x545400 

# colors used in the game/bitmap display
.eqv	BLUE	0x000000FF
.eqv	RED 	0x00FF0000
.eqv	WHITE 	0x00FFFFFF
.eqv	GREEN 	0x0000FF00

# .data section begins here
.data
# string output if the winner is X
X_win:		.asciiz "X is the winner!"
# string output if the winner is O
O_win:		.asciiz "O is the Winner!"
# string output if its a tie game
TIE_GAME:	.asciiz "Tie game! Fair play."

# .text section begins here
.text
main:
	
	li	$t0, 0	# $t0 is counter for loop
	li	$t1, 30 # $t1 is loop check counter
	li	$t2, 10 # $t2 is loop X left diagonal counter
	li	$t3, 10 # $t3 is loop X right diagonal counter
	li	$t4, 2 	# $t4 is O check counter
	
	# integer values to check for winner (1 for X, 2 for O)
	# each of these registers gets updated with the corresponding value of either 1 or 2 based on how the winner (either X or O) ends up winning the game
	li	$s0, 0
	li	$s1, 0 
	li	$s2, 0
	li	$s3, 0
	li	$s4, 0
	li	$s5, 0
	li	$s6, 0
	li	$s7, 0
	li	$v1, 0
	
	# setup to call subroutine to draw pixel in bitmap display
	addi 	$a0, $0, WIDTH	# $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1	# increment by 1
	addi 	$a1, $0, HEIGHT	# $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	addi 	$a2, $0, WHITE  # $a2 = WHITE (0x00FFFFFF)
	
	addi	$a0, $a0, 5
	addi	$a1, $a1, 15
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	

# draw left line of TTT grid
drawLeft:
	beq	$t0, $t1, reset1
	addi	$a1, $a1, -1
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	drawLeft
# reset variables/registers
reset1:
	
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	addi	$a0, $a0, 15
	subi	$a1, $a1, 5
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	
# draw right line of TTT grid
drawRight:
	beq	$t0, $t1, reset2
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	drawRight
#reset variables/registers
reset2:
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	subi	$a0, $a0, 5
	addi	$a1, $a1, 15
	jal	draw_pixel
	
# draw top line of TTT grid
draw_grid_Top:
	beq	$t0, $t1, reset3
	subi	$a0, $a0, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_grid_Top
# reset variables/registers
reset3:
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	addi	$a0, $a0, 15
	addi	$a1, $a1, 5
	jal	draw_pixel
	
# draw bottom line of TTT grid
draw_grid_btm:
	beq	$t0, $t1, reset4
	subi	$a0, $a0, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_grid_btm
#reset variables/registers
reset4:
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
#start first player move (for X)
firstMove:
	lw $t0, 0xffff0000 # $t0 holds available input
    	beq $t0, 0, reset4 # if $t0 = 0 (i.e. no input from user) then jump to reset4 which continuously redraws the TTT grid
	# below is the code which takes input into the MMIO simulator (keyboard) and calls the necessary functions based on which key is pressed for X player's first move
	lw 	$a3, 0xffff0004
	beq	$a3, 32, exit		# space = 32
	beq	$a3, 55, topLeft	# 7 = 55
	beq	$a3, 56, topCenter	# 8 = 56
	beq	$a3, 57, topRight	# 9 = 57
	beq	$a3, 52, midLeft	# 4 = 52
	beq	$a3, 53, midCenter	# 5 = 53
	beq	$a3, 54, midRight	# 6 = 54
	beq	$a3, 49, btmLeft	# 1 = 49
	beq	$a3, 50, btmCenter	# 2 = 50
	beq	$a3, 51, btmRight	# 3 = 51
	j	firstMove		# if you fall through all cases, jump back to firstMove till a first move is made by X
	
# functions below are for which move player x ends up making (code above jumps to one of these accordingly)
topLeft:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 15
	addi	$s0, $s0, 1
	j	draw_X_left
midLeft:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 5
	addi	$s3, $s3, 1
	j	draw_X_left
btmLeft:
	subi	$a0, $a0, 15
	addi	$a1, $a1, 5
	addi	$s6, $s6, 1
	j	draw_X_left
topCenter:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s1, $s1, 1
	j	draw_X_left
midCenter:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s4, $s4, 1
	j	draw_X_left
btmCenter:
	subi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$s7, $s7, 1
	j	draw_X_left
topRight:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s2, $s2, 1
	j	draw_X_left
midRight:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s5, $s5, 1
	j	draw_X_left
btmRight:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$v1, $v1, 1
	j	draw_X_left

# draw x left side	
draw_X_left:
	beq	$t0, $t2, X_reset
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_X_left
# draw X right side
draw_X_right:
	beq	$t0, $t2, X_finish
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_X_right
	
# reset the variables after first move
X_reset:
	addi	$t0, $0, 0
	subi 	$a1, $a1, 10
# reset variables once finished
X_finish:
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	jal	top_win_X

# start second player move (for O)
secondMove:
	lw $t0, 0xffff0000 # $t0 holds available input
    	beq $t0, 0, secondMove # if $t0 = 0 (i.e. no input from user) then jump to secondMove which continuously waits for second move from O
	lw 	$a3, 0xffff0004
	beq	$a3, 32, exit		# space = 32
	beq	$a3, 55, topLeft2	# 7 = 55
	beq	$a3, 56, topCenter2	# 8 = 56
	beq	$a3, 57, topRight2	# 9 = 57
	beq	$a3, 52, midLeft2	# 4 = 52
	beq	$a3, 53, midCenter2	# 5 = 53
	beq	$a3, 54, midRight2	# 6 = 54
	beq	$a3, 49, btmLeft2	# 1 = 49
	beq	$a3, 50, btmCenter2	# 2 = 50
	beq	$a3, 51, btmRight2	# 3 = 51
	j secondMove			# if you fall through all cases, jump back to secondMove till a second move is made by O
	
# functions below are for which move player O ends up making (code above jumps to one of these accordingly)
topLeft2:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 15
	addi	$s0, $s0, 2
	j	draw_O_TLeft
midLeft2:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 5
	addi	$s3, $s3, 2
	j	draw_O_TLeft
btmLeft2:
	subi	$a0, $a0, 15
	addi	$a1, $a1, 5
	addi	$s6, $s6, 2
	j	draw_O_TLeft
topCenter2:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s1, $s1, 2
	j	draw_O_TLeft
midCenter2:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s4, $s4, 2
	j	draw_O_TLeft
btmCenter2:
	subi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$s7, $s7, 1
	j	draw_O_TLeft
topRight2:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s2, $s2, 2
	j	draw_O_TLeft
midRight2:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s5, $s5, 2
	j	draw_O_TLeft
btmRight2:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$v1, $v1, 1
	j	draw_O_TLeft
	
# draw O
draw_O_TLeft:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 1
begin_TLeft:
	beq	$t0, $t4, draw_O_left_side
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	begin_TLeft
draw_O_left_side:
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel	
	addi	$t0, $0, 0	
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
begin_btmLeft:
	beq	$t0, $t4, draw_O_btm
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	begin_btmLeft
draw_O_btm:
	addi	$t0, $0, 0
	addi	$a0, $a0, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
draw_O_btmRight:
	beq	$t0, $t4, draw_O_centerRight
	addi	$a0, $a0, 1
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_O_btmRight
draw_O_centerRight:
	addi	$t0, $0, 0
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
draw_O_topRight:
	beq	$t0, $t4, O_finish
	subi	$a0, $a0, 1
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_O_topRight
# reset variables once finished
O_finish:	
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	jal	top_win_O
# 3rd move (for X)
thirdMove:
	lw $t0, 0xffff0000 # $t0 holds available input
    	beq $t0, 0, thirdMove # if $t0 = 0 (i.e. no input from user) then jump to thirdMove which waits for input
	
	lw 	$a3, 0xffff0004
	beq	$a3, 32, exit		# space = 32
	beq	$a3, 55, topLeft3	# 7 = 55
	beq	$a3, 56, topCenter3	# 8 = 56
	beq	$a3, 57, topRight3	# 9 = 57
	beq	$a3, 52, midLeft3	# 4 = 52
	beq	$a3, 53, midCenter3	# 5 = 53
	beq	$a3, 54, midRight3	# 6 = 54
	beq	$a3, 49, btmLeft3	# 1 = 49
	beq	$a3, 50, btmCenter3	# 2 = 50
	beq	$a3, 51, btmRight3	# 3 = 51
	j thirdMove			# if you fall through all cases, jump back to thirdMove till the third move is made by X
	
# functions below are for which move player X ends up making (code above jumps to one of these accordingly)
topLeft3:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 15
	addi	$s0, $s0, 1
	j	draw_X_left2
midLeft3:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 5
	addi	$s3, $s3, 1
	j	draw_X_left2
btmLeft3:
	subi	$a0, $a0, 15
	addi	$a1, $a1, 5
	addi	$s6, $s6, 1
	j	draw_X_left2
topCenter3:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s1, $s1, 1
	j	draw_X_left2
midCenter3:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s4, $s4, 1
	j	draw_X_left2
btmCenter3:
	subi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$s7, $s7, 1
	j	draw_X_left2
topRight3:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s2, $s3, 1
	j	draw_X_left2
midRight3:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s5, $s5, 1
	j	draw_X_left2
btmRight3:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$v1, $v1, 1
	j	draw_X_left2
	
# draw X
draw_X_left2:
	beq	$t0, $t2, X_reset2
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_X_left2
# reset variables once finished
X_reset2:
	addi	$t0, $0, 0
	subi 	$a1, $a1, 10
draw_X_right2:
	beq	$t0, $t2, X_finish2
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_X_right2
# reset variables once finished
X_finish2:
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	jal	top_win_X

# 4th move (for O)
fourthMove:
	lw $t0, 0xffff0000 # $t0 holds available input
    	beq $t0, 0, fourthMove # if $t0 = 0 (i.e. no input from user) then jump to fourthMove which waits for input
	
	lw 	$a3, 0xffff0004
	beq	$a3, 32, exit		# space = 32
	beq	$a3, 55, topLeft4	# 7 = 55
	beq	$a3, 56, topCenter4	# 8 = 56
	beq	$a3, 57, topRight4	# 9 = 57
	beq	$a3, 52, midLeft4	# 4 = 52
	beq	$a3, 53, midCenter4	# 5 = 53
	beq	$a3, 54, midRight4	# 6 = 54
	beq	$a3, 49, btmLeft4	# 1 = 49
	beq	$a3, 50, btmCenter4	# 2 = 50
	beq	$a3, 51, btmRight4	# 3 = 51
	j fourthMove			# if you fall through all cases, jump back to fourthMove till a fourth move is made by O
	
# functions below are for which move player O ends up making (code above jumps to one of these accordingly)
topLeft4:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 15
	addi	$s0, $s0, 2
	j	draw_O_TLeft2
midLeft4:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 5
	addi	$s3, $s3, 2
	j	draw_O_TLeft2
btmLeft4:
	subi	$a0, $a0, 15
	addi	$a1, $a1, 5
	addi	$s6, $s6, 2
	j	draw_O_TLeft2
topCenter4:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s1, $s1, 2
	j	draw_O_TLeft2
midCenter4:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s4, $s4, 2
	j	draw_O_TLeft2
btmCenter4:
	subi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$s7, $s7, 2
	j	draw_O_TLeft2
topRight4:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s2, $s2, 2
	j	draw_O_TLeft2
midRight4:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s5, $s5, 2
	j	draw_O_TLeft2
btmRight4:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$v1, $v1, 0
	j	draw_O_TLeft2
# draw O
draw_O_TLeft2:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 1
begin_TLeft2:
	beq	$t0, $t4, draw_O_left_side2
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	begin_TLeft2
draw_O_left_side2:
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel	
	addi	$t0, $0, 0	
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
begin_btmLeft2:
	beq	$t0, $t4, draw_O_btm2
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	begin_btmLeft2
draw_O_btm2:
	addi	$t0, $0, 0
	addi	$a0, $a0, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
draw_O_btmRight2:
	beq	$t0, $t4, draw_O_centerRight2
	addi	$a0, $a0, 1
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_O_btmRight2
draw_O_centerRight2:
	addi	$t0, $0, 0
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
draw_O_topRight2:
	beq	$t0, $t4, O_finish2
	subi	$a0, $a0, 1
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_O_topRight2
O_finish2:	#reset variables
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	jal	top_win_O
	
# 5th move (for X)
fifthMove:
	lw $t0, 0xffff0000 # $t0 holds available input
    	beq $t0, 0, fifthMove # if $t0 = 0 (i.e. no input from user) then jump to fifthMove which waits for input
	
	lw 	$a3, 0xffff0004
	beq	$a3, 32, exit		# space = 32
	beq	$a3, 55, topLeft5	# 7 = 55
	beq	$a3, 56, topCenter5	# 8 = 56
	beq	$a3, 57, topRight5	# 9 = 57
	beq	$a3, 52, midLeft5	# 4 = 52
	beq	$a3, 53, midCenter5	# 5 = 53
	beq	$a3, 54, midRight5	# 6 = 54
	beq	$a3, 49, btmLeft5	# 1 = 49
	beq	$a3, 50, btmCenter5	# 2 = 50
	beq	$a3, 51, btmRight5	# 3 = 51
	j fifthMove			# if you fall through all cases, jump back to fifthMove till a fifth move is made by X

# functions below are for which move player X ends up making (code above jumps to one of these accordingly)
topLeft5:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 15
	addi	$s0, $s0, 1
	j	draw_X_left3
midLeft5:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 5
	addi	$s3, $s3, 1
	j	draw_X_left3
btmLeft5:
	subi	$a0, $a0, 15
	addi	$a1, $a1, 5
	addi	$s6, $s6, 1
	j	draw_X_left3
topCenter5:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s1, $s1, 1
	j	draw_X_left3
midCenter5:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s4, $s4, 1
	j	draw_X_left3
btmCenter5:
	subi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$s7, $s7, 1
	j	draw_X_left3
topRight5:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s2, $s2, 1
	j	draw_X_left3
midRight5:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s5, $s5, 1
	j	draw_X_left3
btmRight5:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$v1, $v1, 1
	j	draw_X_left3
# draw X 
draw_X_left3:
	beq	$t0, $t2, X_reset3
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_X_left3
# reset variables once finished
X_reset3:
	addi	$t0, $0, 0
	subi 	$a1, $a1, 10
draw_X_right3:
	beq	$t0, $t2, X_finish3
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_X_right3
# reset variables once finished and check for winner
X_finish3:
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	jal	top_win_X

# 6th move (for O)
sixthMove:
	lw $t0, 0xffff0000 # $t0 holds available input
    	beq $t0, 0, sixthMove # if $t0 = 0 (i.e. no input from user) then jump to sixthMove which waits for input
	
	lw 	$a3, 0xffff0004
	beq	$a3, 32, exit		# space = 32
	beq	$a3, 55, topLeft6	# 7 = 55
	beq	$a3, 56, topCenter6	# 8 = 56
	beq	$a3, 57, topRight6	# 9 = 57
	beq	$a3, 52, midLeft6	# 4 = 52
	beq	$a3, 53, midCenter6	# 5 = 53
	beq	$a3, 54, midRight6	# 6 = 54
	beq	$a3, 49, btmLeft6	# 1 = 49
	beq	$a3, 50, btmCenter6	# 2 = 50
	beq	$a3, 51, btmRight6	# 3 = 51
	j sixthMove			# if you fall through all cases, jump back to sixthMove till a sixth move is made by O
	
# functions below are for which move player O ends up making (code above jumps to one of these accordingly)
topLeft6:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 15
	addi	$s0, $s0, 2
	j	draw_O_TLeft3
midLeft6:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 5
	addi	$s3, $s3, 2
	j	draw_O_TLeft3
btmLeft6:
	subi	$a0, $a0, 15
	addi	$a1, $a1, 5
	addi	$s6, $s6, 2
	j	draw_O_TLeft3
topCenter6:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s1, $s1, 2
	j	draw_O_TLeft3
midCenter6:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s4, $s4, 2
	j	draw_O_TLeft3
btmCenter6:
	subi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$s7, $s7, 2
	j	draw_O_TLeft3
topRight6:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s2, $s2, 2
	j	draw_O_TLeft3

midRight6:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s5, $s5, 2
	j	draw_O_TLeft3
btmRight6:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$v1, $v1, 2
	j	draw_O_TLeft3
# draw O
draw_O_TLeft3:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 1
begin_TLeft3:
	beq	$t0, $t4, draw_O_left_side3
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	begin_TLeft3
draw_O_left_side3:
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel	
	addi	$t0, $0, 0	
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
begin_btmLeft3:
	beq	$t0, $t4, draw_O_btm3
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	begin_btmLeft3
draw_O_btm3:
	addi	$t0, $0, 0
	addi	$a0, $a0, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
draw_O_btmRight3:
	beq	$t0, $t4, draw_O_centerRight3
	addi	$a0, $a0, 1
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_O_btmRight3
draw_O_centerRight3:
	addi	$t0, $0, 0
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
draw_O_topRight3:
	beq	$t0, $t4, O_finish3
	subi	$a0, $a0, 1
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_O_topRight3
# reset variables once finished and check for winner
O_finish3:
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	jal	top_win_O
	
# 7th move (for X)
seventhMove:
	lw $t0, 0xffff0000 # $t0 holds available input
    	beq $t0, 0, seventhMove # if $t0 = 0 (i.e. no input from user) then jump to seventhMove which waits for input
	
	lw 	$a3, 0xffff0004
	beq	$a3, 32, exit		# space = 32
	beq	$a3, 55, topLeft7	# 7 = 55
	beq	$a3, 56, topCenter7	# 8 = 56
	beq	$a3, 57, topRight7	# 9 = 57
	beq	$a3, 52, midLeft7	# 4 = 52
	beq	$a3, 53, midCenter7	# 5 = 53
	beq	$a3, 54, midRight7	# 6 = 54
	beq	$a3, 49, btmLeft7	# 1 = 49
	beq	$a3, 50, btmCenter7	# 2 = 50
	beq	$a3, 51, btmRight7	# 3 = 51
	j seventhMove			# if you fall through all cases, jump back to fseventhMove till a seventh move is made by X
	
# functions below are for which move player X ends up making (code above jumps to one of these accordingly)
topLeft7:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 15
	addi	$s0, $s0, 1
	j	draw_X_left4
midLeft7:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 5
	addi	$s3, $s3, 1
	j	draw_X_left4
btmLeft7:
	subi	$a0, $a0, 15
	addi	$a1, $a1, 5
	addi	$s6, $s6, 1
	j	draw_X_left4
topCenter7:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s1, $s1, 1
	j	draw_X_left4
midCenter7:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s4, $s4, 1
	j	draw_X_left4
btmCenter7:
	subi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$s7, $s7, 1
	j	draw_X_left4
topRight7:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s2, $s2, 1
	j	draw_X_left4
midRight7:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s5, $s5, 1
	j	draw_X_left4
btmRight7:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$v1, $v1, 1
	j	draw_X_left4
# draw X
draw_X_left4:
	beq	$t0, $t2, X_reset4
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_X_left4
# reset variables once finished
X_reset4:
	addi	$t0, $0, 0
	subi 	$a1, $a1, 10
draw_X_right4:
	beq	$t0, $t2, X_finish4
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_X_right4
X_finish4:#reset variables and check if winner
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	jal	top_win_X
# 8th move
eighthMove:
	lw $t0, 0xffff0000 # $t0 holds available input
    	beq $t0, 0, eighthMove # if $t0 = 0 (i.e. no input from user) then jump to eighthMove which waits for input
	
	lw 	$a3, 0xffff0004
	beq	$a3, 32, exit		# space = 32
	beq	$a3, 55, topLeft8	# 7 = 55
	beq	$a3, 56, topCenter8	# 8 = 56
	beq	$a3, 57, topRight8	# 9 = 57
	beq	$a3, 52, midLeft8	# 4 = 52
	beq	$a3, 53, midCenter8	# 5 = 53
	beq	$a3, 54, midRight8	# 6 = 54
	beq	$a3, 49, btmLeft8	# 1 = 49
	beq	$a3, 50, btmCenter8	# 2 = 50
	beq	$a3, 51, btmRight8	# 3 = 51
	j eighthMove			# if you fall through all cases, jump back to eighthMove till a eighth move is made by O
	
# functions below are for which move player O ends up making (code above jumps to one of these accordingly)
topLeft8:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 15
	addi	$s0, $s0, 2
	j	draw_O_TLeft4
midLeft8:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 5
	addi	$s3, $s3, 2
	j	draw_O_TLeft4
btmLeft8:
	subi	$a0, $a0, 15
	addi	$a1, $a1, 5
	addi	$s6, $s6, 2
	j	draw_O_TLeft4
topCenter8:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s1, $s1, 2
	j	draw_O_TLeft4
midCenter8:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s4, $s4, 2
	j	draw_O_TLeft4
btmCenter8:
	subi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$s7, $s7, 2
	j	draw_O_TLeft4
topRight8:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s2, $s2, 2
	j	draw_O_TLeft4
midRight8:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s5, $s5, 2
	j	draw_O_TLeft4
btmRight8:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$v1, $v1, 2
	j	draw_O_TLeft4
#draw O
draw_O_TLeft4:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 1
begin_TLeft4:
	beq	$t0, $t4, draw_O_left_side4
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	begin_TLeft4
draw_O_left_side4:
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel	
	addi	$t0, $0, 0	
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
begin_btmLeft4:
	beq	$t0, $t4, draw_O_btm4
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	begin_btmLeft4
draw_O_btm4:
	addi	$t0, $0, 0
	addi	$a0, $a0, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
draw_O_btmRight4:
	beq	$t0, $t4, draw_O_centerRight4
	addi	$a0, $a0, 1
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_O_btmRight4
draw_O_centerRight4:
	addi	$t0, $0, 0
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
draw_O_topRight4:
	beq	$t0, $t4, O_finish4
	subi	$a0, $a0, 1
	subi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_O_topRight4
# reset variables once finished and check for winner
O_finish4:
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	jal	top_win_O
# 9th move
ninthMove:
	lw $t0, 0xffff0000 # $t0 holds available input
    	beq $t0, 0, ninthMove # if $t0 = 0 (i.e. no input from user) then jump to ninthMove which waits for input
	
	lw 	$a3, 0xffff0004
	beq	$a3, 32, exit		# space = 32
	beq	$a3, 55, topLeft9	# 7 = 55
	beq	$a3, 56, topCenter9	# 8 = 56
	beq	$a3, 57, topRight9	# 9 = 57
	beq	$a3, 52, midLeft9	# 4 = 52
	beq	$a3, 53, midCenter9	# 5 = 53
	beq	$a3, 54, midRight9	# 6 = 54
	beq	$a3, 49, btmLeft9	# 1 = 49
	beq	$a3, 50, btmCenter9	# 2 = 50
	beq	$a3, 51, btmRight9	# 3 = 51
	j ninthMove			# if you fall through all cases, jump back to ninthMove till a ninth move is made by X
	
# functions below are for which move player X ends up making (code above jumps to one of these accordingly)
topLeft9:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 15
	addi	$s0, $s0, 1
	j	draw_X_left5
midLeft9:
	subi	$a0, $a0, 15
	subi	$a1, $a1, 5
	addi	$s3, $s3, 1
	j	draw_X_left5
btmLeft9:
	subi	$a0, $a0, 15
	addi	$a1, $a1, 5
	addi	$s6, $s6, 1
	j	draw_X_left5
topCenter9:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s1, $s1, 1
	j	draw_X_left5
midCenter9:
	subi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s4, $s4, 1
	j	draw_X_left5
btmCenter9:
	subi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$s7, $s7, 1
	j	draw_X_left5
topRight9:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 15
	addi	$s2, $s2, 1
	j	draw_X_left5
midRight9:
	addi	$a0, $a0, 5
	subi	$a1, $a1, 5
	addi	$s5, $s5, 1
	j	draw_X_left5
btmRight9:
	addi	$a0, $a0, 5
	addi	$a1, $a1, 5
	addi	$v1, $v1, 1
	j	draw_X_left5
#draw X (final)
draw_X_left5:
	beq	$t0, $t2, X_reset5
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_X_left5
X_reset5:
	addi	$t0, $0, 0
	subi 	$a1, $a1, 10
draw_X_right5:
	beq	$t0, $t2, X_finish5
	subi	$a0, $a0, 1
	addi	$a1, $a1, 1
	# call subroutine to draw pixel (per Github example)
	jal	draw_pixel
	addi	$t0, $t0, 1
	j	draw_X_right5
# reset variables once finished and check for winner
X_finish5:
	addi	$t0, $0, 0
	addi 	$a0, $0, WIDTH    # $a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # $a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	jal	top_win_X
	
	#if there was no winner display it was a tie
	li $v0, 4 
	la $a0, TIE_GAME
	syscall
	
exit:	li	$v0, 10
	syscall

# MIPS subroutine to draw a pixel (from Github example by professor)
draw_pixel:
	# $a3 = address = MEM + 4 * (x + y * WIDTH) (WORK PEMDAS):
	mul	$a3, $a1, WIDTH	# y * WIDTH
	add	$a3, $a3, $a0	# add X
	mul	$a3, $a3, 4	# multiply by 4 to get word offset
	add	$a3, $a3, MEM	# add to base address
	# line below is giving error, figure out why
	# sw	$a2, 0($a3)	# store color at memory location
	jr 	$ra		# return to $ra (jump back)
	
# functions below are to check if X was the winner in any form and output accordingly	
top_win_X:
	bne	$s0, 1, center_win_X
	bne	$s1, 1, center_win_X
	bne 	$s2, 1, center_win_X
	# use string output syscall value to output if X was winner
	li $v0, 4 
	la $a0, X_win
	syscall
	j	exit
center_win_X:
	bne	$s3, 1, btm_win_X
	bne	$s4, 1, btm_win_X
	bne	$s5, 1, btm_win_X
	# use string output syscall value to output if X was winner
	li $v0, 4 
	la $a0, X_win
	syscall
	j	exit
btm_win_X:
	bne	$s6, 1, LDiag_win_X
	bne	$s7, 1, LDiag_win_X
	bne 	$v1, 1, LDiag_win_X
	# use string output syscall value to output if X was winner
	li $v0, 4 
	la $a0, X_win
	syscall
	j	exit
LDiag_win_X:
	bne	$s0, 1, RDiag_win_X
	bne 	$s4, 1, RDiag_win_X
	bne	$v1, 1, RDiag_win_X
	# use string output syscall value to output if X was winner
	li $v0, 4 
	la $a0, X_win
	syscall
	j	exit
RDiag_win_X:
	bne 	$s2, 1, LDown_win_X
	bne	$s4, 1, LDown_win_X
	bne	$s6, 1, LDown_win_X
	# use string output syscall value to output if X was winner
	li $v0, 4 
	la $a0, X_win
	syscall
	j	exit
LDown_win_X:
	bne	$s0, 1, CDown_win_X
	bne 	$s3, 1, CDown_win_X
	bne 	$s6, 1, CDown_win_X
	# use string output syscall value to output if X was winner
	li $v0, 4 
	la $a0, X_win
	syscall
	j	exit
CDown_win_X:
	bne	$s1, 1, RDown_win_X
	bne	$s4, 1, RDown_win_X
	bne 	$s7, 1, RDown_win_X
	# use string output syscall value to output if X was winner
	li $v0, 4 
	la $a0, X_win
	syscall
	j	exit
RDown_win_X:
	bne	$s2, 1, X_nowin
	bne	$s5, 1, X_nowin
	bne 	$v1, 1, X_nowin
	# use string output syscall value to output if X was winner
	li $v0, 4 
	la $a0, X_win
	syscall
	j	exit
# for no winner for X, return
X_nowin:
	jr	$ra
	
# functions below are to check if O was the winner in any form and output accordingly
top_win_O:
	bne	$s0, 2, center_win_O
	bne	$s1, 2, center_win_O
	bne 	$s2, 2, center_win_O
	li $v0, 4 
	la $a0, O_win
	syscall
	j	exit
center_win_O:
	bne	$s3, 2, btm_win_O
	bne	$s4, 2, btm_win_O
	bne	$s5, 2, btm_win_O
	li $v0, 4 
	la $a0, O_win
	syscall
	j	exit
btm_win_O:
	bne	$s6, 2, LDiag_win_O
	bne	$s7, 2, LDiag_win_O
	bne 	$v1, 2, LDiag_win_O
	li $v0, 4 
	la $a0, O_win
	syscall
	j	exit
LDiag_win_O:
	bne	$s0, 2, RDiag_win_O
	bne 	$s4, 2, RDiag_win_O
	bne	$v1, 2, RDiag_win_O
	li $v0, 4 
	la $a0, O_win
	syscall
	j	exit
RDiag_win_O:
	bne 	$s2, 2, LDown_win_O
	bne	$s4, 2, LDown_win_O
	bne	$s6, 2, LDown_win_O
	li $v0, 4 
	la $a0, O_win
	syscall
	j	exit
LDown_win_O:
	bne	$s0, 2, CDown_win_O
	bne 	$s3, 2, CDown_win_O
	bne 	$s6, 2, CDown_win_O
	li $v0, 4 
	la $a0, O_win
	syscall
	j	exit
CDown_win_O:
	bne	$s1, 2, RDown_win_O
	bne	$s4, 2, RDown_win_O
	bne 	$s7, 2, RDown_win_O
	li $v0, 4 
	la $a0, O_win
	syscall
	j	exit
RDown_win_O:
	bne	$s2, 2, O_nowin
	bne	$s5, 2, O_nowin
	bne 	$v1, 2, O_nowin
	li $v0, 4 
	la $a0, O_win
	syscall
	j	exit
# for no winner for O, return
O_nowin:
	jr	$ra
	
