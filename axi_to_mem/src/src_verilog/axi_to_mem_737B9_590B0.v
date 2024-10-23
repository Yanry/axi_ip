module axi_to_mem_737B9_590B0 (
	clk_i,
	rst_ni,
	busy_o,
	axi_req_i,
	axi_resp_o,
	mem_req_o,
	mem_gnt_i,
	mem_addr_o,
	mem_wdata_o,
	mem_strb_o,
	mem_atop_o,
	mem_we_o,
	mem_rvalid_i,
	mem_rdata_i
);
	parameter [31:0] axi_req_t_DataWidth = 0;
	parameter [31:0] axi_req_t_IdWidth = 0;
	parameter [31:0] axi_req_t_MemAddrWidth = 0;
	parameter [31:0] axi_req_t_UserWidth = 0;
	parameter [31:0] axi_resp_t_DataWidth = 0;
	parameter [31:0] axi_resp_t_IdWidth = 0;
	parameter [31:0] axi_resp_t_UserWidth = 0;
	parameter [31:0] AddrWidth = 0;
	parameter [31:0] DataWidth = 0;
	parameter [31:0] IdWidth = 0;
	parameter [31:0] NumBanks = 0;
	parameter [31:0] BufDepth = 1;
	parameter [0:0] HideStrb = 1'b0;
	parameter [31:0] OutFifoDepth = 1;
	input wire clk_i;
	input wire rst_ni;
	output wire busy_o;
	input wire [(((((((axi_req_t_IdWidth + axi_req_t_MemAddrWidth) + 35) + axi_req_t_UserWidth) + 1) + (((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + 1) + axi_req_t_UserWidth)) + 2) + (((axi_req_t_IdWidth + axi_req_t_MemAddrWidth) + 29) + axi_req_t_UserWidth)) + 1:0] axi_req_i;
	output wire [(((4 + ((axi_resp_t_IdWidth + 2) + axi_resp_t_UserWidth)) + 1) + (((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth)) - 1:0] axi_resp_o;
	output wire [NumBanks - 1:0] mem_req_o;
	input wire [NumBanks - 1:0] mem_gnt_i;
	output wire [(NumBanks * AddrWidth) - 1:0] mem_addr_o;
	output wire [(NumBanks * (DataWidth / NumBanks)) - 1:0] mem_wdata_o;
	output wire [(NumBanks * ((DataWidth / NumBanks) / 8)) - 1:0] mem_strb_o;
	output wire [(NumBanks * 6) - 1:0] mem_atop_o;
	output wire [NumBanks - 1:0] mem_we_o;
	input wire [NumBanks - 1:0] mem_rvalid_i;
	input wire [(NumBanks * (DataWidth / NumBanks)) - 1:0] mem_rdata_i;
	localparam [31:0] sv2v_uu_i_axi_to_detailed_mem_NumBanks = NumBanks;
	localparam [sv2v_uu_i_axi_to_detailed_mem_NumBanks - 1:0] sv2v_uu_i_axi_to_detailed_mem_ext_mem_err_i_0 = 1'sb0;
	localparam [sv2v_uu_i_axi_to_detailed_mem_NumBanks - 1:0] sv2v_uu_i_axi_to_detailed_mem_ext_mem_exokay_i_0 = 1'sb0;
	axi_to_detailed_mem_D1006_BB619 #(
		.axi_req_t_axi_req_t_DataWidth(axi_req_t_DataWidth),
		.axi_req_t_axi_req_t_IdWidth(axi_req_t_IdWidth),
		.axi_req_t_axi_req_t_MemAddrWidth(axi_req_t_MemAddrWidth),
		.axi_req_t_axi_req_t_UserWidth(axi_req_t_UserWidth),
		.axi_resp_t_axi_resp_t_DataWidth(axi_resp_t_DataWidth),
		.axi_resp_t_axi_resp_t_IdWidth(axi_resp_t_IdWidth),
		.axi_resp_t_axi_resp_t_UserWidth(axi_resp_t_UserWidth),
		.AddrWidth(AddrWidth),
		.DataWidth(DataWidth),
		.IdWidth(IdWidth),
		.UserWidth(1),
		.NumBanks(NumBanks),
		.BufDepth(BufDepth),
		.HideStrb(HideStrb),
		.OutFifoDepth(OutFifoDepth)
	) i_axi_to_detailed_mem(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.busy_o(busy_o),
		.axi_req_i(axi_req_i),
		.axi_resp_o(axi_resp_o),
		.mem_req_o(mem_req_o),
		.mem_gnt_i(mem_gnt_i),
		.mem_addr_o(mem_addr_o),
		.mem_wdata_o(mem_wdata_o),
		.mem_strb_o(mem_strb_o),
		.mem_atop_o(mem_atop_o),
		.mem_lock_o(),
		.mem_we_o(mem_we_o),
		.mem_id_o(),
		.mem_user_o(),
		.mem_cache_o(),
		.mem_prot_o(),
		.mem_qos_o(),
		.mem_region_o(),
		.mem_rvalid_i(mem_rvalid_i),
		.mem_rdata_i(mem_rdata_i),
		.mem_err_i(sv2v_uu_i_axi_to_detailed_mem_ext_mem_err_i_0),
		.mem_exokay_i(sv2v_uu_i_axi_to_detailed_mem_ext_mem_exokay_i_0)
	);
endmodule
