module control_unit (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low

	input [6:0] op,
	input [2:0] funct3,
	input [6:0] funct7,
	input zeroE,

	output reg reg_writeW,
	output reg [1:0] result_srcW,
	output reg mem_writeM,
	output reg [2:0] alu_controlE,
	output reg alu_srcE,
	output reg [1:0] imm_srcD,
	output PC_srcE,
	output [1:0] result_srcE0,
	output reg reg_writeM
);

reg reg_writeD;
reg [1:0] result_srcD;
reg mem_writeD;
reg jumpD;
reg branchD;
reg [2:0] alu_controlD;
reg alu_srcD;

reg reg_writeE;
reg [1:0] result_srcE;
reg mem_writeE;
reg jumpE;
reg branchE;

reg [1:0] result_srcM;

reg [1:0] alu_op;

assign result_srcE0 = result_srcE[0];

always @(op, funct3, funct7) begin
	case (op)
		7'b0000011: begin //lw
			reg_writeD = 1;
			imm_srcD = 2'b00;
			alu_srcD = 1;
			mem_writeD = 0;
			result_srcD = 01;
			alu_op = 2'b00;
			branchD = 0;
			jumpD = 0;

		end
		7'b0100011: begin //sw
			reg_writeD = 0;
			imm_srcD = 2'b01;
			alu_srcD = 1;
			mem_writeD = 1;
			result_srcD = 00;
			alu_op = 2'b00;
			branchD = 0;
			jumpD = 0;

		end
		7'b0110011: begin //R-type
			reg_writeD = 1;
			imm_srcD = 2'b00;
			alu_srcD = 0;
			mem_writeD = 0;
			result_srcD = 00;	
			alu_op = 2'b10;	
			branchD = 0;
			jumpD = 0;	
		end
		7'b1100011: begin //beq
			reg_writeD = 0;
			imm_srcD = 2'b10;
			alu_srcD = 0;
			mem_writeD = 0;
			result_srcD = 00;		
			alu_op = 2'b01;	
			branchD = 1;
			jumpD = 0;

		end

		7'b0010011: begin //I-type ALU
			reg_writeD = 1;
			imm_srcD = 2'b00;
			alu_srcD = 1;
			mem_writeD = 0;
			result_srcD = 2'b00;		
			alu_op = 2'b10;	
			branchD = 0;
			jumpD = 0;

		end

		7'b1101111: begin //jal
			reg_writeD = 1;
			imm_srcD = 2'b11;
			alu_srcD = 0;
			mem_writeD = 0;
			result_srcD = 10;		
			alu_op = 2'b00;	
			branchD = 0;
			jumpD = 1;

		end
		default : begin
			reg_writeD = 0;
			imm_srcD = 2'b00;
			alu_srcD = 0;
			mem_writeD = 0;
			result_srcD = 00;		
			alu_op = 2'b00;
			branchD = 0;
			jumpD = 0;		
		end
	endcase
end

always @(alu_op, funct3, funct7) begin

	case (alu_op)
		2'b00: alu_controlD = 3'b000;
		2'b01: alu_controlD = 3'b001;

		2'b10: begin
			if(~(|funct3)) begin
				if(op[5]&funct7[5]) begin
					alu_controlD = 3'b001;
				end
				else if(op[5]&funct7[0]) begin
					alu_controlD = 3'b110;
				end

				else begin
					alu_controlD = 3'b000;
				end 
			end

			else if(funct3 == 3'b010) begin
				alu_controlD = 3'b101;
			end

			else if(funct3 == 3'b110) begin
				alu_controlD = 3'b011;
			end

			else if(funct3 == 3'b111) begin
				alu_controlD = 3'b010;
			end

			else begin
				alu_controlD = 3'b111;
			end
		end
	
		default : alu_controlD = 3'b111;
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		reg_writeE <= 0;
		result_srcE <= 0;
		mem_writeE <= 0;
		jumpE <= 0;
		branchE <= 0;
		alu_controlE <= 0;
		alu_srcE <= 0;
	end else begin
		reg_writeE <= reg_writeD;
		result_srcE <= result_srcD;
		mem_writeE <= mem_writeD;
		jumpE <= jumpD;
		branchE <= branchD;
		alu_controlE <= alu_controlD;
		alu_srcE <= alu_srcD;
	end
end

assign PC_srcE = (zeroE & branchE) | jumpE;

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		reg_writeM <= 0;
		result_srcM <= 0;
		mem_writeM <= 0;
	end else begin
		reg_writeM <= reg_writeE;
		result_srcM <= result_srcE;
		mem_writeM <= mem_writeE;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		reg_writeW <= 0;
		result_srcW <= 0;
	end else begin
		reg_writeW <= reg_writeM;
		result_srcW <= result_srcM;
	end
end
endmodule 