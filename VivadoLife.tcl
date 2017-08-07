#----------------------------------------------------------------------------
# Conway's classic Game of Life on Xilinx Vivado !
#
# Vivado is the FPGA design software from Xilinx. Its intended
# purpose is to map your RTL design to Xilinx FPGAs. Vivado uses
# Tcl as its internal scripting language and features a powerful
# GUI to visualize the device internals. FPGA devices are made up
# of a regular 2-D array of tiles, sites and bels. Vivado TCL API
# allows these to be highlighted with various colors, which is all 
# we need for Game of Life :)
#
# Xilinx Vivado toolset is available for free at xilinx.com (even
# if you dont intend to buy an FPGA).
#
# For best visuals, in the Device-Options menu, turn off Routing 
# view, Tiles, Sites, Bels.
#
# Relatively low load. On my old i3 laptop, barely tops 20%
#
# leo 2017-08-03
#----------------------------------------------------------------------------
# comment this out if device is loaded already
# TODO check design status and dont link if already in a project
#link_design -part xc7k70tfbv676-1

# TODO make this automatically fill the device
set X 60
set Y 100
# programmed expiry for immortal cells
set AgeMax 100
set AgeMid 5

set state [list]
set labels [list]

proc getInd {y x} {
  global Y X
  return [expr {$X*$y + $x}]
}

proc initState {} {
  global Y X state
  set state [list]
  for {set y 0} {$y < $Y} {incr y} {
    for {set x 0} {$x < $X} {incr x} {
      set rVal [expr {int(rand () * 100.0)}]
      if {$rVal > 75} { lappend state 1 } else { lappend state 0 }
    }
  }
}

proc liveNeighs {y x st} {
  global Y X
  set ln 0
   #puts "liveNeighs y: $y x: $x"
  for {set row [expr {$y-1}]} {$row <= [expr {$y+1}]} {incr row} {
    set r $row
    if {$row < 0} { 
      set r [expr {$row + $Y}] 
    } elseif {$row >= $Y} { 
      set r [expr {$row - $Y}] 
    }

    for {set col [expr {$x-1}]} {$col <= [expr {$x+1}]} {incr col} {
      set c $col
      if {$col < 0} {
        set c [expr {$col + $X}]
      } elseif {$col >= $X} {
        set c [expr {$col - $X}]
      }
       #puts "\tr: $r c: $c"

      if {$r == $y && $c == $x} { 
        continue 
      }

      set ind [getInd $r $c]
      if {[lindex $st $ind] >= 1} {
        incr ln
         #puts "\t\tincr ln: $ln"
      }
    }
  }
  return $ln
}

# for debug
proc printState {} {
  global Y X state
  for {set row 0} {$row < $Y} {incr row} {
    for {set col 0} {$col < $X} {incr col} {
      set ind [getInd $row $col]
      puts -nonewline "[lindex $state $ind] "
    }
    puts ""
  }
}

proc updState {} {
  global Y X state AgeMax
  set tstate $state
  for {set row 0} {$row < $Y} {incr row} {
    for {set col 0} {$col < $X} {incr col} {
      set ln [liveNeighs $row $col $tstate]
      set ind [getInd $row $col]
       #puts "row: $row col: $col ind; $ind ln: $ln"
      set cs [lindex $tstate $ind]
      if { $cs > $AgeMax} {
          lset state $ind 0
      } elseif { $cs >= 1} {
        if {$ln == 2 || $ln == 3} {
          lset state $ind [expr {$cs + 1}]
        } else {
          lset state $ind 0
        }
      } else {
        if {$ln == 3} {
          lset state $ind 1 
        } else {
          lset state $ind 0 
        }
      }
    }
  }
}

# grid of labels is slow
proc initGrid {} {
  global Y X state labels
  for {set row 0} {$row < $Y} {incr row} {
    for {set col 0} {$col < $X} {incr col} {
      #set l [ttk::label .l_${row}_${col} -text " "]
			set l [get_sites "SLICE_X${col}Y${row}"]
      lappend labels $l
      #grid $l -column $col -row $row -sticky nsew
      #puts "added $l at row: $row col: $col"
    }
  }
}

proc updGrid3 {} {
  global state labels AgeMax AgeMid
	#unhig
	set cb 0
	set cg 0
	set cr 0
	set hlg [list]
	set hlr [list]
	set hlb [list]

	set hl [list]
	set ul [list]
  foreach l $labels s $state {
    if {$s >= $AgeMax} {
			lappend hlr $l
			incr cr 1
    } elseif {$s >= $AgeMid} {
			lappend hlb $l
			incr cb 1
    } elseif {$s > 0} {
			lappend hlg $l
			incr cg 1
    } else {
			lappend ul $l
    }
  }
	unh $ul
	if {$cr > 0} { hig $hlr -color red }
	if {$cg > 0} { hig $hlg }
	if {$cb > 0} { hig $hlb -color blue }
}

proc loop {times} {
	incr times -1
	if {$times < 1} return;

  updState
  updGrid3
  after 400 [list loop $times]
}

puts "Welcome to Vivado Life !"
unh
initState
initGrid
updGrid3
loop 1000


#puts [liveNeighs 0 0 $state]
