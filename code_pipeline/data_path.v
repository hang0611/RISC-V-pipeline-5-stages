module data_path (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low

	input PC_srcE,
	input reg_writeW,
	input [1:0] imm_srcD,
	input [2:0] alu_controlE,
	input alu_srcE,
	input mem_writeM,
	input [1:0] result_srcW,
	input stallF,
	input stallD,
	input flushD,
	input flushE,
	input [1:0] forwardAE,
	input [1:0] forwardBE,
	input wire for1_4A,
	input wire n_for1_4A,
	input wire for1_4B,
	input wire n_for1_4B,

	output zeroE,
	output [4:0] Rs1D,
	output [4:0] Rs2D,
	output [4:0] Rs1E,
	output [4:0] Rs2E,
	output [4:0] RdE,
	output [4:0] RdM,
	output [4:0] RdW,
	output [31:0] instrD,
	output wire [31:0] alu_resultM,
	output wire [31:0] PCD
);

wire[31:0] PC_targetE;
// wire [31:0] PCD;
wire [31:0] PC_plus4D;

wire [31:0] RD2E;
wire [31:0] RD1E;
wire [31:0] PCE;
wire [31:0] immExtE;
wire [31:0] PC_plus4E;
wire [31:0] write_dataM;
wire [31:0] PC_plus4M;

wire [31:0] resultW;

assign Rs1D = instrD[19:15];
assign Rs2D = instrD[24:20];

instr_mem ins_mem(	.clk(clk),
					.rst_n     (rst_n),
					.PC_srcE   (PC_srcE),
					.PC_targetE(PC_targetE),
					.PCD       (PCD),
					.instrD    (instrD),
					.PC_plus4D (PC_plus4D),
					.flushD    (flushD),
					.stallD    (stallD),
					.stallF    (stallF));

Register_file res_file(		.clk(clk),
							.rst_n    (rst_n),
							.A1       (instrD[19:15]),
							.A2       (instrD[24:20]),
							.A3       (RdW),
							.forwardAE(forwardAE),
							.forwardBE(forwardBE),
							.n_for1_4A(n_for1_4A),
							.n_for1_4B(n_for1_4B),
							.WD3      (resultW),
							.PCD      (PCD),
							.PC_plus4D(PC_plus4D),
							.imm_srcD (imm_srcD),
							.PCE      (PCE),
							.RdD      (instrD[11:7]),
							.RdE      (RdE),
							.imm      (instrD[31:7]),
							.RD1E     (RD1E),
							.RD2E     (RD2E),
							.WE3      (reg_writeW),
							.immExtE  (immExtE),
							.PC_plus4E(PC_plus4E),
							.flushE   (flushE),
							.Rs1E     (Rs1E),
							.Rs2E     (Rs2E));

alu alu_excute(		.alu_controlE(alu_controlE),
					.PCE         (PCE),
					.RdE         (RdE),
					.RD2E        (RD2E),
					.RD1E       (RD1E),
					.immExtE     (immExtE),
					.PC_plus4E   (PC_plus4E),
					.for1_4A     (for1_4A),
					.for1_4B     (for1_4B),
					.alu_srcE    (alu_srcE),
					.PC_targetE  (PC_targetE),
					.RdM         (RdM),
					.zeroE       (zeroE),
					.PC_plus4M   (PC_plus4M),
					.alu_resultM (alu_resultM),
					.write_dataM (write_dataM),
					.rst_n       (rst_n),
					.clk         (clk),
					.resultW     (resultW),
					.forwardAE   (forwardAE),
					.forwardBE   (forwardBE));

Data_mem data_mem (	.clk(clk),
					.rst_n      (rst_n),
					.alu_resultM(alu_resultM),
					.write_dataM(write_dataM),
					.RdM        (RdM),
					.PC_plus4M  (PC_plus4M),
					.result_srcW(result_srcW),
					.mem_writeM (mem_writeM),
					.resultW    (resultW),
					.RdW        (RdW));

endmodule