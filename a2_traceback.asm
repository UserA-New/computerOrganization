.data

	# Example maze arrays: maze1, maze2, maze3:
maze1:
	.byte 0x08, 0x07, 0x06, 0x05, 0x04, 0x05, 0x06, 0x07
	.byte 0x09, 0x08, 0xFF, 0xFF, 0x03, 0x04, 0xFF, 0x08
	.byte 0x0A, 0xFF, 0xFF, 0x01, 0x02, 0x03, 0xFF, 0x09
	.byte 0x0B, 0x0C, 0xFF, 0xFF, 0xFF, 0x04, 0xFF, 0x0A
	.byte 0x0C, 0x0D, 0x0E, 0x0F, 0xFF, 0xFF, 0xFF, 0x0B
	.byte 0x0D, 0x0E, 0xFF, 0x10, 0xFF, 0x0E, 0x0D, 0x0C
	.byte 0x0E, 0x0F, 0xFF, 0xFF, 0xFF, 0x0F, 0x0E, 0x0D
	.byte 0x0F, 0x10, 0x11, 0x12, 0x11, 0x10, 0x0F, 0x0E
maze2:
	.byte 0x0F, 0x10, 0x11, 0x12, 0x13, 0xFF, 0x00, 0x00
	.byte 0x0E, 0xFF, 0x12, 0xFF, 0x12, 0xFF, 0xFF, 0xFF
	.byte 0x0D, 0xFF, 0x13, 0xFF, 0x11, 0xFF, 0x00, 0x00
	.byte 0x0C, 0xFF, 0xFF, 0xFF, 0x10, 0xFF, 0x00, 0x00
	.byte 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xFF, 0xFF, 0xFF
	.byte 0x0A, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x02, 0x03
	.byte 0x09, 0xFF, 0x07, 0xFF, 0x05, 0xFF, 0x01, 0x02
	.byte 0x08, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x03
maze3:
	.byte 0x0B, 0x0A, 0x09, 0x08, 0x07, 0x08, 0x09, 0x0A
	.byte 0x0C, 0xFF, 0xFF, 0xFF, 0x06, 0xFF, 0xFF, 0x09
	.byte 0x0D, 0x0E, 0xFF, 0x04, 0x05, 0x06, 0xFF, 0x08
	.byte 0x0E, 0x0F, 0xFF, 0x03, 0xFF, 0x05, 0x06, 0x07
	.byte 0x0D, 0xFF, 0xFF, 0x02, 0xFF, 0x04, 0xFF, 0x08
	.byte 0x0C, 0x0D, 0xFF, 0x01, 0x02, 0x03, 0xFF, 0x09
	.byte 0x0B, 0xFF, 0xFF, 0xFF, 0xFF, 0x04, 0xFF, 0x0A
	.byte 0x0A, 0x09, 0x08, 0x07, 0x06, 0x05, 0xFF, 0x0B

	# Lookup table for the auxiliary function neighbor:
test_neighbor_lut:
	.word 0x0000f7fe, 0x00fff6fd, 0x00fef5fc, 0x00fdf4fb, 0x00fcf3fa, 0x00fbf2f9, 0x00faf1f8, 0x00f9f000
	.word 0xff00eff6, 0xfef7eef5, 0xfdf6edf4, 0xfcf5ecf3, 0xfbf4ebf2, 0xfaf3eaf1, 0xf9f2e9f0, 0xf8f1e800
	.word 0xf700e7ee, 0xf6efe6ed, 0xf5eee5ec, 0xf4ede4eb, 0xf3ece3ea, 0xf2ebe2e9, 0xf1eae1e8, 0xf0e9e000
	.word 0xef00dfe6, 0xeee7dee5, 0xede6dde4, 0xece5dce3, 0xebe4dbe2, 0xeae3dae1, 0xe9e2d9e0, 0xe8e1d800
	.word 0xe700d7de, 0xe6dfd6dd, 0xe5ded5dc, 0xe4ddd4db, 0xe3dcd3da, 0xe2dbd2d9, 0xe1dad1d8, 0xe0d9d000
	.word 0xdf00cfd6, 0xded7ced5, 0xddd6cdd4, 0xdcd5ccd3, 0xdbd4cbd2, 0xdad3cad1, 0xd9d2c9d0, 0xd8d1c800
	.word 0xd700c7ce, 0xd6cfc6cd, 0xd5cec5cc, 0xd4cdc4cb, 0xd3ccc3ca, 0xd2cbc2c9, 0xd1cac1c8, 0xd0c9c000
	.word 0xcf0000c6, 0xcec700c5, 0xcdc600c4, 0xccc500c3, 0xcbc400c2, 0xcac300c1, 0xc9c200c0, 0xc8c10000

