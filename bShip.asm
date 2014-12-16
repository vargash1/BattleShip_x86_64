; @Author: vargash1
; @Name:   Vargas, Hector
; @Email:  vargash1@wit.edu
; @Date:   2014-12-07 13:04:53
; @Last Modified by:   vargash1
; @Last Modified time: 2014-12-16 17:48:12
INCLUDE Irvine32.inc
;-------------------------------------------
;ships
    Ship        STRUCT
        x_solutions     BYTE    5 DUP (0)
        y_solutions     BYTE    5 DUP (0)
        ship_size       DWORD   0
        x_tmp           DWORD   0
        y_tmp           DWORD   0
    Ship        ENDS
;Carrier        5
;BattleShip     4
;Destroyer      3
;Submarine      3
;Patrol         2
;-------------------------------------------
;dictionary 
    Dictionary  STRUCT
        solutions   BYTE    81 DUP (" ")
        solutions_y BYTE    " "," "," "," "," "," "," "," "," ",0
        display     BYTE    81 DUP (" ")
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
        user_in_x   BYTE     0
        user_in_y   BYTE     0
        hard        DWORD    35
        medium      DWORD    55
        easy        DWORD    75
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
        turn_x      BYTE    "Enter a X coordinate ",0
        turn_y      BYTE    "Enter a Y coordinate ",0
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
    user_event      Event<>
    user_intruc     Instructions<>
    ban             Banner<>
    dict            Dictionary<>
    new_board       Gameboard<>
    air_carrier     Ship<>
    batl_ship       Ship<>
    destroyer       Ship<>
    submarine       Ship<>
    patrol          Ship<>
    ;-------------------------------------------
    ;primatives
    cnt         DWORD    0
    orientation DWORD    0
    flag        BYTE     0          ;used to check spots
    msg_box_caption     BYTE     "Welcome to BattleShip in x86_64 MASM assmembly",0
    msg_box_question    BYTE     "Would you like to play my game?",0
    msg_box_confirmed   BYTE     236,"Alright! Hope you have fun!",236,0
    diff        BYTE    "Choose the difficulty of the game, this will limit the turns you can take!",0Dh,0Ah   
                BYTE    "(H)ard, (I)ntermediate, or (E)asy? Enter the character to select!",0Dh,0Ah,0
    user_diff   DWORD   ?
.code
main             PROC
    call    ask_user_play
    ;if user clicks no then game exits
    call    ask_user_diff
    call    Clrscr
    call    set_ship_data
    call    print_banner
    call    user_intructions
    call    draw_board_start
    call    draw_board_active    
    call    get_turn_x
    call    get_turn_y
    call    random_ships_all
    call    draw_board_active
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
; randomize carrier here WORKS
randomize_carrier     PROC
    call    random_direction
    mov     eax,[orientation]
    cmp     eax,0
    je      vertical_random
    jne     horizontal_random
    ret
vertical_random:
;-------------------------------------------
;random x's
    mov     eax,9
    mov     ecx,1337
r1:
    mov     eax,9
    call    RandomRange
    loop    r1
;-------------------------------------------
;random y's
    mov     [air_carrier.x_tmp],eax
    mov     eax,5
    mov     ecx,1337
r2:
    mov     eax,5
    call    RandomRange
    loop    r2
    mov     esi, OFFSET dict.solutions
    mov     edx,0
    mov     ebx,9
    imul    ebx
    add     esi,eax
    add     esi, air_carrier.x_tmp
    mov     ecx,5
fill_y:
    mov     al,'X'
    mov     [esi],al
    add     esi, 9
    loop    fill_y
    ret
horizontal_random:
;-------------------------------------------
;random x's
    mov     eax,5
    mov     ecx,2121
r3:
    mov     eax,5
    call    RandomRange
    loop    r3
;-------------------------------------------
;random y's
    mov     [air_carrier.x_tmp], eax
    mov     eax,9
    mov     ecx,12
r4:
    mov     eax,9
    call    RandomRange
    loop    r4
    mov     esi, OFFSET dict.solutions
    mov     edx,0
    mov     ebx,9
    imul    ebx
    add     esi, eax
    add     esi, air_carrier.x_tmp
    mov     ecx,5
fill_x:
    mov     al,'X'
    mov     [esi],al
    inc     esi
    loop    fill_x
    ret
randomize_carrier     ENDP
;-------------------------------------------
;randomizes battleship 4 WORKS
;must check for anything in the way 
randomize_bship     PROC
    call    random_direction
    mov     eax,[orientation]
    cmp     eax,0
    je      vertical_random
    jne     horizontal_random
    ret
