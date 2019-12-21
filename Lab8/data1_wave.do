onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab8_check_tb/KEY
add wave -noupdate /lab8_check_tb/SW
add wave -noupdate /lab8_check_tb/LEDR
add wave -noupdate /lab8_check_tb/err
add wave -noupdate /lab8_check_tb/CLOCK_50
add wave -noupdate /lab8_check_tb/DUT/CPU/select_which_pc_signal
add wave -noupdate /lab8_check_tb/DUT/CPU/halt_signal
add wave -noupdate /lab8_check_tb/DUT/CPU/opcode
add wave -noupdate /lab8_check_tb/DUT/CPU/op
add wave -noupdate /lab8_check_tb/DUT/CPU/my_decoder/Rd
add wave -noupdate /lab8_check_tb/DUT/CPU/pc/register_pc
add wave -noupdate /lab8_check_tb/DUT/CPU/pc/pc_out
add wave -noupdate /lab8_check_tb/DUT/CPU/pc/new_pc
add wave -noupdate /lab8_check_tb/DUT/CPU/pc/next_pc
add wave -noupdate /lab8_check_tb/DUT/CPU/pc/controll_original_pc
add wave -noupdate /lab8_check_tb/DUT/CPU/pc/select_which_pc_signal
add wave -noupdate /lab8_check_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /lab8_check_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /lab8_check_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate /lab8_check_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate /lab8_check_tb/DUT/CPU/DP/REGFILE/R4
add wave -noupdate /lab8_check_tb/DUT/CPU/DP/REGFILE/R5
add wave -noupdate /lab8_check_tb/DUT/CPU/DP/REGFILE/R6
add wave -noupdate /lab8_check_tb/DUT/CPU/DP/REGFILE/R7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2017 ps} 0}
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
WaveRestoreZoom {0 ps} {2872 ps}
