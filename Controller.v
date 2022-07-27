`timescale 1ns / 1ns
`define bits 13
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
module Controller(
	input [31:0] cmd,  // 当前指令
	output Jump,   // 跳转信号
	output [1:0]MemtoReg,  // 读内存信号
	output MemWrite,  // 内存写使能信号
	output Branch,  // 分支信号
	output [1:0]ALUSrc,  // ALU操作数2的来源，0 : 寄存器；1 : 立即数
	output [1:0]ExtOp,  // 位扩展方式
	output [4:0]ALUCtrl, // ALU控制信号
	output [1:0]RegDst,  // 寄存器写地址选择，0 : cmd[20 : 17], 1 : cmd[15 : 11]
	output RegWrite  // 寄存器写使能信号
);
    //{ext,RegWrite,[1:0]MemtoReg,[1:0]ALUSrc,Branch,MemWrite,[1:0]RegSrc,Jump,[4:0]ALUCtrl,hilo,}
	 reg [16:0] control_signals;
	 always @(cmd) begin
	     if(cmd == 0) control_signals = 0; // nop操作
	     else case(cmd[31 : 26])  // 根据Opcode段进行判断指令
		    0 : case( cmd [5:0])  // Opcode为0时，根据功能码进行判断
				    0 : begin 
						control_signals = 17'b00_1_01_10_00_00_0_01010; 	//sll
					end
					2 : begin 
						control_signals = 17'b00_1_01_10_00_00_0_01000;	//srl
					end
					3 : begin 
						control_signals = 17'b00_1_01_10_00_00_0_01001;	//sra
					end
					4 : begin 
						 control_signals = 17'b00_1_01_00_00_00_0_01010;	//sllv
					end
					6 : begin  
					 	control_signals = 17'b00_1_01_00_00_00_0_01000;	//srlv
					end
					7 : begin
						control_signals = 17'b00_1_01_00_00_00_0_01001;	//srav
					end
					8 : begin
						control_signals = 17'b00_0_00_00_00_00_1_00000;	//jr
					end
					9 : begin
						control_signals = 17'b00_1_01_00_00_10_1_00000;	//jalr
					end
					32 : begin
						control_signals = 17'b00_1_01_00_00_00_0_00010; //add
					end
					33 : begin
						control_signals = 17'b00_1_01_00_00_00_0_00010; //addu
					end
					34 : begin
						control_signals = 17'b00_1_01_00_00_00_0_00011; //sub
					end
					35 : begin
						control_signals = 17'b00_1_01_00_00_00_0_00011; //subu
					end
					36 : begin
						control_signals = 17'b00_1_01_00_00_00_0_00100; //and
					end
					37 : begin
						control_signals = 17'b00_1_01_00_00_00_0_00101; //or
					end
					38 : begin
						control_signals = 17'b00_1_01_00_00_00_0_00110; //xor
					end
					39 : begin
						control_signals = 17'b00_1_01_00_00_00_0_00111; //nor
					end
					42 : begin
						control_signals = 17'b00_1_01_00_00_00_0_01100; //slt
					end
					43 : begin
						control_signals = 17'b00_1_01_00_00_00_0_01101; //sltu
					end
				endcase
				1 : begin
					case( cmd[20 : 16])  // 在Opcode位置为1的时候，根据rt位置进行判断
						0 : begin
							control_signals = 17'b11_0_00_00_10_00_0_00000; // bltz
						end
						1 : begin
							control_signals = 17'b11_0_00_00_10_00_0_00001; // bgez
						end
						17 : begin
							control_signals = 17'b11_1_10_00_10_10_0_00001; // bgezal
						end
					endcase
				end
				//{[1:0]ext,RegWrite,[1:0]RegDst,[1:0]ALUSrc,Branch,MemWrite,[1:0]RegSrc,Jump,[4:0]ALUCtrl}
				2 : begin
					control_signals=17'b00_0_00_01_00_00_1_00000; //j
				end
				3 : begin
					control_signals=17'b00_1_10_01_00_10_1_00000; //jal
				end
				4 : begin
					control_signals=17'b11_0_00_00_10_00_0_00110; //beq
				end
				5 : begin
					control_signals=17'b11_0_00_00_10_00_0_01011; //bne
				end
				6 : begin
					control_signals=17'b11_0_00_00_10_00_0_01110; //blez
				end
				7 : begin
					control_signals=17'b11_0_00_00_10_00_0_01111; //bgtz
				end
				8 : begin
					control_signals=17'b00_1_00_01_00_00_0_00010;//addi
				end
				9 : begin
					control_signals=17'b00_1_00_01_00_00_0_00010;//addiu
				end
				10 : begin
					control_signals=17'b00_1_00_01_00_00_0_01100;//slti//
				end
				11 : begin
					control_signals=17'b00_1_00_01_00_00_0_01101;//sltiu
				end
				12 : begin
					control_signals=17'b01_1_00_01_00_00_0_00100;//andi
				end
				13 : begin
					control_signals=17'b01_1_00_01_00_00_0_00101;//ori
				end
				14 : begin
					control_signals=17'b01_1_00_01_00_00_0_00110;//xori
				end
				15 : begin
					control_signals=17'b10_1_00_01_00_00_0_00101;//lui
				end
				//16:
				32 : begin
					control_signals=17'b00_1_00_01_00_01_0_00010;//lb
				end
				33 : begin
					control_signals=17'b00_1_00_01_00_01_0_00010;//lh
				end
				35 : begin
					control_signals=17'b00_1_00_01_00_01_0_00010;//lw
				end
				36 : begin
					control_signals=17'b00_1_00_01_00_01_0_00010;//lbu
				end
				37 : begin
					control_signals=17'b00_1_00_01_00_01_0_00010;//lhu
				end
				40 : begin
					control_signals=17'b00_0_00_01_01_00_0_00010;//sb
				end
				41 : begin
					control_signals=17'b00_0_00_01_01_00_0_00010;//sh
				end
				43 : begin
					control_signals=17'b00_0_00_01_01_00_0_00010;//sw
				end
		endcase
	 end
	 assign {ExtOp, RegWrite, RegDst, ALUSrc, Branch, MemWrite, RegSrc, Jump, ALUCtrl } = control_signals;
endmodule
