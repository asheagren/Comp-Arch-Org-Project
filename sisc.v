// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f, instruction);

  input clk, rst_f;

  input[31:0] instruction;


// declare all internal wires here
wire[31:0] rsa;
wire[31:0] rsb;
wire[3:0] stat_in;
wire enable;
wire[3:0] stat_out;
wire[31:0] zero_mux_32;
wire zero_mux_4 = 'b0;
wire wb_sel;
wire[31:0] write_data;
wire[3:0] read_regb;
wire rf_we;
wire[1:0] alu_op;
wire[31:0] alu_result;
wire stat_en;
wire[3:0] mux4_out;


// component instantiation goes here
statreg statreg1(clk, stat_in, stat_en, stat_out);
alu alu1(clk, rsa, rsb, instruction[15:0], alu_op, alu_result, stat_in, stat_en);
mux32 mux321(zero_mux_32, alu_result, wb_sel, write_data);
rf rf1(clk, instruction[19:16], mux4_out, instruction[23:20], write_data, rf_we, rsa, rsb);
ctrl ctrl1(clk, rst_f, instruction[31:28], instruction[27:24], stat_out, rf_we, alu_op, wb_sel); 
mux4 mux41(instruction[23:20], instruction[15:12], zero_mux_4, mux4_out);

initial
	/*$monitor($time,,"IR=%h, R0=%h, R1=%h, R2=%h, R3=%h, R4=%h, R5=%h, ALU_OP=%h, WB_SEL=%b, RF_WE=%b, write_data=%b",
instruction, rf1.ram_array[0], rf1.ram_array[1], rf1.ram_array[2], rf1.ram_array[3], rf1.ram_array[4], rf1.ram_array[5], alu_op, wb_sel, rf_we, write_data);*/
$monitor($time,,"R0=%h, R1=%h, R2=%b, R3=%b, R4=%b, R5=%b",
rf1.ram_array[0], rf1.ram_array[1], rf1.ram_array[2], rf1.ram_array[3], rf1.ram_array[4], rf1.ram_array[5]);
endmodule
