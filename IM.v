`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:53:02 07/27/2022 
// Design Name: 
// Module Name:    test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Instr_Memory(
	input [9:0]		RAddr,
	output [31:0]	RData
);
    reg [31:0] rom[0 : 1023];
	integer i;
	initial begin
	    for(i = 0; i < 1024; i = i + 1) begin
			rom[i] = 0;
		end
		$readmemh("code.txt", rom, 0);
	end
	assign RData = rom[RAddr];
endmodule
