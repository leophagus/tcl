#----------------------------------------------------------------------------
# Conway's Classic Game of Life in Tcl/Tk
# leo 2015-10-05 11:02:34 
#
# 2017-07-09 11:02:34
# faster updates using list traversal and use label bg-color
#----------------------------------------------------------------------------
font create myDefaultFont -family Courier -size 10
option add *font myDefaultFont

set X 40
set Y 20
set AgeMax 100
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
      set l [ttk::label .l_${row}_${col} -text " "]
      lappend labels $l
      grid $l -column $col -row $row -sticky nsew
      #puts "added $l at row: $row col: $col"
    }
  }
}

proc updGrid {} {
  global Y X state labels
  for {set row 0} {$row < $Y} {incr row} {
    for {set col 0} {$col < $X} {incr col} {
      set ind [getInd $row $col]

      set txt "-"
      if { [lindex $state $ind] == 1} {
        set txt "*"
      }
      [lindex $labels $ind] configure -text $txt
      #puts "added $l at row: $row col: $col"
    }
  }
}

# TODO
# add death if cell lives too long
# diff colors for newly born, lonely, fine
proc updGrid2 {} {
  global state labels AgeMax
  foreach l $labels s $state {
    if {$s >= $AgeMax} {
      $l configure -background red
    } elseif {$s > 1} {
      $l configure -background blue
    } elseif {$s == 1} {
      $l configure -background green
    } else {
      $l configure -background white
    }
  }
}

proc loop {times} {
  for {set i 0} {$i < $times} {incr i} {
    updState
    #printState
    updGrid2
    after 250
    update idletasks
  }
}

initState
initGrid
#printState
updGrid2
loop 10000


#puts [liveNeighs 0 0 $state]
