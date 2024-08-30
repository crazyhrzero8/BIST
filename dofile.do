# //////////////////////////////////////////////////////////////////////////////////////////
# //                                                                                      //
# //                               Name: Biplab Das S                                     //
# //                                  BIST MODULE                                         //
# //                   https://www.github.com/crazyhrzero8/BIST/                          //
# //                                                                                      //
# //////////////////////////////////////////////////////////////////////////////////////////


vlib work

vlog -reportprogress 300 -work work C:/Users/USER/OneDrive/Desktop/bist/bist.v
vlog -reportprogress 300 -work work C:/Users/USER/OneDrive/Desktop/bist/tb.v

vsim work.tb

add wave -position insertpoint  \
sim:/tb/c2dr
add wave -position insertpoint  \
sim:/tb/DATA_WIDTH
add wave -position insertpoint  \
sim:/tb/CLK_PERIOD
add wave -position insertpoint  \
sim:/tb/dut/clk
add wave -position insertpoint  \
sim:/tb/dut/rst_n
add wave -position insertpoint  \
sim:/tb/dut/pattern_sel_d
add wave -position insertpoint  \
sim:/tb/dut/pattern_sel
add wave -position insertpoint  \
sim:/tb/dut/capture_start
add wave -position insertpoint  \
sim:/tb/dut/enable_d
add wave -position insertpoint  \
sim:/tb/dut/enable
add wave -position insertpoint  \
sim:/tb/dut/en_d_inv
add wave -position insertpoint  \
sim:/tb/dut/pulse
add wave -position insertpoint  \
sim:/tb/dut/inc_data \
sim:/tb/dut/lfsr_data \
sim:/tb/dut/data_out_temp \
sim:/tb/dut/data_out_d \
sim:/tb/dut/data_out \
sim:/tb/dut/valid_out \
sim:/tb/dut/cnt
add wave -position insertpoint  \
sim:/tb/dut/sync \
sim:/tb/dut/valid_temp \

run -all