onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab6_check/N
add wave -noupdate /lab6_check/V
add wave -noupdate /lab6_check/Z
add wave -noupdate /lab6_check/clk
add wave -noupdate /lab6_check/err
add wave -noupdate /lab6_check/in
add wave -noupdate /lab6_check/load
add wave -noupdate /lab6_check/out
add wave -noupdate /lab6_check/reset
add wave -noupdate /lab6_check/s
add wave -noupdate /lab6_check/w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {65 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
