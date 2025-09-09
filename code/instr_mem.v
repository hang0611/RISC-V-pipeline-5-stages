module instr_mem (
	input clk,    // Clock
	input stallF,
	input stallD,
	input flushD,
	input rst_n,  // Asynchronous reset active low
	
	input PC_srcE,
	input [31:0] PC_targetE,

	output reg [31:0] instrD,
	output reg [31:0] PCD,
	output reg [31:0] PC_plus4D
);

reg [31:0] RD;
reg [31:0] PC_counter;
wire [31:0] PC_plus4F;
reg [31:0] ins_mem [0:4095];

  initial begin
    $readmemh("D:/RISC_V/pipeline/Performance_test/Performance_test/Ex5/machine_code.txt", ins_mem);
  end

  // Mỗi chu kỳ đọc 1 lệnh
  always @(*) begin
      RD = ins_mem[PC_counter >> 2];
  end

  always @(posedge clk or negedge rst_n) begin 
  	if(~rst_n) begin
  		PC_counter <= 0;
  	end else begin
  		if(stallF) begin
  			PC_counter <= PC_counter;
  		end
  		else begin
  			if(PC_srcE) begin
  				PC_counter <= PC_targetE;
  			end 
  			else begin
  				PC_counter <= PC_plus4F;
  			end
  		end
  	end
  end

assign PC_plus4F = PC_counter + 4;

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		instrD <= 0;
		PCD <= 0;
		PC_plus4D <= 0;
	end else begin

		if(stallD) begin
			instrD <= instrD;
			PCD <= PCD;
			PC_plus4D <= PC_plus4D;
		end
		else begin
			if(flushD) begin
				instrD <= 0;
				PCD <= 0;
				PC_plus4D <= 0;	
			end
			else begin
				instrD <= RD;
				PCD <= PC_counter;
				PC_plus4D <= PC_plus4F;				
			end
		end
	end
end
endmodule