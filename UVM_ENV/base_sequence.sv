//base_sequence
class base_sequence extends uvm_sequence #(alu_transaction);
  //packet count
  int unsigned item_count;
  //registering into factory
  `uvm_object_utils(base_sequence)
  
  //constructor
  function new(string name = "base_sequence");
    super.new(name);
    set_automatic_phase_objection(1); //UVM 1.2
  endfunction
  
  //extern methods
  extern virtual task pre_start();
  extern virtual task body();
  
endclass
    
//pre_start method to get item_count from test
task base_sequence::pre_start();
  if(!uvm_config_db#(int)::get(null, get_full_name, "item_count", item_count))
    begin
      `uvm_info(get_full_name(), "item_count is not set in sequence level and setting it to default value = 10", UVM_MEDIUM);
      item_count = 10;
    end
endtask
    
 
//body method to randomize the packet on item_count times
task base_sequence::body();
  bit [31:0] count;
  alu_transaction ref_pkt;
  ref_pkt = alu_transaction::type_id::create("ref_pkt");
  repeat(item_count)
    begin
      `uvm_create(req);
      assert(ref_pkt.randomize());
      req.copy(ref_pkt);
      start_item(req);
      finish_item(req);
      count++;
      `uvm_info(get_type_name(), $sformatf("Transaction[%0d] Generation Done", count), UVM_MEDIUM);
    end 
endtask
