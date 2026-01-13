module alu (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low

	input [2:0] alu_controlE,
	input alu_srcE,
	input [31:0] RD1E,
	input [31:0] RD2E,
	input [31:0] PCE,
	input [4:0] RdE,
	input [31:0] immExtE,
	input [31:0] PC_plus4E,
	input [1:0] forwardAE,
	input [1:0] forwardBE,
	input [31:0] resultW,
	input wire for1_4A,
	input wire for1_4B,

	output reg [31:0] alu_resultM,
	output reg [31:0] write_dataM,
	output reg [4:0] RdM,
	output reg [31:0] PC_plus4M,
	output [31:0] PC_targetE,
	output zeroE

);

reg [31:0] SrcAE;
reg [31:0] SrcBE;
reg [31:0] alu_result;
reg [31:0] write_dataE;

localparam ADD = 3'b000;
localparam SUB = 3'b001;
localparam AND =  3'b010;
localparam OR = 3'b011;
localparam SLT = 3'b101;
localparam MUL = 3'b110;

assign PC_targetE = PCE + immExtE;

always @(alu_srcE, write_dataE, immExtE) begin
	if (alu_srcE) begin
		SrcBE = immExtE;
	end

	else begin
		SrcBE = write_dataE;
	end
end

always @(RD2E, immExtE, forwardBE, alu_resultM, resultW, for1_4B) begin
	if (for1_4B) begin
		write_dataE = RD2E;
	end

	else begin
		case (forwardBE)
			2'b00: write_dataE = RD2E;
			2'b01: write_dataE = resultW;
			2'b10: write_dataE = alu_resultM;
			default : write_dataE = 0;
		endcase
	end
end

always @(forwardAE, RD1E, alu_resultM, resultW, for1_4A) begin
	if (for1_4A) begin
		SrcAE = RD1E;
	end

	else begin
		case (forwardAE)
			2'b00: SrcAE = RD1E;
			2'b01: SrcAE = resultW;
			2'b10: SrcAE = alu_resultM;
			default : SrcAE = 0;	
		endcase
	end
end

always @(alu_controlE, SrcAE, SrcBE) begin
	case (alu_controlE)
		ADD: alu_result = SrcAE + SrcBE;
		SUB: alu_result = SrcAE - SrcBE;
		AND: alu_result = SrcAE & SrcBE;
		OR: alu_result = SrcAE | SrcBE;
		SLT: alu_result = (SrcAE < SrcBE)?1:0;
		MUL: alu_result = SrcAE * SrcBE;

		default : alu_result = 1;
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		alu_resultM <= 0;
		write_dataM <= 0;
		RdM <= 0;
		PC_plus4M <= 0;
	end else begin
		alu_resultM <= alu_result;
		write_dataM <= write_dataE;
		RdM <= RdE;
		PC_plus4M <= PC_plus4E;
	end
end

assign zeroE = (alu_result)?0:1;
endmodule