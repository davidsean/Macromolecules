


# Comments are made with the hash symbol
#puts "Hello world!"

#variables are defined with the "set" command
#set pi 3.14
#pi=3.14

#to refer to variables, prepend them with the $-sign
#puts pi
#puts $pi

#math operations are made using the expr function
#the code in square brackets [] is executed and [] holds the returned value

#puts [expr 3+2]
#puts [expr $pi*2]

#the command incr increments an integer variable by one
#set my_int 0

#puts $my_int
#incr my_int
#puts $my_int


# this is just a shortcut to...
#puts $my_int
#set my_int [expr $my_int+1]


# but it needs to be an integer!
#incr $pi
#puts $pi



#here is a loop example:
#for {set i 0} {$i<10} {incr i} {
#puts "counted $i sheep"
#}

# why does this loop fail?
#for {set i 0}{$i<10} {incr i} {
#puts "counted $i fish"
#}




puts "bye world!"







