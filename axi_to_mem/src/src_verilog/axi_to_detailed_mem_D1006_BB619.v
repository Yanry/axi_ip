module axi_to_detailed_mem_D1006_BB619 (
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
	parameter [31:0] axi_req_t_axi_req_t_DataWidth = 0;
	parameter [31:0] axi_req_t_axi_req_t_IdWidth = 0;
	parameter [31:0] axi_req_t_axi_req_t_MemAddrWidth = 0;
	parameter [31:0] axi_req_t_axi_req_t_UserWidth = 0;
	parameter [31:0] axi_resp_t_axi_resp_t_DataWidth = 0;
	parameter [31:0] axi_resp_t_axi_resp_t_IdWidth = 0;
	parameter [31:0] axi_resp_t_axi_resp_t_UserWidth = 0;
	reg _sv2v_0;
	parameter [31:0] AddrWidth = 1;
	parameter [31:0] DataWidth = 1;
	parameter [31:0] IdWidth = 1;
	parameter [31:0] UserWidth = 1;
	parameter [31:0] NumBanks = 1;
	parameter [31:0] BufDepth = 1;
	parameter [0:0] HideStrb = 1'b0;
	parameter [31:0] OutFifoDepth = 1;
	input wire clk_i;
	input wire rst_ni;
	output wire busy_o;
	input wire [(((((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + 1) + (((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth)) + 2) + (((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth)) + 1:0] axi_req_i;
	output reg [(((4 + ((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth)) + 1) + (((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth)) - 1:0] axi_resp_o;
	output wire [NumBanks - 1:0] mem_req_o;
	input wire [NumBanks - 1:0] mem_gnt_i;
	output wire [(NumBanks * AddrWidth) - 1:0] mem_addr_o;
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
	wire [((DataWidth + NumBanks) + NumBanks) - 1:0] mem_rdata;
	wire [((DataWidth + NumBanks) + NumBanks) - 1:0] m2s_resp;
	reg [7:0] r_cnt_d;
	reg [7:0] r_cnt_q;
	reg [7:0] w_cnt_d;
	reg [7:0] w_cnt_q;
	wire arb_valid;
	wire arb_ready;
	reg rd_valid;
	wire rd_ready;
	reg wr_valid;
	wire wr_ready;
	wire sel_b;
	wire sel_buf_b;
	wire sel_r;
	wire sel_buf_r;
	wire sel_valid;
	wire sel_ready;
	wire sel_buf_valid;
	wire sel_buf_ready;
	reg sel_lock_d;
	reg sel_lock_q;
	wire meta_valid;
	wire meta_ready;
	wire meta_buf_valid;
	wire meta_buf_ready;
	reg meta_sel_d;
	reg meta_sel_q;
	wire m2s_req_valid;
	wire m2s_req_ready;
	wire m2s_resp_valid;
	wire m2s_resp_ready;
	wire mem_req_valid;
	wire mem_req_ready;
	wire mem_rvalid;
	wire [((((((AddrWidth + 7) + (DataWidth / 8)) + DataWidth) + 1) + IdWidth) + UserWidth) + 14:0] m2s_req;
	wire [((((((AddrWidth + 7) + (DataWidth / 8)) + DataWidth) + 1) + IdWidth) + UserWidth) + 14:0] mem_req;
	reg [(((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10:0] rd_meta;
	reg [(((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10:0] rd_meta_d;
	reg [(((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10:0] rd_meta_q;
	reg [(((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10:0] wr_meta;
	reg [(((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10:0] wr_meta_d;
	reg [(((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10:0] wr_meta_q;
	wire [(((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10:0] meta;
	wire [(((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10:0] meta_buf;
	assign busy_o = (((((axi_req_i[1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1)))] | axi_req_i[1]) | axi_req_i[2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1)]) | axi_resp_o[1 + (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))]) | axi_resp_o[(((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0]) | (r_cnt_q > 0)) | (w_cnt_q > 0);
	function automatic [127:0] axi_pkg_aligned_addr;
		input reg [127:0] addr;
		input reg [2:0] size;
		axi_pkg_aligned_addr = (addr >> size) << size;
	endfunction
	function automatic [15:0] axi_pkg_num_bytes;
		input reg [2:0] size;
		axi_pkg_num_bytes = 1 << size;
	endfunction
	function automatic [AddrWidth - 1:0] sv2v_cast_6171F;
		input reg [AddrWidth - 1:0] inp;
		sv2v_cast_6171F = inp;
	endfunction
	function automatic [(DataWidth / 8) - 1:0] sv2v_cast_74977;
		input reg [(DataWidth / 8) - 1:0] inp;
		sv2v_cast_74977 = inp;
	endfunction
	function automatic [IdWidth - 1:0] sv2v_cast_0E8C3;
		input reg [IdWidth - 1:0] inp;
		sv2v_cast_0E8C3 = inp;
	endfunction
	function automatic [UserWidth - 1:0] sv2v_cast_CD06D;
		input reg [UserWidth - 1:0] inp;
		sv2v_cast_CD06D = inp;
	endfunction
	function automatic [(((((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10) >= 0 ? (((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 11 : 1 - ((((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10)) - 1:0] sv2v_cast_71D75;
		input reg [(((((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10) >= 0 ? (((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 11 : 1 - ((((((AddrWidth + 7) + (DataWidth / 8)) + IdWidth) + 9) + UserWidth) + 10)) - 1:0] inp;
		sv2v_cast_71D75 = inp;
	endfunction
	function automatic [AddrWidth - 1:0] sv2v_cast_79459;
		input reg [AddrWidth - 1:0] inp;
		sv2v_cast_79459 = inp;
	endfunction
	function automatic [0:0] sv2v_cast_1;
		input reg [0:0] inp;
		sv2v_cast_1 = inp;
	endfunction
	function automatic [IdWidth - 1:0] sv2v_cast_C5469;
		input reg [IdWidth - 1:0] inp;
		sv2v_cast_C5469 = inp;
	endfunction
	function automatic [3:0] sv2v_cast_4;
		input reg [3:0] inp;
		sv2v_cast_4 = inp;
	endfunction
	function automatic [2:0] sv2v_cast_3;
		input reg [2:0] inp;
		sv2v_cast_3 = inp;
	endfunction
	function automatic [UserWidth - 1:0] sv2v_cast_2A58B;
		input reg [UserWidth - 1:0] inp;
		sv2v_cast_2A58B = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		axi_resp_o[3 + (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))] = 1'b0;
		rd_meta_d = rd_meta_q;
		rd_meta = sv2v_cast_71D75({sv2v_cast_6171F(1'sb0), 7'b0000000, sv2v_cast_74977(1'sb0), sv2v_cast_0E8C3(1'sb0), 9'b000000000, sv2v_cast_CD06D(1'sb0), 11'b00000000000});
		rd_valid = 1'b0;
		r_cnt_d = r_cnt_q;
		if (r_cnt_q > {8 {1'sb0}}) begin
			rd_meta_d[9 + (UserWidth + 10)] = r_cnt_q == 8'd1;
			rd_meta = rd_meta_d;
			rd_meta[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)] = rd_meta_q[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)] + axi_pkg_num_bytes(rd_meta_q[4 + (UserWidth + 10)-:((4 + (UserWidth + 10)) >= (1 + (UserWidth + 11)) ? ((4 + (UserWidth + 10)) - (1 + (UserWidth + 11))) + 1 : ((1 + (UserWidth + 11)) - (4 + (UserWidth + 10))) + 1)]);
			rd_valid = 1'b1;
			if (rd_ready) begin
				r_cnt_d = r_cnt_d - 1;
				rd_meta_d[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)] = rd_meta[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)];
			end
		end
		else if (axi_req_i[1]) begin
			rd_meta_d = {sv2v_cast_79459(axi_pkg_aligned_addr(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7))))-:((axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7))) >= (29 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7))) - (29 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((29 + (axi_req_t_axi_req_t_UserWidth + 0)) - (axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7)))) + 1)], axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (17 + (axi_req_t_axi_req_t_UserWidth + 3)))-:((17 + (axi_req_t_axi_req_t_UserWidth + 3)) >= (18 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((17 + (axi_req_t_axi_req_t_UserWidth + 3)) - (18 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((18 + (axi_req_t_axi_req_t_UserWidth + 0)) - (17 + (axi_req_t_axi_req_t_UserWidth + 3))) + 1)])), 6'b000000, sv2v_cast_1(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (12 + (axi_req_t_axi_req_t_UserWidth + 3)))]), sv2v_cast_74977(1'sb0), sv2v_cast_C5469(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_IdWidth + (axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7)))))-:((axi_req_t_axi_req_t_IdWidth + (axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7)))) >= (axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 0))) ? ((axi_req_t_axi_req_t_IdWidth + (axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7)))) - (axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 0)))) + 1 : ((axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 0))) - (axi_req_t_axi_req_t_IdWidth + (axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7))))) + 1)]), axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (21 + (axi_req_t_axi_req_t_UserWidth + 7)))-:((21 + (axi_req_t_axi_req_t_UserWidth + 7)) >= (21 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((21 + (axi_req_t_axi_req_t_UserWidth + 7)) - (21 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((21 + (axi_req_t_axi_req_t_UserWidth + 0)) - (21 + (axi_req_t_axi_req_t_UserWidth + 7))) + 1)] == 1'b0, sv2v_cast_4(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_UserWidth + 7))-:((axi_req_t_axi_req_t_UserWidth + 7) >= (4 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((axi_req_t_axi_req_t_UserWidth + 7) - (4 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((4 + (axi_req_t_axi_req_t_UserWidth + 0)) - (axi_req_t_axi_req_t_UserWidth + 7)) + 1)]), sv2v_cast_3(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (17 + (axi_req_t_axi_req_t_UserWidth + 3)))-:((17 + (axi_req_t_axi_req_t_UserWidth + 3)) >= (18 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((17 + (axi_req_t_axi_req_t_UserWidth + 3)) - (18 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((18 + (axi_req_t_axi_req_t_UserWidth + 0)) - (17 + (axi_req_t_axi_req_t_UserWidth + 3))) + 1)]), 1'b0, sv2v_cast_2A58B(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_UserWidth - 1))-:axi_req_t_axi_req_t_UserWidth]), sv2v_cast_4(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (7 + (axi_req_t_axi_req_t_UserWidth + 7)))-:((7 + (axi_req_t_axi_req_t_UserWidth + 7)) >= (11 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((7 + (axi_req_t_axi_req_t_UserWidth + 7)) - (11 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((11 + (axi_req_t_axi_req_t_UserWidth + 0)) - (7 + (axi_req_t_axi_req_t_UserWidth + 7))) + 1)]), sv2v_cast_3(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (7 + (axi_req_t_axi_req_t_UserWidth + 3)))-:((7 + (axi_req_t_axi_req_t_UserWidth + 3)) >= (8 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((7 + (axi_req_t_axi_req_t_UserWidth + 3)) - (8 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((8 + (axi_req_t_axi_req_t_UserWidth + 0)) - (7 + (axi_req_t_axi_req_t_UserWidth + 3))) + 1)]), sv2v_cast_4(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_UserWidth + 3))-:((axi_req_t_axi_req_t_UserWidth + 3) >= (axi_req_t_axi_req_t_UserWidth + 0) ? ((axi_req_t_axi_req_t_UserWidth + 3) - (axi_req_t_axi_req_t_UserWidth + 0)) + 1 : ((axi_req_t_axi_req_t_UserWidth + 0) - (axi_req_t_axi_req_t_UserWidth + 3)) + 1)])};
			rd_meta = rd_meta_d;
			rd_meta[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)] = sv2v_cast_79459(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7))))-:((axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7))) >= (29 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7))) - (29 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((29 + (axi_req_t_axi_req_t_UserWidth + 0)) - (axi_req_t_axi_req_t_MemAddrWidth + (21 + (axi_req_t_axi_req_t_UserWidth + 7)))) + 1)]);
			rd_valid = 1'b1;
			if (rd_ready) begin
				r_cnt_d = axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) - 1) - (21 + (axi_req_t_axi_req_t_UserWidth + 7)))-:((21 + (axi_req_t_axi_req_t_UserWidth + 7)) >= (21 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((21 + (axi_req_t_axi_req_t_UserWidth + 7)) - (21 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((21 + (axi_req_t_axi_req_t_UserWidth + 0)) - (21 + (axi_req_t_axi_req_t_UserWidth + 7))) + 1)];
				axi_resp_o[3 + (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))] = 1'b1;
			end
		end
	end
	function automatic [5:0] sv2v_cast_6;
		input reg [5:0] inp;
		sv2v_cast_6 = inp;
	endfunction
	function automatic [(DataWidth / 8) - 1:0] sv2v_cast_B5889;
		input reg [(DataWidth / 8) - 1:0] inp;
		sv2v_cast_B5889 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		axi_resp_o[4 + (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))] = 1'b0;
		axi_resp_o[2 + (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))] = 1'b0;
		wr_meta_d = wr_meta_q;
		wr_meta = sv2v_cast_71D75({sv2v_cast_6171F(1'sb0), 7'b0000000, sv2v_cast_74977(1'sb0), sv2v_cast_0E8C3(1'sb0), 9'b000000000, sv2v_cast_CD06D(1'sb0), 11'b00000000000});
		wr_valid = 1'b0;
		w_cnt_d = w_cnt_q;
		if (w_cnt_q > {8 {1'sb0}}) begin
			wr_meta_d[9 + (UserWidth + 10)] = w_cnt_q == 8'd1;
			wr_meta = wr_meta_d;
			wr_meta[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)] = wr_meta_q[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)] + axi_pkg_num_bytes(wr_meta_q[4 + (UserWidth + 10)-:((4 + (UserWidth + 10)) >= (1 + (UserWidth + 11)) ? ((4 + (UserWidth + 10)) - (1 + (UserWidth + 11))) + 1 : ((1 + (UserWidth + 11)) - (4 + (UserWidth + 10))) + 1)]);
			if (axi_req_i[2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1)]) begin
				wr_valid = 1'b1;
				wr_meta[(DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))-:(((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))) >= (IdWidth + (9 + (UserWidth + 11))) ? (((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))) - (IdWidth + (9 + (UserWidth + 11)))) + 1 : ((IdWidth + (9 + (UserWidth + 11))) - ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))) + 1)] = axi_req_i[((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))) - (((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) - 1) - ((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0)))-:(((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0)) >= (1 + (axi_req_t_axi_req_t_UserWidth + 0)) ? (((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0)) - (1 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((1 + (axi_req_t_axi_req_t_UserWidth + 0)) - ((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0))) + 1)];
				if (wr_ready) begin
					axi_resp_o[2 + (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))] = 1'b1;
					w_cnt_d = w_cnt_d - 1;
					wr_meta_d[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)] = wr_meta[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)];
				end
			end
		end
		else if (axi_req_i[1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1)))] && axi_req_i[2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1)]) begin
			wr_meta_d = {sv2v_cast_79459(axi_pkg_aligned_addr(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5))))-:((axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5))) >= (35 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5))) - (35 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((35 + (axi_req_t_axi_req_t_UserWidth + 0)) - (axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5)))) + 1)], axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (17 + (axi_req_t_axi_req_t_UserWidth + 9)))-:((17 + (axi_req_t_axi_req_t_UserWidth + 9)) >= (24 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((17 + (axi_req_t_axi_req_t_UserWidth + 9)) - (24 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((24 + (axi_req_t_axi_req_t_UserWidth + 0)) - (17 + (axi_req_t_axi_req_t_UserWidth + 9))) + 1)])), sv2v_cast_6(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_UserWidth + 5))-:((axi_req_t_axi_req_t_UserWidth + 5) >= (axi_req_t_axi_req_t_UserWidth + 0) ? ((axi_req_t_axi_req_t_UserWidth + 5) - (axi_req_t_axi_req_t_UserWidth + 0)) + 1 : ((axi_req_t_axi_req_t_UserWidth + 0) - (axi_req_t_axi_req_t_UserWidth + 5)) + 1)]), sv2v_cast_1(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (12 + (axi_req_t_axi_req_t_UserWidth + 9)))]), sv2v_cast_B5889(axi_req_i[((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))) - (((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) - 1) - ((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0)))-:(((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0)) >= (1 + (axi_req_t_axi_req_t_UserWidth + 0)) ? (((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0)) - (1 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((1 + (axi_req_t_axi_req_t_UserWidth + 0)) - ((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0))) + 1)]), sv2v_cast_C5469(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_IdWidth + (axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5)))))-:((axi_req_t_axi_req_t_IdWidth + (axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5)))) >= (axi_req_t_axi_req_t_MemAddrWidth + (35 + (axi_req_t_axi_req_t_UserWidth + 0))) ? ((axi_req_t_axi_req_t_IdWidth + (axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5)))) - (axi_req_t_axi_req_t_MemAddrWidth + (35 + (axi_req_t_axi_req_t_UserWidth + 0)))) + 1 : ((axi_req_t_axi_req_t_MemAddrWidth + (35 + (axi_req_t_axi_req_t_UserWidth + 0))) - (axi_req_t_axi_req_t_IdWidth + (axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5))))) + 1)]), axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (29 + (axi_req_t_axi_req_t_UserWidth + 5)))-:((29 + (axi_req_t_axi_req_t_UserWidth + 5)) >= (27 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((29 + (axi_req_t_axi_req_t_UserWidth + 5)) - (27 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((27 + (axi_req_t_axi_req_t_UserWidth + 0)) - (29 + (axi_req_t_axi_req_t_UserWidth + 5))) + 1)] == 1'b0, sv2v_cast_4(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (8 + (axi_req_t_axi_req_t_UserWidth + 5)))-:((8 + (axi_req_t_axi_req_t_UserWidth + 5)) >= (10 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((8 + (axi_req_t_axi_req_t_UserWidth + 5)) - (10 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((10 + (axi_req_t_axi_req_t_UserWidth + 0)) - (8 + (axi_req_t_axi_req_t_UserWidth + 5))) + 1)]), sv2v_cast_3(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (17 + (axi_req_t_axi_req_t_UserWidth + 9)))-:((17 + (axi_req_t_axi_req_t_UserWidth + 9)) >= (24 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((17 + (axi_req_t_axi_req_t_UserWidth + 9)) - (24 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((24 + (axi_req_t_axi_req_t_UserWidth + 0)) - (17 + (axi_req_t_axi_req_t_UserWidth + 9))) + 1)]), 1'b1, sv2v_cast_2A58B(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_UserWidth - 1))-:axi_req_t_axi_req_t_UserWidth]), sv2v_cast_4(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (15 + (axi_req_t_axi_req_t_UserWidth + 5)))-:((15 + (axi_req_t_axi_req_t_UserWidth + 5)) >= (17 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((15 + (axi_req_t_axi_req_t_UserWidth + 5)) - (17 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((17 + (axi_req_t_axi_req_t_UserWidth + 0)) - (15 + (axi_req_t_axi_req_t_UserWidth + 5))) + 1)]), sv2v_cast_3(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (7 + (axi_req_t_axi_req_t_UserWidth + 9)))-:((7 + (axi_req_t_axi_req_t_UserWidth + 9)) >= (14 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((7 + (axi_req_t_axi_req_t_UserWidth + 9)) - (14 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((14 + (axi_req_t_axi_req_t_UserWidth + 0)) - (7 + (axi_req_t_axi_req_t_UserWidth + 9))) + 1)]), sv2v_cast_4(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_UserWidth + 9))-:((axi_req_t_axi_req_t_UserWidth + 9) >= (6 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((axi_req_t_axi_req_t_UserWidth + 9) - (6 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((6 + (axi_req_t_axi_req_t_UserWidth + 0)) - (axi_req_t_axi_req_t_UserWidth + 9)) + 1)])};
			wr_meta = wr_meta_d;
			wr_meta[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)] = sv2v_cast_79459(axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5))))-:((axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5))) >= (35 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5))) - (35 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((35 + (axi_req_t_axi_req_t_UserWidth + 0)) - (axi_req_t_axi_req_t_MemAddrWidth + (29 + (axi_req_t_axi_req_t_UserWidth + 5)))) + 1)]);
			wr_valid = 1'b1;
			if (wr_ready) begin
				w_cnt_d = axi_req_i[((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) + (1 + ((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))))) - (((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 35) + axi_req_t_axi_req_t_UserWidth) - 1) - (29 + (axi_req_t_axi_req_t_UserWidth + 5)))-:((29 + (axi_req_t_axi_req_t_UserWidth + 5)) >= (27 + (axi_req_t_axi_req_t_UserWidth + 0)) ? ((29 + (axi_req_t_axi_req_t_UserWidth + 5)) - (27 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((27 + (axi_req_t_axi_req_t_UserWidth + 0)) - (29 + (axi_req_t_axi_req_t_UserWidth + 5))) + 1)];
				axi_resp_o[4 + (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))] = 1'b1;
				axi_resp_o[2 + (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))] = 1'b1;
			end
		end
	end
	stream_mux_EC5E5_37FC7 #(
		.DATA_T_AddrWidth(AddrWidth),
		.DATA_T_DataWidth(DataWidth),
		.DATA_T_IdWidth(IdWidth),
		.DATA_T_UserWidth(UserWidth),
		.N_INP(32'd2)
	) i_ax_mux(
		.inp_data_i({wr_meta, rd_meta}),
		.inp_valid_i({wr_valid, rd_valid}),
		.inp_ready_o({wr_ready, rd_ready}),
		.inp_sel_i(meta_sel_d),
		.oup_data_o(meta),
		.oup_valid_o(arb_valid),
		.oup_ready_i(arb_ready)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		meta_sel_d = meta_sel_q;
		sel_lock_d = sel_lock_q;
		if (sel_lock_q) begin
			meta_sel_d = meta_sel_q;
			if (arb_valid && arb_ready)
				sel_lock_d = 1'b0;
		end
		else begin
			if (wr_valid ^ rd_valid)
				meta_sel_d = wr_valid;
			else if (wr_valid && rd_valid) begin
				if (wr_meta[8 + (UserWidth + 10)-:((8 + (UserWidth + 10)) >= (4 + (UserWidth + 11)) ? ((8 + (UserWidth + 10)) - (4 + (UserWidth + 11))) + 1 : ((4 + (UserWidth + 11)) - (8 + (UserWidth + 10))) + 1)] > rd_meta[8 + (UserWidth + 10)-:((8 + (UserWidth + 10)) >= (4 + (UserWidth + 11)) ? ((8 + (UserWidth + 10)) - (4 + (UserWidth + 11))) + 1 : ((4 + (UserWidth + 11)) - (8 + (UserWidth + 10))) + 1)])
					meta_sel_d = 1'b1;
				else if (rd_meta[8 + (UserWidth + 10)-:((8 + (UserWidth + 10)) >= (4 + (UserWidth + 11)) ? ((8 + (UserWidth + 10)) - (4 + (UserWidth + 11))) + 1 : ((4 + (UserWidth + 11)) - (8 + (UserWidth + 10))) + 1)] > wr_meta[8 + (UserWidth + 10)-:((8 + (UserWidth + 10)) >= (4 + (UserWidth + 11)) ? ((8 + (UserWidth + 10)) - (4 + (UserWidth + 11))) + 1 : ((4 + (UserWidth + 11)) - (8 + (UserWidth + 10))) + 1)])
					meta_sel_d = 1'b0;
				else if (wr_meta[8 + (UserWidth + 10)-:((8 + (UserWidth + 10)) >= (4 + (UserWidth + 11)) ? ((8 + (UserWidth + 10)) - (4 + (UserWidth + 11))) + 1 : ((4 + (UserWidth + 11)) - (8 + (UserWidth + 10))) + 1)] == rd_meta[8 + (UserWidth + 10)-:((8 + (UserWidth + 10)) >= (4 + (UserWidth + 11)) ? ((8 + (UserWidth + 10)) - (4 + (UserWidth + 11))) + 1 : ((4 + (UserWidth + 11)) - (8 + (UserWidth + 10))) + 1)]) begin
					if (wr_meta[9 + (UserWidth + 10)] && !rd_meta[9 + (UserWidth + 10)])
						meta_sel_d = 1'b1;
					else if (w_cnt_q > {8 {1'sb0}})
						meta_sel_d = 1'b1;
					else if (r_cnt_q > {8 {1'sb0}})
						meta_sel_d = 1'b0;
					else
						meta_sel_d = ~meta_sel_q;
				end
			end
			if (arb_valid && !arb_ready)
				sel_lock_d = 1'b1;
		end
	end
	stream_fork #(.N_OUP(32'd3)) i_fork(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(arb_valid),
		.ready_o(arb_ready),
		.valid_o({sel_valid, meta_valid, m2s_req_valid}),
		.ready_i({sel_ready, meta_ready, m2s_req_ready})
	);
	assign sel_b = meta[1 + (UserWidth + 10)] & meta[9 + (UserWidth + 10)];
	assign sel_r = ~meta[1 + (UserWidth + 10)] | meta[7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))];
	stream_fifo_90DF0 #(
		.FALL_THROUGH(1'b1),
		.DEPTH(32'd1 + BufDepth)
	) i_sel_buf(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(1'b0),
		.testmode_i(1'b0),
		.data_i({sel_b, sel_r}),
		.valid_i(sel_valid),
		.ready_o(sel_ready),
		.data_o({sel_buf_b, sel_buf_r}),
		.valid_o(sel_buf_valid),
		.ready_i(sel_buf_ready),
		.usage_o()
	);
	stream_fifo_75E84_6CEC6 #(
		.T_AddrWidth(AddrWidth),
		.T_DataWidth(DataWidth),
		.T_IdWidth(IdWidth),
		.T_UserWidth(UserWidth),
		.FALL_THROUGH(1'b1),
		.DEPTH(32'd1 + BufDepth)
	) i_meta_buf(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(1'b0),
		.testmode_i(1'b0),
		.data_i(meta),
		.valid_i(meta_valid),
		.ready_o(meta_ready),
		.data_o(meta_buf),
		.valid_o(meta_buf_valid),
		.ready_i(meta_buf_ready),
		.usage_o()
	);
	function automatic [DataWidth - 1:0] sv2v_cast_8536A;
		input reg [DataWidth - 1:0] inp;
		sv2v_cast_8536A = inp;
	endfunction
	function automatic [((((((((AddrWidth + 7) + (DataWidth / 8)) + DataWidth) + 1) + IdWidth) + UserWidth) + 14) >= 0 ? ((((((AddrWidth + 7) + (DataWidth / 8)) + DataWidth) + 1) + IdWidth) + UserWidth) + 15 : 1 - (((((((AddrWidth + 7) + (DataWidth / 8)) + DataWidth) + 1) + IdWidth) + UserWidth) + 14)) - 1:0] sv2v_cast_332FF;
		input reg [((((((((AddrWidth + 7) + (DataWidth / 8)) + DataWidth) + 1) + IdWidth) + UserWidth) + 14) >= 0 ? ((((((AddrWidth + 7) + (DataWidth / 8)) + DataWidth) + 1) + IdWidth) + UserWidth) + 15 : 1 - (((((((AddrWidth + 7) + (DataWidth / 8)) + DataWidth) + 1) + IdWidth) + UserWidth) + 14)) - 1:0] inp;
		sv2v_cast_332FF = inp;
	endfunction
	assign m2s_req = sv2v_cast_332FF({sv2v_cast_79459(meta[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)]), sv2v_cast_6(meta[7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))-:((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))) >= (1 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))) - (1 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((1 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) + 1)]), meta[1 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))], sv2v_cast_B5889(axi_req_i[((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))) - (((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) - 1) - ((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0)))-:(((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0)) >= (1 + (axi_req_t_axi_req_t_UserWidth + 0)) ? (((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0)) - (1 + (axi_req_t_axi_req_t_UserWidth + 0))) + 1 : ((1 + (axi_req_t_axi_req_t_UserWidth + 0)) - ((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0))) + 1)]), sv2v_cast_8536A(axi_req_i[((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) + (2 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1))) - (((((axi_req_t_axi_req_t_DataWidth + (axi_req_t_axi_req_t_DataWidth / 8)) + 1) + axi_req_t_axi_req_t_UserWidth) - 1) - (axi_req_t_axi_req_t_DataWidth + ((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0))))-:((axi_req_t_axi_req_t_DataWidth + ((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0))) >= ((axi_req_t_axi_req_t_DataWidth / 8) + (1 + (axi_req_t_axi_req_t_UserWidth + 0))) ? ((axi_req_t_axi_req_t_DataWidth + ((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0))) - ((axi_req_t_axi_req_t_DataWidth / 8) + (1 + (axi_req_t_axi_req_t_UserWidth + 0)))) + 1 : (((axi_req_t_axi_req_t_DataWidth / 8) + (1 + (axi_req_t_axi_req_t_UserWidth + 0))) - (axi_req_t_axi_req_t_DataWidth + ((axi_req_t_axi_req_t_DataWidth / 8) + (axi_req_t_axi_req_t_UserWidth + 0)))) + 1)]), meta[1 + (UserWidth + 10)], sv2v_cast_C5469(meta[IdWidth + (9 + (UserWidth + 10))-:((IdWidth + (9 + (UserWidth + 10))) >= (9 + (UserWidth + 11)) ? ((IdWidth + (9 + (UserWidth + 10))) - (9 + (UserWidth + 11))) + 1 : ((9 + (UserWidth + 11)) - (IdWidth + (9 + (UserWidth + 10)))) + 1)]), sv2v_cast_2A58B(meta[UserWidth + 10-:((UserWidth + 10) >= 11 ? UserWidth + 0 : 12 - (UserWidth + 10))]), sv2v_cast_4(meta[10-:4]), sv2v_cast_3(meta[6-:3]), sv2v_cast_4(meta[8 + (UserWidth + 10)-:((8 + (UserWidth + 10)) >= (4 + (UserWidth + 11)) ? ((8 + (UserWidth + 10)) - (4 + (UserWidth + 11))) + 1 : ((4 + (UserWidth + 11)) - (8 + (UserWidth + 10))) + 1)]), sv2v_cast_4(meta[3-:4])});
	stream_to_mem_EE5E3_519A3 #(
		.mem_req_t_AddrWidth(AddrWidth),
		.mem_req_t_DataWidth(DataWidth),
		.mem_req_t_IdWidth(IdWidth),
		.mem_req_t_UserWidth(UserWidth),
		.mem_resp_t_DataWidth(DataWidth),
		.mem_resp_t_NumBanks(NumBanks),
		.BufDepth(BufDepth)
	) i_stream_to_mem(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.req_i(m2s_req),
		.req_valid_i(m2s_req_valid),
		.req_ready_o(m2s_req_ready),
		.resp_o(m2s_resp),
		.resp_valid_o(m2s_resp_valid),
		.resp_ready_i(m2s_resp_ready),
		.mem_req_o(mem_req),
		.mem_req_valid_o(mem_req_valid),
		.mem_req_ready_i(mem_req_ready),
		.mem_resp_i(mem_rdata),
		.mem_resp_valid_i(mem_rvalid)
	);
	wire [((7 + IdWidth) + UserWidth) + 14:0] mem_req_atop;
	wire [((((7 + IdWidth) + UserWidth) + 14) >= 0 ? (NumBanks * (((7 + IdWidth) + UserWidth) + 15)) - 1 : (NumBanks * (1 - (((7 + IdWidth) + UserWidth) + 14))) + (((7 + IdWidth) + UserWidth) + 13)):((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 0 : ((7 + IdWidth) + UserWidth) + 14)] banked_req_atop;
	assign mem_req_atop = {sv2v_cast_6(mem_req[7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14)))))-:((7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14)))))) >= (1 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 15)))))) ? ((7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14)))))) - (1 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 15))))))) + 1 : ((1 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 15)))))) - (7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14))))))) + 1)]), mem_req[1 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14)))))], sv2v_cast_C5469(mem_req[IdWidth + (UserWidth + 14)-:((IdWidth + (UserWidth + 14)) >= (UserWidth + 15) ? ((IdWidth + (UserWidth + 14)) - (UserWidth + 15)) + 1 : ((UserWidth + 15) - (IdWidth + (UserWidth + 14))) + 1)]), sv2v_cast_2A58B(mem_req[UserWidth + 14-:((UserWidth + 14) >= 15 ? UserWidth + 0 : 16 - (UserWidth + 14))]), sv2v_cast_4(mem_req[14-:4]), sv2v_cast_3(mem_req[10-:3]), sv2v_cast_4(mem_req[7-:4]), sv2v_cast_4(mem_req[3-:4])};
	genvar _gv_i_5;
	generate
		for (_gv_i_5 = 0; _gv_i_5 < NumBanks; _gv_i_5 = _gv_i_5 + 1) begin : genblk1
			localparam i = _gv_i_5;
			assign mem_atop_o[i * 6+:6] = banked_req_atop[((((7 + IdWidth) + UserWidth) + 14) >= 0 ? (i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 7 + (IdWidth + (UserWidth + 14)) : (((7 + IdWidth) + UserWidth) + 14) - (7 + (IdWidth + (UserWidth + 14)))) : (((i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 7 + (IdWidth + (UserWidth + 14)) : (((7 + IdWidth) + UserWidth) + 14) - (7 + (IdWidth + (UserWidth + 14))))) + ((7 + (IdWidth + (UserWidth + 14))) >= (1 + (IdWidth + (UserWidth + 15))) ? ((7 + (IdWidth + (UserWidth + 14))) - (1 + (IdWidth + (UserWidth + 15)))) + 1 : ((1 + (IdWidth + (UserWidth + 15))) - (7 + (IdWidth + (UserWidth + 14)))) + 1)) - 1)-:((7 + (IdWidth + (UserWidth + 14))) >= (1 + (IdWidth + (UserWidth + 15))) ? ((7 + (IdWidth + (UserWidth + 14))) - (1 + (IdWidth + (UserWidth + 15)))) + 1 : ((1 + (IdWidth + (UserWidth + 15))) - (7 + (IdWidth + (UserWidth + 14)))) + 1)];
			assign mem_lock_o[i] = banked_req_atop[(i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 1 + (IdWidth + (UserWidth + 14)) : (((7 + IdWidth) + UserWidth) + 14) - (1 + (IdWidth + (UserWidth + 14))))];
			assign mem_id_o[i * IdWidth+:IdWidth] = banked_req_atop[((((7 + IdWidth) + UserWidth) + 14) >= 0 ? (i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? IdWidth + (UserWidth + 14) : (((7 + IdWidth) + UserWidth) + 14) - (IdWidth + (UserWidth + 14))) : (((i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? IdWidth + (UserWidth + 14) : (((7 + IdWidth) + UserWidth) + 14) - (IdWidth + (UserWidth + 14)))) + ((IdWidth + (UserWidth + 14)) >= (UserWidth + 15) ? ((IdWidth + (UserWidth + 14)) - (UserWidth + 15)) + 1 : ((UserWidth + 15) - (IdWidth + (UserWidth + 14))) + 1)) - 1)-:((IdWidth + (UserWidth + 14)) >= (UserWidth + 15) ? ((IdWidth + (UserWidth + 14)) - (UserWidth + 15)) + 1 : ((UserWidth + 15) - (IdWidth + (UserWidth + 14))) + 1)];
			assign mem_user_o[i * UserWidth+:UserWidth] = banked_req_atop[((((7 + IdWidth) + UserWidth) + 14) >= 0 ? (i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? UserWidth + 14 : (((7 + IdWidth) + UserWidth) + 14) - (UserWidth + 14)) : (((i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? UserWidth + 14 : (((7 + IdWidth) + UserWidth) + 14) - (UserWidth + 14))) + ((UserWidth + 14) >= 15 ? UserWidth + 0 : 16 - (UserWidth + 14))) - 1)-:((UserWidth + 14) >= 15 ? UserWidth + 0 : 16 - (UserWidth + 14))];
			assign mem_cache_o[i * 4+:4] = banked_req_atop[((((7 + IdWidth) + UserWidth) + 14) >= 0 ? (i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 14 : ((7 + IdWidth) + UserWidth) + 0) : ((i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 14 : ((7 + IdWidth) + UserWidth) + 0)) + 3)-:4];
			assign mem_prot_o[i * 3+:3] = banked_req_atop[((((7 + IdWidth) + UserWidth) + 14) >= 0 ? (i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 10 : ((7 + IdWidth) + UserWidth) + 4) : ((i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 10 : ((7 + IdWidth) + UserWidth) + 4)) + 2)-:3];
			assign mem_qos_o[i * 4+:4] = banked_req_atop[((((7 + IdWidth) + UserWidth) + 14) >= 0 ? (i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 7 : ((7 + IdWidth) + UserWidth) + 7) : ((i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 7 : ((7 + IdWidth) + UserWidth) + 7)) + 3)-:4];
			assign mem_region_o[i * 4+:4] = banked_req_atop[((((7 + IdWidth) + UserWidth) + 14) >= 0 ? (i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 3 : ((7 + IdWidth) + UserWidth) + 11) : ((i * ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14))) + ((((7 + IdWidth) + UserWidth) + 14) >= 0 ? 3 : ((7 + IdWidth) + UserWidth) + 11)) + 3)-:4];
		end
	endgenerate
	wire [(NumBanks * 2) - 1:0] tmp_ersp;
	wire [(NumBanks * 2) - 1:0] bank_ersp;
	genvar _gv_i_6;
	generate
		for (_gv_i_6 = 0; _gv_i_6 < NumBanks; _gv_i_6 = _gv_i_6 + 1) begin : genblk2
			localparam i = _gv_i_6;
			assign mem_rdata[(NumBanks + (NumBanks - 1)) - ((NumBanks - 1) - i)] = tmp_ersp[i * 2];
			assign mem_rdata[(NumBanks - 1) - ((NumBanks - 1) - i)] = tmp_ersp[(i * 2) + 1];
			assign bank_ersp[i * 2] = mem_err_i[i];
			assign bank_ersp[(i * 2) + 1] = mem_exokay_i[i];
		end
	endgenerate
	mem_to_banks_detailed #(
		.AddrWidth(AddrWidth),
		.DataWidth(DataWidth),
		.RUserWidth(2),
		.NumBanks(NumBanks),
		.HideStrb(HideStrb),
		.MaxTrans(BufDepth),
		.FifoDepth(OutFifoDepth),
		.WUserWidth(((((7 + IdWidth) + UserWidth) + 14) >= 0 ? ((7 + IdWidth) + UserWidth) + 15 : 1 - (((7 + IdWidth) + UserWidth) + 14)))
	) i_mem_to_banks(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.req_i(mem_req_valid),
		.gnt_o(mem_req_ready),
		.addr_i(mem_req[AddrWidth + (7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14))))))-:((AddrWidth + (7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14))))))) >= (7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 15)))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14))))))) - (7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 15))))))) + 1 : ((7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 15)))))) - (AddrWidth + (7 + ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14)))))))) + 1)]),
		.wdata_i(mem_req[DataWidth + (1 + (IdWidth + (UserWidth + 14)))-:((DataWidth + (1 + (IdWidth + (UserWidth + 14)))) >= (1 + (IdWidth + (UserWidth + 15))) ? ((DataWidth + (1 + (IdWidth + (UserWidth + 14)))) - (1 + (IdWidth + (UserWidth + 15)))) + 1 : ((1 + (IdWidth + (UserWidth + 15))) - (DataWidth + (1 + (IdWidth + (UserWidth + 14))))) + 1)]),
		.strb_i(mem_req[(DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14))))-:(((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14))))) >= (DataWidth + (1 + (IdWidth + (UserWidth + 15)))) ? (((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14))))) - (DataWidth + (1 + (IdWidth + (UserWidth + 15))))) + 1 : ((DataWidth + (1 + (IdWidth + (UserWidth + 15)))) - ((DataWidth / 8) + (DataWidth + (1 + (IdWidth + (UserWidth + 14)))))) + 1)]),
		.wuser_i(mem_req_atop),
		.we_i(mem_req[1 + (IdWidth + (UserWidth + 14))]),
		.rvalid_o(mem_rvalid),
		.rdata_o(mem_rdata[DataWidth + (NumBanks + (NumBanks - 1))-:((DataWidth + (NumBanks + (NumBanks - 1))) >= (NumBanks + (NumBanks + 0)) ? ((DataWidth + (NumBanks + (NumBanks - 1))) - (NumBanks + (NumBanks + 0))) + 1 : ((NumBanks + (NumBanks + 0)) - (DataWidth + (NumBanks + (NumBanks - 1)))) + 1)]),
		.ruser_o(tmp_ersp),
		.bank_req_o(mem_req_o),
		.bank_gnt_i(mem_gnt_i),
		.bank_addr_o(mem_addr_o),
		.bank_wdata_o(mem_wdata_o),
		.bank_strb_o(mem_strb_o),
		.bank_wuser_o(banked_req_atop),
		.bank_we_o(mem_we_o),
		.bank_rvalid_i(mem_rvalid_i),
		.bank_rdata_i(mem_rdata_i),
		.bank_ruser_i(bank_ersp)
	);
	wire mem_join_valid;
	wire mem_join_ready;
	stream_join #(.N_INP(32'd2)) i_join(
		.inp_valid_i({m2s_resp_valid, meta_buf_valid}),
		.inp_ready_o({m2s_resp_ready, meta_buf_ready}),
		.oup_valid_o(mem_join_valid),
		.oup_ready_i(mem_join_ready)
	);
	wire [2:1] sv2v_tmp_i_fork_dynamic_valid_o;
	always @(*) {axi_resp_o[1 + (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))], axi_resp_o[(((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0]} = sv2v_tmp_i_fork_dynamic_valid_o;
	stream_fork_dynamic #(.N_OUP(32'd2)) i_fork_dynamic(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(mem_join_valid),
		.ready_o(mem_join_ready),
		.sel_i({sel_buf_b, sel_buf_r}),
		.sel_valid_i(sel_buf_valid),
		.sel_ready_o(sel_buf_ready),
		.valid_o(sv2v_tmp_i_fork_dynamic_valid_o),
		.ready_i({axi_req_i[1 + ((((axi_req_t_axi_req_t_IdWidth + axi_req_t_axi_req_t_MemAddrWidth) + 29) + axi_req_t_axi_req_t_UserWidth) + 1)], axi_req_i[0]})
	);
	localparam NumBytesPerBank = (DataWidth / NumBanks) / 8;
	wire [NumBanks - 1:0] meta_buf_bank_strb;
	wire [NumBanks - 1:0] meta_buf_size_enable;
	wire resp_b_err;
	wire resp_b_exokay;
	wire resp_r_err;
	wire resp_r_exokay;
	genvar _gv_i_7;
	generate
		for (_gv_i_7 = 0; _gv_i_7 < NumBanks; _gv_i_7 = _gv_i_7 + 1) begin : genblk3
			localparam i = _gv_i_7;
			assign meta_buf_bank_strb[i] = |meta_buf[((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))) - (((DataWidth / 8) - 1) - (i * NumBytesPerBank))+:NumBytesPerBank];
			assign meta_buf_size_enable[i] = (((i * NumBytesPerBank) + NumBytesPerBank) > ((meta_buf[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)] % DataWidth) / 8)) && ((i * NumBytesPerBank) < ((((meta_buf[AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))-:((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) >= (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) ? ((AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10)))))) - (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11)))))) + 1 : ((7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 11))))) - (AddrWidth + (7 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))))) + 1)] % DataWidth) / 8) + 1) << meta_buf[4 + (UserWidth + 10)-:((4 + (UserWidth + 10)) >= (1 + (UserWidth + 11)) ? ((4 + (UserWidth + 10)) - (1 + (UserWidth + 11))) + 1 : ((1 + (UserWidth + 11)) - (4 + (UserWidth + 10))) + 1)]));
		end
	endgenerate
	assign resp_b_err = |(m2s_resp[NumBanks + (NumBanks - 1)-:((NumBanks + (NumBanks - 1)) >= (NumBanks + 0) ? ((NumBanks + (NumBanks - 1)) - (NumBanks + 0)) + 1 : ((NumBanks + 0) - (NumBanks + (NumBanks - 1))) + 1)] & meta_buf_bank_strb);
	assign resp_b_exokay = &(m2s_resp[NumBanks - 1-:NumBanks] | ~meta_buf_bank_strb) & meta_buf[1 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))];
	assign resp_r_err = |(m2s_resp[NumBanks + (NumBanks - 1)-:((NumBanks + (NumBanks - 1)) >= (NumBanks + 0) ? ((NumBanks + (NumBanks - 1)) - (NumBanks + 0)) + 1 : ((NumBanks + 0) - (NumBanks + (NumBanks - 1))) + 1)] & meta_buf_size_enable);
	assign resp_r_exokay = &(m2s_resp[NumBanks - 1-:NumBanks] | ~meta_buf_size_enable) & meta_buf[1 + ((DataWidth / 8) + (IdWidth + (9 + (UserWidth + 10))))];
	reg collect_b_err_d;
	reg collect_b_err_q;
	reg collect_b_exokay_d;
	reg collect_b_exokay_q;
	wire next_collect_b_err;
	wire next_collect_b_exokay;
	assign next_collect_b_err = collect_b_err_q | resp_b_err;
	assign next_collect_b_exokay = collect_b_exokay_q & resp_b_exokay;
	always @(*) begin
		if (_sv2v_0)
			;
		collect_b_err_d = collect_b_err_q;
		collect_b_exokay_d = collect_b_exokay_q;
		if (sel_buf_valid && sel_buf_ready) begin
			if (meta_buf[1 + (UserWidth + 10)] && meta_buf[9 + (UserWidth + 10)]) begin
				collect_b_err_d = 1'b0;
				collect_b_exokay_d = 1'b1;
			end
			else if (meta_buf[1 + (UserWidth + 10)]) begin
				collect_b_err_d = next_collect_b_err;
				collect_b_exokay_d = next_collect_b_exokay;
			end
		end
	end
	localparam axi_pkg_RESP_EXOKAY = 2'b01;
	localparam axi_pkg_RESP_OKAY = 2'b00;
	localparam axi_pkg_RESP_SLVERR = 2'b10;
	function automatic [axi_resp_t_axi_resp_t_IdWidth - 1:0] sv2v_cast_F1F63;
		input reg [axi_resp_t_axi_resp_t_IdWidth - 1:0] inp;
		sv2v_cast_F1F63 = inp;
	endfunction
	function automatic [axi_resp_t_axi_resp_t_UserWidth - 1:0] sv2v_cast_CAF6D;
		input reg [axi_resp_t_axi_resp_t_UserWidth - 1:0] inp;
		sv2v_cast_CAF6D = inp;
	endfunction
	wire [((((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0)) >= (1 + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0)) ? ((((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0)) - (1 + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))) + 1 : ((1 + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0)) - (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))) + 1) * 1:1] sv2v_tmp_DEAAE;
	assign sv2v_tmp_DEAAE = {sv2v_cast_F1F63(meta_buf[IdWidth + (9 + (UserWidth + 10))-:((IdWidth + (9 + (UserWidth + 10))) >= (9 + (UserWidth + 11)) ? ((IdWidth + (9 + (UserWidth + 10))) - (9 + (UserWidth + 11))) + 1 : ((9 + (UserWidth + 11)) - (IdWidth + (9 + (UserWidth + 10)))) + 1)]), (next_collect_b_err ? axi_pkg_RESP_SLVERR : (next_collect_b_exokay ? axi_pkg_RESP_EXOKAY : axi_pkg_RESP_OKAY)), sv2v_cast_CAF6D(1'sb0)};
	always @(*) axi_resp_o[((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0)-:((((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0)) >= (1 + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0)) ? ((((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0)) - (1 + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))) + 1 : ((1 + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0)) - (((axi_resp_t_axi_resp_t_IdWidth + 2) + axi_resp_t_axi_resp_t_UserWidth) + ((((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) + 0))) + 1)] = sv2v_tmp_DEAAE;
	function automatic [axi_resp_t_axi_resp_t_DataWidth - 1:0] sv2v_cast_D0E4C;
		input reg [axi_resp_t_axi_resp_t_DataWidth - 1:0] inp;
		sv2v_cast_D0E4C = inp;
	endfunction
	wire [(((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) * 1:1] sv2v_tmp_F544A;
	assign sv2v_tmp_F544A = {sv2v_cast_F1F63(meta_buf[IdWidth + (9 + (UserWidth + 10))-:((IdWidth + (9 + (UserWidth + 10))) >= (9 + (UserWidth + 11)) ? ((IdWidth + (9 + (UserWidth + 10))) - (9 + (UserWidth + 11))) + 1 : ((9 + (UserWidth + 11)) - (IdWidth + (9 + (UserWidth + 10)))) + 1)]), sv2v_cast_D0E4C(m2s_resp[DataWidth + (NumBanks + (NumBanks - 1))-:((DataWidth + (NumBanks + (NumBanks - 1))) >= (NumBanks + (NumBanks + 0)) ? ((DataWidth + (NumBanks + (NumBanks - 1))) - (NumBanks + (NumBanks + 0))) + 1 : ((NumBanks + (NumBanks + 0)) - (DataWidth + (NumBanks + (NumBanks - 1)))) + 1)]), (resp_r_err ? axi_pkg_RESP_SLVERR : (resp_r_exokay ? axi_pkg_RESP_EXOKAY : axi_pkg_RESP_OKAY)), meta_buf[9 + (UserWidth + 10)], sv2v_cast_CAF6D(1'sb0)};
	always @(*) axi_resp_o[(((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth) - 1-:((axi_resp_t_axi_resp_t_IdWidth + axi_resp_t_axi_resp_t_DataWidth) + 3) + axi_resp_t_axi_resp_t_UserWidth] = sv2v_tmp_F544A;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			meta_sel_q <= 1'b0;
		else
			meta_sel_q <= meta_sel_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			sel_lock_q <= 1'b0;
		else
			sel_lock_q <= sel_lock_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			rd_meta_q <= sv2v_cast_71D75({sv2v_cast_6171F(1'sb0), 7'b0000000, sv2v_cast_74977(1'sb0), sv2v_cast_0E8C3(1'sb0), 9'b000000000, sv2v_cast_CD06D(1'sb0), 11'b00000000000});
		else
			rd_meta_q <= rd_meta_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			wr_meta_q <= sv2v_cast_71D75({sv2v_cast_6171F(1'sb0), 7'b0000000, sv2v_cast_74977(1'sb0), sv2v_cast_0E8C3(1'sb0), 9'b000000000, sv2v_cast_CD06D(1'sb0), 11'b00000000000});
		else
			wr_meta_q <= wr_meta_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			r_cnt_q <= 1'sb0;
		else
			r_cnt_q <= r_cnt_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			w_cnt_q <= 1'sb0;
		else
			w_cnt_q <= w_cnt_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			collect_b_err_q <= 1'sb0;
		else
			collect_b_err_q <= collect_b_err_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			collect_b_exokay_q <= 1'b1;
		else
			collect_b_exokay_q <= collect_b_exokay_d;
	initial _sv2v_0 = 0;
endmodule
