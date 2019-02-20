// ECE:3350 SISC computer project
// finite state machine

`timescale 1ns/100ps

module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel);
  input clk,rst_f, stat, opcode, mm;
  output [1:0]alu_op;
  output wb_sel, rf_we;
  
  /* TODO: Declare the ports listed above as inputs or outputs */
  
  
  // states
  parameter start0 = 0, start1 = 1, fetch = 2, decode = 3, execute = 4, mem = 5, writeback = 6;
   
  // opcodes
  parameter NOOP = 0, LOD = 1, STR = 2, SWP = 3, BRA = 4, BRR = 5, BNE = 6, BNR = 7, ALU_OP = 8, HLT=15;
	
  // addressing modes
  parameter am_imm = 8;

  // state registers
  reg [2:0]  present_state, next_state;

  initial
    present_state = start0;

  /* TODO: Write a sequential procedure that progresses the fsm to the next state on the
       positive edge of the clock, OR resets the state to 'start1' on the negative edge
       of rst_f. Notice that the computer is reset when rst_f is low, not high. */
       //I'm not sure if this will work I can't ever get it to clone so I did it in github let me know if it doesn't and I'll 
       //work on it some more
       
	always @(posedge clk) begin
	   present_state = next_state;
	end 

	always @(negedge clk)begin

	    if(rst_f == 0) begin
	        present_state = start1;
	    end
  	end
		
  /* TODO: Write a combination procedure that determines the next state of the fsm. */
  /* Chase: refer to slides 43, 49-53, 58 in 3b - Basic CPU.pptx under Processor Design link */

	if (present_state == start0) begin
	    assign next_state = start1;
	end		

	else if (present_state == start1) begin
	  assign next_state = fetch;
	end		

	else if (present_state == fetch) begin
	   assign next_state = decode;
	end	
	
	else if (present_state == decode) begin
	   assign next_state = execute;
	end	
	
	else if (present_state == execute) begin
	   assign next_state = mem;
	end	
	
	else if (present_state == mem) begin
	   assign next_state = writeback;
	end	
	
	else if (present_state == writeback) begin
	   assign next_state = fetch;

	end	



  /* TODO: Generate outputs based on the FSM states and inputs. For Parts 2, 3 and 4 you will
       add the new control signals here. */
     
 always @ (posedge clk)
 	begin : output_logic
 	if (rst_f == start1) begin
 		present_state <=  start0;
 		next_state <=  start1;
 	end
 	else begin
 	case(present_state)
 	decode : begin
        	present_state <= start0;
 		next_state <=  start0;
 	end
 	fetch : begin
                present_state <=  start1;
                next_state <=  start0;
        end
 	mem : begin
                present_state <=  start0;
                next_state <=  start1;
        end
    	default : begin
                present_state <=  start0;
                next_state <=  start0;
        end
 	endcase
 end
 end
// Halt on HLT instruction
  
  always @ (opcode)
  begin
    if (opcode == HLT)
    begin 
      #5 $display ("Halt."); //Delay 5 ns so $monitor will print the halt instruction
      $stop;
    end
  end
    
  
endmodule
