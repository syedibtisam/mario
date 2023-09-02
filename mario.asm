.model small
.data
	fire_reached db 0
	origin_x_fire dw 0
	origin_y_fire dw 0
	mario_colliding_with_fire db 0

    row_number db ?
    column_number db ?
	x_coord_reactangle dw ?
	y_coord_reactangle dw ?
	length_of_reactangle dw ?
	height_of_reactangle dw ?
	origin_x_character dw ?
	origin_y_character dw ?

	origin_x_enemy1 dw 0
	origin_y_enemy1 dw 0
	origin_x_enemy2 dw 0
	origin_y_enemy2 dw 0

	origin_x_monster dw 0
	origin_y_monster dw 0
	color_monster db 0
	height_triangle dw 0
	x_coord_triangle dw 0
	y_coord_triangle dw 0
	color_triangle db 3
	counter_triangle dw 1
	draw_counter db 0 	
	add_or_sub db 0

	draw_counter2 db 0
	add_or_sub2 db 0

	draw_counter3 db 0
	add_or_sub3 db 0

	draw_counter4 db 0

	color_reactangle db ?
	color_for_whole_screen db ?
	binary_check db 1
	remainder db ?
    enter_key_to_continue db "Press ENTER key to continue the game.","$"
    ending db "Game ended!!! Thanks for playing!",'$'
    game_name DB "S U P E R M A R I O",'$'
    lets_play DB "Press ENTER key to play game",'$'
    arr db "please enter your name: ",'$'
	user_name db 100 DUP(?)
	game_level db 1
	game_score db 0
	display_score db "Score = ","$"
	display_level db "Level = ","$"
	display_level_completed db "Level completed","$"
	display_all_levels_completed db "Congratulations!!! You have passed all the levels.","$"
	display_exit_string db "Press Enter key to Exit.","$"
	display_lives db "Lives = ","$"
	does_it_collide db 0
	collision_occuring_ONE db 0
	lives db 3
	lost_a_live db ". You have lost a life!","$"
	you_lost_all_lives db "You have Lost all your lifes.","$"
	print_stars db "* * * *","$"
.stack 100h
.code
	jmp start
delay proc                  ;the procedure to delay the program
	push ax
	push bx
	push cx
	push dx
	mov cx,1000
	mydelay:
	mov bx,300      ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.
	mydelay1:
	dec bx
	jnz mydelay1
	loop mydelay
	pop dx
	pop cx
	pop bx
	pop ax
	ret
delay endp

clear_entire_graphics proc
	mov color_reactangle,0
	mov height_of_reactangle,480
	mov length_of_reactangle,640
	mov x_coord_reactangle,0
	mov y_coord_reactangle,0
	call draw_reactangle
ret
clear_entire_graphics endp

draw_reactangle proc
	push x_coord_reactangle;backing of coordinates
	push y_coord_reactangle
	mov cx,0
	mov dx,0
	mov al, color_reactangle
	mov bh, 0
	mov cx,height_of_reactangle
	next_row:
		push x_coord_reactangle
		push cx
		mov cx,length_of_reactangle
		draw_lines:
			push cx
				mov ah, 0ch
				mov cx, x_coord_reactangle
				mov dx, y_coord_reactangle
				int 10h
				inc x_coord_reactangle
			pop cx
		loop draw_lines
		inc y_coord_reactangle
		pop cx
		pop x_coord_reactangle
	loop next_row
	pop y_coord_reactangle
	pop x_coord_reactangle
	ret
draw_reactangle endp

draw_triangle proc
	push x_coord_triangle
	push y_coord_triangle

	mov cx,0
	mov dx,0
	mov bh, 0
	mov al, color_triangle

	mov cx,height_triangle
	outer2:
		push cx
		push x_coord_triangle
		mov cx,0
		mov cx,counter_triangle

		inner2:
			push cx
			mov cx,0
			mov ah, 0ch
			mov cx, x_coord_triangle
			mov dx, y_coord_triangle
			inc x_coord_triangle
			int 10h
			pop cx
		loop inner2
		pop x_coord_triangle ;restorig the starting point
		sub x_coord_triangle,1
		add counter_triangle,2 ;for making it triangle
		inc y_coord_triangle 	;for next line
		pop cx
	loop outer2

	mov bx,1
	mov counter_triangle,bx ;initializing to 1
	pop y_coord_triangle
	pop x_coord_triangle
	ret
draw_triangle endp

set_cursor_at_row_and_column proc
    mov ah,02       ;set cursor to write super mario
    mov bh,0
    mov dh,row_number
    mov dl,column_number
    int 10h
    ret
set_cursor_at_row_and_column endp

set_color_on_whole_screen proc
    mov ah,06
    mov al,0
    mov ch,0
    mov dh,24
    mov cl,0
    mov dl,80
    mov bh,color_for_whole_screen
    int 10h
    ret
set_color_on_whole_screen endp

