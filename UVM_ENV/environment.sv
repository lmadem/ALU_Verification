//environemnt component
class environment extends uvm_env;
  //registering into factory
  `uvm_component_utils(environment)
  
  //expected dropped packet count
  bit [31:0] exp_drop_count;
  
  //component handles
  master_agent magent;
  slave_agent sagent;
  scoreboard scb;
  predictor pred;
  
  //constructor
  function new(string name = "environment", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void extract_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);
endclass 
    
    

//build_phase to construct the components
function void environment::build_phase(uvm_phase phase);
  super.build_phase(phase);
  magent = master_agent::type_id::create("magent", this);
  sagent = slave_agent::type_id::create("sagent", this);
  scb = scoreboard::type_id::create("scb", this);
  pred = predictor::type_id::create("pred", this);
endfunction
    
  
//connect_phase to configure the components
function void environment::connect_phase(uvm_phase phase);
  magent.ap.connect(pred.analysis_export);
  pred.analysis_scb_port.connect(scb.mon_in);
  sagent.ap.connect(scb.mon_out);
endfunction
    
    
//extract_phase to get the exp_drop_count
function void environment::extract_phase(uvm_phase phase);
  uvm_config_db#(bit [31:0])::get(this, "", "exp_dropped_count", exp_drop_count);
endfunction
    
    
//report_phase to validate the scoreboard count    
function void environment::report_phase(uvm_phase phase);
  //expected packet count
  bit [31:0] exp_pkt_count;
  //scoreboard received packet count
  bit [31:0] scb_received_pkt_count;
  
  //getting the expected packet count from test
  uvm_config_db#(int)::get(null,"uvm_test_top.env.magent.seqr.*","item_count",exp_pkt_count);
  scb_received_pkt_count=scb.m_comp.m_mismatches+ scb.m_comp.m_matches;
  
  if((scb_received_pkt_count + exp_drop_count) != exp_pkt_count)
    begin
      `uvm_info("env","*********************************************",UVM_NONE);
	  `uvm_error("FAILED","Test FAILED Due to packet count mismatch");
      `uvm_info("env",$sformatf("expected=%0d received_in_scb=%0d",exp_pkt_count,scb_received_pkt_count),UVM_NONE);
      `uvm_info("env",$sformatf("pkts_matched=%0d pkts_mismatched=%0d dropped=%0d",scb.m_comp.m_matches,scb.m_comp.m_mismatches,exp_drop_count),UVM_NONE);
      `uvm_info("env","**********************************************",UVM_NONE);
    end
  else if(scb.m_comp.m_mismatches != 0)
    begin
      `uvm_info("env","********************************************",UVM_NONE);
	  `uvm_error(get_type_name(),"Test FAILED ");
      `uvm_info("env",$sformatf("pkts_matched=%0d pkts_mismatched=%0d dropped=%0d",scb.m_comp.m_matches,scb.m_comp.m_mismatches,exp_drop_count),UVM_NONE);
      `uvm_info("env",$sformatf("pkts_matched=%0d pkts_mismatched=%0d",scb.m_comp.m_matches,scb.m_comp.m_mismatches),UVM_NONE);
      `uvm_info("env","*****************************************",UVM_NONE);
    end 
  else 
    begin 
      `uvm_info("env","**************************************",UVM_NONE);
      `uvm_info("PASSED","Test PASSED",UVM_NONE);
      `uvm_info("env",$sformatf("expected=%0d received_in_scb=%0d",exp_pkt_count,scb_received_pkt_count),UVM_NONE);
      `uvm_info("env",$sformatf("pkts_matched=%0d pkts_mismatched=%0d dropped=%0d",scb.m_comp.m_matches,scb.m_comp.m_mismatches,exp_drop_count),UVM_NONE);
      `uvm_info("env","*************************************",UVM_NONE);
    end
endfunction
    
    
