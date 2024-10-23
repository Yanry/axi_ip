module stream_join (
	inp_valid_i,
	inp_ready_o,
	oup_valid_o,
	oup_ready_i
);
	parameter [31:0] N_INP = 32'd0;
	input wire [N_INP - 1:0] inp_valid_i;
	output wire [N_INP - 1:0] inp_ready_o;
	output wire oup_valid_o;
	input wire oup_ready_i;
	stream_join_dynamic #(.N_INP(N_INP)) i_stream_join_dynamic(
		.inp_valid_i(inp_valid_i),
		.inp_ready_o(inp_ready_o),
		.sel_i({N_INP {1'b1}}),
		.oup_valid_o(oup_valid_o),
		.oup_ready_i(oup_ready_i)
	);
endmodule
