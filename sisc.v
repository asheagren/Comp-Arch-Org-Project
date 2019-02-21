// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f, instruction);

  input clk, rst_f;

  input[31:0] instruction;


// declare all internal wires here
wire[31:0] rsa;
wire[31:0] rsb;
wire[3:0] stat;
wire enable;
wire out;

wire[1:0] alu_op;

wire zero;
wire wb_sel;
wire[31:0] write_data;

wire rf_we;
wire rst_f;



wire zero;
wire wb_sel;
wire[31:0] write_data;
wire[3:0] read_regb;
wire rf_we;
wire[1:0] alu_op;
wire sel;

wire stat_en;


// component instantiation goes here
statreg statreg1(clk, stat, stat_en, out);
 alu alu1(clk, rsa, rsb, alu_instruction, alu_op, alu_result, stat, stat_en);
 mux32 mux321(zero, alu_result, wb_sel, write_data);
 rf rf1(clk, rf_instruction1, read_regb, rf_mux4_instruction, write_data, rf_we, rsa, rsb);
 ctrl ctrl1(clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel);
 mux4 mux41(rf_mux4_instruction, mux4_instruction, sel, read_regb);

initial

	$monitor($time,,"RSA=%b, RSB=%b, stat=%b, enable=%b, out=%b, alu_re=%b, alu_op=%b, instruct=%b, zero=%b, wb_sel=%b, write_data=%b, read_regb=%b, rf_we=%b, rst_f=%b, alu_op=%b, sel=%b  ", rsa,rsb,stat,enable,out,alu_result,alu_op,instruction,zero,wb_sel,write_data,read_regb,rf_we,rst_f,alu_op,sel);
endmodule
