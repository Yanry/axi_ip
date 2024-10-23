module stream_fifo_75E84_6CEC6 (
	clk_i,
	rst_ni,
	flush_i,
	testmode_i,
	usage_o,
	data_i,
	valid_i,
	ready_o,
	data_o,
	valid_o,
	ready_i
);
	parameter [31:0] T_AddrWidth = 0;
	parameter [31:0] T_DataWidth = 0;
	parameter [31:0] T_IdWidth = 0;
	parameter [31:0] T_UserWidth = 0;
	parameter [0:0] FALL_THROUGH = 1'b0;
	parameter [31:0] DATA_WIDTH = 32;
	parameter [31:0] DEPTH = 8;
	parameter [31:0] ADDR_DEPTH = (DEPTH > 1 ? $clog2(DEPTH) : 1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire testmode_i;
	output wire [ADDR_DEPTH - 1:0] usage_o;
	input wire [(((((T_AddrWidth + 7) + (T_DataWidth / 8)) + T_IdWidth) + 9) + T_UserWidth) + 10:0] data_i;
	input wire valid_i;
	output wire ready_o;
	output wire [(((((T_AddrWidth + 7) + (T_DataWidth / 8)) + T_IdWidth) + 9) + T_UserWidth) + 10:0] data_o;
	output wire valid_o;
	input wire ready_i;
	wire push;
	wire pop;
	wire empty;
	wire full;
	assign push = valid_i & ~full;
	assign pop = ready_i & ~empty;
	assign ready_o = ~full;
	assign valid_o = ~empty;
	fifo_v3_25BB5_2766A #(
		.dtype_T_AddrWidth(T_AddrWidth),
		.dtype_T_DataWidth(T_DataWidth),
		.dtype_T_IdWidth(T_IdWidth),
		.dtype_T_UserWidth(T_UserWidth),
		.FALL_THROUGH(FALL_THROUGH),
		.DATA_WIDTH(DATA_WIDTH),
		.DEPTH(DEPTH)
	) fifo_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(flush_i),
		.testmode_i(testmode_i),
		.full_o(full),
		.empty_o(empty),
		.usage_o(usage_o),
		.data_i(data_i),
		.push_i(push),
		.data_o(data_o),
		.pop_i(pop)
	);
endmodule
