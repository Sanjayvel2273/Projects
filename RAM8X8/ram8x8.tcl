#read liberty file for verilog
read_liberty -lib cmos_cells.lib

#read verilog files
read_verilog ram8x8.v

#synth top module
synth -top ram8x8

#read abc lib and mapping ff
dfflibmap -liberty cmos_cells.lib
abc -liberty cmos_cells.lib

#create netlist file
write_verilog ram8to8_synth.v

write_spice ram8to8.sp

write_json ram8x8.json
stat
