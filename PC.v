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
module PC(
	input 			clk,
	input 			reset,
	input [31:0]	next,
	output reg [31:0] IAddr = 32'h00003000
);
    always @(posedge clk) begin
	    if(reset) begin
			IAddr <= 32'h00003000;  // 起始地址为0x00003000
		end
		else begin
			IAddr <= next;
		end
	 end
endmodule
