//master agent component
class master_agent extends uvm_agent;
  //registering into factory
  `uvm_component_utils(master_agent)
  
  //component handles
  sequencer seqr;
  driver drvr;
  iMonitor iMon;
  
  //TLM analysis port
  uvm_analysis_port #(alu_transaction) ap;
  
  //constructor
  function new(string name = "master_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass
    
    
//build_phase to build the components
function void master_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap = new("magent_ap", this);
  if(is_active == UVM_ACTIVE)
    begin
      seqr = sequencer::type_id::create("seqr", this);
      drvr = driver::type_id::create("drvr", this);
    end
  iMon = iMonitor::type_id::create("iMon", this);  
endfunction
    
    
//connect_phase for establishing the connections b/w components
function void master_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(is_active == UVM_ACTIVE)
    begin
      drvr.seq_item_port.connect(seqr.seq_item_export);
    end
  iMon.analysis_port.connect(this.ap); 
endfunction
