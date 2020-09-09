source synopsys_dc.setup
read_file CS.v
source CS_DC.sdc
compile
write -format verilog -hierarchy -output CS_syn.v
write -format ddc -hierarchy -output CS_syn.ddc
write_sdf -version 2.1 CS_syn.sdf
