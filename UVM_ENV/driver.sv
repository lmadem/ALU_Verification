//driver component
class driver extends uvm_driver#(alu_transaction);
  //registering into factory
  `uvm_component_utils(driver)
  //packet count in driver
  bit [31:0] pkt_id;
  //virtual interface
  virtual alu_intf.tb vif;
  
  //constructor
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task drive(input alu_transaction pkt);
  extern virtual task reset_phase(uvm_phase phase);
  
endclass
    
    
//build_phase to get the virtual interface connection
function void driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uvm_config_db#(virtual alu_intf.tb)::get(get_parent(), "", "drvr_vif", vif);
  assert(vif != null) else
    `uvm_fatal(get_type_name(), "Virtual Interface in driver is NULL ");
endfunction
    
    
//run_phase to run driver continously
task driver::run_phase(uvm_phase phase);
  forever
    begin
      seq_item_port.get_next_item(req);
      pkt_id++;
      `uvm_info("[Drvr]", $sformatf("Received Transaction[%0d] from TLM port", pkt_id), UVM_HIGH);
      drive(req);
      seq_item_port.item_done();
      `uvm_info(get_type_name(), $sformatf("Transaction[%0d] Done", pkt_id), UVM_MEDIUM); 
    end
endtask
    
    
//drive task to drive the stimulus to DUT
task driver::drive(input alu_transaction pkt);
  @(vif.cb);
  `uvm_info(get_type_name(), "Transaction Started...", UVM_HIGH);
  vif.cb.op_code <= pkt.op;
  vif.cb.inp1 <= pkt.inp1;
  vif.cb.inp2 <= pkt.inp2;
  `uvm_info(get_type_name(), "Transaction Ended...", UVM_HIGH);  
endtask
    
    
//reset_phase to apply reset stimulus to DUT
task driver::reset_phase(uvm_phase phase);
  phase.raise_objection(this, "Reset Objection Raised..");
  `uvm_info("RESET", "Reset Started...", UVM_MEDIUM);
  vif.reset <= 1'b1;
  repeat(5) @(vif.cb);
  vif.reset <= 1'b0;
  `uvm_info("RESET", "Reset Ended...", UVM_MEDIUM);
  phase.drop_objection(this, "Reset Objection Dropped..");
endtask
