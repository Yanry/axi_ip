module axi_demux_4E7B0_F61E2 (
	clk_i,
	rst_ni,
	test_i,
	slv_req_i,
	slv_aw_select_i,
	slv_ar_select_i,
	slv_resp_o,
	mst_reqs_o,
	mst_resps_i
);
	parameter [31:0] ar_chan_t_AddrWidth = 0;
	parameter [31:0] ar_chan_t_IdWidth = 0;
	parameter [31:0] ar_chan_t_UserWidth = 0;
	parameter [31:0] aw_chan_t_AddrWidth = 0;
	parameter [31:0] aw_chan_t_IdWidth = 0;
	parameter [31:0] aw_chan_t_UserWidth = 0;
	parameter [31:0] b_chan_t_IdWidth = 0;
	parameter [31:0] b_chan_t_UserWidth = 0;
	parameter [31:0] r_chan_t_DataWidth = 0;
	parameter [31:0] r_chan_t_IdWidth = 0;
	parameter [31:0] r_chan_t_UserWidth = 0;
	parameter [31:0] w_chan_t_DataWidth = 0;
	parameter [31:0] w_chan_t_UserWidth = 0;
	parameter [31:0] AxiIdWidth = 32'd0;
	parameter [0:0] AtopSupport = 1'b1;
	parameter [31:0] NoMstPorts = 32'd0;
	parameter [31:0] MaxTrans = 32'd8;
	parameter [31:0] AxiLookBits = 32'd3;
	parameter [0:0] UniqueIds = 1'b0;
	parameter [0:0] SpillAw = 1'b1;
	parameter [0:0] SpillW = 1'b0;
	parameter [0:0] SpillB = 1'b0;
	parameter [0:0] SpillAr = 1'b1;
	parameter [0:0] SpillR = 1'b0;
	parameter [31:0] SelectWidth = (NoMstPorts > 32'd1 ? $clog2(NoMstPorts) : 32'd1);
	input wire clk_i;
	input wire rst_ni;
	input wire test_i;
	input wire slv_req_i;
	input wire [SelectWidth - 1:0] slv_aw_select_i;
	input wire [SelectWidth - 1:0] slv_ar_select_i;
	output wire slv_resp_o;
	output wire [NoMstPorts - 1:0] mst_reqs_o;
	input wire [NoMstPorts - 1:0] mst_resps_i;
	wire slv_req_cut;
	wire slv_resp_cut;
	wire slv_aw_ready_chan;
	wire slv_aw_ready_sel;
	wire slv_aw_valid_chan;
	wire slv_aw_valid_sel;
	wire slv_ar_ready_chan;
	wire slv_ar_ready_sel;
	wire slv_ar_valid_chan;
	wire slv_ar_valid_sel;
	wire [SelectWidth - 1:0] slv_aw_select;
	wire [SelectWidth - 1:0] slv_ar_select;
	spill_register_0E710_4951B #(
		.T_aw_chan_t_AddrWidth(aw_chan_t_AddrWidth),
		.T_aw_chan_t_IdWidth(aw_chan_t_IdWidth),
		.T_aw_chan_t_UserWidth(aw_chan_t_UserWidth),
		.Bypass(~SpillAw)
	) i_aw_spill_reg(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(slv_req_i.aw_valid),
		.ready_o(slv_aw_ready_chan),
		.data_i(slv_req_i.aw),
		.valid_o(slv_aw_valid_chan),
		.ready_i(slv_resp_cut.aw_ready),
		.data_o(slv_req_cut.aw)
	);
	spill_register_AACFF_CD18F #(
		.T_SelectWidth(SelectWidth),
		.Bypass(~SpillAw)
	) i_aw_select_spill_reg(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(slv_req_i.aw_valid),
		.ready_o(slv_aw_ready_sel),
		.data_i(slv_aw_select_i),
		.valid_o(slv_aw_valid_sel),
		.ready_i(slv_resp_cut.aw_ready),
		.data_o(slv_aw_select)
	);
	assign slv_resp_o.aw_ready = slv_aw_ready_chan & slv_aw_ready_sel;
	assign slv_req_cut.aw_valid = slv_aw_valid_chan & slv_aw_valid_sel;
	spill_register_D780D_04F1E #(
		.T_w_chan_t_DataWidth(w_chan_t_DataWidth),
		.T_w_chan_t_UserWidth(w_chan_t_UserWidth),
		.Bypass(~SpillW)
	) i_w_spill_reg(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(slv_req_i.w_valid),
		.ready_o(slv_resp_o.w_ready),
		.data_i(slv_req_i.w),
		.valid_o(slv_req_cut.w_valid),
		.ready_i(slv_resp_cut.w_ready),
		.data_o(slv_req_cut.w)
	);
	spill_register_58660_A7680 #(
		.T_ar_chan_t_AddrWidth(ar_chan_t_AddrWidth),
		.T_ar_chan_t_IdWidth(ar_chan_t_IdWidth),
		.T_ar_chan_t_UserWidth(ar_chan_t_UserWidth),
		.Bypass(~SpillAr)
	) i_ar_spill_reg(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(slv_req_i.ar_valid),
		.ready_o(slv_ar_ready_chan),
		.data_i(slv_req_i.ar),
		.valid_o(slv_ar_valid_chan),
		.ready_i(slv_resp_cut.ar_ready),
		.data_o(slv_req_cut.ar)
	);
	spill_register_AACFF_CD18F #(
		.T_SelectWidth(SelectWidth),
		.Bypass(~SpillAr)
	) i_ar_sel_spill_reg(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(slv_req_i.ar_valid),
		.ready_o(slv_ar_ready_sel),
		.data_i(slv_ar_select_i),
		.valid_o(slv_ar_valid_sel),
		.ready_i(slv_resp_cut.ar_ready),
		.data_o(slv_ar_select)
	);
	assign slv_resp_o.ar_ready = slv_ar_ready_chan & slv_ar_ready_sel;
	assign slv_req_cut.ar_valid = slv_ar_valid_chan & slv_ar_valid_sel;
	spill_register_E37E1_6F6CF #(
		.T_b_chan_t_IdWidth(b_chan_t_IdWidth),
		.T_b_chan_t_UserWidth(b_chan_t_UserWidth),
		.Bypass(~SpillB)
	) i_b_spill_reg(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(slv_resp_cut.b_valid),
		.ready_o(slv_req_cut.b_ready),
		.data_i(slv_resp_cut.b),
		.valid_o(slv_resp_o.b_valid),
		.ready_i(slv_req_i.b_ready),
		.data_o(slv_resp_o.b)
	);
	spill_register_60618_B07A5 #(
		.T_r_chan_t_DataWidth(r_chan_t_DataWidth),
		.T_r_chan_t_IdWidth(r_chan_t_IdWidth),
		.T_r_chan_t_UserWidth(r_chan_t_UserWidth),
		.Bypass(~SpillR)
	) i_r_spill_reg(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(slv_resp_cut.r_valid),
		.ready_o(slv_req_cut.r_ready),
		.data_i(slv_resp_cut.r),
		.valid_o(slv_resp_o.r_valid),
		.ready_i(slv_req_i.r_ready),
		.data_o(slv_resp_o.r)
	);
	axi_demux_simple_6475F #(
		.AxiIdWidth(AxiIdWidth),
		.AtopSupport(AtopSupport),
		.NoMstPorts(NoMstPorts),
		.MaxTrans(MaxTrans),
		.AxiLookBits(AxiLookBits),
		.UniqueIds(UniqueIds)
	) i_demux_simple(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.test_i(test_i),
		.slv_req_i(slv_req_cut),
		.slv_aw_select_i(slv_aw_select),
		.slv_ar_select_i(slv_ar_select),
		.slv_resp_o(slv_resp_cut),
		.mst_reqs_o(mst_reqs_o),
		.mst_resps_i(mst_resps_i)
	);
endmodule
