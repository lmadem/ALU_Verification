//interface
interface alu_intf(input clk);
  parameter N = 8;
  logic reset; //asynchronous reset, active high
  logic [N-1 : 0] inp1; //Input1
  logic [N-1 : 0] inp2; //Input2
  logic [2:0] op_code;  //OP_CODE
  logic [(2*N) - 1 : 0] alu_out; //Output
  
  //clocking block for driver
  clocking cb@(posedge clk);
    //directions are w.r.t to testbench
    output inp1,inp2;
    output op_code;
  endclocking
  
  //clocking block for input monitor - master
  clocking cb_mon_in@(posedge clk);
    input inp1,inp2;
    input op_code;
  endclocking
  
  //clocking block for output monitor - slave
  clocking cb_mon_out@(posedge clk);
    input alu_out;
  endclocking
 
  //modport for specifying directions
  modport tb(clocking cb, output reset);
  modport tb_mon_in(clocking cb_mon_in);
  modport tb_mon_out(clocking cb_mon_out, input reset);  
  
  
endinterface