test_rueckgabe: .asciiz "Rueckgabewert: "
test_print_maze_str_header: .asciiz "Irrgarten:\n    0  1  2  3  4  5  6  7\n   -------------------------\n0 | "

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:
	la $t0, test_maze_select
	lw $a0, 0($t0)
	la $t0, test_maze_destination
	lw $a1, 0($t0)
	jal trace_back
	
	move $t0, $v0
	li $v0, SYS_PUTSTR
	la $a0, test_rueckgabe
	syscall
	
	li $v0, SYS_PUTINT
	move $a0, $t0
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall

	la $t0, test_maze_select
	lw $a0, 0($t0)
	jal print_maze
	
	li $v0, SYS_EXIT
	syscall

	# Auxiliary function neighbor
	# Parameters   $a0: Exit index
	#              $a1: Direction (0 = above, 1 = left, 2 = below, 3 = right)
	# Return value $v0: Neighbor index
neighbor: 
	sll $a0, $a0, 2
	andi $a1, $a1, 3
	xori $a1, $a1, 3
	or $a0, $a0, $a1
	andi $a0, $a0, 255
	la $t0, test_neighbor_lut
	add $t0, $a0, $t0
	lbu $t0, 0($t0)
	xori $t0, $t0, 255
	sll $t0, $t0, 24
	sra $v0, $t0, 24
	jr $ra

	# Function print_maze: is called from the default code and prints the maze in $a0 as text.
	# Parameter $a0: Maze array
	# Return value: none
print_maze:
	# $t0: position, $t1: index
	move $t0, $a0
	move $t1, $zero

	li $v0, SYS_PUTSTR
	la $a0, test_print_maze_str_header
	syscall
	
print_maze_loop:
	# $t2: zero if end of line
	and $t2, $t1, 7
	xor $t2, $t2, 7

	# $t3: current field, $t4: next field (or zero, if end of line)
	lbu $t3, 0($t0)
	move $t4, $zero
	beq $t2, $zero, print_maze_dont_read_next
	lbu $t4, 1($t0)
print_maze_dont_read_next:
	
	beq $t3, 0, print_maze_empty
	beq $t3, 255, print_maze_barr
	beq $t3, 254, print_maze_route
	
	ble $t3, 99, print_maze_not_too_big
	li $t3, 99
print_maze_not_too_big:
	
	li $v0, SYS_PUTINT
	move $a0, $t3
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, ' '
	syscall
	bge $t3, 10, print_maze_single_space
	syscall
print_maze_single_space:
	j print_maze_entry_end

print_maze_empty:
	li $v0, SYS_PUTCHAR
	la $a0, ' '
	syscall
	syscall
	syscall
	j print_maze_entry_end

print_maze_route:
	la $a0, '+'
	j print_maze_barr_or_route
print_maze_barr:
	la $a0, 'X'
print_maze_barr_or_route:
	li $v0, SYS_PUTCHAR
	syscall
	syscall
	beq $t4, $t3, print_maze_long
	la $a0, ' '
print_maze_long:
	syscall
	j print_maze_entry_end

print_maze_entry_end:   
	# print newline at end of row
	bne $t2, $zero, print_maze_no_nl
	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall

	bge $t1, 63, print_maze_loop_end
			
	li $v0, SYS_PUTINT
	srl $a0, $t1, 3
	addi $a0, $a0, 1
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, ' '
	syscall 
	li $a0, '|'
	syscall 
	li $a0, ' '
	syscall 
print_maze_no_nl:

	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j print_maze_loop

