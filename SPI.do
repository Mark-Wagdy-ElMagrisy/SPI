vlib work
vlog Counter.v RAM.v SPIslave.v SPIsystem.v testBench.v
vsim -voptargs=+acc work.SPISystem_tb
add wave -position insertpoint  \
sim:/SPISystem_tb/test/MOSI \
sim:/SPISystem_tb/test/SS_n \
sim:/SPISystem_tb/test/rst_n \
sim:/SPISystem_tb/test/clk \
sim:/SPISystem_tb/test/MISO \
sim:/SPISystem_tb/test/din_rx \
sim:/SPISystem_tb/test/rx_valid \
sim:/SPISystem_tb/test/tx_valid \
sim:/SPISystem_tb/test/tx_data
add wave -position insertpoint  \
sim:/SPISystem_tb/test/memory/dout \
sim:/SPISystem_tb/test/memory/mem \
sim:/SPISystem_tb/test/memory/write_address \
sim:/SPISystem_tb/test/memory/read_address \
sim:/SPISystem_tb/test/memory/opmode
add wave -position insertpoint  \
sim:/SPISystem_tb/test/slave/rx_data \
sim:/SPISystem_tb/test/slave/ns \
sim:/SPISystem_tb/test/slave/cs \
sim:/SPISystem_tb/test/slave/shiftReg \
sim:/SPISystem_tb/test/slave/MOSIreg \
sim:/SPISystem_tb/test/slave/counterOut \
sim:/SPISystem_tb/test/slave/switchState \
sim:/SPISystem_tb/test/slave/opmode
run -all
#quit -sim
