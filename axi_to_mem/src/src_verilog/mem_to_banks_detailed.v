module mem_to_banks_detailed (
	clk_i,
	rst_ni,
	req_i,
	gnt_o,
	addr_i,
	wdata_i,
	strb_i,
	wuser_i,
	we_i,
	rvalid_o,
	rdata_o,
	ruser_o,
	bank_req_o,
	bank_gnt_i,
	bank_addr_o,
	bank_wdata_o,
	bank_strb_o,
	bank_wuser_o,
	bank_we_o,
	bank_rvalid_i,
	bank_rdata_i,
	bank_ruser_i
);
	parameter [31:0] AddrWidth = 32'd0;
	parameter [31:0] DataWidth = 32'd0;
	parameter [31:0] WUserWidth = 32'd0;
	parameter [31:0] RUserWidth = 32'd0;
	parameter [31:0] NumBanks = 32'd1;
	parameter [0:0] HideStrb = 1'b0;
	parameter [31:0] MaxTrans = 32'd1;
	parameter [31:0] FifoDepth = 32'd1;
	input wire clk_i;
	input wire rst_ni;
	input wire req_i;
	output wire gnt_o;
	input wire [AddrWidth - 1:0] addr_i;
	input wire [DataWidth - 1:0] wdata_i;
	input wire [(DataWidth / 8) - 1:0] strb_i;
	input wire [WUserWidth - 1:0] wuser_i;
	input wire we_i;
	output wire rvalid_o;
	output wire [DataWidth - 1:0] rdata_o;
	output wire [(NumBanks * RUserWidth) - 1:0] ruser_o;
	output wire [NumBanks - 1:0] bank_req_o;
	input wire [NumBanks - 1:0] bank_gnt_i;
	output wire [(NumBanks * AddrWidth) - 1:0] bank_addr_o;
	output wire [(NumBanks * (DataWidth / NumBanks)) - 1:0] bank_wdata_o;
	output wire [(NumBanks * ((DataWidth / NumBanks) / 8)) - 1:0] bank_strb_o;
	output wire [(NumBanks * WUserWidth) - 1:0] bank_wuser_o;
	output wire [NumBanks - 1:0] bank_we_o;
	input wire [NumBanks - 1:0] bank_rvalid_i;
	input wire [(NumBanks * (DataWidth / NumBanks)) - 1:0] bank_rdata_i;
	input wire [(NumBanks * RUserWidth) - 1:0] bank_ruser_i;
	localparam [31:0] DataBytes = DataWidth / 8;
	localparam [31:0] BitsPerBank = DataWidth / NumBanks;
	localparam [31:0] BytesPerBank = (DataWidth / NumBanks) / 8;
	wire req_valid;
	wire [NumBanks - 1:0] req_ready;
	wire [NumBanks - 1:0] resp_valid;
	wire [NumBanks - 1:0] resp_ready;
	wire [(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (NumBanks * ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1)) - 1 : (NumBanks * (1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) - 1)):(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? 0 : (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0)] bank_req;
	wire [(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (NumBanks * ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1)) - 1 : (NumBanks * (1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) - 1)):(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? 0 : (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0)] bank_oup;
	wire [NumBanks - 1:0] bank_req_internal;
	wire [NumBanks - 1:0] bank_gnt_internal;
	wire [NumBanks - 1:0] zero_strobe;
	wire [NumBanks - 1:0] dead_response;
	wire [NumBanks - 1:0] dead_response_unmasked;
	wire dead_write_fifo_full;
	wire dead_write_fifo_empty;
	function automatic [AddrWidth - 1:0] align_addr;
		input reg [AddrWidth - 1:0] addr;
		align_addr = (addr >> $clog2(DataBytes)) << $clog2(DataBytes);
	endfunction
	assign req_valid = req_i & gnt_o;
	genvar _gv_i_14;
	generate
		for (_gv_i_14 = 0; $unsigned(_gv_i_14) < NumBanks; _gv_i_14 = _gv_i_14 + 1) begin : gen_reqs
			localparam i = _gv_i_14;
			assign bank_req[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))))) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))))) + ((AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) >= ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) ? ((AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1)))) + 1 : (((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) - (AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))))) + 1)) - 1)-:((AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) >= ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) ? ((AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1)))) + 1 : (((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) - (AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))))) + 1)] = align_addr(addr_i) + (i * BytesPerBank);
			assign bank_req[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))))) + (((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) >= (((DataWidth / NumBanks) / 8) + (WUserWidth + 1)) ? (((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) + 1 : ((((DataWidth / NumBanks) / 8) + (WUserWidth + 1)) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) + 1)) - 1)-:(((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) >= (((DataWidth / NumBanks) / 8) + (WUserWidth + 1)) ? (((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) + 1 : ((((DataWidth / NumBanks) / 8) + (WUserWidth + 1)) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) + 1)] = wdata_i[i * BitsPerBank+:BitsPerBank];
			assign bank_req[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? ((DataWidth / NumBanks) / 8) + (WUserWidth + 0) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? ((DataWidth / NumBanks) / 8) + (WUserWidth + 0) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) + ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1)) - 1)-:((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1)] = strb_i[i * BytesPerBank+:BytesPerBank];
			assign bank_req[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? WUserWidth + 0 : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (WUserWidth + 0)) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? WUserWidth + 0 : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (WUserWidth + 0))) + ((WUserWidth + 0) >= 1 ? WUserWidth + 0 : 2 - (WUserWidth + 0))) - 1)-:((WUserWidth + 0) >= 1 ? WUserWidth + 0 : 2 - (WUserWidth + 0))] = wuser_i;
			assign bank_req[(i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? 0 : (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0)] = we_i;
			stream_fifo_E69A1_C2046 #(
				.T_AddrWidth(AddrWidth),
				.T_DataWidth(DataWidth),
				.T_NumBanks(NumBanks),
				.T_WUserWidth(WUserWidth),
				.FALL_THROUGH(1'b1),
				.DATA_WIDTH(1 * (((((0 + AddrWidth) + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1)),
				.DEPTH(FifoDepth)
			) i_ft_reg(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.flush_i(1'b0),
				.testmode_i(1'b0),
				.usage_o(),
				.data_i(bank_req[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? 0 : (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) + (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0)))+:(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))]),
				.valid_i(req_valid),
				.ready_o(req_ready[i]),
				.data_o(bank_oup[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? 0 : (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) + (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0)))+:(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))]),
				.valid_o(bank_req_internal[i]),
				.ready_i(bank_gnt_internal[i])
			);
			assign bank_addr_o[i * AddrWidth+:AddrWidth] = bank_oup[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))))) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))))) + ((AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) >= ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) ? ((AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1)))) + 1 : (((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) - (AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))))) + 1)) - 1)-:((AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) >= ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) ? ((AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1)))) + 1 : (((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) - (AddrWidth + ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))))) + 1)];
			assign bank_wdata_o[i * (DataWidth / NumBanks)+:DataWidth / NumBanks] = bank_oup[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))))) + (((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) >= (((DataWidth / NumBanks) / 8) + (WUserWidth + 1)) ? (((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) + 1 : ((((DataWidth / NumBanks) / 8) + (WUserWidth + 1)) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) + 1)) - 1)-:(((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) >= (((DataWidth / NumBanks) / 8) + (WUserWidth + 1)) ? (((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 1))) + 1 : ((((DataWidth / NumBanks) / 8) + (WUserWidth + 1)) - ((DataWidth / NumBanks) + (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) + 1)];
			assign bank_strb_o[i * ((DataWidth / NumBanks) / 8)+:(DataWidth / NumBanks) / 8] = bank_oup[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? ((DataWidth / NumBanks) / 8) + (WUserWidth + 0) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? ((DataWidth / NumBanks) / 8) + (WUserWidth + 0) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) + ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1)) - 1)-:((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1)];
			assign bank_wuser_o[i * WUserWidth+:WUserWidth] = bank_oup[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? WUserWidth + 0 : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (WUserWidth + 0)) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? WUserWidth + 0 : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (WUserWidth + 0))) + ((WUserWidth + 0) >= 1 ? WUserWidth + 0 : 2 - (WUserWidth + 0))) - 1)-:((WUserWidth + 0) >= 1 ? WUserWidth + 0 : 2 - (WUserWidth + 0))];
			assign bank_we_o[i] = bank_oup[(i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? 0 : (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0)];
			assign zero_strobe[i] = bank_req[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? ((DataWidth / NumBanks) / 8) + (WUserWidth + 0) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? ((DataWidth / NumBanks) / 8) + (WUserWidth + 0) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) + ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1)) - 1)-:((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1)] == {((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1) * 1 {1'sb0}};
			if (HideStrb) begin : gen_hide_strb
				assign bank_req_o[i] = (bank_oup[(i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? 0 : (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0)] && (bank_oup[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? ((DataWidth / NumBanks) / 8) + (WUserWidth + 0) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? ((DataWidth / NumBanks) / 8) + (WUserWidth + 0) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) + ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1)) - 1)-:((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1)] == {((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1) * 1 {1'sb0}}) ? 1'b0 : bank_req_internal[i]);
				assign bank_gnt_internal[i] = (bank_oup[(i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? 0 : (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0)] && (bank_oup[(((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? ((DataWidth / NumBanks) / 8) + (WUserWidth + 0) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) : (((i * (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? (((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 1 : 1 - ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0))) + (((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) >= 0 ? ((DataWidth / NumBanks) / 8) + (WUserWidth + 0) : ((((AddrWidth + (DataWidth / NumBanks)) + ((DataWidth / NumBanks) / 8)) + WUserWidth) + 0) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0)))) + ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1)) - 1)-:((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1)] == {((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) >= (WUserWidth + 1) ? ((((DataWidth / NumBanks) / 8) + (WUserWidth + 0)) - (WUserWidth + 1)) + 1 : ((WUserWidth + 1) - (((DataWidth / NumBanks) / 8) + (WUserWidth + 0))) + 1) * 1 {1'sb0}}) ? 1'b1 : bank_gnt_i[i]);
			end
			else begin : gen_legacy_strb
				assign bank_req_o[i] = bank_req_internal[i];
				assign bank_gnt_internal[i] = bank_gnt_i[i];
			end
		end
	endgenerate
	assign gnt_o = (&req_ready & (&resp_ready)) & !dead_write_fifo_full;
	generate
		if (HideStrb) begin : gen_dead_write_fifo
			fifo_v3 #(
				.FALL_THROUGH(1'b0),
				.DEPTH(MaxTrans + 1),
				.DATA_WIDTH(NumBanks)
			) i_dead_write_fifo(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.flush_i(1'b0),
				.testmode_i(1'b0),
				.full_o(dead_write_fifo_full),
				.empty_o(dead_write_fifo_empty),
				.usage_o(),
				.data_i({NumBanks {we_i}} & zero_strobe),
				.push_i(req_i & gnt_o),
				.data_o(dead_response_unmasked),
				.pop_i(rvalid_o)
			);
			assign dead_response = dead_response_unmasked & {NumBanks {~dead_write_fifo_empty}};
		end
		else begin : gen_no_dead_write_fifo
			assign dead_response_unmasked = 1'sb0;
			assign dead_response = 1'sb0;
			assign dead_write_fifo_full = 1'b0;
			assign dead_write_fifo_empty = 1'b1;
		end
	endgenerate
	genvar _gv_i_15;
	generate
		for (_gv_i_15 = 0; $unsigned(_gv_i_15) < NumBanks; _gv_i_15 = _gv_i_15 + 1) begin : gen_resp_regs
			localparam i = _gv_i_15;
			stream_fifo #(
				.FALL_THROUGH(1'b1),
				.DATA_WIDTH((DataWidth / NumBanks) + RUserWidth),
				.DEPTH(FifoDepth)
			) i_ft_reg(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.flush_i(1'b0),
				.testmode_i(1'b0),
				.usage_o(),
				.data_i({bank_rdata_i[i * (DataWidth / NumBanks)+:DataWidth / NumBanks], bank_ruser_i[i * RUserWidth+:RUserWidth]}),
				.valid_i(bank_rvalid_i[i]),
				.ready_o(resp_ready[i]),
				.data_o({rdata_o[i * BitsPerBank+:BitsPerBank], ruser_o[i * RUserWidth+:RUserWidth]}),
				.valid_o(resp_valid[i]),
				.ready_i(rvalid_o & !dead_response[i])
			);
		end
	endgenerate
	assign rvalid_o = &(resp_valid | dead_response);
endmodule
