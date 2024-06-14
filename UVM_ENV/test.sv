//base_test component
class base_test extends uvm_test;
  //registering into factory
  `uvm_component_utils(base_test);
  
  //environment handle
  environment env;
  
  //constructor
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  
endclass
    
    
//build_phase to build & configure the components
function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  env = environment::type_id::create("env", this);
  
  //config - driver virtual interface
  uvm_config_db#(virtual alu_intf.tb)::set(this, "env.magent", "drvr_vif", top.alu_intf_inst.tb);
  
  //config - input monitor virtual interface
  uvm_config_db#(virtual alu_intf.tb_mon_in)::set(this, "env.magent", "iMon_if", top.alu_intf_inst.tb_mon_in);
  
  //config - output monitor virtual interface
  uvm_config_db#(virtual alu_intf.tb_mon_out)::set(this, "env.sagent", "oMon_if", top.alu_intf_inst.tb_mon_out);
  
  //config - item_count to sequence
  uvm_config_db#(int)::set(this,"env.magent.seqr.*", "item_count", 500);
  
  //config - default sequence as base_sequence
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.magent.seqr.main_phase", "default_sequence", base_sequence::get_type());

endfunction
    
    
//main_phase to add an extra buffer time to the design to process driven packets
task base_test::main_phase(uvm_phase phase);
  uvm_objection objection;
  super.main_phase(phase);
  objection = phase.get_objection();
  //The drain time is the amount of time to wait once all objections have been dropped
  objection.set_drain_time(this, 50ns);
endtask
    

//start_of_simulation_phase to print the topology
function void base_test::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
  uvm_top.print_topology();
endfunction
