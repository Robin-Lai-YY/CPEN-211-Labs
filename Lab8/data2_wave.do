onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab8_stage2_tb/KEY
add wave -noupdate /lab8_stage2_tb/SW
add wave -noupdate /lab8_stage2_tb/LEDR
add wave -noupdate /lab8_stage2_tb/err
add wave -noupdate /lab8_stage2_tb/CLOCK_50
add wave -noupdate /lab8_stage2_tb/hapi
add wave -noupdate /lab8_stage2_tb/break
add wave -noupdate /lab8_stage2_tb/DUT/N
add wave -noupdate /lab8_stage2_tb/DUT/V
add wave -noupdate /lab8_stage2_tb/DUT/PC
add wave -noupdate /lab8_stage2_tb/DUT/halt_signal
add wave -noupdate /lab8_stage2_tb/DUT/CPU/pc/register_pc
add wave -noupdate /lab8_stage2_tb/DUT/CPU/pc/pc_out
add wave -noupdate /lab8_stage2_tb/DUT/CPU/pc/new_pc
add wave -noupdate /lab8_stage2_tb/DUT/CPU/pc/next_pc
add wave -noupdate /lab8_stage2_tb/DUT/CPU/pc/select_which_pc_signal
add wave -noupdate /lab8_stage2_tb/DUT/CPU/my_decoder/Rd
add wave -noupdate /lab8_stage2_tb/DUT/CPU/my_decoder/sximm8
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R4
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R5
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R6
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1553 ps} 0}
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
WaveRestoreZoom {0 ps} {2027 ps}
