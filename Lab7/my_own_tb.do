onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /my_own_tb/KEY
add wave -noupdate /my_own_tb/LEDR
add wave -noupdate /my_own_tb/SW
add wave -noupdate /my_own_tb/DUT/CPU/clk
add wave -noupdate /my_own_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /my_own_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /my_own_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate /my_own_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate /my_own_tb/DUT/one/LEDR
add wave -noupdate /my_own_tb/DUT/one/clk
add wave -noupdate /my_own_tb/DUT/one/mem_addr
add wave -noupdate /my_own_tb/DUT/one/mem_cmd
add wave -noupdate /my_own_tb/DUT/one/out
add wave -noupdate /my_own_tb/DUT/one/write_data
add wave -noupdate /my_own_tb/DUT/second/dtcswitch_out
add wave -noupdate /my_own_tb/DUT/second/mem_addr
add wave -noupdate /my_own_tb/DUT/second/mem_cmd
add wave -noupdate /my_own_tb/DUT/second/out
add wave -noupdate /my_own_tb/DUT/second/read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {452 ps} 0}
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
WaveRestoreZoom {0 ps} {499 ps}
