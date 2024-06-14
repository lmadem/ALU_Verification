//scoreboard component - In order

class scoreboard extends uvm_scoreboard;
  //registering into factory
  `uvm_component_utils(scoreboard)
  
  //TLM analysis port
  uvm_analysis_port #(alu_transaction) mon_in;
  uvm_analysis_port #(alu_transaction) mon_out;
  uvm_in_order_class_comparator #(alu_transaction) m_comp;
  
  //constructor
  function new(string name = "scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  //build_phase to costruct analysis ports
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_comp = uvm_in_order_class_comparator#(alu_transaction)::type_id::create("m_comp", this);
    mon_in = new("mon_in", this);
    mon_out = new("mon_out", this);
  endfunction
  
  //connect_phase to connect monitors and scoreboard
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mon_in.connect(m_comp.before_export);
    mon_out.connect(m_comp.after_export);
  endfunction
  
  //report_phase to keep track of matches and mismatches in scoreboard component
  virtual function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("scoreboard completed with matches = %0d mismatches = %0d", m_comp.m_matches, m_comp.m_mismatches), UVM_NONE);
  endfunction
  
endclass
