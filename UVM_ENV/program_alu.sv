//Include alu_env_pkg
`include "alu_env_pkg.pkg"
//program block
program alu_prgm();
  //import uvm package
  import uvm_pkg::*;
  //import alu env package
  import alu_env_pkg::*;
  
  //Include test
  `include "test.sv"
  
  initial
    begin
      $timeformat(-9, 1, "ns", 10);
      run_test();
    end
  
  
endprogram