Draw_mario proc
	mov bx,0
	mov ax,0
	mov dx,0
	mov bx,origin_x_character		;40 staring axis
	mov ax,origin_y_character		;420
	cmp color_reactangle,0
	je make_mario_black
			;;stomach
		mov color_reactangle,6
		mov height_of_reactangle,20
		mov length_of_reactangle,19
		mov x_coord_reactangle,bx
		mov y_coord_reactangle,ax
		call draw_reactangle
		;;;;;;;;;;;;;;;leg1
		mov color_reactangle,7
		mov height_of_reactangle,10
		mov length_of_reactangle,3
		add x_coord_reactangle,3
		add y_coord_reactangle,20
		call draw_reactangle
		;;;;;;;;;;;;;;;leg2
		add x_coord_reactangle,10
		call draw_reactangle
		;;;;;;;;;;;;;;;Neck
		mov color_reactangle,8
		mov height_of_reactangle,5
		mov length_of_reactangle,4
		sub x_coord_reactangle,6
		sub y_coord_reactangle,25
		call draw_reactangle
		;;;;;;;;;;;;;;;Head
		mov color_reactangle,6
		mov height_of_reactangle,12
		mov length_of_reactangle,12
		sub x_coord_reactangle,4
		sub y_coord_reactangle,11
		call draw_reactangle
		;;;;;;;;;;;;;;;;right Arm
		mov color_reactangle,15
		mov height_of_reactangle,4
		mov length_of_reactangle,6
		add x_coord_reactangle,16
		add y_coord_reactangle,19
		call draw_reactangle
		;;;;;;;;;;;;;;;;left Arm
		sub x_coord_reactangle,25
		call draw_reactangle

	jmp skip_mario_make_black
	make_mario_black:
	;;stomach
	mov height_of_reactangle,20
	mov length_of_reactangle,19
	mov x_coord_reactangle,bx
	mov y_coord_reactangle,ax
	call draw_reactangle
	;;;;;;;;;;;;;;;leg1
	mov height_of_reactangle,10
	mov length_of_reactangle,3
	add x_coord_reactangle,3
	add y_coord_reactangle,20
	call draw_reactangle
	;;;;;;;;;;;;;;;leg2
	add x_coord_reactangle,10
	call draw_reactangle
	;;;;;;;;;;;;;;;Neck
	mov height_of_reactangle,5
	mov length_of_reactangle,4
	sub x_coord_reactangle,6
	sub y_coord_reactangle,25
	call draw_reactangle
	;;;;;;;;;;;;;;;Head
	mov height_of_reactangle,12
	mov length_of_reactangle,12
	sub x_coord_reactangle,4
	sub y_coord_reactangle,11
	call draw_reactangle
	;;;;;;;;;;;;;;;;right Arm
	mov height_of_reactangle,4
	mov length_of_reactangle,10
	add x_coord_reactangle,16
	add y_coord_reactangle,19
	call draw_reactangle
	;;;;;;;;;;;;;;;;left Arm
	sub x_coord_reactangle,29
	call draw_reactangle

	skip_mario_make_black:
	ret
Draw_mario endp

Draw_enemy proc
	mov ax,0
	mov bx,0
	mov ax,origin_x_enemy1
	mov bx,origin_y_enemy1

	;;;head
	mov x_coord_triangle,ax	;170
	mov y_coord_triangle,bx	;400
	mov height_triangle,10
	;mov color_triangle,3
	call draw_triangle
	;;;foot one
	mov ax,origin_x_enemy1
	mov bx,origin_y_enemy1
	add bx,10
	sub ax,4	
	mov height_of_reactangle,10
	mov length_of_reactangle,3
	mov x_coord_reactangle,ax
	mov y_coord_reactangle,bx
	call draw_reactangle

	;;;foot two
	mov ax,origin_x_enemy1
	mov bx,origin_y_enemy1
	add bx,10
	add ax,2	
	mov height_of_reactangle,10
	mov length_of_reactangle,3
	mov x_coord_reactangle,ax
	mov y_coord_reactangle,bx
	call draw_reactangle
ret
Draw_enemy endp

Draw_enemy2 proc
	mov ax,0
	mov bx,0
	mov ax,origin_x_enemy2
	mov bx,origin_y_enemy2

	;;;head
	mov x_coord_triangle,ax	;340
	mov y_coord_triangle,bx	;400
	mov height_triangle,10
	;mov color_triangle,3
	call draw_triangle
		;;;foot one
	mov ax,origin_x_enemy2
	mov bx,origin_y_enemy2
	add bx,10
	sub ax,4
	mov height_of_reactangle,10
	mov length_of_reactangle,3
	mov x_coord_reactangle,ax
	mov y_coord_reactangle,bx
	call draw_reactangle

	;;;foot two
	mov ax,origin_x_enemy2
	mov bx,origin_y_enemy2
	add bx,10
	add ax,2
	mov height_of_reactangle,10
	mov length_of_reactangle,3
	mov x_coord_reactangle,ax
	mov y_coord_reactangle,bx
	call draw_reactangle
ret
Draw_enemy2 endp

Draw_monster proc
	mov ax,0
	mov bx,0
	cmp bl,color_monster
	jne skip_make_color
	jmp make_monster_black
	skip_make_color:
	mov color_triangle,4
	mov ax,origin_x_monster		;right trianlge
	mov bx,origin_y_monster
	mov x_coord_triangle,ax	;340
	mov y_coord_triangle,bx	;180
	mov height_triangle,10
	call draw_triangle
	sub x_coord_triangle,24		;;left trianlge
	call draw_triangle
	mov height_of_reactangle,3	;left trianlge eye
	mov length_of_reactangle,3
	mov ax,0
	mov ax,x_coord_triangle
	mov bx,0
	mov bx,y_coord_triangle
	dec ax
	add bx,3
	mov x_coord_reactangle,ax	;316
	mov y_coord_reactangle,bx	;183
	mov color_reactangle,5
	call draw_reactangle
	add x_coord_reactangle,23	;right trianlge eye
	call draw_reactangle
	mov height_of_reactangle,20	;stomach
	mov length_of_reactangle,50
	sub x_coord_reactangle,35
	add y_coord_reactangle,7
	mov color_reactangle,6
	call draw_reactangle
	mov height_of_reactangle,4	;left hand
	mov length_of_reactangle,10
	sub x_coord_reactangle,10
	add y_coord_reactangle,3
	mov color_reactangle,7
	call draw_reactangle
	add x_coord_reactangle,60	;right hand
	call draw_reactangle
	jmp endpp
	make_monster_black:
	mov color_reactangle,0
	mov color_triangle,0
	mov ax,origin_x_monster		;right trianlge
	mov bx,origin_y_monster
	mov x_coord_triangle,ax	;340
	mov y_coord_triangle,bx	;180
	mov height_triangle,10
	call draw_triangle
	sub x_coord_triangle,24		;;left trianlge
	call draw_triangle
	mov height_of_reactangle,3	;left trianlge eye
	mov length_of_reactangle,3
	mov ax,0
	mov ax,x_coord_triangle
	mov bx,0
	mov bx,y_coord_triangle
	dec ax
	add bx,3
	mov x_coord_reactangle,ax	;316
	mov y_coord_reactangle,bx	;183
	call draw_reactangle
	add x_coord_reactangle,23	;right trianlge eye
	call draw_reactangle
	mov height_of_reactangle,20	;stomach
	mov length_of_reactangle,50
	sub x_coord_reactangle,35
	add y_coord_reactangle,7
	call draw_reactangle
	mov height_of_reactangle,4	;left hand
	mov length_of_reactangle,10
	sub x_coord_reactangle,10
	add y_coord_reactangle,3
	call draw_reactangle
	add x_coord_reactangle,60	;right hand
	call draw_reactangle
	endpp:
