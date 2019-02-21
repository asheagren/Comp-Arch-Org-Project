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
output[31:0] instruction;
wire zero;
wire wb_sel;
wire[31:0] write_data;
output[3:0] read_regb;
wire rf_we;
wire rst_f;
wire[1:0] alu_op;
output sel;


// component instantiation goes here
statreg statreg1(clk, stat, stat_en, out);
 alu alu1(clk, rsa, rsb, instruction[15:0], alu_op, alu_result, stat, stat_en);
 mux32 mux321(zero, alu_result, wb_sel, write_data);
 rf rf1(clk, instruction[19:16], read_regb, instruction[23:20], write_data, rf_we, rsa, rsb);
 ctrl ctrl1(clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel);
 mux4 mux41(instruction[23:20], instruction[15:12], sel, read_regb);



endmodule