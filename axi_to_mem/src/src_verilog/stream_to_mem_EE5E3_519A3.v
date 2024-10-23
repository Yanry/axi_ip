module stream_to_mem_EE5E3_519A3 (
	clk_i,
	rst_ni,
	req_i,
	req_valid_i,
	req_ready_o,
	resp_o,
	resp_valid_o,
	resp_ready_i,
	mem_req_o,
	mem_req_valid_o,
	mem_req_ready_i,
	mem_resp_i,
	mem_resp_valid_i
);
	parameter [31:0] mem_req_t_AddrWidth = 0;
	parameter [31:0] mem_req_t_DataWidth = 0;
	parameter [31:0] mem_req_t_IdWidth = 0;
	parameter [31:0] mem_req_t_UserWidth = 0;
	parameter [31:0] mem_resp_t_DataWidth = 0;
	parameter [31:0] mem_resp_t_NumBanks = 0;
	reg _sv2v_0;
	parameter [31:0] BufDepth = 32'd1;
	input wire clk_i;
	input wire rst_ni;
	input wire [((((((mem_req_t_AddrWidth + 7) + (mem_req_t_DataWidth / 8)) + mem_req_t_DataWidth) + 1) + mem_req_t_IdWidth) + mem_req_t_UserWidth) + 14:0] req_i;
	input wire req_valid_i;
	output wire req_ready_o;
	output wire [((mem_resp_t_DataWidth + mem_resp_t_NumBanks) + mem_resp_t_NumBanks) - 1:0] resp_o;
	output wire resp_valid_o;
	input wire resp_ready_i;
	output wire [((((((mem_req_t_AddrWidth + 7) + (mem_req_t_DataWidth / 8)) + mem_req_t_DataWidth) + 1) + mem_req_t_IdWidth) + mem_req_t_UserWidth) + 14:0] mem_req_o;
	output wire mem_req_valid_o;
	input wire mem_req_ready_i;
	input wire [((mem_resp_t_DataWidth + mem_resp_t_NumBanks) + mem_resp_t_NumBanks) - 1:0] mem_resp_i;
	input wire mem_resp_valid_i;
	reg [$clog2(BufDepth + 1):0] cnt_d;
	reg [$clog2(BufDepth + 1):0] cnt_q;
	wire buf_ready;
	wire req_ready;
	generate
		if (BufDepth > 0) begin : gen_buf
			always @(*) begin
				if (_sv2v_0)
					;
				cnt_d = cnt_q;
				if (req_valid_i && req_ready_o)
					cnt_d = cnt_d + 1;
				if (resp_valid_o && resp_ready_i)
					cnt_d = cnt_d - 1;
			end
			assign req_ready = (cnt_q < BufDepth) | (resp_valid_o & resp_ready_i);
			assign req_ready_o = mem_req_ready_i & req_ready;
			assign mem_req_valid_o = req_valid_i & req_ready;
			stream_fifo_32829_838AE #(
				.T_mem_resp_t_DataWidth(mem_resp_t_DataWidth),
				.T_mem_resp_t_NumBanks(mem_resp_t_NumBanks),
				.FALL_THROUGH(1'b1),
				.DEPTH(BufDepth)
			) i_resp_buf(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.flush_i(1'b0),
				.testmode_i(1'b0),
				.data_i(mem_resp_i),
				.valid_i(mem_resp_valid_i),
				.ready_o(buf_ready),
				.data_o(resp_o),
				.valid_o(resp_valid_o),
				.ready_i(resp_ready_i),
				.usage_o()
			);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					cnt_q <= 1'sb0;
				else
					cnt_q <= cnt_d;
		end
		else begin : gen_no_buf
			assign mem_req_valid_o = req_valid_i;
			assign resp_valid_o = (mem_req_valid_o & mem_req_ready_i) & mem_resp_valid_i;
			assign req_ready_o = resp_ready_i & resp_valid_o;
			assign resp_o = mem_resp_i;
		end
	endgenerate
	assign mem_req_o = req_i;
	initial _sv2v_0 = 0;
endmodule