ret
Draw_monster endp 

zig_zaq_enemy_1 proc
		push cx
	push bx
	mov ax,0
	mov bx,0
	inc draw_counter
	mov bl,10
	cmp bl,draw_counter
		jne skip_draw_enemy_again
	mov color_triangle,0
	mov color_reactangle,0
	call Draw_enemy

	mov ax,140
	cmp origin_x_enemy1,ax ;if equal then it will add in x
	je make_add_or_sub_zero

	mov ax,280
	cmp origin_x_enemy1,ax
	jg make_add_or_sub_ONE
	jmp skip_make_ONE
	make_add_or_sub_ONE:
		mov bl,1
		mov add_or_sub,bl
	jmp skip_make_ONE
	make_add_or_sub_ZERO:
		mov bl,0
		mov add_or_sub,bl

	skip_make_ONE:
		mov bx,0

		cmp add_or_sub,bl 	;if 0 then add in enemy x if 1 sub from enemy x
		je add_in_enemy_x
			sub_in_enemy_x:
			sub origin_x_enemy1,5
			jmp skip_add
				add_in_enemy_x:
					add origin_x_enemy1,5

	skip_add:

	mov color_triangle,10 	;drawing enemy
	mov color_reactangle,10

	call Draw_enemy

	mov bl,0
	mov draw_counter,bl 	;restoring draw_counter to zero
	skip_draw_enemy_again:

	pop bx
	pop cx
	ret
zig_zaq_enemy_1 endp

zig_zaq_enemy_2 proc
push cx
	push bx
	mov ax,0
	mov bx,0
	inc draw_counter2
	mov bl,10
	cmp bl,draw_counter2
		jne skip_draw_enemy_again2
	mov color_triangle,0
	mov color_reactangle,0
	call Draw_enemy2

	mov ax,330
	cmp origin_x_enemy2,ax ;if equal then it will add in x
	je make_add_or_sub_zero2

	mov ax,480
	cmp origin_x_enemy2,ax
	jg make_add_or_sub_ONE2
	jmp skip_make_ONE2
	make_add_or_sub_ONE2:
		mov bl,1
		mov add_or_sub2,bl
	jmp skip_make_ONE2
	make_add_or_sub_ZERO2:
		mov bl,0
		mov add_or_sub2,bl

	skip_make_ONE2:
		mov bx,0

		cmp add_or_sub2,bl 	;if 0 then add in enemy x if 1 sub from enemy x
		je add_in_enemy_x2
			sub_in_enemy_x2:
			sub origin_x_enemy2,5
			jmp skip_add2
				add_in_enemy_x2:
					add origin_x_enemy2,5

	skip_add2:

	mov color_triangle,10 	;drawing enemy
	mov color_reactangle,10
	call Draw_enemy2

	mov bl,0
	mov draw_counter2,bl 	;restoring draw_counter to zero
	skip_draw_enemy_again2:

	pop bx
	pop cx
	ret
zig_zaq_enemy_2 endp

zig_zaq_monster proc
	push cx
	push bx
	mov ax,0
	mov bx,0
	inc draw_counter3
	mov bl,4
	cmp bl,draw_counter3
		jne skip_draw_monster_again
	mov color_monster,0
	call Draw_monster

	mov ax,50
	cmp origin_x_monster,ax ;if equal then it will add in x
	je make_add_or_sub_zero3

	mov ax,580
	cmp origin_x_monster,ax
	jg make_add_or_sub_ONE3
	jmp skip_make_ONE3
	make_add_or_sub_ONE3:
		mov bl,1
		mov add_or_sub3,bl
	jmp skip_make_ONE3
	make_add_or_sub_ZERO3:
		mov bl,0
		mov add_or_sub3,bl

	skip_make_ONE3:
		mov bx,0

		cmp add_or_sub3,bl 	;if 0 then add in monster x if 1 sub from monster x
		je add_in_monster_x
			sub_in_monster_x:
			sub origin_x_monster,5
			jmp skip_add3
				add_in_monster_x:
					add origin_x_monster,5

	skip_add3:

	mov color_monster,3 	;drawing monster
	call Draw_monster

	mov bl,0
	mov draw_counter3,bl 	;restoring draw_counter to zero
	skip_draw_monster_again:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;fire implementation
	inc draw_counter4		;for slowing down fire object
	mov bl,5
	cmp bl,draw_counter4
	jne skip_fire_conditions
	mov draw_counter4,0

	mov color_reactangle,0
	call draw_fire_object

	cmp fire_reached,1 ; 1 when fire object is in air 
	je increment_in_fire_object_till_it_reached_ground

	fire_start:	;0 when monster didnt fire so start firing
		mov fire_reached,1
		mov bx,0
		mov bx,origin_x_monster
		mov cx,0
		mov cx,origin_y_monster
		add cx,20
		mov origin_x_fire,bx 	;setting axis of monster to fire object
		mov origin_y_fire,cx 
	jmp skip_fire_conditions
	increment_in_fire_object_till_it_reached_ground:
		add origin_y_fire,5

	cmp origin_y_fire,430 	;floor y axis
	je fire_object_reached_floor

	mov ax,85 	;checking first hurdle top from left starting point
	cmp origin_x_fire,ax
	jg check_is_it_less_than_end_of_first_hurdle_top
	jmp draw_still	

	check_is_it_less_than_end_of_first_hurdle_top:
		mov ax,135
		cmp origin_x_fire,ax
		jl check_heigth_of_hurdle_1

	jmp skip_hurdle_1_check

	check_heigth_of_hurdle_1:
		mov ax,380 	;heigth of first hurdle
		cmp origin_y_fire,ax
		je fire_object_reached_floor
		jmp draw_still
	skip_hurdle_1_check:
		mov ax,0
		mov ax,275
		cmp origin_x_fire,ax
		jg check_right_side_hurdle_2_top
		jmp skip_hurdle_2_check
	check_right_side_hurdle_2_top:
		mov ax,0
		mov ax,325 	;right end of hurdle 2 top
		cmp origin_x_fire,ax
		jl check_heigth_of_hurdle_2
	jmp skip_hurdle_2_check
	check_heigth_of_hurdle_2:
		mov ax,0
		mov ax,360
		cmp origin_y_fire,ax
		je fire_object_reached_floor
		jmp draw_still

	skip_hurdle_2_check:
		mov ax,0
		mov ax,480
		cmp origin_x_fire,ax
		jg check_hurdle_3_right_top
		jmp draw_still
	check_hurdle_3_right_top:
		mov ax,0
		mov ax,530
		cmp origin_x_fire,ax
		jl check_heigth_of_hurdle_3
		jmp draw_still

	check_heigth_of_hurdle_3:
		mov ax,0
		mov ax,390
		cmp origin_y_fire,ax
		je fire_object_reached_floor
	draw_still:
	mov color_reactangle,5
	call draw_fire_object
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	detection_of_mario_with_fire_object:
	mov ax,0
	mov ax,origin_x_fire	;comparing x axis
	cmp origin_x_character,ax
	je check_y_axis_colliding

	jmp skip_fire_conditions
	check_y_axis_colliding:
		mov ax,0
		mov ax,origin_y_fire
		cmp ax,origin_y_character
		je collision_occuring_with_fire

	mov ax,0
	mov ax,origin_x_fire	;comparing x axis
	add ax,5
	cmp origin_x_character,ax
	je check_y_axis_colliding2

	jmp skip_fire_conditions
	check_y_axis_colliding2:
		mov ax,0
		mov ax,origin_y_fire
		sub ax,5
		cmp ax,origin_y_character
		je collision_occuring_with_fire

	jmp skip_fire_collision_initializing
	collision_occuring_with_fire:
		mov mario_colliding_with_fire,1 ;1 means collided 

	skip_fire_collision_initializing:
	jmp skip_fire_conditions
	fire_object_reached_floor:
		mov fire_reached,0

	skip_fire_conditions:
	pop bx
	pop cx

