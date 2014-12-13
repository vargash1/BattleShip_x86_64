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
        x_solutions     BYTE    5 DUP (0)
        y_solutions     BYTE    5 DUP (0)
    Carrier     ENDS
;BattleShip     4
    BattleShip  STRUCT
        x_solutions     BYTE    5 DUP (0)
        y_solutions     BYTE    5 DUP (0)
    BattleShip  ENDS
;Destroyer      3
    Destroyer   STRUCT
        x_solutions     BYTE    5 DUP (0)
        y_solutions     BYTE    5 DUP (0)
    Destroyer   ENDS
;Submarine      3
    Submarine   STRUCT
        x_solutions     BYTE    5 DUP (0)
        y_solutions     BYTE    5 DUP (0)
    Submarine   ENDS
;Patrol         2
    Patrol      STRUCT
        x_solutions     BYTE    5 DUP (0)
        y_solutions     BYTE    5 DUP (0)
    Patrol      ENDS
;-------------------------------------------
;dictionary 
    Dictionary  STRUCT
        solutions   BYTE    91 DUP (" ")
        solutions_y BYTE    " "," "," "," "," "," "," "," "," ",0
        display     BYTE    91 DUP (" ")
        display_y   BYTE    " "," "," "," "," "," "," "," "," ",0
    Dictionary  ENDS
;-------------------------------------------
;board 
    Gameboard  STRUCT
        board_x     BYTE    "  1 2 3 4 5 6 7 8 9",0
        board_x_2   BYTE    "  __________________",0
        board_bot   BYTE    "  ------------------",0
        board_y     BYTE    "A","B","C","D","E","F","G","H","I"
        vtab        BYTE    '|'
    Gameboard  ENDS
;-------------------------------------------
;player move 
    Event STRUCT
        miss        BYTE    'O'
        hit         BYTE    'X'
        ships_hit   BYTE     0      ; if this == 17 game is over 
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
        row7        BYTE    "                                                                    "
        row8        BYTE    "By: Hector Vargas",0                     ; ^ ugly but makes it look nice!
    Banner       ENDS
;-------------------------------------------
.data
    ;-------------------------------------------
    ;structures
    user_intruc     Instructions<>
    ban             Banner<>
    dict            Dictionary<>
    new_board       Gameboard<>
    ship_carrier    Carrier <>
    bship           BattleShip<>
    destroy         Destroyer<>
    submar          Submarine<>
    patrol_boat     Patrol<>
    ;-------------------------------------------
    ;primatives
    cnt         DWORD    0
    orientation DWORD    0
.code
main             PROC
    call    print_banner
    call    user_intructions
    
INVOKE  ExitProcess,0
main             ENDP
;-------------------------------------------
; greets and prints instructions to the user
user_intructions PROC
    mov     eax, lightGreen + (black * 16)
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
    call    default_text_color
    ret
user_intructions ENDP
;-------------------------------------------
; draw the board out
draw_board_x       PROC
    mov     eax,gray + (black * 16)
    call    SetTextColor
    mov     edx,OFFSET new_board.board_x
    call    WriteString
    call    crlf
    mov     edx,OFFSET new_board.board_x_2 
    call    WriteString
    call    default_text_color
    call    crlf
    ret
draw_board_x       ENDP
;-------------------------------------------
;draws field 
draw_board_y       PROC
    mov     eax,gray + (black * 16)
    call    SetTextColor
    mov     esi, OFFSET new_board.board_y  
    mov     edi, OFFSET dict.display
    mov     ecx, LENGTHOF new_board.board_y
    mov     [cnt],ecx
; main loop
drb_y:
    mov     al, [esi]
    call    WriteChar
    push    ecx
    mov     ecx, [cnt]
    mov     al, new_board.vtab
    call    WriteChar
; nested loop
drb_y_sub:
    mov     al, [edi]
    call    WriteChar
    mov     al, new_board.vtab
    call    WriteChar
    inc     edi
    loop    drb_y_sub
; end of nested loop 
    pop     ecx
    call    crlf
    inc     esi
    loop    drb_y   
    mov     edx, OFFSET new_board.board_bot
    call    WriteString
    call    crlf 
    call    default_text_color
    ret
draw_board_y       ENDP
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
    mov     eax,cyan + (black * 16)
    call    SetTextColor
    mov     edx,OFFSET ban.row1
    call    WriteString
    call    crlf
    mov     eax,lightGreen + (black * 16)
    call    SetTextColor
    mov     edx,OFFSET ban.row2
    call    WriteString
    call    crlf
    mov     eax,lightRed + (black * 16)
    call    SetTextColor
    mov     edx,OFFSET ban.row3
    call    WriteString
    call    crlf
    mov     eax,yellow + (black * 16)
    call    SetTextColor
    mov     edx,OFFSET ban.row4
    call    WriteString
    call    crlf
    mov     eax,lightGreen + (black * 16)
    call    SetTextColor
    mov     edx,OFFSET ban.row5
    call    WriteString
    call    crlf
    mov     eax,lightBlue + (black * 16)
    call    SetTextColor
    mov     edx,OFFSET ban.row6
    call    WriteString
    call    crlf
    mov     eax,black + (black * 16)
    call    SetTextColor
    mov     edx,OFFSET ban.row7
    call    WriteString
    mov     eax,black + (gray * 16)
    call    SetTextColor
    mov     edx,OFFSET ban.row8
    call    WriteString
    call    crlf
    call    default_text_color
    ret
print_banner    ENDP
;-------------------------------------------
default_text_color  PROC
    mov    eax,white + (black * 16)
    call   SetTextColor
    ret
default_text_color  ENDP
;-------------------------------------------
;if 0 horizontal
;if 1 vertical
random_direction    PROC
    mov     eax,2
    call    RandomRange
    mov     [orientation],eax
    ret
random_direction    ENDP
;-------------------------------------------
;draws board in the beginning
draw_board_start    PROC
    call    draw_board_x
    call    draw_board_y
    call    crlf
    ret 
draw_board_start    ENDP
;-------------------------------------------
;draws board during game, clears screen
draw_board_active   PROC
    call    WaitMsg
    call    Clrscr
    call    WaitMsg
    call    draw_board_x
    call    draw_board_y
    call    crlf
    ret
draw_board_active   ENDP
end     main