vertical_random:
;-------------------------------------------
;random x's
    mov     eax,9
    mov     ecx,1337
r1:
    mov     eax,9
    call    RandomRange
    loop    r1
;-------------------------------------------
;random y's
    mov     [batl_ship.x_tmp],eax
    mov     eax,4
    mov     ecx,1337
r2:
    mov     eax,4
    call    RandomRange
    loop    r2
    mov     esi, OFFSET dict.solutions
    mov     edx,0
    mov     ebx,9
    imul    ebx
    add     esi,eax
    add     esi, batl_ship.x_tmp
    mov     ecx,4
fill_y:
    mov     [flag],0
    call    check_if_taken
    mov     eax,DWORD PTR [flag]
    cmp     eax,1
    je      recurse
    call    crlf
    mov     al,'X'
    mov     [esi],al
    add     esi, 9
    loop    fill_y
    ret
recurse:    ;if esi is occupied already
    call    randomize_bship
    ret
    
  
horizontal_random:
;-------------------------------------------
;random x's
    mov     eax,4
    mov     ecx,2121
r3:
    mov     eax,4
    call    RandomRange
    loop    r3
;-------------------------------------------
;random y's
    mov     [batl_ship.x_tmp], eax
    mov     eax,9
    mov     ecx,12
r4:
    mov     eax,9
    call    RandomRange
    loop    r4
    mov     esi, OFFSET dict.solutions
    mov     edx,0
    mov     ebx,9
    imul    ebx
    add     esi, eax
    add     esi, batl_ship.x_tmp
    mov     ecx,4
fill_x:
    ; mov     [flag],0
    ; call    check_if_taken
    ; mov     al,[flag]
    ; cmp     al,1
    ; je      recurse
    ; mov     al,'X'
    mov     [esi],al
    inc     esi
    loop    fill_x
    ret
randomize_bship     ENDP
;-------------------------------------------
;randomizes destroyer 4 WORKS
;must check for anything in the way 
randomize_destroyer     PROC
    call    random_direction
    mov     eax,[orientation]
    cmp     eax,0
    je      vertical_random
    jne     horizontal_random
    ret
vertical_random:
;-------------------------------------------
;random x's
    mov     eax,9
    mov     ecx,1337
r1:
    mov     eax,9
    call    RandomRange
    loop    r1
;-------------------------------------------
;random y's
    mov     [destroyer.x_tmp],eax
    mov     eax,3
    mov     ecx,1337
r2:
    mov     eax,3
    call    RandomRange
    loop    r2
    mov     esi, OFFSET dict.solutions
    mov     edx,0
    mov     ebx,9
    imul    ebx
    add     esi,eax
    add     esi, destroyer.x_tmp
    mov     ecx,3
fill_y:
    mov     [flag],0
    call    check_if_taken
    mov     al,[flag]
    cmp     al,1
    je      recurse_dest
    mov     al,'X'
    mov     [esi],al
    add     esi, 9
    loop    fill_y
    ret
recurse_dest:    ;if esi is occupied already
    call    randomize_destroyer
    ret
horizontal_random:
;-------------------------------------------
;random x's
    mov     eax,3
    mov     ecx,2121
r3:
    mov     eax,3
    call    RandomRange
    loop    r3
;-------------------------------------------
;random y's
    mov     [destroyer.x_tmp], eax
    mov     eax,9
    mov     ecx,1337
r4:
    mov     eax,9
    call    RandomRange
    loop    r4
    mov     esi, OFFSET dict.solutions
    mov     edx,0
    mov     ebx,9
    imul    ebx
    add     esi, eax
    add     esi, destroyer.x_tmp
    mov     ecx,3
fill_x:
    mov     [flag],0
    call    check_if_taken
    mov     al,[flag]
    cmp     al,1
    je      recurse_1
recurse_1:    ;if esi is occupied already
    call    randomize_destroyer
    ret
    
    mov     al,'X'
    mov     [esi],al
    inc     esi
    loop    fill_x
    ret
randomize_destroyer     ENDP
;-------------------------------------------
;randomizes battleship 4 WORKS
;must check for anything in the way 
randomize_sub     PROC
    call    random_direction
    mov     eax,[orientation]
    cmp     eax,0
    je      vertical_random
    jne     horizontal_random
    ret
vertical_random:
;-------------------------------------------
;random x's
    mov     eax,9
    mov     ecx,1337
