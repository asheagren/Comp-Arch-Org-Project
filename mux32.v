// ECE:3350 SISC processor project
// 32-bit mux

`timescale 1ns/100ps

module mux32 (in_a, in_b, swap_a, swap_b, sel, out);

  /*
   *  32-BIT MULTIPLEXER - mux32.v
   *
   *  Inputs:
   *   - in_a (32 bits): First input to multiplexer. Selected when sel = 0.
   *   - in_b (32 bits): Second input. Selected when sel = 1.
   *   - sel: Selects which input propagates to output.
   *
   *  Outputs:
   *   - out (32 bits): Multiplexer output.
   *
   */

  input  [31:0] in_a;
  input  [31:0] in_b;
  input  [31:0] swap_a;
  input  [31:0] swap_b;
  input  [1:0]  sel;
  output [31:0] out;

  reg   [31:0] outreg;
   
  always @ (in_a, in_b, swap_a, swap_b, sel)
  begin
    case (sel)
	0: begin
		outreg = in_a;
	end
	1: begin
		outreg = in_b;
	end
	2: begin
		outreg = swap_a;
	end
	3: begin
		outreg = swap_b;
	end
    endcase
  end

  assign out = outreg;

endmodule
