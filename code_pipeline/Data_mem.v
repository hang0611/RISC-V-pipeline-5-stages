module Data_mem (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	
	input [31:0] alu_resultM,
	input [31:0] write_dataM,
	input [4:0] RdM,
	input [31:0] PC_plus4M,
	input mem_writeM,
	input [1:0] result_srcW,

	output reg [31:0] resultW,
	output reg [4:0] RdW
);

reg [31:0] data_mem [0:4095];
reg [31:0] read_dataW;
reg [31:0] alu_resultW;
reg [31:0] PC_plus4W;
wire [31:0] RD;

integer i;

assign RD = data_mem[alu_resultM];

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		for (i = 0; i < 4096; i = i + 1) begin
			data_mem[i] <= 0;
		end
	end else begin
		if(mem_writeM) begin
			data_mem[alu_resultM] <= write_dataM;
		end
	end
end

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		alu_resultW <= 0;
		read_dataW <= 0;
		RdW <= 0;
		PC_plus4W <= 0;
	end else begin
		alu_resultW <= alu_resultM;
		read_dataW <= RD;
		RdW <= RdM;
		PC_plus4W <= PC_plus4M;
	end
end

always @(result_srcW, alu_resultW, read_dataW, PC_plus4W) begin
	case (result_srcW)
		2'b00: resultW = alu_resultW;
		2'b01: resultW = read_dataW;
		2'b10: resultW = PC_plus4W;
	
		default : resultW = 0;
	endcase
end

endmodule 