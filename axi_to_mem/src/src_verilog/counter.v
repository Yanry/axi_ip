module counter (
	clk_i,
	rst_ni,
	clear_i,
	en_i,
	load_i,
	down_i,
	d_i,
	q_o,
	overflow_o
);
	parameter [31:0] WIDTH = 4;
	parameter [0:0] STICKY_OVERFLOW = 1'b0;
	input wire clk_i;
	input wire rst_ni;
	input wire clear_i;
	input wire en_i;
	input wire load_i;
	input wire down_i;
	input wire [WIDTH - 1:0] d_i;
	output wire [WIDTH - 1:0] q_o;
	output wire overflow_o;
	delta_counter #(
		.WIDTH(WIDTH),
		.STICKY_OVERFLOW(STICKY_OVERFLOW)
	) i_counter(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.clear_i(clear_i),
		.en_i(en_i),
		.load_i(load_i),
		.down_i(down_i),
		.delta_i({{WIDTH - 1 {1'b0}}, 1'b1}),
		.d_i(d_i),
		.q_o(q_o),
		.overflow_o(overflow_o)
	);
endmodule
