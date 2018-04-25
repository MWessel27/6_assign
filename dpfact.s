# Mikalangelo David Wessel - 04/25/2018
# mdw15d
# dpfact.s - a simple driver program that tests the double factorial
#	function written by Professor Leach
# Register use:
#	$a0	parameters for factorial start number and syscall
#	$v0	syscall parameter
#	$t0 temporary calculations
#   $f0 floating point answer
#   $f2 floating point calculations
#	$f12 floating point return

dpfact:	
      li	$t0, 1		# initialize product to 1.0
	  mtc1	$t0, $f0
	  cvt.d.w	$f0, $f0

again:
      slti	$t0, $a0, 2		# test for n < 2
	  bne	$t0, $zero,done	# if n < 2, return

	  mtc1	$a0, $f2		# move n to floating register
	  cvt.d.w	$f2, $f2		# and convert to double precision

	  mul.d	$f0, $f0, $f2	# multiply product by n
	
	  addi	$a0, $a0, -1	# decrease n
	  j	again		# and loop

done:
 	  jr	    $ra		# return to calling routine

main: la	$a0, intro	# print intro
      li	$v0, 4
	  syscall

loop: la	$a0, req	# request value of n
	  li	$v0, 4
	  syscall
	  
	  li	$v0, 5		# read value of n
	  syscall
	  
	  slt	$t0, $v0, $zero	# if n < 0, exit
	  bne	$t0, $zero, out
	  
	  move	$s0, $v0	# save value of n
	  move	$a0, $v0	# place value of n in $a0
	  
	  jal	dpfact		# call fact function
	  
	  move  $s1, $v0	# save value returned by fact
	  
	  move	$a0, $s0	# display result
	  li	$v0, 1		# print value of n
	  syscall
	  
	  la	$a0, ans	# print text part of answer
	  li	$v0, 4
	  syscall

	  li	$v0, 3      # prepare to read out double prec value
	  mov.d $f12, $f0   # move into FP return register
	  syscall
	  
	  la	$a0, cr		# print carriage return
	  li	$v0, 4
	  syscall
	  
	  j	loop	# branch back and next value of n

out:  la	$a0, adios	# display closing
	  li	$v0, 4
	  syscall
	  
	  li	$v0, 10		# exit from the program
	  syscall
	
	  .data
intro: .asciiz	"Welcome to the double factorial tester!\n"
req:   .asciiz  "Enter a value for n (or a negative value to exit): "
ans:   .asciiz  "! is "
cr:    .asciiz  "\n"
adios: .asciiz  "Come back soon!\n"