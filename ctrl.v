// ECE:3350 SISC computer project
// finite state machine

`timescale 1ns/100ps

module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel,rd_sel);

  /* TODO: Declare the ports listed above as inputs or outputs */
  input clk,rst_f;
  input[3:0] opcode, mm, stat;
  output reg[1:0] alu_op;
  output reg wb_sel, rf_we, rd_sel;
  reg wb_wire, rf_wire;
  
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
	always @(present_state) begin
//$monitor("present_state = %b, next_state=%b",present_state, next_state);
		case(present_state)
			start0: begin
				next_state <= start0;
			end
			start1: begin
				next_state <= fetch;
			end 
			fetch: begin
				next_state <= decode;
			end
			decode: begin
				next_state <= execute;
			end
			execute: begin
				next_state <= mem;
			end
			mem: begin
				next_state <= writeback;
			end
			writeback: begin
				next_state <= start1;
			end
		endcase
		
	end

  /* TODO: Generate outputs based on the FSM states and inputs. For Parts 2, 3 and 4 you will
       add the new control signals here. */
   
 always @ (posedge clk) begin
	case(present_state) 
		fetch: begin
			rf_we <= 1'b0;
			wb_sel <= 1'b0;
			//alu_op <= 2'b00;
			rd_sel <= 1'b0;

		end
		decode: begin
			/*
			if(opcode == 4'b1000) 
				alu_op[0] <= 1'b1;
			else
				alu_op[0] <= 1'b0;
			if(mm == 4'b1000)
				alu_op[1] <= 1'b1;
			else
				alu_op[1] <= 1'b0;
		*/end
		execute: begin
			if(opcode == 4'b1000) 
				alu_op[0] <= 1'b1;
			else
				alu_op[0] <= 1'b0;
			if(mm == 4'b1000)
				alu_op[1] <= 1'b1;
			else
				alu_op[1] <= 1'b0;
		end
		mem: begin
			
			rf_we <= 1'b1;
		end
		

	endcase
	
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
