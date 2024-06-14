//slave agent component
class slave_agent extends uvm_agent;
  //registering into factory
  `uvm_component_utils(slave_agent)
  
  //output monitor handle
  oMonitor oMon;
  //TLM analysis port
  uvm_analysis_port #(alu_transaction) ap;
  
  //constructor
  function new(string name = "slave_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass
    
    
//build_phase to build the components
function void slave_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap = new("sagent_ap", this);
  oMon = oMonitor::type_id::create("oMon", this);
endfunction
    
        
//connect_phase for establishing the connections b/w components
function void slave_agent::connect_phase(uvm_phase phase);   
  super.connect_phase(phase);
  oMon.analysis_port.connect(this.ap);
endfunction
    
    
