#BattleShip x86_64 MASM Format
This is the board game Battleship in x86_64 assembly(MASM FORMAT).
####- Made by Hector Vargas.

You will need the Irvine 32 Libary to run this, which is located [here.](http://www.kipirvine.com/asm/examples/)
This is in MASM format, it has been tested in Windows only. Tests have been successful in Windows 7 x32,x64 Windows 8 & 8.1 x32 x64!!
####'X's represent Hits
####'O's represent Misses
I will improve this game in the future, for now a working copy will do.
I used Visual Studio 2013 Free Edition to assemble and run the code.
You may also need Visual Studio 2012 Build Tools to run this successfully! These can be found [here.](http://www.microsoft.com/en-us/download/details.aspx?id=38807)

####Randomization
The game will use 1's and 0's to determine if the ship will be placed on the board in vertical or horizontal position. Then using the firstmost part of the ship(ex : aircraft carrier is 5 slots big, begin with slot 1) will be mapped to some randomly generated integer within the board.
Henceforth, the Y or X values will be filled in into the solutions. Note the solutions aren't displayed unless the user enters coordinates that match coordinates in the solutions. 
Game counter is determined by a 'difficulty' chosen by the user at the beginning of the game. Hard greatly reduces the amount of turns a user has, whereas Easy makes is pretty easy to win the game with a good amount of turns. 
Messageboxes will appear at the beginning and end ( only if user wins ).
#####Clone
```bash
	git clone https://github.com/vargash1/BattleShip_x86_64.git
```

Some Sample Runs:
![alt text](https://github.com/vargash1/BattleShip_x86_64/blob/master/images/Screenshot%20from%202014-12-16%2023:09:26.png "Sample Runtime!")
![alt text](https://github.com/vargash1/BattleShip_x86_64/blob/master/images/Screenshot%20from%202014-12-16%2023:09:35.png "Sample Runtime!")
![alt text](https://github.com/vargash1/BattleShip_x86_64/blob/master/images/Screenshot%20from%202014-12-16%2023:09:57.png "Sample Runtime!")
![alt text](https://github.com/vargash1/BattleShip_x86_64/blob/master/images/Screenshot%20from%202014-12-16%2023:10:06.png "Sample Runtime!")
![alt text](https://github.com/vargash1/BattleShip_x86_64/blob/master/images/Screenshot%20from%202014-12-16%2023:10:09.png "Sample Runtime!")
![alt text](https://github.com/vargash1/BattleShip_x86_64/blob/master/images/Screenshot%20from%202014-12-16%2023:10:11.png "Sample Runtime!")
![alt text](https://github.com/vargash1/BattleShip_x86_64/blob/master/images/Screenshot%20from%202014-12-16%2023:10:18.png "Sample Runtime!")
