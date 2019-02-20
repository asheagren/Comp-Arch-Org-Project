// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f, ir);

  input clk, rst_f;
  input [31:0] ir;

// declare all internal wires here
wire[31:0] rsa;
wire[31:0] rsb;
wire[3:0] stat;
wire enable;
wire out;
wire[31:0] alu_result;
wire[1:0] alu_op;
wire[31:0] instruction;
wire zero;
wire wb_sel;
wire[31:0] write_data;
wire[3:0] read_regb;
wire rf_we;
wire rst_f;
wire[1:0] alu_op;
wire sel;


// component instantiation goes here
module statreg (clk, stat, stat_en, out);
module alu (clk, rsa, rsb, instruction[15:0], alu_op, alu_result, stat, stat_en);
module mux32 (zero, alu_result, wb_sel, write_data);
module rf (clk, instruction[19:16], read_regb, instruction[23:20], write_data, rf_we, rsa, rsb);
module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel);
module mux4 (instruction[23:20], instruction[15:12], sel, read_regb);

  initial
  
// put a $monitor statement here.  
$monitor($time,,"RSA=%b, RSB=%b, stat=%b, enable=%b, out=%b, alu_re=%b, alu_op=%b, instruct=%b, zero=%b, wb_sel=%b, write_data=%b, read_regb=%b, rf_we=%b, rst_f=%b, alu_op=%b, sel=%b  ",
rsa,rsb,stat,enable,out,alu_result,alu_op,instruction,zero,wb_sel,write_data,read_regb,rf_we,rst_f,alu_op,sel);

endmodule


