# Tic-Tac-Toe
Tic-Tac-Toe game made using MIPS Bitmap and MMIO Simulator

# Objective
This program uses the MIPS Bitmap display and the MIPS Keyboard and Display MMIO Simulator to simulate a tic-tac-toe game. The game can be played using the numeric pad on a keyboard: 
```output
						     7 | 8 | 9
						   -------------
						     4 | 5 | 6
						   -------------
						     1 | 2 | 3
```
						 
(Note: If you do not have a keypad on your keyboard, you can still play this game the same way using the numeric keys 
above the character keys)

Instructions to run the program:
1.	Launch the Mars .jar file on your computer (to run MIPS code)
2.	Open the program file
3.	Click on tools and select:
a.	Bitmap Display
b.	Keyboard and Display MMIO Simulator
4.	Connect both of the above tools to MIPS after changing settings accordingly
5.	Once they are connected, build, and run the program in Mars
6.	The game will have automatically started, with X being the first player and O being the second player
7.	Play the game until either X wins, O wins, or it’s a tie game
8.	Goodluck!

What this program does, is uses the MIPS Bitmap and MMIO Keyboard simulator to receive input from the user into the 
keyboard and translates what is inputted to a tic-tac-toe (TTT) game. Based on what X’s first move is on the TTT 
grid, the program jumps to one of the defined functions for that specific spot on the grid and places an X there. 
For the next move which would be O’s move, O decides where to put their symbol, and the program jumps to the 
corresponding function to place an O in the designated spot. (Note: The space key exits the program)

Once the grid is full, there are functions defined to check if X or O won in a few ways which are:
1.	Across the top row
2.	Across the center row
3.	Across the bottom row
4.	Across the left diagonal
5.	Across the right diagonal
6.	Down the leftmost column
7.	Down the center column
8.	Down the rightmost column

# Sample Run(s)
![Screen Shot 2022-04-10 at 9 54 05 PM](https://user-images.githubusercontent.com/87043795/162808985-f0b7d188-a7d9-40e7-abbe-75ada93af3bf.png)
