module alu(clk,reset,op_code,inp1,inp2,outp);
  parameter N = 4;
  input clk,reset;
  input [N-1:0] inp1,inp2;
  input [2:0] op_code;
  output [(2*N)-1:0] outp;
  reg [(2*N)-1:0] outp;
  
  parameter ADD = 3'b000, SUB = 3'b001, MUL = 3'b010, DIV = 3'b011, LOR = 3'b100, LAND = 3'b101, 
  COMP = 3'b110, SHIFT = 3'b111;
  //Internal Signals
  reg [N-1 : 0] in1,in2;
  
  always @ (posedge clk or posedge reset) 
    begin
      if(reset)
        outp='0;
      else
        begin
          case(op_code)
            ADD :   outp = inp1 +  inp2;
            
            MUL :   outp = inp1 *  inp2;
            
            SUB :   if(inp1 >= inp2)
              outp = inp1 - inp2;
            else
              outp = inp2 -  inp1;
            
            DIV :   outp = inp1 /  inp2;
            
            LOR :   outp = inp1 | inp2;
            
            LAND :  outp= inp1 & inp2;
            
            COMP : outp = (inp1 == inp2) ? 1 : 0;
            
            SHIFT : begin
              in1 = inp1 << 1; //left-shift
              in2 = inp2 >> 1; //right-shift
              outp = {in1,in2}; //concatenation
            end
            
            default : outp = 'bz;
          endcase
        end
    end
endmodule
