//predictor component : Implemented reference model in c 
//Subscriber component has in-built analysis_export, this export provides access to the write method, which derived subscribers must implement

class predictor extends uvm_subscriber #(alu_transaction);
  //registering into factory
  `uvm_component_utils(predictor)
  
  //TLM port to connect the monitor to the scoreboard
  uvm_analysis_port #(alu_transaction) analysis_scb_port;
  //variable to store previous output
  bit [31:0] prev_out;
  //expected dropped count
  bit [31:0] exp_drop_count;
  //number of packets
  bit [31:0] pkt_id;
  //width to pass for the reference model
  int unsigned width;
  
  
  //constructor
  function new(string name = "predictor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //build_phase to build the analysis port
  function void build_phase(uvm_phase phase);
    analysis_scb_port = new("predictor_port", this);
    uvm_config_db#(int)::get(this, "", "N_parameter", width);
  endfunction
  
  
  //write method
  virtual function void write(T t);
    alu_transaction pkt;
    $cast(pkt, t.clone());
    pkt_id++;
    `uvm_info(get_type_name(), $sformatf("Received packet(%0d) in predictor", pkt_id), UVM_MEDIUM);
    pkt.alu_out = alu_dpi_model(pkt.inp1, pkt.inp2, pkt.op, width);
    
    if(prev_out == pkt.alu_out)
      begin
        `uvm_warning("[PKT_DROP]", "Previous output matches with current output");
        `uvm_warning("[PKT_DROP]", $sformatf("packet (%0d) will not be detected in output monitor", pkt_id));
        `uvm_warning("[PKT_DROP]", $sformatf("previous_output = %0d current_output = %0d", prev_out, pkt.alu_out));
        exp_drop_count++;
      end
    else
      begin
        `uvm_info(get_type_name(), pkt.input2string(), UVM_MEDIUM);
        analysis_scb_port.write(pkt);
      end
    prev_out = pkt.alu_out;
  endfunction
  
   //extract_phase to fill the exp_drop_count
  virtual function void extract_phase(uvm_phase phase);
    uvm_config_db#(bit [31:0])::set(null, "uvm_test_top.env", "exp_dropped_count", exp_drop_count);
  endfunction
  
endclass
