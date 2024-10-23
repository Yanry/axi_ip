module axi_from_mem (
	clk_i,
	rst_ni,
	mem_req_i,
	mem_addr_i,
	mem_we_i,
	mem_wdata_i,
	mem_be_i,
	mem_gnt_o,
	mem_rsp_valid_o,
	mem_rsp_rdata_o,
	mem_rsp_error_o,
	slv_aw_cache_i,
	slv_ar_cache_i,
	axi_req_o,
	axi_rsp_i
);
	parameter [31:0] MemAddrWidth = 32'd0;
	parameter [31:0] AxiAddrWidth = 32'd0;
	parameter [31:0] DataWidth = 32'd0;
	parameter [31:0] MaxRequests = 32'd0;
	parameter [2:0] AxiProt = 3'b000;
	input wire clk_i;
	input wire rst_ni;
	input wire mem_req_i;
	input wire [MemAddrWidth - 1:0] mem_addr_i;
	input wire mem_we_i;
	input wire [DataWidth - 1:0] mem_wdata_i;
	input wire [(DataWidth / 8) - 1:0] mem_be_i;
	output wire mem_gnt_o;
	output wire mem_rsp_valid_o;
	output wire [DataWidth - 1:0] mem_rsp_rdata_o;
	output wire mem_rsp_error_o;
	input wire [3:0] slv_aw_cache_i;
	input wire [3:0] slv_ar_cache_i;
	output wire axi_req_o;
	input wire axi_rsp_i;
	wire [((((((AxiAddrWidth + 2) >= 0 ? AxiAddrWidth + 3 : 1 - (AxiAddrWidth + 2)) + 1) + (DataWidth + (DataWidth / 8))) + 2) + ((AxiAddrWidth + 2) >= 0 ? AxiAddrWidth + 3 : 1 - (AxiAddrWidth + 2))) + 1:0] axi_lite_req;
	wire [(6 + ((DataWidth + 1) >= 0 ? DataWidth + 2 : 1 - (DataWidth + 1))) + 0:0] axi_lite_rsp;
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
		.mem_gnt_o(mem_gnt_o),
		.mem_rsp_valid_o(mem_rsp_valid_o),
		.mem_rsp_rdata_o(mem_rsp_rdata_o),
		.mem_rsp_error_o(mem_rsp_error_o),
		.axi_req_o(axi_lite_req),
		.axi_rsp_i(axi_lite_rsp)
	);
	axi_lite_to_axi_10175_F31BF #(
		.req_lite_t_AxiAddrWidth(AxiAddrWidth),
		.req_lite_t_DataWidth(DataWidth),
		.resp_lite_t_DataWidth(DataWidth),
		.AxiDataWidth(DataWidth)
	) i_axi_lite_to_axi(
		.slv_req_lite_i(axi_lite_req),
		.slv_resp_lite_o(axi_lite_rsp),
		.slv_aw_cache_i(slv_aw_cache_i),
		.slv_ar_cache_i(slv_ar_cache_i),
		.mst_req_o(axi_req_o),
		.mst_resp_i(axi_rsp_i)
	);
endmodule
