onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /insdecoder_tb/ALUop
add wave -noupdate /insdecoder_tb/decoder_out
add wave -noupdate /insdecoder_tb/in
add wave -noupdate /insdecoder_tb/nsel
add wave -noupdate /insdecoder_tb/op
add wave -noupdate /insdecoder_tb/opcode
add wave -noupdate /insdecoder_tb/readnum
add wave -noupdate /insdecoder_tb/shift
add wave -noupdate /insdecoder_tb/sximm5
add wave -noupdate /insdecoder_tb/sximm8
add wave -noupdate /insdecoder_tb/writenum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {241 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 116
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
WaveRestoreZoom {0 ps} {402 ps}
