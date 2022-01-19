.data

test_neighbor_header: .asciiz "\nPos\toben\tlinks\tunten\trechts\n---\t----\t-----\t-----\t------\n"

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:   
	li $v0, SYS_PUTSTR
	la $a0, test_neighbor_header
	syscall
	
	move $s0, $zero

test_neighbor_loop_position:

	li $v0, SYS_PUTINT
	move $a0, $s0
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\t'
	syscall
	
	move $s1, $zero

test_neighbor_loop_direction:
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	jal neighbor
	
	move $a0, $v0   
	li $v0, SYS_PUTINT
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\t'
	syscall
	
	addi $s1, $s1, 1
	blt $s1, 4, test_neighbor_loop_direction

	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall

	addi $s0, $s0, 1
	blt $s0, 64, test_neighbor_loop_position

	li $v0, SYS_EXIT
	syscall
	
	# Auxiliary function neighbor
	# Parameters   $a0: Exit index
	#              $a1: Direction (0 = above, 1 = left, 2 = below, 3 = right)
	# Return value $v0: Neighbor index
neighbor:
	beq  $a1, 0, above         #  if ($a1 == 0) go to above
	beq  $a1, 1, left          #  if ($a1 == 1) go to left
	beq  $a1, 2, below         #  if ($a1 == 2) go to below
	beq  $a1, 3, right         #  if ($a1 == 3) go to right
above:
	ble  $a0, 7, not_above     #  if ($a0 <= 7) go to not_above
	move $t1, $a0              #  setting $t1 to contents of $a0
	addi $t1, $t1, -8          #  $t1 -= 8
	move $v0, $t1              #  setting $v0 to contents of $t1
	jr   $ra                   #  jump to statement whose address is in $ra
not_above:
	li   $v0, -1               #  $v0 = -1
    jr   $ra                   #  jump to statement whose address is in $ra
left:
	andi $t1, $a0, 7           # calculating the modulo of the content of $a0 ($a0 mod 8)
	                           # $t1 = $a0 % 8 (== $a0 & 7)
	beq  $t1, $zero, not_left  # if ($t1 == 0) go to not_left
	move $t2, $a0              # setting $t2 to contents of $a0
	addi $t2, $t2, -1          # $t2 -= 1
	move $v0, $t2              # setting $v0 to contents of $t2
	jr   $ra                   # jump to statement whose address is in $ra
not_left:
	li   $v0, -1               # $v0 = -1
	jr   $ra                   # jump to statement whose address is in $ra
below:
	bge  $a0, 56, not_below    #  if ($a0 >= 56) go to not_below
	move $t1, $a0              #  setting $t1 to contents of $a0
	addi $t1, $t1, 8           #  $t1 += 8
	move $v0, $t1              #  setting $v0 to contents of $t1
	jr   $ra                   #  jump to statement whose address is in $ra
not_below:
	li   $v0, -1               #  $v0 = -1
    jr   $ra                   #  jump to statement whose address is in $ra 
right:
	andi $t1, $a0, 7           # calculating the modulo of the content of $a0 ($a0 mod 8)
							   # $t1 = $a0 % 8 (== $a0 & 7)
	li   $t3, 7                # $t3 = 7
	beq  $t1, $t3, not_right   # if ($t1 == $t3) go to not_right
	move $t2, $a0              # setting $t2 to contents of $a0
	addi $t2, $t2, 1           # $t2 += 1
	move $v0, $t2              # setting $v0 to contents of $t2
	jr   $ra                   # jump to statement whose address is in $ra
not_right:
	li   $v0, -1               # $v0 = -1
	jr   $ra                   # jump to statement whose address is in $ra