ret 
zig_zaq_monster endp

draw_fire_object proc
	mov height_of_reactangle,5
	mov length_of_reactangle,5
	mov ax,0
	mov bx,0
	mov ax,origin_x_fire
	mov bx,origin_y_fire
	mov x_coord_reactangle,ax
	mov y_coord_reactangle,bx
	call draw_reactangle

ret 
draw_fire_object endp

Darw_obstacles_and_flag proc
		mov ah, 00h ;video mode
	mov al, 12h
	int 10h
	mov color_reactangle,3
	;;;;;;;;;;;;;;;;;;;;;;;hurdle 1			;;;;;;;;;;;;;;;;;;Drawing objects
	mov color_reactangle,4
	mov height_of_reactangle,30
	mov length_of_reactangle,20
	mov x_coord_reactangle,110
	mov y_coord_reactangle,420
	call draw_reactangle
	;;;;;;;;;;;;;;;;;;;;;;;hurdle top of 1
	mov color_reactangle,8
	mov height_of_reactangle,10
	mov length_of_reactangle,40
	mov x_coord_reactangle,100
	mov y_coord_reactangle,410
	call draw_reactangle
	;;;;;;;;;;;;;;;;;;;;;;;;hurdle 2
	mov color_reactangle,4
	mov height_of_reactangle,50
	mov length_of_reactangle,20
	mov x_coord_reactangle,300
	mov y_coord_reactangle,400
	call draw_reactangle
	;;;;;;;;;;;;;;;;;;;;;;;hurdle top of 2
	mov color_reactangle,8
	mov height_of_reactangle,10
	mov length_of_reactangle,40
	mov x_coord_reactangle,290
	mov y_coord_reactangle,390
	call draw_reactangle
	;;;;;;;;;;;;;;;;;;;;;;;;hurdle 3
	mov color_reactangle,4
	mov height_of_reactangle,25
	mov length_of_reactangle,20
	mov x_coord_reactangle,500
	mov y_coord_reactangle,430
	call draw_reactangle
	;;;;;;;;;;;;;;;;;;;;;;;hurdle top of 3
	mov color_reactangle,8
	mov height_of_reactangle,10
	mov length_of_reactangle,40
	mov x_coord_reactangle,490
	mov y_coord_reactangle,420
	call draw_reactangle
	;;;;;;;;;;;;;;;;;;;;;;;;bottom layer of game
	mov color_reactangle,9
	mov height_of_reactangle,35
	mov length_of_reactangle,640
	mov x_coord_reactangle,0
	mov y_coord_reactangle,450
	call draw_reactangle
	mov bl,3
	cmp game_level,bl
	je skip_flag
	;;;;;;;;;;;;;;;;;;;;;;;;;making flag
	;;pole
	mov color_reactangle,7
	mov height_of_reactangle,300
	mov length_of_reactangle,10
	mov x_coord_reactangle,630
	mov y_coord_reactangle,200
	call draw_reactangle
	;;flag
	mov color_reactangle,1
	mov height_of_reactangle,80
	mov length_of_reactangle,80
	mov x_coord_reactangle,550
	mov y_coord_reactangle,200
	call draw_reactangle
	jmp skip_ki
	;;;;;;;;;;;;;;;;;;;;;;;;;drawing kindom
	skip_flag:
	mov x_coord_triangle,633
	mov y_coord_triangle,413
	mov height_triangle,7
	mov color_triangle,9
	call draw_triangle
	mov x_coord_triangle,617 ;top triangles;2
	call draw_triangle	
	mov x_coord_triangle,601 	;1
	call draw_triangle

	mov color_reactangle,7
	mov height_of_reactangle,10 ;walls
	mov length_of_reactangle,10
	mov x_coord_reactangle,597
	mov y_coord_reactangle,420
	call draw_reactangle

	mov x_coord_reactangle,613
	call draw_reactangle
	mov x_coord_reactangle,629
	call draw_reactangle	

	mov color_reactangle,8
	mov height_of_reactangle,20 	;base
	mov length_of_reactangle,47
	mov x_coord_reactangle,594
	mov y_coord_reactangle,430
	call draw_reactangle			

	skip_ki:
	ret
Darw_obstacles_and_flag endp

