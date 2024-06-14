//Output Monitor component
class oMonitor extends uvm_monitor;
  //registering into factory
  `uvm_component_utils(oMonitor)
  
  //virtual interface
  virtual alu_intf.tb_mon_out vif;
  
  //TLM port to connect the monitor to the scoreboard
  uvm_analysis_port #(alu_transaction) analysis_port;
  
  //current monitored trasaction
  alu_transaction pkt;
  
  //constructor
  function new(string name = "oMonitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass
    
    
//build_phase to get the virtual interface connection
function void oMonitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual alu_intf.tb_mon_out)::get(get_parent(), "", "oMon_if", vif))
    begin
      `uvm_fatal(get_type_name(), "Virtual Interface is not in oMonitor component");
    end
  //create TLM port
  analysis_port = new("analysis_port", this);
endfunction
    
    
//run_phase to actively monitor and collect the dut output 
task oMonitor::run_phase(uvm_phase phase);
  // The purpose of the oMonitor is to passively monitor the physical signals, interprete and report the activities it sees.  In this case, to re-construct the alu_trans that it sees on the DUT's output port as specified
  forever
    begin
      @(vif.cb_mon_out.alu_out);
      //skipping the loop when alu_out is in high impedence state and when reset is asserted
      if(vif.cb_mon_out.alu_out === 'x || vif.cb_mon_out.alu_out === 'z)
        continue;
      if(vif.reset == 1'b1)
        continue;
      
      pkt = alu_transaction::type_id::create("pkt", this);
      pkt.alu_out = vif.cb_mon_out.alu_out; //output data
      
      `uvm_info(get_type_name(), $sformatf("pkt.alu_out = %0d", pkt.alu_out), UVM_MEDIUM);
      analysis_port.write(pkt);
    end
endtask
    
