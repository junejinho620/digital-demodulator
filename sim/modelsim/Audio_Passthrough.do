quit -sim

vlib work

vlog clockdiv.sv i2s_rx.sv i2s_tx.sv audio_passthrough.sv

vsim audio_passthrough

log -r {/*}

add wave -noupdate -divider CLOCKDIV

add wave -label MCLK -radix binary /audio_passthrough/CD/MCLK
add wave -label SCLK -radix binary /audio_passthrough/CD/SCLK
add wave -label LRCLK -radix binary /audio_passthrough/CD/LRCLK
add wave -label S_count -radix unsigned /audio_passthrough/CD/S_count
add wave -label L_count -radix unsigned /audio_passthrough/CD/L_count

add wave -noupdate -divider AUDIO_PASSTHROUGH

add wave -label reset -radix binary /audio_passthrough/reset

add wave -label next_sclk_rise -radix binary /audio_passthrough/next_sclk_rise
add wave -label next_sclk_fall -radix binary /audio_passthrough/next_sclk_fall
add wave -label next_lrclk_rise -radix binary /audio_passthrough/next_lrclk_rise

add wave -label MCLK -radix binary /audio_passthrough/MCLK
add wave -label LRCLK -radix binary /audio_passthrough/LRCLK
add wave -label SCLK -radix binary /audio_passthrough/SCLK

add wave -label valid -radix binary /audio_passthrough/valid

add wave -label serial_in -radix binary /audio_passthrough/serial_in
add wave -label serial_out -radix binary /audio_passthrough/serial_out

add wave -noupdate -divider RECEIVER

add wave -label i_sdata -radix binary /audio_passthrough/receiver/i_sdata
add wave -label o_left -radix binary /audio_passthrough/receiver/o_left
add wave -label o_right -radix binary /audio_passthrough/receiver/o_right
add wave -label S_count -radix unsigned /audio_passthrough/receiver/S_count

add wave -noupdate -divider TRANSMITTER

add wave -label i_ldin -radix binary /audio_passthrough/transmitter/i_ldin
add wave -label i_rdin -radix binary /audio_passthrough/transmitter/i_rdin
add wave -label o_sdout -radix binary /audio_passthrough/transmitter/o_sdout
add wave -label S_count -radix unsigned /audio_passthrough/transmitter/S_count


force {MCLK} 0 0ns, 1 40.6901042ns -r 81.3802084ns

force {reset} 1

run 1000ns

force {reset} 0

run 41000ns

force {serial_in} 1

run 666.6666ns

#serial data now

run 100000ns