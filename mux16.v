// ECE:3350 SISC processor project
// 16-bit mux

`timescale 1ns/100ps

module mux16 (rs_new, rs_in, in_a, in_b, sel, out);

  /*
   *  16-BIT MULTIPLEXER - mux16.v
   *
   *  Inputs:
       - rs_new: Says when a new Rs value is there
   *   - in_a (16 bits): First input to the multiplexer. Chosen when sel = 0.
   *   - in_b (16 bits): Second input to the multiplexer. Chosen when sel = 1.
       - rs_in (16_bits): Rs register into the multiplexer. Chosen when sel = 2;
   *   - sel: Controls which input is seen at the output.
   *
   *  Outputs:
   *   - out: Output from the multiplexer.
   *
   */
  input rs_new;
  input[15:0] rs_in;
  reg[15:0] rs_hold;
  input[15:0] in_a;
  input[15:0] in_b;
  input[1:0]  sel;
  output [15:0] out;

  reg   [15:0] out;

  always @(posedge rs_new)begin
	rs_hold <= rs_in;
	$display(rs_in);
  end
   
  always @ (in_a, in_b, sel)
  begin
    if (sel == 0)
      out <= in_a;
    else if(sel == 1)
      out <= in_b;
    else if(sel == 2)
      out <= rs_hold;
  end

endmodule 
