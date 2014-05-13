`timescale 1ns/1ns


module testbench();


`include "c_functions.v"


parameter max_vc_number=2;
parameter memory_bank_depth=32;
parameter memory_bank_width=64;


localparam memory_addr_width=clogb(memory_bank_depth);


reg clk;
reg reset;
reg read_enable;
reg write_enable;
reg [0:memory_bank_width-1] flit_in;
reg [0:max_vc_number-1] vc_read_from;
reg [0:max_vc_number-1] vc_written_into;

wire [0:memory_bank_width-1] flit_out;


wire memory_bank_full;
wire memory_bank_empty;


initial
begin
	$display($time,"simulation started.\n");

	clk=0;
	reset=0;

	flit_in=0;
	read_enable=0;
	write_enable=0;
	vc_read_from=0;
	vc_written_into=0;

	#1  reset=1;
	#1  reset=0;
	#1  reset=1;

	#100 $finish;
	$display($time,"simulation finalized.\n");
end


initial
begin
$dumpfile("debug.vcd");
$dumplimit(100000);
$dumpvars;
end


always
	#1 clk=~clk;


always
begin
	#1;
	flit_in={$random}%100;
	vc_read_from={$random}%2;
	vc_written_into={$random}%2;
	read_enable=memory_bank_empty?0:{$random}%5;
	write_enable=memory_bank_full?0:{$random}%5;
end


memory_bank #(
	.max_vc_number(max_vc_number),
	.memory_bank_depth(memory_bank_depth),
	.memory_bank_width(memory_bank_width))
    bank(
	.clk(clk),
	.reset(reset),
	.flit_in(flit_in),
	.vc_written_into(vc_written_into),
	.flit_out(flit_out),
	.vc_read_from(vc_read_from),
	.read_enable(read_enable),
	.write_enable(write_enable),
	.memory_bank_full(memory_bank_full),
	.memory_bank_empty(memory_bank_empty));


endmodule
