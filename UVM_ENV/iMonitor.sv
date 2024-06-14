//Input Monitor Component
class iMonitor extends uvm_monitor;
  //registering into factory
  `uvm_component_utils(iMonitor)
  
  //virtual interface
  virtual alu_intf.tb_mon_in vif;
  
  //TLM port used to connect the monitor to the scoreboard
  uvm_analysis_port #(alu_transaction) analysis_port;
  
  //current monitored transaction
  alu_transaction pkt;
  
  //constructor
  function new(string name = "iMonitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass
    
//build_phase to get the virtual interface connetion    
function void iMonitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual alu_intf.tb_mon_in)::get(get_parent(), "", "iMon_if", vif))
    begin
      `uvm_fatal(get_type_name(), "iMonitor virtual interface not set");
    end
  //create TLM port
  analysis_port = new("analysis_port", this);
endfunction
    
    
//run_phase to monitor and collect driven packets 
task iMonitor::run_phase(uvm_phase phase);
  forever
    begin
      @(vif.cb_mon_in.inp1 or vif.cb_mon_in.inp2 or vif.cb_mon_in.op_code);
      pkt = alu_transaction::type_id::create("pkt", this);
      pkt.inp1 = vif.cb_mon_in.inp1;
      pkt.inp2 = vif.cb_mon_in.inp2;
      pkt.op = vif.cb_mon_in.op_code;
      `uvm_info(get_type_name(), pkt.input2string(), UVM_MEDIUM);
      analysis_port.write(pkt);
    end
endtask
