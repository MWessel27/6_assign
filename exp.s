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
      l.d   $f2, cons0       # $f2 = 0.0
      l.d   $f4, cons1       # $f4 = 1.0
      l.d   $f6, conse	     # $f6 = 1.0e-15

      mov.d $f8, $f12        # save exponent entered
      mov.d $f10, $f12       # second copy of term 
      abs.d $f8, $f8         # get absolute value

      l.d   $f20, cons1      # set n to 1
      div.d $f14, $f8, $f20   # divide x by n
      add.d $f18, $f4, $f14   # add term 0(1) to x/n

again:
      add.d $f20, $f20, $f4  # add 1 to n
      mul.d $f14, $f14, $f8  # multiply old term by x
      div.d $f14, $f14, $f20 # divide by incremented n

      c.lt.d $f14, $f6       # compare term to 1.0e-15
      bc1t   done

      add.d $f18, $f18, $f14 # add result into total

	  j	again		# and loop

done:
      mov.d     $f0, $f18    # move into return
 	  jr	    $ra		# return to calling routine

main: la	$a0, intro	# print intro
      li	$v0, 4
	  syscall

loop: la	$a0, req	# request value of x
	  li	$v0, 4
	  syscall
	  
	  li	$v0, 7		# read value of x
	  syscall

      l.d     $f16, flag  # exit if 999 was entered
      c.eq.d  $f16, $f0
      bc1t    out
	  
	  la	$a0, ans	# print text part of answer
	  li	$v0, 4
	  syscall

      li	$v0, 3
      mov.d $f12, $f0   # display value of x
      syscall

      la	$a0, cr	    # print text part of answer
	  li	$v0, 4
	  syscall

      #move	$a0, $s2	# place value of n in $a0
	  
	  jal	exp		    # call exp function
	  
	  #move  $s1, $v0	# save value returned by fact

	  #li	$v0, 3      # prepare to read out double prec value
	  #mov.d $f12, $f0   # move into FP return register
	  #syscall

      li	$v0, 3      # prepare to read out double prec value
	  mov.d $f12, $f0   # move into FP return register
	  syscall
	  
	  j	loop	        # branch back and next value of n

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
flag:  .double   999.00
cons0: .double   0.00
cons1: .double   1.00
conse: .double   1.0e-15