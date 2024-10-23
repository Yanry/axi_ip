module axi_burst_splitter_counters (
	clk_i,
	rst_ni,
	alloc_id_i,
	alloc_len_i,
	alloc_req_i,
	alloc_gnt_o,
	cnt_id_i,
	cnt_len_o,
	cnt_set_err_i,
	cnt_err_o,
	cnt_dec_i,
	cnt_req_i,
	cnt_gnt_o
);
	reg _sv2v_0;
	parameter [31:0] MaxTxns = 0;
	parameter [0:0] FullBW = 0;
	parameter [31:0] IdWidth = 0;
	input wire clk_i;
	input wire rst_ni;
	input wire [IdWidth - 1:0] alloc_id_i;
	input wire [7:0] alloc_len_i;
	input wire alloc_req_i;
	output wire alloc_gnt_o;
	input wire [IdWidth - 1:0] cnt_id_i;
	output wire [7:0] cnt_len_o;
	input wire cnt_set_err_i;
	output reg cnt_err_o;
	input wire cnt_dec_i;
	input wire cnt_req_i;
	output wire cnt_gnt_o;
	localparam [31:0] CntIdxWidth = (MaxTxns > 1 ? $clog2(MaxTxns) : 32'd1);
	reg [MaxTxns - 1:0] cnt_dec;
	wire [MaxTxns - 1:0] cnt_free;
	reg [MaxTxns - 1:0] cnt_set;
	reg [MaxTxns - 1:0] err_d;
	reg [MaxTxns - 1:0] err_q;
	wire [8:0] cnt_inp;
	wire [(MaxTxns * 9) - 1:0] cnt_oup;
	wire [CntIdxWidth - 1:0] cnt_free_idx;
	wire [CntIdxWidth - 1:0] cnt_r_idx;
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < MaxTxns; _gv_i_1 = _gv_i_1 + 1) begin : gen_cnt
			localparam i = _gv_i_1;
			counter #(.WIDTH(9)) i_cnt(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.clear_i(1'b0),
				.en_i(cnt_dec[i]),
				.load_i(cnt_set[i]),
				.down_i(1'b1),
				.d_i(cnt_inp),
				.q_o(cnt_oup[i * 9+:9]),
				.overflow_o()
			);
			assign cnt_free[i] = cnt_oup[i * 9+:9] == {9 {1'sb0}};
		end
	endgenerate
	assign cnt_inp = {1'b0, alloc_len_i} + 1;
	lzc #(
		.WIDTH(MaxTxns),
		.MODE(1'b0)
	) i_lzc(
		.in_i(cnt_free),
		.cnt_o(cnt_free_idx),
		.empty_o()
	);
	wire idq_inp_req;
	wire idq_inp_gnt;
	wire idq_oup_gnt;
	wire idq_oup_valid;
	wire idq_oup_pop;
	localparam [31:0] sv2v_uu_i_idq_data_t_CntIdxWidth = CntIdxWidth;
	localparam [sv2v_uu_i_idq_data_t_CntIdxWidth - 1:0] sv2v_uu_i_idq_ext_exists_data_i_0 = 1'sb0;
	localparam [sv2v_uu_i_idq_data_t_CntIdxWidth - 1:0] sv2v_uu_i_idq_ext_exists_mask_i_0 = 1'sb0;
	id_queue_17CB4_38A7A #(
		.data_t_CntIdxWidth(CntIdxWidth),
		.ID_WIDTH(IdWidth),
		.CAPACITY(MaxTxns),
		.FULL_BW(FullBW)
	) i_idq(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.inp_id_i(alloc_id_i),
		.inp_data_i(cnt_free_idx),
		.inp_req_i(idq_inp_req),
		.inp_gnt_o(idq_inp_gnt),
		.exists_data_i(sv2v_uu_i_idq_ext_exists_data_i_0),
		.exists_mask_i(sv2v_uu_i_idq_ext_exists_mask_i_0),
		.exists_req_i(1'b0),
		.exists_o(),
		.exists_gnt_o(),
		.oup_id_i(cnt_id_i),
		.oup_pop_i(idq_oup_pop),
		.oup_req_i(cnt_req_i),
		.oup_data_o(cnt_r_idx),
		.oup_data_valid_o(idq_oup_valid),
		.oup_gnt_o(idq_oup_gnt)
	);
	assign idq_inp_req = alloc_req_i & alloc_gnt_o;
	assign alloc_gnt_o = idq_inp_gnt & |cnt_free;
	assign cnt_gnt_o = idq_oup_gnt & idq_oup_valid;
	wire [8:0] read_len;
	assign read_len = cnt_oup[cnt_r_idx * 9+:9] - 1;
	assign cnt_len_o = read_len[7:0];
	assign idq_oup_pop = ((cnt_req_i & cnt_gnt_o) & cnt_dec_i) & (cnt_len_o == 8'd0);
	always @(*) begin
		if (_sv2v_0)
			;
		cnt_dec = 1'sb0;
		cnt_dec[cnt_r_idx] = (cnt_req_i & cnt_gnt_o) & cnt_dec_i;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		cnt_set = 1'sb0;
		cnt_set[cnt_free_idx] = alloc_req_i & alloc_gnt_o;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		err_d = err_q;
		cnt_err_o = err_q[cnt_r_idx];
		if ((cnt_req_i && cnt_gnt_o) && cnt_set_err_i) begin
			err_d[cnt_r_idx] = 1'b1;
			cnt_err_o = 1'b1;
		end
		if (alloc_req_i && alloc_gnt_o)
			err_d[cnt_free_idx] = 1'b0;
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			err_q <= 1'sb0;
		else
			err_q <= err_d;
	initial _sv2v_0 = 0;
endmodule
