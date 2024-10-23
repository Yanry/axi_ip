module spill_register_E37E1_6F6CF (
	clk_i,
	rst_ni,
	valid_i,
	ready_o,
	data_i,
	valid_o,
	ready_i,
	data_o
);
	parameter [31:0] T_b_chan_t_IdWidth = 0;
	parameter [31:0] T_b_chan_t_UserWidth = 0;
	parameter [0:0] Bypass = 1'b0;
	input wire clk_i;
	input wire rst_ni;
	input wire valid_i;
	output wire ready_o;
	input wire [((T_b_chan_t_IdWidth + 2) + T_b_chan_t_UserWidth) - 1:0] data_i;
	output wire valid_o;
	input wire ready_i;
	output wire [((T_b_chan_t_IdWidth + 2) + T_b_chan_t_UserWidth) - 1:0] data_o;
	spill_register_flushable_82112_0F811 #(
		.T_T_b_chan_t_IdWidth(T_b_chan_t_IdWidth),
		.T_T_b_chan_t_UserWidth(T_b_chan_t_UserWidth),
		.Bypass(Bypass)
	) spill_register_flushable_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(valid_i),
		.flush_i(1'b0),
		.ready_o(ready_o),
		.data_i(data_i),
		.valid_o(valid_o),
		.ready_i(ready_i),
		.data_o(data_o)
	);
endmodule
