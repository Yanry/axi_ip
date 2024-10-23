module axi_to_axi_lite (
	clk_i,
	rst_ni,
	test_i,
	slv_req_i,
	slv_resp_o,
	mst_req_o,
	mst_resp_i
);
	parameter [31:0] AxiAddrWidth = 32'd0;
	parameter [31:0] AxiDataWidth = 32'd0;
	parameter [31:0] AxiIdWidth = 32'd0;
	parameter [31:0] AxiUserWidth = 32'd0;
	parameter [31:0] AxiMaxWriteTxns = 32'd0;
	parameter [31:0] AxiMaxReadTxns = 32'd0;
	parameter [0:0] FullBW = 0;
	parameter [0:0] FallThrough = 1'b1;
	input wire clk_i;
	input wire rst_ni;
	input wire test_i;
	input wire slv_req_i;
	output wire slv_resp_o;
	output wire mst_req_o;
	input wire mst_resp_i;
	wire filtered_req;
	wire splitted_req;
	wire filtered_resp;
	wire splitted_resp;
	axi_atop_filter_24B4D #(
		.AxiIdWidth(AxiIdWidth),
		.AxiMaxWriteTxns(AxiMaxWriteTxns)
	) i_axi_atop_filter(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.slv_req_i(slv_req_i),
		.slv_resp_o(slv_resp_o),
		.mst_req_o(filtered_req),
		.mst_resp_i(filtered_resp)
	);
	axi_burst_splitter_A0B31 #(
		.MaxReadTxns(AxiMaxReadTxns),
		.MaxWriteTxns(AxiMaxWriteTxns),
		.FullBW(FullBW),
		.AddrWidth(AxiAddrWidth),
		.DataWidth(AxiDataWidth),
		.IdWidth(AxiIdWidth),
		.UserWidth(AxiUserWidth)
	) i_axi_burst_splitter(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.slv_req_i(filtered_req),
		.slv_resp_o(filtered_resp),
		.mst_req_o(splitted_req),
		.mst_resp_i(splitted_resp)
	);
	axi_to_axi_lite_id_reflect_8F333 #(
		.AxiIdWidth(AxiIdWidth),
		.AxiMaxWriteTxns(AxiMaxWriteTxns),
		.AxiMaxReadTxns(AxiMaxReadTxns),
		.FallThrough(FallThrough)
	) i_axi_to_axi_lite_id_reflect(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.test_i(test_i),
		.slv_req_i(splitted_req),
		.slv_resp_o(splitted_resp),
		.mst_req_o(mst_req_o),
		.mst_resp_i(mst_resp_i)
	);
endmodule
