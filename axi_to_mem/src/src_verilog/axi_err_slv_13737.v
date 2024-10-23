module axi_err_slv_13737 (
	clk_i,
	rst_ni,
	test_i,
	slv_req_i,
	slv_resp_o
);
	reg _sv2v_0;
	parameter [31:0] AxiIdWidth = 0;
	localparam axi_pkg_RESP_DECERR = 2'b11;
	parameter [1:0] Resp = axi_pkg_RESP_DECERR;
	parameter [31:0] RespWidth = 32'd64;
	parameter [RespWidth - 1:0] RespData = 64'hca11ab1ebadcab1e;
	parameter [0:0] ATOPs = 1'b1;
	parameter [31:0] MaxTrans = 1;
	input wire clk_i;
	input wire rst_ni;
	input wire test_i;
	input wire slv_req_i;
	output wire slv_resp_o;
	wire err_req;
	reg err_resp;
	generate
		if (ATOPs) begin : genblk1
			axi_atop_filter_24B4D #(
				.AxiIdWidth(AxiIdWidth),
				.AxiMaxWriteTxns(MaxTrans)
			) i_atop_filter(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.slv_req_i(slv_req_i),
				.slv_resp_o(slv_resp_o),
				.mst_req_o(err_req),
				.mst_resp_i(err_resp)
			);
		end
		else begin : genblk1
			assign err_req = slv_req_i;
			assign slv_resp_o = err_resp;
		end
	endgenerate
	wire w_fifo_full;
	wire w_fifo_empty;
	wire w_fifo_push;
	reg w_fifo_pop;
	wire [AxiIdWidth - 1:0] w_fifo_data;
	wire b_fifo_full;
	wire b_fifo_empty;
	reg b_fifo_push;
	reg b_fifo_pop;
	wire [AxiIdWidth - 1:0] b_fifo_data;
	wire [AxiIdWidth + 7:0] r_fifo_inp;
	wire r_fifo_full;
	wire r_fifo_empty;
	wire r_fifo_push;
	reg r_fifo_pop;
	wire [AxiIdWidth + 7:0] r_fifo_data;
	reg r_cnt_clear;
	reg r_cnt_en;
	reg r_cnt_load;
	wire [7:0] r_current_beat;
	reg r_busy_d;
	reg r_busy_q;
	reg r_busy_load;
	assign w_fifo_push = err_req.aw_valid & ~w_fifo_full;
	wire [$bits(type(err_resp.aw_ready)):1] sv2v_tmp_5D5D6;
	assign sv2v_tmp_5D5D6 = ~w_fifo_full;
	always @(*) err_resp.aw_ready = sv2v_tmp_5D5D6;
	fifo_v3_F9D8C_B67E5 #(
		.dtype_AxiIdWidth(AxiIdWidth),
		.FALL_THROUGH(1'b1),
		.DEPTH(MaxTrans)
	) i_w_fifo(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(1'b0),
		.testmode_i(test_i),
		.full_o(w_fifo_full),
		.empty_o(w_fifo_empty),
		.usage_o(),
		.data_i(err_req.aw.id),
		.push_i(w_fifo_push),
		.data_o(w_fifo_data),
		.pop_i(w_fifo_pop)
	);
	always @(*) begin : proc_w_channel
		if (_sv2v_0)
			;
		err_resp.w_ready = 1'b0;
		w_fifo_pop = 1'b0;
		b_fifo_push = 1'b0;
		if (!w_fifo_empty && !b_fifo_full) begin
			err_resp.w_ready = 1'b1;
			if (err_req.w_valid && err_req.w.last) begin
				w_fifo_pop = 1'b1;
				b_fifo_push = 1'b1;
			end
		end
	end
	fifo_v3_F9D8C_B67E5 #(
		.dtype_AxiIdWidth(AxiIdWidth),
		.FALL_THROUGH(1'b0),
		.DEPTH($unsigned(2))
	) i_b_fifo(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(1'b0),
		.testmode_i(test_i),
		.full_o(b_fifo_full),
		.empty_o(b_fifo_empty),
		.usage_o(),
		.data_i(w_fifo_data),
		.push_i(b_fifo_push),
		.data_o(b_fifo_data),
		.pop_i(b_fifo_pop)
	);
	always @(*) begin : proc_b_channel
		if (_sv2v_0)
			;
		b_fifo_pop = 1'b0;
		err_resp.b = 1'sb0;
		err_resp.b.id = b_fifo_data;
		err_resp.b.resp = Resp;
		err_resp.b_valid = 1'b0;
		if (!b_fifo_empty) begin
			err_resp.b_valid = 1'b1;
			b_fifo_pop = err_req.b_ready;
		end
	end
	assign r_fifo_push = err_req.ar_valid & ~r_fifo_full;
	wire [$bits(type(err_resp.ar_ready)):1] sv2v_tmp_66A26;
	assign sv2v_tmp_66A26 = ~r_fifo_full;
	always @(*) err_resp.ar_ready = sv2v_tmp_66A26;
	assign r_fifo_inp[AxiIdWidth + 7-:((AxiIdWidth + 7) >= 8 ? AxiIdWidth + 0 : 9 - (AxiIdWidth + 7))] = err_req.ar.id;
	assign r_fifo_inp[7-:8] = err_req.ar.len;
	fifo_v3_0EFFB_75D82 #(
		.dtype_AxiIdWidth(AxiIdWidth),
		.FALL_THROUGH(1'b0),
		.DEPTH(MaxTrans)
	) i_r_fifo(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(1'b0),
		.testmode_i(test_i),
		.full_o(r_fifo_full),
		.empty_o(r_fifo_empty),
		.usage_o(),
		.data_i(r_fifo_inp),
		.push_i(r_fifo_push),
		.data_o(r_fifo_data),
		.pop_i(r_fifo_pop)
	);
	always @(*) begin : proc_r_channel
		if (_sv2v_0)
			;
		r_busy_d = r_busy_q;
		r_busy_load = 1'b0;
		r_fifo_pop = 1'b0;
		r_cnt_clear = 1'b0;
		r_cnt_en = 1'b0;
		r_cnt_load = 1'b0;
		err_resp.r = 1'sb0;
		err_resp.r.id = r_fifo_data[AxiIdWidth + 7-:((AxiIdWidth + 7) >= 8 ? AxiIdWidth + 0 : 9 - (AxiIdWidth + 7))];
		err_resp.r.data = RespData;
		err_resp.r.resp = Resp;
		err_resp.r_valid = 1'b0;
		if (r_busy_q) begin
			err_resp.r_valid = 1'b1;
			err_resp.r.last = r_current_beat == {8 {1'sb0}};
			if (err_req.r_ready) begin
				r_cnt_en = 1'b1;
				if (r_current_beat == {8 {1'sb0}}) begin
					r_busy_d = 1'b0;
					r_busy_load = 1'b1;
					r_cnt_clear = 1'b1;
					r_fifo_pop = 1'b1;
				end
			end
		end
		else if (!r_fifo_empty) begin
			r_busy_d = 1'b1;
			r_busy_load = 1'b1;
			r_cnt_load = 1'b1;
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			r_busy_q <= 1'sb0;
		else if (r_busy_load)
			r_busy_q <= r_busy_d;
	counter #(.WIDTH(8)) i_r_counter(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.clear_i(r_cnt_clear),
		.en_i(r_cnt_en),
		.load_i(r_cnt_load),
		.down_i(1'b1),
		.d_i(r_fifo_data[7-:8]),
		.q_o(r_current_beat),
		.overflow_o()
	);
	localparam axi_pkg_RESP_SLVERR = 2'b10;
	initial _sv2v_0 = 0;
endmodule