check_obstacles_detection proc
		mov ax,0
		mov ax,85	;starting point of hurdle 1
		cmp ax,origin_x_character		;checking mario for touching first obstacle from left side
		jne check_first_obstacle_from_right_side
		sub ax,5
		jmp checked_conditions

		check_first_obstacle_from_right_side:
			mov ax,0
			mov ax,135	;ending point of hurdle 1
			cmp ax,origin_x_character	;checking mario for touching first obstacle from right side
			jne check_second_obstacle_from_left_side
			add ax,5
			jmp checked_conditions
		check_second_obstacle_from_left_side:
			mov ax,0
			mov ax,280	;starting point of hurdle 2
			cmp ax,origin_x_character	;checking mario for touching second obstacle from left side
			jne check_second_obstacle_from_right_side
			sub ax,5
			jmp checked_conditions
		check_second_obstacle_from_right_side:
			mov ax,0
			mov ax,325	;ending point of hurdle 2
			cmp ax,origin_x_character	;checking mario for touching second obstacle from right side
			jne check_third_obstacle_from_left_side
			add ax,5
			jmp checked_conditions
		check_third_obstacle_from_left_side:
			mov ax,0
			mov ax,470	;starting point of hurdle 3
			cmp ax,origin_x_character	;checking mario for touching third obstacle from left side
			jne check_third_obstacle_from_right_side
			sub ax,5
			jmp checked_conditions
		check_third_obstacle_from_right_side:
			mov ax,0
			mov ax,535	;ending point of hurdle 3
			cmp ax,origin_x_character	;checking mario for touching third obstacle from right side
			jne end_obstacles_conditions
			add ax,5
			jmp checked_conditions
		checked_conditions:
			mov origin_x_character,ax
			end_obstacles_conditions:
	ret
check_obstacles_detection endp

make_it_multiple_of_5 proc
	mov ax,0
	mov bx,0
	mov ax,origin_x_character
	mov bl,5
	div bl
	mov remainder,ah
	mov bl,5
	sub bl,remainder
	cmp bl,5
	je skip_extra_add
	add origin_x_character,bx
	skip_extra_add:
	ret 
make_it_multiple_of_5 endp

mov_mario_to_ground_function proc
	mov_mario_to_ground:
		mov color_reactangle,0
		call Draw_mario
		mov bx,0
		mov bx,420
		cmp origin_y_character,bx
		je skip_addtion

		add origin_y_character,5
		mov color_reactangle,3
		call Draw_mario

	jmp mov_mario_to_ground
	skip_addtion:
ret
mov_mario_to_ground_function endp

check_detection_with_obstacles_when_jump_is_taken_or_falling_down proc 	;conditions when mario touch with borders of obstacles while jumping
	mov does_it_collide,0
	call make_it_multiple_of_5
	mov ax,0
	mov ax,420	;	is mario off the floor (condition)
	cmp origin_y_character,ax 	
	je skip_value_move
	mov ax,0
	mov ax,380 	;height of first hurdle 
	cmp origin_y_character,ax 	;checking when collide from left side of hurdle 1
	jg check_x_axis_for_hurdle1
	jmp skip_condition_of_collision_hurdle1

	check_x_axis_for_hurdle1:
		mov ax,0
		mov ax,75
		cmp origin_x_character,ax 	;checking for x axis of hurdle 1
		je collision_occuring

	skip_condition_of_collision_hurdle1:
	mov ax,0
	mov ax,360
	cmp origin_y_character,ax 	;checking when collide from left side of hurdle 2
	jg check_x_axis_for_hurdle2
	jmp skip_condition_of_collision_hurdle2

	check_x_axis_for_hurdle2:
		mov ax,0
		mov ax,265
		cmp origin_x_character,ax 
		je collision_occuring

	skip_condition_of_collision_hurdle2:
		mov ax,0
		mov ax,390
		cmp origin_x_character,ax
		jg check_x_axis_for_hurdle3
	jmp skip_value_move

	check_x_axis_for_hurdle3:
		mov ax,0
		mov ax,475
		je collision_occuring

	jmp skip_value_move
	collision_occuring:
		mov does_it_collide,1 	;1 for collision
	skip_value_move:

	ret 
check_detection_with_obstacles_when_jump_is_taken_or_falling_down endp

detection_with_enemies proc
	checking_x_axis_of_mario_and_enemy1:
		mov ax,0
		mov ax,origin_x_enemy1
		cmp ax,origin_x_character 	;checking x axis of both characters
		je check_difference_of_y_axix_of_mario_and_enemy1
		jmp now_check_collision_with_enemy2
	check_difference_of_y_axix_of_mario_and_enemy1:
		mov bx,0
		mov bx,origin_y_character
		add bx,10
		cmp bx,430	;y axis for enemies (both same)
			je collision_occuring_with_enemy
		jmp now_check_collision_with_enemy2

		collision_occuring_with_enemy:
			mov collision_occuring_ONE,1	;1 for collision make level end
		jmp end_check_collion_with_enemies
	now_check_collision_with_enemy2:
		mov ax,0
		mov ax,origin_x_enemy2
		cmp ax,origin_x_character 	;checking x axis of both characters
		je check_difference_of_y_axix_of_mario_and_enemy2
		jmp end_check_collion_with_enemies

		check_difference_of_y_axix_of_mario_and_enemy2:
			mov bx,0
			mov bx,origin_y_character
			add bx,10
			cmp bx,430
				je collision_occuring_with_enemy

	end_check_collion_with_enemies:
ret
detection_with_enemies endp

start:
main proc
	mov ax,@data
	mov ds,ax

	mov ah,00       ;video mode
	mov al,03
	int 10h

	mov color_for_whole_screen,01000000b    ;for red color(whole screen)
	call set_color_on_whole_screen

mov cx,5
l5:
    call delay
loop l5

mov ah,06   ;for blue box
mov al,0
mov ch,9
mov dh,11
mov cl,28
mov dl,48
mov bh,14h
int 10h


mov row_number,10
mov column_number,28
call set_cursor_at_row_and_column  ;set cursor to write super mario


mov  si,offset game_name
mov cx,19

