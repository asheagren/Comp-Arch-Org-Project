// ECE:3350 SISC processor project
// data memory

`timescale 1ns/100ps

module dm (read_addr, write_addr, write_data, dm_we, read_data);

  /*
   *  DATA MEMORY UNIT - dm.v
   *
   *  Inputs:
   *   - read_addr (16 bits): Memory address to be read from.
   *   - write_addr (16 bits): Memory address to be written to.
   *   - write_data (32 bits): Word to be written to memory.
   *   - dm_we: Control line that, when set to 1, causes input write_data to
   *        be saved to the memory address specified by write_addr.
   *
   *  Outputs:
   *   - read_data (32 bits): Word stored in memory location read_addr. Note
   *       that if the address specified is not within the range explicitly
   *       assigned values in the datamemory.data file, this will return
   *       xxxxxxxx, not 0x00000000.
   *
   */

  input  [15:0] read_addr;
  input  [15:0] write_addr;
  input  [31:0] write_data;
  input  dm_we;
  output [31:0] read_data;
  
  reg    [31:0] ram_array [65532:0];
  reg    [31:0] read_data;
 
  // load data
  initial begin : prog_load
    $readmemh("datamemory.data",ram_array);
  end

  // read process is sensitive to read address.
  // address is [15:0] because ram_array word addressable, not 
  // byte addressable.
  always @(read_addr, dm_we)
  begin

	$display("mem       ram_array[8] = ", ram_array[8]);
	$display("mem       ram_array[9] = ", ram_array[9]);
	
	
    read_data <= ram_array[read_addr];
//$display(read_data);
  end
  
  // write process is sensitive to write enable
  always @(negedge dm_we)
  begin
	$display("writeback ram_array[read_addr] = ", ram_array[read_addr]);
	$display("writeback  read_addr = ", read_addr);
	$display("writeback  write_data = ", write_data);
  	ram_array[write_addr] <= write_data;
  end
  
endmodule
