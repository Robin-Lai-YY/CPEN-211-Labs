onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_check_tb/DUT/clk
add wave -noupdate -divider register
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate -divider AND-Gate
add wave -noupdate /lab7_check_tb/DUT/write
add wave -noupdate /lab7_check_tb/DUT/after_AND_dout
add wave -noupdate -divider STATUS
add wave -noupdate /lab7_check_tb/DUT/mem_cmd
add wave -noupdate -label mem_addr /lab7_check_tb/DUT/select_out
add wave -noupdate /lab7_check_tb/DUT/read_data
add wave -noupdate /lab7_check_tb/DUT/write_data
add wave -noupdate -divider MEM
add wave -noupdate /lab7_check_tb/DUT/MEM/write
add wave -noupdate /lab7_check_tb/DUT/MEM/dout
add wave -noupdate /lab7_check_tb/DUT/MEM/din
add wave -noupdate -divider IR
add wave -noupdate /lab7_check_tb/DUT/CPU/my_reg/in
add wave -noupdate /lab7_check_tb/DUT/CPU/my_SM/load_ir
add wave -noupdate /lab7_check_tb/DUT/CPU/my_reg/reg_out
add wave -noupdate -divider {Instr Decoder}
add wave -noupdate /lab7_check_tb/DUT/CPU/my_decoder/decoder_out
add wave -noupdate /lab7_check_tb/DUT/CPU/my_decoder/opcode
add wave -noupdate /lab7_check_tb/DUT/CPU/my_decoder/op
add wave -noupdate /lab7_check_tb/DUT/CPU/my_decoder/Rn
add wave -noupdate /lab7_check_tb/DUT/CPU/my_decoder/Rd
add wave -noupdate /lab7_check_tb/DUT/CPU/my_decoder/imm5
add wave -noupdate -divider {Data path}
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/from_SM
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/vsel
add wave -noupdate -divider {Program counter}
add wave -noupdate /lab7_check_tb/DUT/CPU/pc/load_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/pc/reset_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/pc/next_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/pc/pc_out
add wave -noupdate -divider {data address}
add wave -noupdate /lab7_check_tb/DUT/CPU/data_address/load
add wave -noupdate /lab7_check_tb/DUT/CPU/data_address/next
add wave -noupdate /lab7_check_tb/DUT/CPU/data_address/out
add wave -noupdate -label addr_sel /lab7_check_tb/DUT/CPU/address_sel/sel
add wave -noupdate -label {PC to addr_sel} /lab7_check_tb/DUT/CPU/address_sel/ain
add wave -noupdate -label {data_address_out(same as mem_addr)} /lab7_check_tb/DUT/CPU/address_sel/out
add wave -noupdate -divider LED
add wave -noupdate /lab7_check_tb/DUT/one/LEDR
add wave -noupdate /lab7_check_tb/DUT/one/out
add wave -noupdate /lab7_check_tb/DUT/one/write_data
add wave -noupdate -divider switch
add wave -noupdate /lab7_check_tb/DUT/second/dtcswitch_out
add wave -noupdate /lab7_check_tb/DUT/second/out
add wave -noupdate /lab7_check_tb/DUT/second/read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {112 ps} 0}
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
WaveRestoreZoom {0 ps} {383 ps}