r1:
    mov     eax,9
    call    RandomRange
    loop    r1
;-------------------------------------------
;random y's
    mov     [submarine.x_tmp],eax
    mov     eax,3
    mov     ecx,1337
r2:
    mov     eax,3
    call    RandomRange
    loop    r2
    mov     esi, OFFSET dict.solutions
    mov     edx,0
    mov     ebx,9
    imul    ebx
    add     esi,eax
    add     esi, submarine.x_tmp
    mov     ecx,3
fill_y:
    mov     [flag],0
    call    check_if_taken
    mov     al,[flag]
    cmp     al,1
    je      recurse_sub_1
    mov     al,'X'
    mov     [esi],al
    add     esi, 9
    loop    fill_y
    ret
recurse_sub_1:    ;if esi is occupied already
    call    randomize_sub
    ret
horizontal_random:
;-------------------------------------------
;random x's
    mov     eax,3
    mov     ecx,2121
r3:
    mov     eax,3
    call    RandomRange
    loop    r3
;-------------------------------------------
;random y's
    mov     [submarine.x_tmp], eax
    mov     eax,9
    mov     ecx,1337
r4:
    mov     eax,9
    call    RandomRange
    loop    r4
    mov     esi, OFFSET dict.solutions
    mov     edx,0
    mov     ebx,9
    imul    ebx
    add     esi, eax
    add     esi, submarine.x_tmp
    mov     ecx,3
fill_x:
    mov     [flag],0
    call    check_if_taken
    mov     al,[flag]
    cmp     al,1
    je      recurse_sub_2
    mov     al,'X'
    mov     [esi],al
    inc     esi
    loop    fill_x
    ret
recurse_sub_2:    ;if esi is occupied already
    call    randomize_sub
    ret
randomize_sub     ENDP
;-------------------------------------------
;randomizes battleship 4 WORKS
;must check for anything in the way 
randomize_patrol_boat     PROC
    call    random_direction
    mov     eax,[orientation]
    cmp     eax,0
    je      vertical_random
    jne     horizontal_random
    ret
vertical_random:
;-------------------------------------------
;random x's
    mov     eax,9
    mov     ecx,1337
r1:
    mov     eax,9
    call    RandomRange
    loop    r1
;-------------------------------------------
;random y's
    mov     [patrol.x_tmp],eax
    mov     eax,2
    mov     ecx,1337
r2:
    mov     eax,2
    call    RandomRange
    loop    r2
    mov     esi, OFFSET dict.solutions
    mov     edx,0
    mov     ebx,9
    imul    ebx
    add     esi,eax
    add     esi, patrol.x_tmp
    mov     ecx,2
fill_y:
    mov     [flag],0
    call    check_if_taken
    mov     al,[flag]
    cmp     al,1
    je      recurse_pat_1
    mov     al,'X'
    mov     [esi],al
    add     esi, 9
    loop    fill_y
    ret
recurse_pat_1:    ;if esi is occupied already
    call    randomize_patrol_boat
    ret
horizontal_random:
;-------------------------------------------
;random x's
    mov     eax,3
    mov     ecx,2121
r3:
    mov     eax,2
    call    RandomRange
    loop    r3
;-------------------------------------------
;random y's
    mov     [submarine.x_tmp], eax
    mov     eax,9
    mov     ecx,1337
r4:
    mov     eax,9
    call    RandomRange
    loop    r4
    mov     esi, OFFSET dict.solutions
    mov     edx,0
    mov     ebx,9
    imul    ebx
    add     esi, eax
    add     esi, submarine.x_tmp
    mov     ecx,2
fill_x:
    mov     [flag],0
    call    check_if_taken
    mov     al,[flag]
    cmp     al,1
    je      recurse_pat_2
    mov     al,'X'
    mov     [esi],al
    inc     esi
    loop    fill_x
    ret
recurse_pat_2:    ;if esi is occupied already
    call    randomize_patrol_boat
    ret
randomize_patrol_boat     ENDP
;-------------------------------------------
;  get user turn x coordinate
;  will be called until the user enters 
;  a value from 1-9
get_turn_x       PROC
    mov     edx, OFFSET user_intruc.turn_x
    call    WriteString
    call    crlf
    mov     edx, OFFSET user_intruc.prompt
    call    WriteString
    call    ReadChar
    cmp     al,'1'
    jl      invalid_in_x
    cmp     al,'9'
    jg      invalid_in_x
    mov     [user_event.user_in_x], al
    mov     al, [user_event.user_in_x]
    call    WriteChar
    call    crlf        
    ret