l1:                 ;writing name super mario
    push cx

    mov ah,02       ;moving cursor forward
    mov bh,0
    inc dl
    int 10h

    mov ah,09           ; to write after cursor position
    mov al,[si]	        ;the letter or ascci
    mov bh,0	        ;page no
    mov bl,71h	        ;color number
   

    mov cx,1	        ;number of times printing
    int 10h
    inc si

    call delay
    pop cx
    add bl,cl          ;to change color for every row

loop l1

mov row_number,12
mov column_number,28
call set_cursor_at_row_and_column  ;set cursor to write lets_play

mov dx,offset lets_play     ;display the LETS PLAY string
mov ah,09
int 21h

game_start_when_enter_key_press:
    mov ah,10h  ;keyboard input ( 10h = wait for key)
    int 16h

    cmp ah,1ch   ;comparing scan code of enter key which is 1c
    jne game_start_when_enter_key_press

;first page completed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov color_for_whole_screen,00000000b    ;for black color(whole screen)
call set_color_on_whole_screen

        mov ax,03h
        int 10h

mov row_number,10
mov column_number,14
call set_cursor_at_row_and_column   ;setting cursor to ask name

        
        mov ah,09
        mov dx, OFFSET arr
        int 21H
     
inc row_number
call set_cursor_at_row_and_column       ;next row for drawing astarik


mov cx,22       ;drawing astarik
trm:
    mov dx,02ah		
    mov ah,02
    int 21h
loop trm

dec row_number
mov column_number,37
call set_cursor_at_row_and_column ;setting cursor for name input infront of enter name string

mov si,offset user_name

user_name_input:                                 ;taking name input from user
    mov ah,01
    int 21h
    cmp al,13;
    je exit
    mov [si],al
    inc si
jmp user_name_input

exit:
    inc si
    mov bl,'$'
    mov [si],bl
;input taken of name in user_name

                 
mov row_number,13       ;setting cursor to write enter_key_to_continue string   
mov column_number,20
call set_cursor_at_row_and_column

mov dx,offset enter_key_to_continue
mov ah,09
int 21h

press_enter_key_to_continue:
    mov ah,10h  ;keyboard input ( 10h = wait for key)
    int 16h

    cmp ah,1ch   ;comparing scan code of enter key which is 1c
    jne press_enter_key_to_continue

;page 2 completed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

draw_again_all:	;;;;;;;;;;;;;;;;;;;when level complete

;;;;;;;;;initializing variables for the game
mov origin_x_character,30;30
mov origin_y_character,420

mov bl,1
cmp bl,game_level
je skip_draw_e4
mov origin_x_enemy1,170 	;enemy1 characters axis
mov origin_y_enemy1,430

mov origin_x_enemy2,340		;enemy2 characters axis
mov origin_y_enemy2,430
skip_draw_e4:
mov bl,3
cmp bl,game_level
jne skip_initializing_monster
	initializing_monster_axis:
		mov origin_x_monster,340
		mov origin_y_monster,180	

;;;;;;;;;;;;;;;;;;;;;;;;;


skip_initializing_monster:

call Darw_obstacles_and_flag 	;drawing objects
mov dx,offset user_name
mov ah,09
int 21h
mov row_number,1         
mov column_number,0
call set_cursor_at_row_and_column

mov dx,offset display_level
mov ah,09
int 21h
mov dl,game_level
add dl,48
mov ah,02
int 21h
mov row_number,2         
mov column_number,0
call set_cursor_at_row_and_column

mov dx,offset display_score
mov ah,09
int 21h
mov dl,game_score
add dl,48
mov ah,02
int 21h

mov row_number,0      
mov column_number,55
call set_cursor_at_row_and_column

mov dx,offset display_exit_string
mov ah,09
int 21h

mov row_number,1      
mov column_number,55
call set_cursor_at_row_and_column

mov dx,offset display_lives
mov ah,09
int 21h
mov dl,lives
add dl,48
mov ah,02
int 21h

mov row_number,13
mov column_number,70
call set_cursor_at_row_and_column

mov dx,offset print_stars
mov ah,09
int 21h
mov row_number,15
mov column_number,70
call set_cursor_at_row_and_column

mov dx,offset print_stars
mov ah,09
int 21h


game_start:
;;;;;;;;;;;;;;;;;;;;;;;;making character
mov color_reactangle,3
call Draw_mario

mov bl,1
cmp game_level,bl 	;checking game level
je skip_draw_e3

call detection_with_enemies

mov al,collision_occuring_ONE
cmp al,1 	;1 for collision
je lose_a_life_screen

call zig_zaq_enemy_1
call zig_zaq_enemy_2
skip_draw_e3:
mov al,3
cmp game_level,al;;;;;;;;;;;;;;;;;;;drawing monster
jne skip_draw_monster

call zig_zaq_monster

cmp mario_colliding_with_fire,1
je lose_a_life_screen

skip_draw_monster:


