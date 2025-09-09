module Register_file (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input flushE,
	input [4:0] A1,
	input [4:0] A2,
	input [4:0] A3,
	input [31:0] WD3,
	input WE3,
	input [1:0] imm_srcD,
	input [31:0] PCD,
	input [4:0] RdD,
	input [24:0] imm,
	input [31:0] PC_plus4D,
	input [1:0] forwardAE,
	input [1:0] forwardBE,
	input wire n_for1_4A,
	input wire n_for1_4B,

	output reg [31:0] RD2E,
	output reg [31:0] RD1E,
	output reg [31:0] Rs1E,
	output reg [31:0] Rs2E,
	output reg [31:0] PCE,
	output reg [31:0] RdE,
	output reg [31:0] immExtE,
	output reg [31:0] PC_plus4E
);

wire [31:0] RD1;
wire [31:0] RD2;
reg [31:0] immExtD;


reg [31:0] register_file [0:255];

integer i;

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		for (i = 0; i < 256; i = i + 1) begin
			register_file[i] <= 0;
		end

	end else begin
		if (WE3) begin
			register_file[A3] <= WD3;
		end
	end
end

assign RD1 = (n_for1_4A) ? WD3 : register_file[A1];
assign RD2 = (n_for1_4B) ? WD3 : register_file[A2];

always @(imm_srcD, imm) begin
	case (imm_srcD)
		2'b01: immExtD = {{20{imm[24]}},imm[24:18],imm[4:0]};   //S
		2'b10: immExtD = {{20{imm[24]}},imm[0],imm[23:18],imm[4:1],1'b0};  //B
		2'b00: immExtD = {{20{imm[24]}},imm[24:13]};   //I
		2'b11: immExtD = {{12{imm[24]}},imm[12:5],imm[13],imm[23:14],1'b0};   //J
		default : immExtD = 0;
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		RD1E <= 0;
		RD2E <= 0;
		PCE <= 0;
		RdE <= 0;
		immExtE <= 0;
		PC_plus4E <= 0;
		Rs1E <= 0;
		Rs2E <= 0;
	end else begin
		if(flushE) begin
			RD1E <= 0;
			RD2E <= 0;
			PCE <= 0;
			RdE <= 0;
			immExtE <= 0;
			PC_plus4E <= 0;
			Rs1E <= 0;
			Rs2E <= 0;	
		end
		else begin
			RD1E <= RD1;
			RD2E <= RD2;
			PCE <= PCD;
			RdE <= RdD;
			immExtE <= immExtD;
			PC_plus4E <= PC_plus4D;
			Rs1E <= A1;
			Rs2E <= A2;
		end
	end
end
endmodule