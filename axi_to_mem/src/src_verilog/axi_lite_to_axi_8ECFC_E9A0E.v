module axi_lite_to_axi_8ECFC_E9A0E (
	slv_req_lite_i,
	slv_resp_lite_o,
	slv_aw_cache_i,
	slv_ar_cache_i,
	mst_req_o,
	mst_resp_i
);
	parameter [31:0] axi_req_t_DataWidth = 0;
	parameter [31:0] axi_req_t_IdWidth = 0;
	parameter [31:0] axi_req_t_MemAddrWidth = 0;
	parameter [31:0] axi_req_t_UserWidth = 0;
	parameter [31:0] axi_resp_t_DataWidth = 0;
	parameter [31:0] axi_resp_t_IdWidth = 0;
	parameter [31:0] axi_resp_t_UserWidth = 0;
	parameter [31:0] req_lite_t_AxiAddrWidth = 0;
	parameter [31:0] req_lite_t_DataWidth = 0;
	parameter [31:0] resp_lite_t_DataWidth = 0;
	parameter [31:0] AxiDataWidth = 32'd0;
	input wire [((((((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1) + (req_lite_t_DataWidth + (req_lite_t_DataWidth / 8))) + 2) + ((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2))) + 1:0] slv_req_lite_i;
	output wire [(6 + ((resp_lite_t_DataWidth + 1) >= 0 ? resp_lite_t_DataWidth + 2 : 1 - (resp_lite_t_DataWidth + 1))) + 0:0] slv_resp_lite_o;
	input wire [3:0] slv_aw_cache_i;
	input wire [3:0] slv_ar_cache_i;
	output wire [(((((((axi_req_t_IdWidth + axi_req_t_MemAddrWidth) + 35) + axi_req_t_UserWidth) + 1) + (((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + 1) + axi_req_t_UserWidth)) + 2) + (((axi_req_t_IdWidth + axi_req_t_MemAddrWidth) + 29) + axi_req_t_UserWidth)) + 1:0] mst_req_o;
	input wire [(((4 + ((axi_resp_t_IdWidth + 2) + axi_resp_t_UserWidth)) + 1) + (((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth)) - 1:0] mst_resp_i;
	function automatic [2:0] sv2v_cast_3;
		input reg [2:0] inp;
		sv2v_cast_3 = inp;
	endfunction
	localparam [31:0] AxiSize = sv2v_cast_3($unsigned($clog2(AxiDataWidth / 8)));
	localparam axi_pkg_BURST_FIXED = 2'b00;
	function automatic [axi_req_t_IdWidth - 1:0] sv2v_cast_E7F32;
		input reg [axi_req_t_IdWidth - 1:0] inp;
		sv2v_cast_E7F32 = inp;
	endfunction
	function automatic [axi_req_t_MemAddrWidth - 1:0] sv2v_cast_AB0BE;
		input reg [axi_req_t_MemAddrWidth - 1:0] inp;
		sv2v_cast_AB0BE = inp;
	endfunction
	function automatic [axi_req_t_UserWidth - 1:0] sv2v_cast_74C7C;
		input reg [axi_req_t_UserWidth - 1:0] inp;
		sv2v_cast_74C7C = inp;
	endfunction
	function automatic [axi_req_t_DataWidth - 1:0] sv2v_cast_7CD9D;
		input reg [axi_req_t_DataWidth - 1:0] inp;
		sv2v_cast_7CD9D = inp;
	endfunction
	function automatic [(axi_req_t_DataWidth / 8) - 1:0] sv2v_cast_095BE;
		input reg [(axi_req_t_DataWidth / 8) - 1:0] inp;
		sv2v_cast_095BE = inp;
	endfunction
	function automatic [(((axi_req_t_IdWidth + axi_req_t_MemAddrWidth) + 35) + axi_req_t_UserWidth) - 1:0] sv2v_cast_7EF73;
		input reg [(((axi_req_t_IdWidth + axi_req_t_MemAddrWidth) + 35) + axi_req_t_UserWidth) - 1:0] inp;
		sv2v_cast_7EF73 = inp;
	endfunction
	function automatic [(((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + 1) + axi_req_t_UserWidth) - 1:0] sv2v_cast_5745E;
		input reg [(((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + 1) + axi_req_t_UserWidth) - 1:0] inp;
		sv2v_cast_5745E = inp;
	endfunction
	function automatic [(((axi_req_t_IdWidth + axi_req_t_MemAddrWidth) + 29) + axi_req_t_UserWidth) - 1:0] sv2v_cast_A281D;
		input reg [(((axi_req_t_IdWidth + axi_req_t_MemAddrWidth) + 29) + axi_req_t_UserWidth) - 1:0] inp;
		sv2v_cast_A281D = inp;
	endfunction
	assign mst_req_o = {sv2v_cast_7EF73({sv2v_cast_E7F32(1'sb0), sv2v_cast_AB0BE(slv_req_lite_i[((req_lite_t_AxiAddrWidth + 2) >= 0 ? (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + (1 + ((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1))))) - ((req_lite_t_AxiAddrWidth + 2) - (req_lite_t_AxiAddrWidth + 2)) : (((1 + ((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 2)))) - (req_lite_t_AxiAddrWidth + 2)) + ((req_lite_t_AxiAddrWidth + 2) >= 3 ? req_lite_t_AxiAddrWidth + 0 : 4 - (req_lite_t_AxiAddrWidth + 2))) - 1)-:((req_lite_t_AxiAddrWidth + 2) >= 3 ? req_lite_t_AxiAddrWidth + 0 : 4 - (req_lite_t_AxiAddrWidth + 2))]), 8'b00000000, sv2v_cast_3(AxiSize), axi_pkg_BURST_FIXED, 1'b0, slv_aw_cache_i, sv2v_cast_3(slv_req_lite_i[((req_lite_t_AxiAddrWidth + 2) >= 0 ? (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + (1 + ((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1))))) - (req_lite_t_AxiAddrWidth + 0) : 1 + ((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 2))))-:3]), 14'b00000000000000, sv2v_cast_74C7C(1'sb0)}), slv_req_lite_i[1 + ((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1)))], sv2v_cast_5745E({sv2v_cast_7CD9D(slv_req_lite_i[((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1))) - (((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) - 1) - (req_lite_t_DataWidth + ((req_lite_t_DataWidth / 8) - 1)))-:((req_lite_t_DataWidth + ((req_lite_t_DataWidth / 8) - 1)) >= ((req_lite_t_DataWidth / 8) + 0) ? ((req_lite_t_DataWidth + ((req_lite_t_DataWidth / 8) - 1)) - ((req_lite_t_DataWidth / 8) + 0)) + 1 : (((req_lite_t_DataWidth / 8) + 0) - (req_lite_t_DataWidth + ((req_lite_t_DataWidth / 8) - 1))) + 1)]), sv2v_cast_095BE(slv_req_lite_i[((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) + (2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1))) - (((req_lite_t_DataWidth + (req_lite_t_DataWidth / 8)) - 1) - ((req_lite_t_DataWidth / 8) - 1))-:req_lite_t_DataWidth / 8]), 1'b1, sv2v_cast_74C7C(1'sb0)}), slv_req_lite_i[2 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1)], slv_req_lite_i[1 + (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1)], sv2v_cast_A281D({sv2v_cast_E7F32(1'sb0), sv2v_cast_AB0BE(slv_req_lite_i[((req_lite_t_AxiAddrWidth + 2) >= 0 ? (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1) - ((req_lite_t_AxiAddrWidth + 2) - (req_lite_t_AxiAddrWidth + 2)) : ((2 - (req_lite_t_AxiAddrWidth + 2)) + ((req_lite_t_AxiAddrWidth + 2) >= 3 ? req_lite_t_AxiAddrWidth + 0 : 4 - (req_lite_t_AxiAddrWidth + 2))) - 1)-:((req_lite_t_AxiAddrWidth + 2) >= 3 ? req_lite_t_AxiAddrWidth + 0 : 4 - (req_lite_t_AxiAddrWidth + 2))]), 8'b00000000, sv2v_cast_3(AxiSize), axi_pkg_BURST_FIXED, 1'b0, slv_ar_cache_i, sv2v_cast_3(slv_req_lite_i[((req_lite_t_AxiAddrWidth + 2) >= 0 ? (((req_lite_t_AxiAddrWidth + 2) >= 0 ? req_lite_t_AxiAddrWidth + 3 : 1 - (req_lite_t_AxiAddrWidth + 2)) + 1) - (req_lite_t_AxiAddrWidth + 0) : 2)-:3]), 8'b00000000, sv2v_cast_74C7C(1'sb0)}), slv_req_lite_i[1], slv_req_lite_i[0]};
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	function automatic [resp_lite_t_DataWidth - 1:0] sv2v_cast_1293D;
		input reg [resp_lite_t_DataWidth - 1:0] inp;
		sv2v_cast_1293D = inp;
	endfunction
	function automatic [((resp_lite_t_DataWidth + 1) >= 0 ? resp_lite_t_DataWidth + 2 : 1 - (resp_lite_t_DataWidth + 1)) - 1:0] sv2v_cast_BE32A;
		input reg [((resp_lite_t_DataWidth + 1) >= 0 ? resp_lite_t_DataWidth + 2 : 1 - (resp_lite_t_DataWidth + 1)) - 1:0] inp;
		sv2v_cast_BE32A = inp;
	endfunction
	assign slv_resp_lite_o = {mst_resp_i[4 + (((axi_resp_t_IdWidth + 2) + axi_resp_t_UserWidth) + ((((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth) + 0))], mst_resp_i[2 + (((axi_resp_t_IdWidth + 2) + axi_resp_t_UserWidth) + ((((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth) + 0))], sv2v_cast_2({sv2v_cast_2(mst_resp_i[(((axi_resp_t_IdWidth + 2) + axi_resp_t_UserWidth) + ((((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth) + 0)) - ((((axi_resp_t_IdWidth + 2) + axi_resp_t_UserWidth) - 1) - (axi_resp_t_UserWidth + 1))-:((axi_resp_t_UserWidth + 1) >= (axi_resp_t_UserWidth + 0) ? ((axi_resp_t_UserWidth + 1) - (axi_resp_t_UserWidth + 0)) + 1 : ((axi_resp_t_UserWidth + 0) - (axi_resp_t_UserWidth + 1)) + 1)])}), mst_resp_i[1 + (((axi_resp_t_IdWidth + 2) + axi_resp_t_UserWidth) + ((((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth) + 0))], mst_resp_i[3 + (((axi_resp_t_IdWidth + 2) + axi_resp_t_UserWidth) + ((((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth) + 0))], sv2v_cast_BE32A({sv2v_cast_1293D(mst_resp_i[((((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth) - 1) - (((((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth) - 1) - (axi_resp_t_DataWidth + (axi_resp_t_UserWidth + 2)))-:((axi_resp_t_DataWidth + (axi_resp_t_UserWidth + 2)) >= (3 + (axi_resp_t_UserWidth + 0)) ? ((axi_resp_t_DataWidth + (axi_resp_t_UserWidth + 2)) - (3 + (axi_resp_t_UserWidth + 0))) + 1 : ((3 + (axi_resp_t_UserWidth + 0)) - (axi_resp_t_DataWidth + (axi_resp_t_UserWidth + 2))) + 1)]), sv2v_cast_2(mst_resp_i[((((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth) - 1) - (((((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth) - 1) - (axi_resp_t_UserWidth + 2))-:((axi_resp_t_UserWidth + 2) >= (1 + (axi_resp_t_UserWidth + 0)) ? ((axi_resp_t_UserWidth + 2) - (1 + (axi_resp_t_UserWidth + 0))) + 1 : ((1 + (axi_resp_t_UserWidth + 0)) - (axi_resp_t_UserWidth + 2)) + 1)])}), mst_resp_i[(((axi_resp_t_IdWidth + axi_resp_t_DataWidth) + 3) + axi_resp_t_UserWidth) + 0]};
endmodule
