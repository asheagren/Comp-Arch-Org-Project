// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f, ir);

  input clk, rst_f;
  input [31:0] ir;

// declare all internal wires here
wire[31:0] rsa;
wire[31:0] rsb;
wire[


// component instantiation goes here
module statreg (clk, in, enable, out);
module alu (clk, rsa, rsb, imm, alu_op, alu_result, stat, stat_en);
module mux32 (in_a, in_b, sel, out);
module rf (clk, read_rega, read_regb, write_reg, write_data, rf_we, rsa, rsb);
module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel);
module mux4 (in_a, in_b, sel, out);

  initial
  
// put a $monitor statement here.  



endmodule


