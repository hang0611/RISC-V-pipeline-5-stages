`timescale 1ns/1ps
module testbench();
	 logic clk;
	 logic rst_n;
	 wire [31:0] alu_resultM;
	 logic [31:0] RD2, A;
	 logic mem_writeM;
	 logic [31:0] ins;
	 logic [31:0] PCD;
  reg [31:0] ins_mem [0:255];  // tối đa 256 lệnh
  //integer pc;  // program counter = index dòng
	 // instantiate device to be tested
	 reg [31:0] data_mem [0:255];
	 reg [31:0] register_mem [0:255];

  // initial begin
  //   $readmemh("D:/RISC_V/pipeline/Performance_test/Performance_test/Ex5/golden_mem.txt", data_mem);
  // end

  // initial begin
  //   $readmemh("D:/RISC_V/pipeline/Performance_test/Performance_test/Ex5/golden_rf.txt", register_mem);
  // end  



	 top dut (.clk(clk),
	 					.rst_n(rst_n),
	 					.alu_resultM(alu_resultM),
	 					.PCD        (PCD),
	 					.mem_writeM (mem_writeM));
	 // initialize test
	 initial
	 begin
	 	rst_n <= 0; # 22; rst_n <= 1;
	 end

	 // generate clock to sequence tests
	 always
	 begin
	 	clk <= 1; # 5; clk <= 0; # 5;
	 end


  // Load chương trình từ file
  // initial begin
  //   $readmemh("D:/RISC_V/single_cycle/riscV_test.txt", ins_mem);
  // end

  // // Mỗi chu kỳ đọc 1 lệnh
  // always @(*) begin
  //     ins <= ins_mem[PC/4];
  //     $display("Time=%0t | PC=%0d | ins=%h", $time, PC/4, ins_mem[PC/4]);
  // end

	 // check results EX1
	 // always @(negedge clk)
	 // begin
	 // 	if(mem_writeM) begin
	 // 		if(alu_resultM === 100) begin
	 // 			@(posedge clk);
	 // 			@(negedge clk);
	 // 			$display("Simulation succeeded");
	 // 			$stop;
	 // 		end

	 // 		else if (alu_resultM !== 96) begin
	 // 			$display("Simulation failed");
	 // 			$stop;
	 // 		end
	 // 	end
	 // end

	 always @(negedge clk)
	 begin
	 		if(PCD == 292) begin
	 			@(posedge clk);
	 			@(negedge clk);
	 			$display("Simulation succeeded");
	 			$stop;
	 		end

	 		// else if (alu_resultM !== 96) begin
	 		// 	$display("Simulation failed");
	 		// 	$stop;
	 		// end
	 end
endmodule