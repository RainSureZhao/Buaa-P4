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
	input 			WEnable,  // 寄存器写使能信号
	input 			reset,  // 复位信号
	input 	[4:0]	RAddr1,  // 第一个读出寄存器编号
	input 	[4:0]	RAddr2,  // 第二个读出寄存器编号
	input 	[4:0]	WAddr,  // 写寄存器的编号
	input 	[31:0]	WData,  // 写入寄存器的值
	input 	[31:0]	IAddr,  // 32位当前输入指令的地址
	output 	[31:0]	RData1,  // 第一个寄存器读出的值
	output 	[31:0]	RData2  // 第二个寄存器读出的值
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
		else if(WEnable && WAddr > 0) begin
		    regs[WAddr] <= WData;
			$display("@%h: $%d <= %h", IAddr, WAddr,WData);
		end
	 end
	 assign RData1 = regs[RAddr1];
	 assign RData2 = regs[RAddr2];
endmodule
