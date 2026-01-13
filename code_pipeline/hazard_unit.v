module hazard_unit (
	input clk,
	input rst_n,
	input [4:0] Rs1D,
	input [4:0] Rs2D,	
	input [4:0] Rs1E,
	input [4:0] Rs2E,
	input [4:0] RdM,
	input [4:0] RdE,
	input [4:0] RdW,
	input reg_writeW,
	input reg_writeM,
	input result_srcE0,
	input PC_srcE,

	output reg [1:0] forwardAE,
	output reg [1:0] forwardBE,
	output reg for1_4B,
	output reg n_for1_4A,
	output reg for1_4A,
	output reg n_for1_4B,
	output stallF,
	output stallD,
	output flushE,
	output flushD
);

wire lwStall;

assign lwStall = result_srcE0 & ((Rs1D == RdE) | (Rs2D == RdE));
assign stallF = lwStall;
assign stallD = lwStall;
assign flushE = lwStall | PC_srcE;
assign flushD = PC_srcE;

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		for1_4A <= 0;
		for1_4B <= 0;

	end else begin
		for1_4A <= n_for1_4A;
		for1_4B <= n_for1_4B;
	end
end

always @(Rs1E, RdM, reg_writeM, RdW, reg_writeW, Rs1D) begin
	if(((Rs1D == RdW) && reg_writeW) && (Rs1D)) begin
		n_for1_4A = 1;
	end

	else begin
		n_for1_4A = 0;
	end

	if(((Rs1E == RdM) && reg_writeM) && (Rs1E)) begin
		forwardAE = 2'b10;
	end
	else if(((Rs1E == RdW) && reg_writeW) && (Rs1E)) begin
		forwardAE = 2'b01;
	end

	// else if(((Rs1D == RdW) && reg_writeW) && (Rs1D)) begin
	// 	forwardAE = 2'b11;
	// end

	else begin
		forwardAE = 2'b00;
	end
end

always @(Rs2E, RdM, reg_writeM, RdW, reg_writeW, Rs2D) begin
	if(((Rs2D == RdW) && reg_writeW) && (Rs2D)) begin
		n_for1_4B = 1;
	end

	else begin
		n_for1_4B = 0;
	end

	if(((Rs2E == RdM) && reg_writeM) && (Rs2E)) begin
		forwardBE = 2'b10;
	end
	else if(((Rs2E == RdW) && reg_writeW) && (Rs2E)) begin
		forwardBE = 2'b01;
	end

	// else if(((Rs2D == RdW) && reg_writeW) && (Rs2D)) begin
	// 	forwardBE = 2'b11;
	// end

	else begin
		forwardBE = 2'b00;
	end
end

endmodule