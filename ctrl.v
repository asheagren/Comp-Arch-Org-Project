// ECE:3350 SISC computer project
// finite state machine

`timescale 1ns/100ps
//mm is condition code
module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel,rb_sel, pc_sel, pc_write, pc_rst, ir_load, br_sel, mux_16_sel, dm_we, mux4_swap_sel,swap_ctrl);
  /* TODO: Declare the ports listed above as inputs or outputs */
  input clk,rst_f;
  input[3:0] opcode, mm, stat;
  output reg[1:0] alu_op, wb_sel;
  output reg rf_we, rb_sel, pc_sel, pc_write, pc_rst, ir_load, br_sel, mux_16_sel, dm_we, mux4_swap_sel, swap_ctrl;

  
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
			swap_ctrl <= 0;
			rf_we <= 1'b0;
			wb_sel <= 0;
			alu_op <= 2'b10;
			rb_sel <= 1'b0;
			pc_write <= 1'b0;	
			ir_load <= 1'b0;
			br_sel <= 1'b0;
			pc_rst <= 1'b1;
			pc_sel <= 1'b0;
			mux4_swap_sel <= 0;
			dm_we <= 0;
		end

		start1: begin
			dm_we <= 0;
			//wb_sel <= 0;
			alu_op <= 2'b00;
			ir_load <= 1'b0;
			pc_rst <= 1'b0;
			mux4_swap_sel <= 0;
			dm_we <= 0;
		end

		fetch: begin
			swap_ctrl <= 0;
			rf_we <= 1'b0;
			wb_sel <= 0;
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

					br_sel <= 1'b1;
					pc_sel <= 1;

					if((stat& mm) == 4'b0000) begin
						pc_sel <= 1;
						pc_write <= 1;
						br_sel <= 1;
					end
				end
				BRA: begin
					pc_sel <= 1;
					if ((stat & mm) != 4'b0000) begin
						pc_sel <= 1;
						pc_write <= 1;
						br_sel <= 1;
					end
				end
				BRR: begin

					br_sel <= 1'b0;
					

					pc_sel <= 1;
					if ((stat & mm) != 4'b0000) begin
						pc_sel <= 1;
						pc_write <= 1;
						br_sel <= 0;
					end
				end
				BNR: begin
					pc_sel <= 1;
					if ((stat & mm) == 4'b0000) begin
						pc_sel <= 1;
						pc_write <= 1;
						br_sel <= 0;
					end
				end
				STR: begin //STR general store opcode mm tells what kind of store 
						// part 3 STX mm == 8 STA mm == 0 
						// Part 4 STP: mm == 9 STR mm == 1
					rb_sel <= 1;
					
				end
				SWP: begin
					rb_sel <= 1;
					//swap_ctrl <= 1;
					
				end
			endcase
		end

		execute: begin
			pc_write <= 1'b0;
			ir_load <= 1'b0;
			case(mm)
				am_imm: begin //mm == 8
					case(opcode)
						ALU_OP: begin

							alu_op <= 2'b01;
							dm_we <= 0;
						end
						STR: begin
							alu_op <= 2'b11;
							dm_we <= 1;
						end
						LOD: begin //LOD general load opcode 
							//Part 3: LDX mm == 8 LDA mm == 0
							//Part 4: LDP mm == 9 LDR mm == 1
						
							alu_op <= 2'b11;
							wb_sel = 1;
							dm_we <= 0;
						end
						SWP: begin	
							swap_ctrl <= 1;					
							wb_sel <= 2;

						end
						default: begin
							alu_op <= 2'b11;
							dm_we <= 0;
						
						end
					endcase

				1: begin //mm == 1 for LDR & STR
					case(opcode)
						LOD:begin
						end
						STR:begin
						end
					endcase

				9:begin //mm == 9 for LDP & STP
					case(opcode)
						LOD:begin
						end
						STR:begin
						end
					endcase

				default:begin  //mm == 0 
					case(opcode)
						ALU_OP: begin
							alu_op <= 2'b00;
							dm_we <= 0;
						end
						STR: begin
							alu_op <= 2'b10;
							dm_we <= 1;						
						end
						SWP: begin
							swap_ctrl <= 1;
							wb_sel <= 2;
						end
						LOD: begin
							alu_op <= 2'b10;
							wb_sel = 1;
							dm_we <= 0;						
						end
						default: begin
							alu_op <= 2'b10;
							dm_we <= 0;
						end
	
					endcase
				end

			endcase
		end
/*
			if(mm == am_imm) begin
				
				case(opcode)
					ALU_OP: begin

						alu_op <= 2'b01;
						dm_we <= 0;
					end
					STR: begin
						alu_op <= 2'b11;
						dm_we <= 1;
					end
					LOD: begin //LOD general load opcode 
							//Part 3: LDX mm == 8 LDA mm == 0
							//Part 4: LDP mm == 9 LDR mm == 1
						
						alu_op <= 2'b11;
						wb_sel = 1;
						dm_we <= 0;
					end
					SWP: begin	
						swap_ctrl <= 1;					
						wb_sel <= 2;

					end
					default: begin
						alu_op <= 2'b11;
						dm_we <= 0;
						
					end
				endcase
			end
*/

/*
			else begin // mm == 0
				
				case(opcode)
					ALU_OP: begin
						alu_op <= 2'b00;
						dm_we <= 0;
					end
					STR: begin
						alu_op <= 2'b10;
						dm_we <= 1;						
					end
					SWP: begin
						swap_ctrl <= 1;
						wb_sel <= 2;
					end
					LOD: begin
						alu_op <= 2'b10;
						wb_sel = 1;
						dm_we <= 0;						
					end
					default: begin
						alu_op <= 2'b10;
						dm_we <= 0;
					end
	
				endcase
			end
*/
		end

		mem: begin
			swap_ctrl <= 0;
			case (opcode)
				LOD: begin
					case(mm)
						am_imm:begin //mm == 8
							mux_16_sel <= 1;
						end
						1:begin // mm == 1
						end
						9:begin //mm == 9
						end
						default:begin //mm == 0
							mux_16_sel <= 0;
						end
					endcase
/*
					if(mm == am_imm)begin
						mux_16_sel <= 1;
					end
					else begin
						mux_16_sel <= 0;
					end
*/	
					rf_we <= 1;
				end
				STR: begin
					case(mm)
						am_imm:begin //mm == 8
						end
						1:begin //mm == 1
						end
						9:begin //mm == 9
						end
						default:begin //mm == 0
						end
					endcase
/*
					if(mm == am_imm) begin
						mux_16_sel <= 1;
					end
					else begin
						mux_16_sel <= 0;
					end
*/
					dm_we <= 1;
				end
				SWP: begin
					rf_we = 1;
					//mux4_swap_sel = 1;
					
				end		
			endcase
		end

		writeback: begin //I cant believe you messed this up
			rf_we = 0;
			dm_we <= 0;
			case(opcode) 
				ALU_OP: begin
					rf_we = 1;
				end
				LOD: begin
					rf_we = 1;
				end
				SWP: begin
					wb_sel = 3;
					mux4_swap_sel = 1;
					rf_we = 1;
				end
			endcase 

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