// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f, instruction);

  input clk, rst_f;
input instruction; 
  wire[31:0] instruction;


// declare all internal wires here
wire[31:0] rsa;
wire[31:0] rsb;
wire[3:0] cc;
wire enable;
wire[3:0] stat_out;
wire[31:0] zero_mux_32 = 32'h00000000;
wire zero_mux_4 = 4'b0000;
wire[1:0] wb_sel;
wire[31:0] write_data;
wire[3:0] read_regb;
wire rf_we;
wire[1:0] alu_op;
wire[31:0] alu_result;
wire stat_en;
wire[3:0] mux4_out;
wire rb_sel;
wire[15:0] pc;
wire[15:0] br;
wire ir;
wire[15:0] im;
wire pc_sel;
wire pc_write;
wire pc_rst;
wire[15:0] pc_out;
wire ir_load;
wire[31:0] instr_in;
wire br_sel;
wire[15:0] br_out;
wire[15:0] mux_16_out;
wire dm_we;
wire[31:0] read_data;
wire[1:0] mux_16_sel;
wire mux_16_in_a;
wire mux_16_in_b;
wire[31:0] swap_a;
wire[31:0] swap_b;
wire swap_sel;
wire[3:0] mux4_swap_out;
wire swap_ctrl;
wire rs_new;
// component instantiation goes here

//in_a, in_b, sel--could be rb_sel, out
mux4 mux41(.in_a(instruction[15:12]),.in_b(instruction[23:20]), .sel(rb_sel), .out(mux4_out));

mux4 mux4_swap(.in_a(instruction[23:20]), .in_b(instruction[19:16]), .sel(swap_sel), .out(mux4_swap_out));

//clk, read_rega, read_regb, write_reg, write_data, rf_we, rsa, rsb
rf rf1(.clk(clk), .read_rega(instruction[19:16]), .read_regb(mux4_out), .write_reg(mux4_swap_out), .write_data(write_data), .rf_we(rf_we), .rsa(rsa), .rsb(rsb));

//clk, rsa, rsb, imm, alu_op, alu_result, stat, stat_en
alu alu1(clk, rsa, rsb, instruction[15:0], alu_op, alu_result, cc, stat_en);

//in_a, in_b, sel, out
mux32 mux321(swap_ctrl, alu_result, read_data, rsa, rsb, wb_sel, write_data);

//clk, in, stat_en, out
statreg statreg1(.clk(clk), .in(cc), .stat_en(stat_en), .out(stat_out));

//clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel, rd_sel
ctrl ctrl1(clk, rst_f, instruction[31:28], instruction[27:24], stat_out, rf_we, alu_op, wb_sel,rb_sel, pc_sel, pc_write, pc_rst, ir_load, br_sel, mux_16_sel, dm_we, swap_sel, swap_ctrl,rs_new); 

pc pc1(clk, br_out[15:0], pc_sel, pc_write, pc_rst, pc_out[15:0]);

im im1(pc_out[15:0], instr_in[31:0]);

ir ir1(clk, ir_load, instr_in[31:0], instruction[31:0]);

br br1(pc_out[15:0], instruction[15:0], br_sel, br_out[15:0]);

dm dm1(mux_16_out, mux_16_out, rsb, dm_we, read_data);

mux16 mux161(.rs_new(rs_new),.rs_in(rsa[15:0]),.in_a(instruction[15:0]), .in_b(alu_result[15:0]), .sel(mux_16_sel), .out(mux_16_out));



initial


/*Good one $monitor($time,,"IR=%h, pc=%h, R0=%h, R1=%h, R2=%h, R3=%h, R4=%h, R5=%h, ALU_OP=%h, WB_SEL=%b, RF_WE=%b,RD_SEL=%b, pc_sel=%h, br_sel=%h, pc_write=%b, write_data=%h",
instruction, pc_out, rf1.ram_array[0], rf1.ram_array[1], rf1.ram_array[2], rf1.ram_array[3], rf1.ram_array[4], rf1.ram_array[5], alu_op, wb_sel, rf_we,rb_sel, pc_sel, br_sel, pc_write, write_data);
//$monitor("pc_sel=%b, pc_write=%b,ir_load=%b, pc_out=%b, br_sel= %b, imm=%h, stat_reg=%b, instruction=%h",pc_sel,pc_write,ir_load,pc_out[15:0],br_sel, instruction[15:0], stat_out, instruction); */


/*Debug stat*/	/*$monitor("STAT=%b", stat_out);*/

/*Debug registers */	$monitor("IR=%h, PC=%H, R0=%h, R1=%h, R2=%h, R3=%h, R4=%h, R5=%h, R6=%h, R7=%h, R8=%h, R9=%h",
instruction, pc_out, rf1.ram_array[0], rf1.ram_array[1], rf1.ram_array[2], rf1.ram_array[3], rf1.ram_array[4], rf1.ram_array[5], rf1.ram_array[6], rf1.ram_array[7],rf1.ram_array[8],rf1.ram_array[9]);

/*$monitor($time,,"R0=%h, R1=%h, R2=%b, R3=%b, R4=%b, R5=%b",
rf1.ram_array[0], rf1.ram_array[1], rf1.ram_array[2], rf1.ram_array[3], rf1.ram_array[4], rf1.ram_array[5]);*/


endmodule
