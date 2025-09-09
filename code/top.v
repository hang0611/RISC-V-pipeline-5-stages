module top (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	output wire [31:0] alu_resultM,
	output wire mem_writeM,
	output wire [31:0] PCD
	// input [31:0] instrD,
	
	// output [31:0] PCD,
	// output [31:0] resultW
);

wire PC_srcE;
wire reg_writeW;
wire [1:0] imm_srcD;
wire [2:0] alu_controlE;
wire alu_srcE;
wire [1:0] result_srcW;
wire zeroE;
wire [31:0] instrD;
wire [4:0] Rs1D;
wire [4:0] Rs2D;
wire [4:0] Rs1E;
wire [4:0] Rs2E;
wire [4:0] RdM;
wire [4:0] RdE;
wire [4:0] RdW;
wire reg_writeM;
wire [1:0] result_srcE;
wire [1:0] forwardAE;
wire [1:0] forwardBE;
wire stallF;
wire stallD;
wire flushE;
wire flushD;
wire result_srcE0;
wire for1_4A;
wire n_for1_4A;
wire for1_4B;
wire n_for1_4B;


data_path path (	.clk		 (clk),
					.rst_n       (rst_n),
					.instrD      (instrD),
					.reg_writeW  (reg_writeW),
					.PC_srcE     (PC_srcE),
					.imm_srcD    (imm_srcD),
					.zeroE       (zeroE),
					.alu_srcE    (alu_srcE),
					.mem_writeM  (mem_writeM),
					.result_srcW (result_srcW),
					.alu_controlE(alu_controlE),
					.RdE         (RdE),
					.Rs1D        (Rs1D),
					.Rs2D        (Rs2D),
					.flushD      (flushD),
					.flushE      (flushE),
					.stallD      (stallD),
					.stallF      (stallF),
					.forwardAE   (forwardAE),
					.forwardBE   (forwardBE),
					.for1_4A     (for1_4A),
					.for1_4B     (for1_4B),
					.n_for1_4A   (n_for1_4A),
					.n_for1_4B   (n_for1_4B),
					.RdM         (RdM),
					.RdW         (RdW),
					.Rs1E        (Rs1E),
					.Rs2E        (Rs2E),
					.PCD         (PCD),
					.alu_resultM (alu_resultM));

control_unit ctrl (	.op			 (instrD[6:0]),
					.funct3      (instrD[14:12]),
					.funct7      (instrD[31:25]),
					.zeroE       (zeroE),
					.reg_writeW  (reg_writeW),
					.PC_srcE     (PC_srcE),
					.imm_srcD    (imm_srcD),
					.alu_srcE    (alu_srcE),
					.mem_writeM  (mem_writeM),
					.result_srcW (result_srcW),
					.alu_controlE(alu_controlE),
					.clk         (clk),
					.rst_n       (rst_n),
					.reg_writeM  (reg_writeM),
					.result_srcE0(result_srcE0));

hazard_unit hazard(	.clk         (clk),
					.rst_n       (rst_n),
					.PC_srcE(PC_srcE),
					.reg_writeW (reg_writeW),
					.RdE        (RdE),
					.Rs1D       (Rs1D),
					.Rs2D       (Rs2D),
					.flushD     (flushD),
					.flushE     (flushE),
					.stallD     (stallD),
					.stallF     (stallF),
					.forwardAE  (forwardAE),
					.forwardBE  (forwardBE),
					.RdM        (RdM),
					.RdW        (RdW),
					.reg_writeM (reg_writeM),
					.Rs1E       (Rs1E),
					.Rs2E       (Rs2E),
					.result_srcE0(result_srcE0),
					.for1_4A     (for1_4A),
					.for1_4B     (for1_4B),
					.n_for1_4A   (n_for1_4A),
					.n_for1_4B   (n_for1_4B));
endmodule 
