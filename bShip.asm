; @Author: vargash1
; @Name:   Vargas, Hector
; @Email:  vargash1@wit.edu
; @Date:   2014-12-07 13:04:53
; @Last Modified by:   vargash1
; @Last Modified time: 2014-12-09 10:13:30
INCLUDE Irvine32.inc
;-------------------------------------------
;ships
;Carrier        5
    Carrier     STRUCT
        dummy   BYTE    0
    Carrier     ENDS
;BattleShip     4
    BattleShip  STRUCT
        dummy   BYTE    0
    BattleShip  ENDS
;Destroyer      3
    Destroyer   STRUCT
        dummy   BYTE    0
    Destroyer   ENDS
;Submarine      3
    Submarine   STRUCT
        dummy   BYTE    0
    Submarine   ENDS
;Patrol         2
    Patrol      STRUCT
        dummy   BYTE    0
    Patrol      ENDS
;-------------------------------------------
;dictionary 
    Dictionary  STRUCT
        solutions_x BYTE    " "," "," "," "," "," "," "," "," ",0
        solutions_y BYTE    " "," "," "," "," "," "," "," "," ",0
        display_x   BYTE    " "," "," "," "," "," "," "," "," ",0
        display_y   BYTE    " "," "," "," "," "," "," "," "," ",0
    Dictionary  ENDS
;-------------------------------------------
;board 
    Gameboard  STRUCT
        board_x     BYTE    1,2,3,4,5,6,7,8,9
        board_y     BYTE    "ABCDEFGHI",0
        vtab        BYTE    "|",0
    Gameboard  ENDS
;-------------------------------------------
;player move 
    Event STRUCT
        miss        BYTE    'O'
        hit         BYTE    'X'
    Event ENDS      
;-------------------------------------------
;user instructions
    Instructions STRUCT
        move_a      BYTE    '0'
        move_b      BYTE    'Z'
        begin       BYTE    "Welome to Battleship!",0
        ships       BYTE    "Ships have been randomized on the field! Good Luck!",0
        move_x      BYTE    "You will enter a number on the X axis",0
        move_y      BYTE    "Followed by a letter on the Y axis!",0    
        prompt      BYTE    "> ",0
    Instructions ENDS 
;-------------------------------------------
;fun banner
    Banner       STRUCT
        row1        BYTE    "     ____        __  __  __    _____ __    _          _          __  ______   _____ __  ___",0
        row2        BYTE    "    / __ )____ _/ /_/ /_/ /__ / ___// /_  (_)___     (_)___     /  |/  /   | / ___//  |/  /",0
        row3        BYTE    "   / __  / __ `/ __/ __/ / _ \\__ \/ __ \/ / __ \   / / __ \   / /|_/ / /| | \__ \/ /|_/ / ",0
        row4        BYTE    "  / /_/ / /_/ / /_/ /_/ /  __/__/ / / / / / /_/ /  / / / / /  / /  / / ___ |___/ / /  / /  ",0
        row5        BYTE    " /_____/\___/\__/\__/_/\___/____/_/ /_/_/  ____/  /_/_/ /_/  /_/  /_/_/  |_/____/_/  /_/   ",0
        row6        BYTE    "                                        /_/                                                ",0
    Banner       ENDS
;-------------------------------------------
.data
    ;-------------------------------------------
    ;structures
    ship_carrier    Carrier <>
    user_intruc     Instructions<>
    ban             Banner<>
    dict            Dictionary<>
    new_board       Gameboard<>
    ;-------------------------------------------
    ;primatives
    cnt         DWORD    0
.code
main             PROC
    call    print_banner
    call    user_intructions
    call    draw_board
    INVOKE  ExitProcess,0
main             ENDP
;-------------------------------------------
; greets and prints instructions to the user
user_intructions PROC
    mov     eax, green + (black * 16)
    call    SetTextColor
    mov     edx,OFFSET user_intruc.begin
    call    WriteString
    call    crlf
    mov     edx,OFFSET user_intruc.ships   
    call    WriteString
    call    crlf
    mov     edx,OFFSET user_intruc.move_x
    call    WriteString
    call    crlf
    mov     edx,OFFSET user_intruc.move_y
    call    WriteString
    call    crlf
    mov     eax, white + (black * 16)
    call    SetTextColor
    ret
user_intructions ENDP
;-------------------------------------------
; draw the board out
draw_board       PROC
    call    crlf
    mov     esi, OFFSET new_board.board_x
    mov     ecx, LENGTHOF new_board.board_x
    ;draws the row
drb_x:
    mov     al,' '
    call    WriteChar
    mov     edx, [esi] 
    call    WriteString
    mov     al,' '
    call    WriteChar
    inc     esi
    loop    drb_x
    call    crlf
    call    draw_field
    ret
draw_board       ENDP
;-------------------------------------------
;draws field 
draw_field      PROC
    mov     esi, OFFSET new_board.board_y  
    mov     ecx, LENGTHOF new_board.board_y
drb_y:
    mov     edx, [esi]
    call    WriteString
    mov     al,' '
    call    WriteChar
    mov     al,'|'     
    call    WriteChar
    inc     esi
    loop    drb_y   
    
    ret
draw_field      ENDP
;-------------------------------------------
; TODO randomize ships here
randomize_s     PROC
    ret
randomize_s     ENDP
;-------------------------------------------
; TODO get user turn
get_turn        PROC
    ret
get_turn        ENDP
;-------------------------------------------
; TODO update board
update_board    PROC
    ret
update_board    ENDP
;-------------------------------------------
print_banner    PROC
    mov    edx,OFFSET ban.row1
    call   WriteString
    call   crlf
    mov    edx,OFFSET ban.row2
    call   WriteString
    call   crlf
    mov    edx,OFFSET ban.row3
    call   WriteString
    call   crlf
    mov    edx,OFFSET ban.row4
    call   WriteString
    call   crlf
    mov    edx,OFFSET ban.row5
    call   WriteString
    call   crlf
    mov    edx,OFFSET ban.row6
    call   WriteString
    call   crlf
    call   crlf
    ret
print_banner    ENDP
end     main

