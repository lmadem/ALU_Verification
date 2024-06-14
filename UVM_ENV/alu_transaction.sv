`define WIDTH 6
//transaction class
class alu_transaction extends uvm_sequence_item;
  
  //control knob to identify the transaction type
  typedef enum bit [2:0] {ADD = 0, SUB = 1, MUL = 2, DIV = 3, LOR = 4, LAND = 5, COMP = 6, SHIFT = 7} op_code_enum_t;
  //Input Stimulus
  rand logic [`WIDTH - 1 : 0] inp1;
  rand logic [`WIDTH - 1 : 0] inp2;
  //OP CODE
  rand logic [2:0] op;
  
  //control knob handle
  op_code_enum_t op_e;
  
  //dut output for comparison
  logic [(2 * `WIDTH) - 1 : 0] alu_out;
  
  //to generate new set of inputs for every sampling period
  bit [`WIDTH - 1 : 0] prev_inp1;
  bit [`WIDTH - 1 : 0] prev_inp2;
  
  //registerting object, fields into the factory
  `uvm_object_utils_begin(alu_transaction);
  `uvm_field_int(inp1, UVM_ALL_ON | UVM_NOCOMPARE);
  `uvm_field_int(inp2, UVM_ALL_ON | UVM_NOCOMPARE);
  `uvm_field_int(op, UVM_ALL_ON | UVM_NOCOMPARE);
  `uvm_field_int(alu_out, UVM_ALL_ON);
  `uvm_object_utils_end
  
  //constructor
  function new(string name = "alu_transaction");
    super.new(name);
  endfunction
  
  //constraint to generate the input stimuli within the range
  constraint valid {
    inp1 inside {[1 : (2 ** `WIDTH) - 1]};
    inp2 inside {[1 : (2 ** `WIDTH) - 1]};
    op inside {[0:7]};
    inp1 != prev_inp1;
    inp2 != prev_inp2;
  }
  
  //post_randomize function
  function void post_randomize();
    prev_inp1 = inp1;
    prev_inp2 = inp2;
  endfunction
  
  //convert2string method
  virtual function string convert2string();
    return $sformatf("op_code = %0s inp1 = %0d inp2 = %0d alu_out = %0d", op_e.name(), inp1, inp2, alu_out);
  endfunction
  
  //input2string method
  virtual function string input2string();
    op_e = op_code_enum_t'(op);
    return $sformatf("op_code = %0s inp1 = %0d inp2 = %0d alu_out = %0d", op_e.name(), inp1, inp2, alu_out);
  endfunction

endclass

