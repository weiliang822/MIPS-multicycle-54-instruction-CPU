######################################################################
#
# File name : cpu54_tb_simulate.do
# Created on: Sat Jul 15 15:10:15 +0800 2023
#
# Auto generated by Vivado for 'post-synthesis' simulation
#
######################################################################
vsim -voptargs="+acc" +transport_int_delays +pulse_r/0 +pulse_int_r/0 -L simprims_ver -L secureip -L xil_defaultlib -lib xil_defaultlib xil_defaultlib.cpu54_tb xil_defaultlib.glbl

do {cpu54_tb_wave.do}

view wave
view structure
view signals

do {cpu54_tb.udo}

run 200000ns
