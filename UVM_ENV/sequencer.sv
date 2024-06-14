//sequencer
typedef uvm_sequencer #(alu_transaction) sequencer;


/*
(or)
class sequencer extends uvm_sequencer #(alu_transaction);
  `uvm_component_utils(sequencer)
  
  //constructor
  function new(string name = "uvm_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

*/


