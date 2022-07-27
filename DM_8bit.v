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
module DM_8bit(
	input 		clk,  // 时钟信号
	input 		WE,   // 写入使能信号
	input 		reset, // 复位信号(同步复位)
	input 		isu,  // 是否无符号加载
	input [1:0]	MemDst,  // 内存操作类型
	input [11:0] Addr,  // 12位地址
	input [31:0] WData,  // 32位写入数据
	input [31:0] IAddr,  // 32位输入当前指令地址
	output [31:0] RData  // 32位读取数据
);
    reg [7 : 0]   ram [0 : 4095];  // 8 * 4096
	wire [31 : 0]	out1;
	wire [31 : 0]	out2;
	integer i;
	initial begin
	     for(i = 0;i <= 4095;i = i + 1) begin
			ram[i] = 0;
		 end
	end
	 always @(posedge clk) begin
	    if(reset) begin
			for(i = 0;i <= 4095; i = i + 1) begin
				ram[i] = 0;
			end
		end
		else if(WE) begin
			case(MemDst)
				0 : begin
					ram[Addr] = WData[7 : 0]; //sb  存储一个字节 8位
					$display("@%h: *%h <= %h",IAddr, {20'b0, Addr}, {24'b0, WData[7:0]});
				end
				1 : begin
					{ram[Addr + 1], ram[Addr]} = WData[15 : 0]; //sh 存储半字  16位
					$display("@%h: *%h <= %h",IAddr, {20'b0,Addr},{16'b0,WData[15:0]});
				end
				3 : begin
					{ram[Addr + 3], ram[Addr + 2], ram[Addr + 1], ram[Addr]} = WData; //sw 存储字，32位
					$display("@%h: *%h <= %h", IAddr, {20'b0,Addr}, WData);
				end
			endcase
		end
	 end
	 ext extend1({ram[Addr + 1], ram[Addr]}, {1'b0, isu}, out1); //lb,lbu 加载字节 加载无符号字节
	 extbyte extend2(ram[Addr], isu, out2); // lh, lhu  加载半字，加载无符号半字
//	 assign RData = (MemDst == 3) ? {ram[Addr+3], ram[Addr+2], ram[Addr+1], ram[Addr]} : (MemDst[0] ? out1 : out2);
	if (MemDst == 3) begin
		RData = {ram[Addr+3], ram[Addr+2], ram[Addr+1], ram[Addr]};
	end
	else if (MemDst[0]) begin
		RData = out1;
	end
	else if(MemDst[0] == 0) begin
		RData = out2;
	end
endmodule