invalid_in_x:
    call    get_turn_x
    ret
get_turn_x       ENDP
;-------------------------------------------
;  get user turn y coordinate
;  will be called until the user enters 
;  a value from A-I
get_turn_y       PROC
    mov     edx, OFFSET user_intruc.turn_y
    call    WriteString
    call    crlf
    mov     edx, OFFSET user_intruc.prompt
    call    WriteString
    call    ReadChar
    cmp     al,'A'
    jl      invalid_in_y
    cmp     al,'I'
    jg      invalid_in_y
    mov     [user_event.user_in_y], al
    mov     al, [user_event.user_in_y]
    call    WriteChar
    call    crlf        
    ret
invalid_in_y:
    call    get_turn_y
    ret
get_turn_y       ENDP
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
red_text_color  PROC
    mov     eax,red + (black * 16)
    call    SetTextColor
    ret
red_text_color  ENDP
gray_text_color  PROC
    mov     eax,gray + (black * 16)
    call    SetTextColor
    ret
gray_text_color  ENDP
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
;------------------------------------------
;draws board during game, clears screen
draw_board_active   PROC
    call    WaitMsg
    call    Clrscr
    call    crlf
    call    draw_board_x
    call    draw_board_y_sol
    call    crlf
    ret
draw_board_active   ENDP
;-------------------------------------------
;sets ship sizes
set_ship_data   PROC
    mov     air_carrier.ship_size, 5
    mov     batl_ship.ship_size, 4
    mov     destroyer.ship_size, 3
    mov     submarine.ship_size, 3
    mov     patrol.ship_size, 2
    ret
set_ship_data   ENDP
;-------------------------------------------
;draws field 
draw_board_y_sol       PROC
    mov     eax,gray + (black * 16)
    call    SetTextColor
    mov     esi, OFFSET new_board.board_y  
    mov     edi, OFFSET dict.solutions
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
draw_board_y_sol       ENDP
;-------------------------------------------
; checks if anything is in the way, returns true (1) 
; check eax
check_if_taken  PROC
    mov     al,'X'
    mov     dl,[esi]
    cmp     dl,al
    je      reroll
    jne     confirmed
    ret
reroll:
    ;if [esi] is taken simply try again until it isn't 
    mov     [flag],1
    ret
confirmed:
    ;if jump here then continue adding ship to board
    ret
check_if_taken  ENDP
random_ships_all    PROC
    call    randomize_carrier
    call    randomize_bship
    call    randomize_destroyer
    call    randomize_sub
    call    randomize_patrol_boat
    mov     al,236
    call    WriteChar
    call    DumpRegs
    ret
random_ships_all    ENDP
; check_if_hit    PROC
;     mov     esi, OFFSET dict.solutions
;     mov     edi, OFFSET dict.display
;     mov     al, user_event.user_in_x
;     mov     ebx, DWORD PTR al

;     ret     
; check_if_hit    ENDP
ask_user_play   PROC
    mov     ebx,OFFSET msg_box_caption
    mov     edx,OFFSET msg_box_question
    call    MsgBoxAsk
    cmp     eax,6
    je      user_wants_in
    jne     user_quit
    ret
user_wants_in:
    mov     ebx, OFFSET msg_box_caption
    mov     edx, OFFSET msg_box_confirmed
    call    MsgBox
    ret
user_quit:
    INVOKE  ExitProcess,0
ask_user_play   ENDP
;asks the user if the game should make it harder
;this just reduces the amount of turns they can take 
;75 55 35 
;E  I  H
ask_user_diff   PROC
    mov     edx,OFFSET diff
    call    WriteString
    call    crlf
    mov     edx,OFFSET user_intruc.prompt
    call    WriteString
    call    ReadChar
    cmp     al,'E'
    je      easy 
    jg      valid_option
    jl      invalid_option
    ret
valid_option:
    cmp     al,'H'
    je      hard
    jg      valid_option_2
    ret
valid_option_2:
    cmp     al,'I'
    je      medium
    jne     invalid_option
    ret
easy:
    mov     [user_diff],75
    ret
medium:
    mov     [user_diff],55
    ret
hard:
    mov     [user_diff],35
    ret
invalid_option:
    call    ask_user_diff
    ret
ask_user_diff   ENDP
;TODO UPDATE the board with ecx, user_diff!! and we are donnerino
;TODO use logic operator AND to convert ***************
;lowercase to uppercase!!!
end     main

