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
module mips(
	input clk,
	input reset
);
   
    wire [31:0]	IAddr;
	wire [31:0]	next;
	wire [31:0] Instr;
	wire Jump, MemWrite, Branch, RegWrite, zero;
	wire [1:0]	MemtoReg;
	wire [1:0]	RegDst;
	wire [1:0]	ALUSrc;
	wire [1:0]	ExtOp;
	wire [4:0]	ALUCtrl;
	wire [31:0]	SrcA;
	wire [31:0]	SrcB;
	wire [31:0]	RData1;
	wire [31:0]	RData2;
	wire [31:0]	WData;
	wire [31:0]	RData;
	wire [4:0]	RegWAddr;
	wire [31:0]	ALUResult;
	wire [31:0]	Imm;
	wire [31:0]	temp;
	 
	parameter condition = 1'b1;

	assign temp = IAddr + 4;
	assign next = Jump ? (ALUSrc[0] ? { temp[31:28], Instr[25:0], 2'b00} : RData1) : ((Branch && zero) ? temp + Imm : temp);
	assign RegWAddr = RegDst[1] ? 5'd31 : (RegDst[0] ? Instr[15:11] : Instr[20:16]);
	assign SrcA = ALUSrc[1] ? {27'b0, Instr[10:6]} : RData1;
	assign SrcB = ALUSrc[0] ? Imm : RData2;
	assign WData = MemtoReg[1] ? temp : (MemtoReg[0] ? RData : ALUResult);
	 
	PC pc(.clk(clk), .reset(reset), .next(next), .IAddr(IAddr));
	Instr_Memory im(.RAddr(IAddr[11:2]), .RData(Instr));
	Controller controller(.cmd(Instr), .Jump(Jump), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .Branch(Branch), .ALUSrc(ALUSrc), .RegDst(RegDst), .RegWrite(RegWrite), .ExtOp(ExtOp), .ALUCtrl(ALUCtrl));
	GRF grf(.clk(clk), .WEnable(Branch && condition ? ( RegWrite && zero ) : RegWrite), .reset(reset), .RAddr1(Instr[25:21]), .RAddr2(Instr[20:16]), .WAddr(RegWAddr), .WData(WData), .IAddr(IAddr), .RData1(RData1), .RData2(RData2));
	ALU alu(.op1(SrcA), .op2(SrcB), .sel(ALUCtrl), .result(ALUResult), .zero(zero));
	ext extender(.imm(Instr[15:0]), .EOp(ExtOp), .ext(Imm));
	 //Data_Memory dm(clk,MemWrite,reset,ALUResult[11:2],RData2,IAddr,RData);
	DM_8bit DM(.clk(clk), .WE(MemWrite), .reset(reset), .isu(Instr[28]), .MemDst(Instr[27:26]), .Addr(ALUResult[11:0]), .WData(RData2), .IAddr(IAddr), .RData(RData));
endmodule
