// ECE:3350 SISC computer project
// finite state machine

`timescale 1ns/100ps
//mm is condition code
module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel,rb_sel, pc_sel, pc_write, pc_rst, ir_load, br_sel, mux_16_sel, dm_we);
  /* TODO: Declare the ports listed above as inputs or outputs */
  input clk,rst_f;
  input[3:0] opcode, mm, stat;
  output reg[1:0] alu_op;
  output reg wb_sel, rf_we, rb_sel, pc_sel, pc_write, pc_rst, ir_load, br_sel, mux_16_sel, dm_we;
  
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
	   pc_rst = 1'b0;
	   present_state = next_state;
	end 

	always @(negedge clk)begin

	    if(rst_f == 0) begin
	        present_state = start1;
		pc_rst = 1'b1;
	    end
  	end
		
  /* TODO: Write a combination procedure that determines the next state of the fsm. */
  /* Chase: refer to slides 43, 49-53, 58 in 3b - Basic CPU.pptx under Processor Design link */
	always @(present_state) begin
//$monitor("present_state = %b, next_state=%b",present_state, next_state);
		case(present_state)
			start0: begin
				next_state <= start1;
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
				next_state <= fetch;
			end
		endcase
		
	end

  /* TODO: Generate outputs based on the FSM states and inputs. For Parts 2, 3 and 4 you will
       add the new control signals here. */
   
 always @ (posedge clk or opcode) begin
	case(present_state) 
		start0: begin
			rf_we <= 1'b0;
			wb_sel <= 1'b0;
			alu_op <= 2'b10;
			rb_sel <= 1'b0;
			pc_write <= 1'b0;	
			ir_load <= 1'b0;
			br_sel <= 1'b0;
			pc_rst <= 1'b1;
			pc_sel <= 1'b0;
		end

		start1: begin
			alu_op <= 2'b00;
			ir_load <= 1'b0;
			pc_rst <= 1'b0;
		end

		fetch: begin
			rf_we <= 1'b0;
			wb_sel <= 1'b0;
			alu_op <= 2'b00;
			rb_sel <= 1'b0;
			pc_write <= 1'b1;	// Always increment the pc in fetch
			ir_load <= 1'b1;
			br_sel <= 1'b0;
			pc_rst <= 1'b0;
			pc_sel <= 1'b0;	
		end

		decode: begin
			ir_load <= 1'b0;
			pc_write <= 1'b0;
			
			case(opcode) 
				BNE: begin

					pc_sel <= 1;
					if((stat& mm) == 4'b0000) begin
						$display("Took BNE branch");
						pc_sel <= 1;
						pc_write <= 1;
						br_sel <= 1;
					end
				end
				BRA: begin
					pc_sel <= 1;
					if ((stat & mm) != 4'b0000) begin
						$display("Took BRA branch");
						pc_sel <= 1;
						pc_write <= 1;
						br_sel <= 1;
					end
				end
				BRR: begin

					pc_sel <= 1;
					if ((stat & mm) != 4'b0000) begin

						$display("Took BRR branch");
						pc_sel <= 1;
						pc_write <= 1;
						br_sel <= 0;
					end
				end
				BNR: begin
					pc_sel <= 1;
					if ((stat & mm) == 4'b0000) begin
						$display("Took BNR branch");
						pc_sel <= 1;
						pc_write <= 1;
						br_sel <= 0;
					end
				end
			endcase
		end

		execute: begin
			pc_write <= 1'b0;
			ir_load <= 1'b0;

			case(mm) 
				am_imm:begin
					if(opcode == ALU_OP) 
						alu_op <= 2'b01;
					
					else
						alu_op <= 2'b11;
					
				end

				default:begin
					if(opcode == ALU_OP) 
						alu_op <= 2'b00;	
					
					else 
						alu_op <= 2'b10;
					
				end
			endcase
	
			if(mm == am_imm) begin
				if(opcode == ALU_OP) begin
					alu_op <= 2'b01;
				end
				else begin
					alu_op <= 2'b11;
				end
			end
			else begin
				if(opcode == ALU_OP) begin
					alu_op <= 2'b00;
				end
				else begin
					alu_op <= 2'b10;
				end
			end
		end

		mem: begin
			
			if (opcode == LOD) begin
				case(mm) 
					4'b1000:begin // ldx
						$display("ldx");
						mux_16_sel <= 0;
						
					end
					4'b0000:begin // lda
						$display("lda");
						mux_16_sel <= 1;
					end

					default:begin
					end
				endcase
			end
			if (opcode == STR) begin
				dm_we <= 1;
				case(mm)
					4'b1000:begin // stx	
						$display("stx");
						mux_16_sel <= 0;
					end
					4'b0000:begin // sta
						$display("sta");
						mux_16_sel <= 1;
					end
				endcase
			end
		end

		writeback: begin //I cant believe you messed this up
			dm_we <= 0;
			if(opcode == ALU_OP) begin
				$display("Setting rf_we=1");				
				rf_we = 1;
			end
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