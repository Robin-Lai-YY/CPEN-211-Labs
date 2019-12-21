onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /stage3_tb/DUT/CPU/clk
add wave -noupdate /stage3_tb/KEY
add wave -noupdate /stage3_tb/LEDR
add wave -noupdate /stage3_tb/SW
add wave -noupdate /stage3_tb/SW
add wave -noupdate /stage3_tb/DUT/CPU/my_SM/w
add wave -noupdate /stage3_tb/DUT/CPU/my_SM/reset
add wave -noupdate /stage3_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /stage3_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /stage3_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate /stage3_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate /stage3_tb/DUT/CPU/mem_cmd
add wave -noupdate /stage3_tb/KEY
add wave -noupdate /stage3_tb/LEDR
add wave -noupdate /stage3_tb/SW
add wave -noupdate /stage3_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /stage3_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /stage3_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate /stage3_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate /stage3_tb/DUT/CPU/my_SM/clk
add wave -noupdate /stage3_tb/DUT/CPU/my_SM/w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {709 ps}
