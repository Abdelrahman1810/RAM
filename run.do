vlib work
vlog RAM.v register.v testbench.v
vsim -voptargs=+acc work.testbench
add wave *

#add wave -r /*

run -all

# quit -sim