# RISC-V-pipeline-5-stages
A standard RISC-V 5-stage pipeline consists of the following steps: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB). Each stage processes a single instruction at a time, allowing multiple instructions to be in different stages of execution simultaneously, which increases overall processor performance and throughput. 
# Hazard
Hazards are classified as data hazards, control hazards, structual hazard.
  - Data hazard - Forwarding: a result from the Memory or Writeback stage to a dependent instruction in the Execute stage. This requires adding multiplexers in front of
the ALU to select its operands from the register file or the Memory or Writeback stage.
  - Control hazard - Stall: the lw instruction does not finish reading data until the end of the Memory stage, so its result cannot be forwarded to the Execute stage of the next instruction (can't use forwarding)
  - Structual hazard: a type of hazard in a computer's instruction pipeline that occurs when two or more instructions simultaneously require the same hardware resource, leading to a conflict and potential pipeline stall
      + In this code, I solve this problem by use 2 multiplexers between register file and execute memory.
        2 multiplexers are controlled by 2 signals in the Hazard unit to register files to choose to get the address value from the instruction mem or from the writeback.