print_maze_loop_end:
	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall     

	jr $ra

.data
	test_maze_select: .word maze3
	test_maze_destination: .word 63

.text

trace_back:

	addi $sp, $sp, -36
	sw   $ra, 32($sp)   #  storing the location it'll jump to, which is main.
	sw   $s0, 28($sp)   #  storing the following $sX registers.
	sw   $s1, 24($sp)
	sw   $s2, 20($sp) 
	sw   $s3, 16($sp) 
	sw   $s4, 12($sp)
	sw   $s5, 8($sp)
	sw   $s6, 4($sp)
 	sw   $s7, 0($sp)
	  
	
	move $s0, $a0       #  (constant) $s0 = $a0 = &mazeX[0] (saving the first argument) 
	                    #  (Ein Pointer auf das erste Element des Irrgaten-Arrays)
	                  
	move $s1, $a1       #  (constant) $s1 = $a1 = dest (saving the second argument) (Array-Index)
	
	move $s2, $a1       #  (inconstant) $s2 = $a1 = location (saving the second argument) (Array-Index)
                        #  (initialized with dest)
					 
	add  $s3, $s0, $s1  #  $s3 = &mazeX[0] + dest = &mazeX[dest]
	
	lbu  $s3, 0($s3)    #  $s3 = *(&mazeX[dest]) = the distance of the path
	
	li   $s4, 254       #  $s4 = 254
	
trace_back_outer_while:

	add  $a0, $s0, $s2  #  $a0 = $s0 (&mazeX[0]) + $s2 (location) = &mazeX[location]
	move $s5, $a0       #  $s5 = $a0 (&mazeX[location])
	lbu  $s6, 0($a0)    #  $s6 = *(&mazeX[location]) = current distance
	#if
	beq  $s6, 1, trace_back_end_outer_while  #  if current distance is equal to 1, then we're done!
	                                         #  go to trace_back_end_outer_while
	
	li   $s7, 0         #  $s7 = 0 (First, it'll look up the neighbor above and consecutively other neighbors.)
trace_back_inner_while:

	move $a1, $s7       #  setting $a1 to contents of $s7 (setting $a1 for the function neighbor)
	jal  neighbor       #  $v0 = Array-Index of the neighbor
	add  $t5, $s0, $v0  #  $t5 = $s0 (&mazeX[0]) + $v0 (Array-Index of the neighbor)
	                    #  $t5 = &mazeX[Array-Index of the neighbor]
	                    
	lbu  $t6, 0($t5)    #  $t6 = *(&mazeX[Array-Index of the neighbor])
                        #  $t6 = the distance to compare with (neighbor's distance)
	
	#if
	beq $v0, -1, trace_back_end_if            #  if the neighbor isn't reachable, look up others.
	bgt $s6, $t6, trace_back_end_inner_while  #  if the neighbor's distance less than the current distance, go there.

trace_back_end_if:

	addi $s7, $s7, 1    #  $s7 +=1 (look consecutive neighbors)
	move $a0, $s5       #  moving the first argument again to $a0
	                    #  setting $a0 for the function neighbor
	                   
	j trace_back_inner_while  #  go to trace_back_inner_while

trace_back_end_inner_while:
	
	move $s2, $v0       #  moving the Array-Index of the neighbor to $s2
	sb   $s4, 0($s5)    #  *(&mazeX[location]) = 254 (marking the path)
	j trace_back_outer_while  #  go to trace_back_outer_while
	
trace_back_end_outer_while:

	sb   $s4, 0($s5)    #  *(&mazeX[location]) = 254 (marking the location)

	move $v0, $s3       #  moving the value of the distance of the path ($s3) to $v0
	
	lw   $s7, 0($sp)    #  loading the following $sX registers.
	lw   $s6, 4($sp)
	lw   $s5, 8($sp)
	lw   $s4, 12($sp)    
	lw   $s3, 16($sp)
	lw   $s2, 20($sp)
	lw   $s1, 24($sp)
	lw   $s0, 28($sp)  
	lw   $ra, 32($sp)   #  loading the location it'll jump to, which is main.
	addi $sp, $sp, 36
	
	jr   $ra