input_key:
		mov ah,1h	;enter key
		int 16h
		
		jz taken_one_input 	;if zf=0 then then key is pressed
		mov ah,0
		int 16h

		cmp ah,48h
		je up_arrow_pressed

		cmp ah,50h
		je down_arrow_pressed

		cmp ah,4dh
		je right_arrow_pressed

		cmp ah,4bh
		je left_arrow_pressed

		cmp al,27	;terminate when ESC is pressed
		jne end_conditons


		clear_screen:
			call clear_entire_graphics
			jmp end_input

		end_conditons:
		
	jmp input_key
	taken_one_input:

	checking_for_fall_of_mario_from_obstacle_top:	;when mario is on top of hurdle and it moves forward to fall down implement 
		mov ax,0
		mov ax,420	;floor y point
		cmp origin_y_character,ax 	;checking mario already on floor or not
		je skip_move_mario_to_floor
		mov ax,0
		mov ax,80	;starting point of hurdle top 1
		cmp origin_x_character,ax 	;fall when mario move backward from hurdle top 1
		jl mov_mario_to_ground2
		mov ax,140	;ending point of hurdle top 1
		cmp origin_x_character,ax	;checking is mario is moving forward from hurdle top 1
		jg check_is_mario_before_hurdle2_top

		jmp skip_check_mario_btw_hurdle_1_and_2

		check_is_mario_before_hurdle2_top: 	;checking is mario before hurdle top 2
			mov ax,0
			mov ax,270	;starting point of hurdle top 2
			cmp origin_x_character,ax
			jl mov_mario_to_ground2

		skip_check_mario_btw_hurdle_1_and_2:
		mov ax,0
		mov ax,330	;ending point of hurdle top 2
		cmp origin_x_character,ax 		;if mario move forward from hurdle top 2
		jg check_is_mario_before_hurdle3_top

		jmp skip_check_mario_btw_hurdle_2_and_3

		check_is_mario_before_hurdle3_top:
			mov ax,0
			mov ax,470 	;starting point of hurdle top 3
			cmp origin_x_character,ax
			jl mov_mario_to_ground2

		skip_check_mario_btw_hurdle_2_and_3:

		check_mario_is_moving_forward_from_hurdle_3_top:
			mov ax,0
			mov ax,535
			cmp origin_x_character,ax 	;if mario move forward from hurdle top 3
			jg mov_mario_to_ground2

		jmp skip_move_mario_to_floor
		mov_mario_to_ground2:
		call mov_mario_to_ground_function

		skip_move_mario_to_floor:

	checking_mario_axis_for_obstacles:
		mov ax,0
		mov ax,420
		cmp origin_y_character,ax 	;checking_mario_is_on_floor
		jne game_start
		call check_obstacles_detection ;obstacle touching conditions function

	check_flag_touch:
		mov bl,3
		cmp bl,game_level	;extra x axix checking when level is 3
		je check_level_complete_of_level_3

		mov ax,0
		mov ax,605	;flag conditions 
		cmp origin_x_character,ax 	; flag touching condition
		jg level_completed

		check_level_complete_of_level_3:
			mov ax,0
			mov ax,580
			cmp origin_x_character,ax
			jg level_completed

		jmp skip_level_check

		level_completed:		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;level checking
			inc game_level
			;;;;;;;;;initializing variables for the game
			add game_score,2
			call clear_entire_graphics

			mov row_number,12
			mov column_number,28
			call set_cursor_at_row_and_column  ;set cursor to write level completed

			mov dx,offset display_level_completed     
			mov ah,09
			int 21h

			mov row_number,13
			mov column_number,28
			call set_cursor_at_row_and_column  ;set cursor to write  continue string

			mov dx,offset enter_key_to_continue
			mov ah,09
			int 21h

			game_start_when_enter_key_press2:
			    mov ah,10h  ;keyboard input ( 10h = wait for key)
			    int 16h

			    cmp ah,1ch   ;comparing scan code of enter key which is 1c
			    jne game_start_when_enter_key_press2
			 mov bl,4
			 cmp bl,game_level
			 je all_levels_completed
			 jmp draw_again_all

		skip_level_check:
	jmp game_start		

	;mov color_for_whole_screen,0
	;call set_color_on_whole_screen

