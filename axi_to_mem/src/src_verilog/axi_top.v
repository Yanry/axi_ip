module axi_top (
	clk_i,
	rst_ni,
	mem_req_i,
	mem_addr_i,
	mem_we_i,
	mem_wdata_i,
	mem_be_i,
	mem_rsp_valid_o,
	mem_rsp_rdata_o,
	mem_rsp_error_o,
	busy_o,
	mem_req_o,
	mem_addr_o,
	mem_wdata_o,
	mem_strb_o,
	mem_atop_o,
	mem_lock_o,
	mem_we_o,
	mem_id_o,
	mem_user_o,
	mem_cache_o,
	mem_prot_o,
	mem_qos_o,
	mem_region_o,
	mem_rvalid_i,
	mem_rdata_i,
	mem_err_i,
	mem_exokay_i
);
	parameter [31:0] MemAddrWidth = 32'd0;
	parameter [31:0] AxiAddrWidth = 32'd0;
	parameter [31:0] DataWidth = 32'd0;
	parameter [31:0] MaxRequests = 32'd1;
	parameter [2:0] AxiProt = 3'b000;
	parameter [31:0] IdWidth = 1;
	parameter [31:0] UserWidth = 1;
	parameter [31:0] NumBanks = 1;
	parameter [31:0] BufDepth = 1;
	parameter [0:0] HideStrb = 1'b0;
	parameter [31:0] OutFifoDepth = 1;
	input wire clk_i;
	input wire rst_ni;
	input wire mem_req_i;
	input wire [MemAddrWidth - 1:0] mem_addr_i;
	input wire mem_we_i;
	input wire [DataWidth - 1:0] mem_wdata_i;
	input wire [(DataWidth / 8) - 1:0] mem_be_i;
	output wire mem_rsp_valid_o;
	output wire [DataWidth - 1:0] mem_rsp_rdata_o;
	output wire mem_rsp_error_o;
	output wire busy_o;
	output wire [NumBanks - 1:0] mem_req_o;
	output wire [(NumBanks * MemAddrWidth) - 1:0] mem_addr_o;
	output wire [(NumBanks * (DataWidth / NumBanks)) - 1:0] mem_wdata_o;
	output wire [(NumBanks * ((DataWidth / NumBanks) / 8)) - 1:0] mem_strb_o;
	output wire [(NumBanks * 6) - 1:0] mem_atop_o;
	output wire [NumBanks - 1:0] mem_lock_o;
	output wire [NumBanks - 1:0] mem_we_o;
	output wire [(NumBanks * IdWidth) - 1:0] mem_id_o;
	output wire [(NumBanks * UserWidth) - 1:0] mem_user_o;
	output wire [(NumBanks * 4) - 1:0] mem_cache_o;
	output wire [(NumBanks * 3) - 1:0] mem_prot_o;
	output wire [(NumBanks * 4) - 1:0] mem_qos_o;
	output wire [(NumBanks * 4) - 1:0] mem_region_o;
	input wire [NumBanks - 1:0] mem_rvalid_i;
	input wire [(NumBanks * (DataWidth / NumBanks)) - 1:0] mem_rdata_i;
	input wire [NumBanks - 1:0] mem_err_i;
	input wire [NumBanks - 1:0] mem_exokay_i;
	wire [((((((AxiAddrWidth + 2) >= 0 ? AxiAddrWidth + 3 : 1 - (AxiAddrWidth + 2)) + 1) + (DataWidth + (DataWidth / 8))) + 2) + ((AxiAddrWidth + 2) >= 0 ? AxiAddrWidth + 3 : 1 - (AxiAddrWidth + 2))) + 1:0] axi_lite_req;
	wire [(6 + ((DataWidth + 1) >= 0 ? DataWidth + 2 : 1 - (DataWidth + 1))) + 0:0] axi_lite_rsp;
	wire mem_gnt;
	axi_lite_from_mem_30327_27473 #(
		.axi_req_t_AxiAddrWidth(AxiAddrWidth),
		.axi_req_t_DataWidth(DataWidth),
		.axi_rsp_t_DataWidth(DataWidth),
		.MemAddrWidth(MemAddrWidth),
		.AxiAddrWidth(AxiAddrWidth),
		.DataWidth(DataWidth),
		.MaxRequests(MaxRequests),
		.AxiProt(AxiProt)
	) i_axi_lite_from_mem(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.mem_req_i(mem_req_i),
		.mem_addr_i(mem_addr_i),
		.mem_we_i(mem_we_i),
		.mem_wdata_i(mem_wdata_i),
		.mem_be_i(mem_be_i),
		.mem_gnt_o(mem_gnt),
		.mem_rsp_valid_o(mem_rsp_valid_o),
		.mem_rsp_rdata_o(mem_rsp_rdata_o),
		.mem_rsp_error_o(mem_rsp_error_o),
		.axi_req_o(axi_lite_req),
		.axi_rsp_i(axi_lite_rsp)
	);
	wire [(((((((IdWidth + MemAddrWidth) + 35) + UserWidth) + 1) + (((DataWidth + (DataWidth / 8)) + 1) + UserWidth)) + 2) + (((IdWidth + MemAddrWidth) + 29) + UserWidth)) + 1:0] axi_req;
	wire [(((((((IdWidth + MemAddrWidth) + 35) + UserWidth) + 1) + (((DataWidth + (DataWidth / 8)) + 1) + UserWidth)) + 2) + (((IdWidth + MemAddrWidth) + 29) + UserWidth)) + 1:0] axi_fifo_req;
	wire [(((4 + ((IdWidth + 2) + UserWidth)) + 1) + (((IdWidth + DataWidth) + 3) + UserWidth)) - 1:0] axi_rsp;
	wire [(((4 + ((IdWidth + 2) + UserWidth)) + 1) + (((IdWidth + DataWidth) + 3) + UserWidth)) - 1:0] axi_fifo_rsp;
	axi_lite_to_axi_8ECFC_E9A0E #(
		.axi_req_t_DataWidth(DataWidth),
		.axi_req_t_IdWidth(IdWidth),
		.axi_req_t_MemAddrWidth(MemAddrWidth),
		.axi_req_t_UserWidth(UserWidth),
		.axi_resp_t_DataWidth(DataWidth),
		.axi_resp_t_IdWidth(IdWidth),
		.axi_resp_t_UserWidth(UserWidth),
		.req_lite_t_AxiAddrWidth(AxiAddrWidth),
		.req_lite_t_DataWidth(DataWidth),
		.resp_lite_t_DataWidth(DataWidth),
		.AxiDataWidth(DataWidth)
	) i_axi_lite_to_axi(
		.slv_req_lite_i(axi_lite_req),
		.slv_resp_lite_o(axi_lite_rsp),
		.slv_aw_cache_i(4'b0000),
		.slv_ar_cache_i(4'b0000),
		.mst_req_o(axi_req),
		.mst_resp_i(axi_rsp)
	);
	axi_fifo_2DE1F_D0182 #(
		.ar_chan_t_IdWidth(IdWidth),
		.ar_chan_t_MemAddrWidth(MemAddrWidth),
		.ar_chan_t_UserWidth(UserWidth),
		.aw_chan_t_IdWidth(IdWidth),
		.aw_chan_t_MemAddrWidth(MemAddrWidth),
		.aw_chan_t_UserWidth(UserWidth),
		.axi_req_t_DataWidth(DataWidth),
		.axi_req_t_IdWidth(IdWidth),
		.axi_req_t_MemAddrWidth(MemAddrWidth),
		.axi_req_t_UserWidth(UserWidth),
		.axi_resp_t_DataWidth(DataWidth),
		.axi_resp_t_IdWidth(IdWidth),
		.axi_resp_t_UserWidth(UserWidth),
		.b_chan_t_IdWidth(IdWidth),
		.b_chan_t_UserWidth(UserWidth),
		.r_chan_t_DataWidth(DataWidth),
		.r_chan_t_IdWidth(IdWidth),
		.r_chan_t_UserWidth(UserWidth),
		.w_chan_t_DataWidth(DataWidth),
		.w_chan_t_UserWidth(UserWidth),
		.Depth(32'd0),
		.FallThrough(1'b0)
	) i_axi_fifo(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.test_i(1'b0),
		.slv_req_i(axi_req),
		.slv_resp_o(axi_rsp),
		.mst_req_o(axi_fifo_req),
		.mst_resp_i(axi_fifo_rsp)
	);
	axi_to_mem_737B9_590B0 #(
		.axi_req_t_DataWidth(DataWidth),
		.axi_req_t_IdWidth(IdWidth),
		.axi_req_t_MemAddrWidth(MemAddrWidth),
		.axi_req_t_UserWidth(UserWidth),
		.axi_resp_t_DataWidth(DataWidth),
		.axi_resp_t_IdWidth(IdWidth),
		.axi_resp_t_UserWidth(UserWidth),
		.AddrWidth(MemAddrWidth),
		.DataWidth(DataWidth),
		.IdWidth(IdWidth),
		.NumBanks(NumBanks),
		.BufDepth(BufDepth),
		.HideStrb(HideStrb),
		.OutFifoDepth(OutFifoDepth)
	) i_axi_to_mem(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.busy_o(busy_o),
		.axi_req_i(axi_fifo_req),
		.axi_resp_o(axi_fifo_rsp),
		.mem_req_o(mem_req_o),
		.mem_gnt_i(mem_gnt),
		.mem_addr_o(mem_addr_o),
		.mem_wdata_o(mem_wdata_o),
		.mem_strb_o(mem_strb_o),
		.mem_atop_o(mem_atop_o),
		.mem_we_o(mem_we_o),
		.mem_rvalid_i(mem_rvalid_i),
		.mem_rdata_i(mem_rdata_i)
	);
endmodule
