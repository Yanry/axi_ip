module axi_lite_to_axi_10175_F31BF (
	slv_req_lite_i,
	slv_resp_lite_o,
	slv_aw_cache_i,
	slv_ar_cache_i,
	mst_req_o,
	mst_resp_i
);
	parameter [31:0] req_lite_t_AxiAddrWidth = 0;
	parameter [31:0] req_lite_t_DataWidth = 0;
	parameter [31:0] resp_lite_t_DataWidth = 0;
	parameter [31:0] AxiDataWidth = 32'd0;
	input wire [((((((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1) + (req_lite_t_DataWidth + (req_lite_t_DataWidth / 8))) + 2) + ((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2))) + 1:0] slv_req_lite_i;
	output wire [(6 + ((resp_lite_t_DataWidth + 1) >= 0 ? resp_lite_t_DataWidth + 2 : 1 - (resp_lite_t_DataWidth + 1))) + 0:0] slv_resp_lite_o;
	input wire [3:0] slv_aw_cache_i;
	input wire [3:0] slv_ar_cache_i;
	output wire mst_req_o;
	input wire mst_resp_i;
	function automatic [2:0] sv2v_cast_3;
		input reg [2:0] inp;
		sv2v_cast_3 = inp;
	endfunction
	localparam [31:0] AxiSize = sv2v_cast_3($unsigned($clog2(AxiDataWidth / 8)));
	localparam axi_pkg_BURST_FIXED = 2'b00;
	assign mst_req_o = '{
		aw: '{
			addr: slv_req_lite_i[((req_lite_t_AxiAddrWidth + 2) >= 0 ? (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + (1 + ((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1))))) - ((req_lite_t_AxiAddrWidth + 2) - (req_lite_t_AxiAddrWidth + 2)) : (((1 + ((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 2)))) - (req_lite_t_AxiAddrWidth + 2)) + ((req_lite_t_AxiAddrWidth + 2) >= 3 ? req_lite_t_AxiAddrWidth + 0 : 4 - (req_lite_t_AxiAddrWidth + 2))) - 1)-:((req_lite_t_AxiAddrWidth + 2) >= 3 ? req_lite_t_AxiAddrWidth + 0 : 4 - (req_lite_t_AxiAddrWidth + 2))],
			prot: slv_req_lite_i[((req_lite_t_AxiAddrWidth + 2) >= 0 ? (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + (1 + ((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1))))) - (req_lite_t_AxiAddrWidth + 0) : 1 + ((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 2))))-:3],
			size: AxiSize,
			burst: axi_pkg_BURST_FIXED,
			cache: slv_aw_cache_i,
			default: 1'sb0
		},
		aw_valid: slv_req_lite_i[1 + ((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1)))],
		w: '{
			data: slv_req_lite_i[((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1))) - (((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) - 1) - (req_lite_t_DataWidth + ((req_lite_t_DataWidth / 8) - 1)))-:((req_lite_t_DataWidth + ((req_lite_t_DataWidth / 8) - 1)) >= ((req_lite_t_DataWidth / 8) + 0) ? ((req_lite_t_DataWidth + ((req_lite_t_DataWidth / 8) - 1)) - ((req_lite_t_DataWidth / 8) + 0)) + 1 : (((req_lite_t_DataWidth / 8) + 0) - (req_lite_t_DataWidth + ((req_lite_t_DataWidth / 8) - 1))) + 1)],
			strb: slv_req_lite_i[((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1))) - (((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) - 1) - ((req_lite_t_DataWidth / 8) - 1))-:req_lite_t_DataWidth / 8],
			last: 1'b1,
			default: 1'sb0
		},
		w_valid: slv_req_lite_i[2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1)],
		b_ready: slv_req_lite_i[1 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1)],
		ar: '{
			addr: slv_req_lite_i[((req_lite_t_AxiAddrWidth + 2) >= 0 ? (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1) - ((req_lite_t_AxiAddrWidth + 2) - (req_lite_t_AxiAddrWidth + 2)) : ((2 - (req_lite_t_AxiAddrWidth + 2)) + ((req_lite_t_AxiAddrWidth + 2) >= 3 ? req_lite_t_AxiAddrWidth + 0 : 4 - (req_lite_t_AxiAddrWidth + 2))) - 1)-:((req_lite_t_AxiAddrWidth + 2) >= 3 ? req_lite_t_AxiAddrWidth + 0 : 4 - (req_lite_t_AxiAddrWidth + 2))],
			prot: slv_req_lite_i[((req_lite_t_AxiAddrWidth + 2) >= 0 ? (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1) - (req_lite_t_AxiAddrWidth + 0) : 2)-:3],
			size: AxiSize,
			burst: axi_pkg_BURST_FIXED,
			cache: slv_ar_cache_i,
			default: 1'sb0
		},
		ar_valid: slv_req_lite_i[1],
		r_ready: slv_req_lite_i[0],
		default: 1'sb0
	};
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	function automatic [resp_lite_t_DataWidth - 1:0] sv2v_cast_1293D;
		input reg [resp_lite_t_DataWidth - 1:0] inp;
		sv2v_cast_1293D = inp;
	endfunction
	function automatic [0:0] sv2v_cast_1;
		input reg [0:0] inp;
		sv2v_cast_1 = inp;
	endfunction
	function automatic [((resp_lite_t_DataWidth + 1) >= 0 ? resp_lite_t_DataWidth + 2 : 1 - (resp_lite_t_DataWidth + 1)) - 1:0] sv2v_cast_BE32A;
		input reg [((resp_lite_t_DataWidth + 1) >= 0 ? resp_lite_t_DataWidth + 2 : 1 - (resp_lite_t_DataWidth + 1)) - 1:0] inp;
		sv2v_cast_BE32A = inp;
	endfunction
	assign slv_resp_lite_o = {sv2v_cast_1(mst_resp_i.aw_ready), sv2v_cast_1(mst_resp_i.w_ready), sv2v_cast_2({sv2v_cast_2(mst_resp_i.b.resp)}), sv2v_cast_1(mst_resp_i.b_valid), sv2v_cast_1(mst_resp_i.ar_ready), sv2v_cast_BE32A({sv2v_cast_1293D(mst_resp_i.r.data), sv2v_cast_2(mst_resp_i.r.resp)}), sv2v_cast_1(mst_resp_i.r_valid)};
endmodule