jmp game_start
	lose_a_life_screen:;;;;;;;;;;;;;;;;;;;;;;;;;;when collide with enemy or fire
		mov bl,0
		mov mario_colliding_with_fire,bl
		mov collision_occuring_ONE,bl
		call clear_entire_graphics
		mov row_number,14
		mov column_number,15
		call set_cursor_at_row_and_column

		mov dx,offset user_name
		mov ah,09
		int 21h

		mov dx,offset lost_a_live
		mov ah,09
		int 21h

		dec lives

		mov bl,0
		cmp bl,lives
			je last_screen 	;mov to end when all lives lost

		mov row_number,15
		mov column_number,28
		call set_cursor_at_row_and_column

		mov dx,offset enter_key_to_continue
		mov ah,09
		int 21h

		press_enter_key_to_continue3:
  			mov ah,10h  ;keyboard input ( 10h = wait for key)
    		int 16h

			cmp ah,1ch   ;comparing scan code of enter key which is 1c
			jne press_enter_key_to_continue3
		jmp draw_again_all ;reset the game when a life is lost lost
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	up_arrow_pressed:			;;;;;;;;;;;;;;;;;;;;jump mario code start
		;mov color_reactangle,0
		;call Draw_mario
		;comment!
		call make_it_multiple_of_5
		;;;;;;;;;;neccessary jumping conditions
		mov ax,80 	;hurdle1
		cmp ax,origin_x_character
		je end_mario_jump

		mov ax,270 	;hurdle 2
		cmp origin_x_character,ax
		je end_mario_jump

		mov ax,460	;hurdle 3
		cmp origin_x_character,ax
		je end_mario_jump
		mov ax,465	;hurdle 3
		cmp origin_x_character,ax
		je end_mario_jump
		;;;;;;;;;;;;;;;
		mov al, 3;for graphics
		mov bh, 0
		mov cx,40
		mov_to_top:
			mov bl,1	;draw enemy when level is not 1
			cmp game_level,bl
			je skip_draw_e2
			call zig_zaq_enemy_1
			call zig_zaq_enemy_2
			skip_draw_e2:
			mov al,3
			cmp game_level,al;;;;;;;;;;;;;;;;;;;drawing monster
			jne skip_draw_monster4
			call zig_zaq_monster
			cmp mario_colliding_with_fire,1
			je lose_a_life_screen
			skip_draw_monster4:
			check_flag_touch2:
			mov ax,605	;flag conditions 
			cmp origin_x_character,ax 	; flag touching condition
			jg level_completed
			mov does_it_collide,0
			push cx
			mov color_reactangle,0
			call Draw_mario
			cmp binary_check,0
			je add_in_x
			sub origin_y_character,5 	;telling ky kinta increment ya decrement karna hai in origin_y_character
			dec binary_check	;making 0
			jmp skip_add_in_x
			add_in_x:
			add origin_x_character,3 	;telling ky kinta increment ya decrement karna hai in origin_x_character
			inc binary_check	;making 1
			skip_add_in_x:
			call check_detection_with_obstacles_when_jump_is_taken_or_falling_down
			cmp does_it_collide,1 	;when it is 1 means invalid jump we have to make it to move to ground
			je mov_down
			jmp skip_it
			mov_down:
				call mov_mario_to_ground_function
				jmp end_mario_jump
			skip_it:
			mov color_reactangle,3
			call Draw_mario
			pop cx		
			cmp origin_y_character,420;checking floor
			je end_mario_jump
		loop mov_to_top

		mov_to_bottom:
			mov bl,1	;draw enemy when level is not 1
			cmp game_level,bl
			je skip_draw_e1
			call zig_zaq_enemy_1
			call zig_zaq_enemy_2
			skip_draw_e1:

			mov bl,3
			cmp game_level,al;;;;;;;;;;;;;;;;;;;drawing monster
			jne skip_draw_monster3
			call zig_zaq_monster
			cmp mario_colliding_with_fire,1
			je lose_a_life_screen
			skip_draw_monster3:

			check_flag_touch3:
			mov ax,0
			mov ax,605	;flag conditions 
			cmp origin_x_character,ax 	; flag touching condition
			jg level_completed

			mov does_it_collide,0
			mov color_reactangle,0
			call Draw_mario
			mov bl,0
			cmp binary_check,bl
			je add_in_x2
			add origin_y_character,5 	;telling ky kinta increment ya decrement karna hai in origin_y_character
			dec binary_check	;making 0
			jmp skip_add_in_x2
			add_in_x2:
			add origin_x_character,3 	;telling ky kinta increment ya decrement karna hai in origin_x_character
			inc binary_check	;making 1
			skip_add_in_x2:

			call check_detection_with_obstacles_when_jump_is_taken_or_falling_down
			mov al,1
			cmp does_it_collide,al 	;when it is 1 means invalid jump we have to make it to move to ground
			je mov_down

			mov color_reactangle,3
			call Draw_mario

			;;;;;;;;;;;;;;;;;;;implementation of hurdles top collision detection;;;;;;;;stay on hurdles tops
			mov dx,0
			mov dx,380
			cmp dx,origin_y_character	;comparing height of mario with first hurdle
			je height_match_of_hurdle_1
			jmp skip_check_hurdel1_top
			height_match_of_hurdle_1:
				mov dx,0
				mov dx,85	;starting value of hurdle1 TOP 
				cmp origin_x_character,dx
				jg starting_range_matched_hurdle1_top
			jmp skip_check_hurdel1_top
			starting_range_matched_hurdle1_top:
				mov dx,135		;ending value of hurdle1 TOP
				cmp origin_x_character,dx
				jl end_mario_jump

			skip_check_hurdel1_top:
			mov dx,0
			mov dx,360
			cmp dx,origin_y_character	;comparing height of mario with second hurdle
			je height_match_of_hurdle_2
			jmp skip_check_hurdel2_top
			height_match_of_hurdle_2:
				mov dx,0
				mov dx,275	;starting value of hurdle2 TOP 
				cmp origin_x_character,dx
				jg starting_range_matched_hurdle2_top
			jmp skip_check_hurdel2_top
			starting_range_matched_hurdle2_top:
				mov dx,0
				mov dx,325		;ending value of hurdle2 TOP
				cmp origin_x_character,dx
				jl end_mario_jump

			skip_check_hurdel2_top:
			mov dx,0
			mov dx,390
			cmp dx,origin_y_character	;comparing height of mario with third hurdle
			je height_match_of_hurdle_3
			jmp skip_check_hurdel3_top
			height_match_of_hurdle_3:
				mov dx,0
				mov dx,480	;starting value of hurdle3 TOP 
				cmp origin_x_character,dx
				jg starting_range_matched_hurdle3_top
			jmp skip_check_hurdel3_top
			starting_range_matched_hurdle3_top:
				mov dx,0
				mov dx,530		;ending value of hurdle3 TOP
				cmp origin_x_character,dx
				jl end_mario_jump

			skip_check_hurdel3_top:

			;;;;;;;;;;;;;;;;;;;
			mov dx,420			;checking floor
			cmp dx,origin_y_character
			je end_mario_jump
		jmp mov_to_bottom

		end_mario_jump:
			mov color_reactangle,0
			call Draw_mario
			call make_it_multiple_of_5
			mov color_reactangle,3
			call Draw_mario
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; jump mario code end
		
		;mov color_reactangle,0
		;call Draw_mario
		;sub origin_y_character,5
		jmp taken_one_input
	down_arrow_pressed:
		;mov color_reactangle,0
		;call Draw_mario
		;add origin_y_character,5
		jmp taken_one_input
	right_arrow_pressed:
		mov color_reactangle,0
		call Draw_mario
		add origin_x_character,5
		jmp taken_one_input
	left_arrow_pressed:
		mov ax,0
		mov ax,15
		cmp origin_x_character,ax
		jl taken_one_input
		mov color_reactangle,0
		call Draw_mario
		sub origin_x_character,5
		jmp taken_one_input

all_levels_completed:

	mov bl,3
	mov game_level,bl
	mov row_number,13       ;setting cursor to write all levels_completed string   
	mov column_number,20
	call set_cursor_at_row_and_column

	mov dx,offset display_all_levels_completed
	mov ah,09
	int 21h

	mov row_number,14
	mov column_number,28
	call set_cursor_at_row_and_column

	end_input:
	mov row_number,14
	mov column_number,28
	call set_cursor_at_row_and_column
	mov dx,offset user_name
	mov ah,09
	int 21h
	mov row_number,15
	mov column_number,28
	call set_cursor_at_row_and_column  

	mov dx,offset display_level
	mov ah,09
	int 21h
	mov dl,game_level
	add dl,48
	mov ah,02
	int 21h

	mov row_number,16
	mov column_number,28
	call set_cursor_at_row_and_column

	mov dx,offset display_score
	mov ah,09
	int 21h
	mov dl,game_score
	add dl,48
	mov ah,02
	int 21h

	mov row_number,17
	mov column_number,28
	call set_cursor_at_row_and_column

	mov dx,offset ending
	mov ah,09
	int 21h

	jmp end_game_here_plzzz
	last_screen:
		mov row_number,13
		mov column_number,24
		call set_cursor_at_row_and_column

		mov dx,offset you_lost_all_lives
		mov ah,09
		int 21h

		mov row_number,14
		mov column_number,24
		call set_cursor_at_row_and_column
		mov dx,offset ending
		mov ah,09
		int 21h

end_game_here_plzzz:	
	mov ah,4ch
	int 21h
main endp
end main