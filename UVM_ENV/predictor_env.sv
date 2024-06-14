//predictor component : Implemented golden/reference model in write method
//Subscriber component has in-built analysis_export, this export provides access to the write method, which derived subscribers must implement

class predictor extends uvm_subscriber #(alu_transaction);
  //registering into factory
  `uvm_component_utils(predictor)
  
  //TLM port to connect the monitor to the scoreboard
  uvm_analysis_port #(alu_transaction) analysis_scb_port;
  
  //variable to store previous output
  bit [31:0] prev_out;
  //flag signal
  bit done;
  //expected dropped count
  bit [31:0] exp_drop_count;
  //number of packets
  bit [31:0] pkt_id;
  
  
  //constructor
  function new(string name = "predictor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //build_phase to build the analysis port
  function void build_phase(uvm_phase phase);
    analysis_scb_port = new("predictor_port", this);
  endfunction
  
  //write method - Implemented reference model
  virtual function void write(T t);
    alu_transaction pkt;
    $cast(pkt, t.clone());
    pkt_id++;
    `uvm_info(get_type_name(), $sformatf("Received packet(%0d) in predictor", pkt_id), UVM_MEDIUM);
    case(pkt.op)
      3'b000 : begin pkt.alu_out = pkt.inp1 + pkt.inp2; end //add
      3'b001 : begin //sub
        if(pkt.inp1 >= pkt.inp2)
          pkt.alu_out = pkt.inp1 - pkt.inp2; 
        else
          pkt.alu_out = pkt.inp2 - pkt.inp1; 
      end 
      3'b010 : begin pkt.alu_out = pkt.inp1 * pkt.inp2; end //mul
      3'b011 : begin pkt.alu_out = pkt.inp1 / pkt.inp2; end //div
      3'b100 : begin pkt.alu_out = pkt.inp1 | pkt.inp2; end //bitwise or
      3'b101 : begin pkt.alu_out = pkt.inp1 & pkt.inp2; end //bitwise and
      3'b110 : begin pkt.alu_out = (pkt.inp1 == pkt.inp2) ? 1 : 0; end //comparison
      3'b111 : begin 
        pkt.inp1 = pkt.inp1 << 1;
        pkt.inp2 = pkt.inp2 >> 1;
        pkt.alu_out = {pkt.inp1, pkt.inp2};
      end
      //default : pkt.alu_out = 'z; //No Operation
    endcase
    if(done && (prev_out == pkt.alu_out)) 
      begin
        `uvm_warning("[PKT_DROP]", "Previous output matches with current output");
        `uvm_warning("[PKT_DROP]", $sformatf("packet (%0d) will not be detected in output monitor", pkt_id));
        `uvm_warning("[PKT_DROP]", $sformatf("OP_CODE = %0d previous_output = %0d current_output = %0d", pkt.op, prev_out, pkt.alu_out));
        exp_drop_count++;
      end
    else
      begin
        `uvm_info(get_type_name(), pkt.input2string(), UVM_MEDIUM);
        analysis_scb_port.write(pkt);
      end
    prev_out = pkt.alu_out;
    done = 1;
  endfunction
  
  
  //extract_phase to fill the exp_drop_count
  virtual function void extract_phase(uvm_phase phase);
    uvm_config_db#(bit [31:0])::set(null, "uvm_test_top.env", "exp_dropped_count", exp_drop_count);
  endfunction

endclass
