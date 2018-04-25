# Mikalangelo David Wessel - 04/25/2018
# mdw15d
# exp.s - a simple driver program that tests the double factorial
#	function written by Professor Leach
# Register use:
#	$a0	parameters for factorial start number and syscall
#	$v0	syscall parameter
#	$t0 temporary calculations
#   $f0 floating point answer
#   $f2 floating point calculations
#	$f12 floating point return

exp:	
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
	  
      slti	$t0, $v0, 999	# if n is 999, exit
	  beq	$t0, $zero, out
	  
	  move	$s2, $v0	# save value of n
	  
	  la	$a0, ans	# print text part of answer
	  li	$v0, 4
	  syscall

      move	$a0, $s0
	  li	$v0, 1		# print value of n
	  syscall

      la	$a0, cr	    # print text part of answer
	  li	$v0, 4
	  syscall

      move	$a0, $s2	# place value of n in $a0
	  
	  jal	exp		# call exp function
	  
	  move  $s1, $v0	# save value returned by fact

	  li	$v0, 3      # prepare to read out double prec value
	  mov.d $f12, $f0   # move into FP return register
	  syscall
	  
	  j	loop	# branch back and next value of n

out:  la	$a0, adios	# display closing
	  li	$v0, 4
	  syscall
	  
	  li	$v0, 10		# exit from the program
	  syscall
	
	  .data
intro: .asciiz	"Let's test our exponential function!"
req:   .asciiz  "\nEnter a value for x (or 999 to exit): "
ans:   .asciiz  "Our approximation for e^"
cr:    .asciiz  " is "
adios: .asciiz  "Come back soon!\n"