`include "interface.sv"
`include "program_alu.sv"

//top module
module top;
  //parameter to override the width of inputs in dut & interface
  parameter reg [31:0] N_tb = 6;
  //clock declaration
  bit clk;
  //clock generation
  always #5 clk = ~clk;
  
  
  //Interface Instanstiation
  alu_intf #(.N(N_tb)) alu_intf_inst (clk);
  
     
  //DUT Instanstiation           
  alu #(.N(N_tb)) alu_dut_inst(.clk(clk),
                               .reset(alu_intf_inst.reset),
                               .op_code(alu_intf_inst.op_code),
                               .inp1(alu_intf_inst.inp1),
                               .inp2(alu_intf_inst.inp2),
                               .outp(alu_intf_inst.alu_out)
                              );
  
  //Program Block Instantiation
  alu_prgm alu_prgm_inst();
  
        
  initial
    begin
      uvm_config_db#(int)::set(null, "uvm_test_top.env.pred", "N_parameter", N_tb);
      $dumpfile("dump.vcd");
      $dumpvars(0,top.alu_dut_inst);
    end
  
endmodule
