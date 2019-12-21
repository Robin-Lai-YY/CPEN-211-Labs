onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_tb/clk
add wave -noupdate /datapath_tb/datapath_out
add wave -noupdate /datapath_tb/from_decoder
add wave -noupdate /datapath_tb/from_SM
add wave -noupdate /datapath_tb/N
add wave -noupdate /datapath_tb/V
add wave -noupdate /datapath_tb/Z_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {215 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 261
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {2 ps} {653 ps}
