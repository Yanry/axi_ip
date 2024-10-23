module axi_to_axi_lite_id_reflect_8F333 (
	clk_i,
	rst_ni,
	test_i,
	slv_req_i,
	slv_resp_o,
	mst_req_o,
	mst_resp_i
);
	parameter [31:0] AxiIdWidth = 32'd0;
	parameter [31:0] AxiMaxWriteTxns = 32'd0;
	parameter [31:0] AxiMaxReadTxns = 32'd0;
	parameter [0:0] FallThrough = 1'b1;
	input wire clk_i;
	input wire rst_ni;
	input wire test_i;
	input wire slv_req_i;
	output wire slv_resp_o;
	output wire mst_req_o;
	input wire mst_resp_i;
	wire aw_full;
	wire aw_empty;
	wire aw_push;
	wire aw_pop;
	wire ar_full;
	wire ar_empty;
	wire ar_push;
	wire ar_pop;
	wire [AxiIdWidth - 1:0] aw_reflect_id;
	wire [AxiIdWidth - 1:0] ar_reflect_id;
	assign slv_resp_o = '{
		aw_ready: mst_resp_i.aw_ready & ~aw_full,
		w_ready: mst_resp_i.w_ready,
		b: '{
			id: aw_reflect_id,
			resp: mst_resp_i.b.resp,
			default: 1'sb0
		},
		b_valid: mst_resp_i.b_valid & ~aw_empty,
		ar_ready: mst_resp_i.ar_ready & ~ar_full,
		r: '{
			id: ar_reflect_id,
			data: mst_resp_i.r.data,
			resp: mst_resp_i.r.resp,
			last: 1'b1,
			default: 1'sb0
		},
		r_valid: mst_resp_i.r_valid & ~ar_empty,
		default: 1'sb0
	};
	assign aw_push = mst_req_o.aw_valid & slv_resp_o.aw_ready;
	assign aw_pop = slv_resp_o.b_valid & mst_req_o.b_ready;
	fifo_v3_F9D8C_B67E5 #(
		.dtype_AxiIdWidth(AxiIdWidth),
		.FALL_THROUGH(FallThrough),
		.DEPTH(AxiMaxWriteTxns)
	) i_aw_id_fifo(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(1'b0),
		.testmode_i(test_i),
		.full_o(aw_full),
		.empty_o(aw_empty),
		.usage_o(),
		.data_i(slv_req_i.aw.id),
		.push_i(aw_push),
		.data_o(aw_reflect_id),
		.pop_i(aw_pop)
	);
	assign ar_push = mst_req_o.ar_valid & slv_resp_o.ar_ready;
	assign ar_pop = slv_resp_o.r_valid & mst_req_o.r_ready;
	fifo_v3_F9D8C_B67E5 #(
		.dtype_AxiIdWidth(AxiIdWidth),
		.FALL_THROUGH(FallThrough),
		.DEPTH(AxiMaxReadTxns)
	) i_ar_id_fifo(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(1'b0),
		.testmode_i(test_i),
		.full_o(ar_full),
		.empty_o(ar_empty),
		.usage_o(),
		.data_i(slv_req_i.ar.id),
		.push_i(ar_push),
		.data_o(ar_reflect_id),
		.pop_i(ar_pop)
	);
	assign mst_req_o = '{
		aw: '{
			addr: slv_req_i.aw.addr,
			prot: slv_req_i.aw.prot
		},
		aw_valid: slv_req_i.aw_valid & ~aw_full,
		w: '{
			data: slv_req_i.w.data,
			strb: slv_req_i.w.strb
		},
		w_valid: slv_req_i.w_valid,
		b_ready: slv_req_i.b_ready & ~aw_empty,
		ar: '{
			addr: slv_req_i.ar.addr,
			prot: slv_req_i.ar.prot
		},
		ar_valid: slv_req_i.ar_valid & ~ar_full,
		r_ready: slv_req_i.r_ready & ~ar_empty,
		default: 1'sb0
	};
endmodule
