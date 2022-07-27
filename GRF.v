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
module GRF(
	input 			clk,     // 寄存器堆部分实现
	input 			WEnable,
	input 			reset,
	input 	[4:0]	RAddr1,
	input 	[4:0]	RAddr2,
	input 	[4:0]	WAddr,
	input 	[31:0]	WData,
	input 	[31:0]	IAddr,
	output 	[31:0]	RData1,
	output 	[31:0]	RData2
);
    reg [31:0] regs [0:31];   // 32个32位寄存器
	integer i;
    initial begin
	     for(i = 0;i <= 31; i = i + 1) begin
			regs[i]=0;
		 end
		regs[28] = 32'h00001800;  // 全局指针  $gp
		regs[29] = 32'h00000ffc;  // 堆栈指针  $sp
	end
	always @(posedge clk) begin
	    if(reset) begin
		    for( i = 0; i <= 31; i = i + 1) begin
				regs[i] <= 0;
			end
			regs[28] = 32'h00001800;  // 全局指针  $gp
			regs[29] = 32'h00000ffc;  // 堆栈指针  $sp
		end
		else if(WEnable&&WAddr > 0) begin
		    regs[WAddr]<=WData;
			$display("@%h: $%d <= %h", IAddr, WAddr,WData);
		end
	 end
	 assign RData1 = regs[RAddr1];
	 assign RData2 = regs[RAddr2];
endmodule
