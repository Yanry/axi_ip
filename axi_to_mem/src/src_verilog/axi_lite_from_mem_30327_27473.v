module axi_lite_from_mem_30327_27473 (
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
	axi_req_o,
	axi_rsp_i
);
	parameter [31:0] axi_req_t_AxiAddrWidth = 0;
	parameter [31:0] axi_req_t_DataWidth = 0;
	parameter [31:0] axi_rsp_t_DataWidth = 0;
	reg _sv2v_0;
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
	output reg mem_gnt_o;
	output wire mem_rsp_valid_o;
	output wire [DataWidth - 1:0] mem_rsp_rdata_o;
	output wire mem_rsp_error_o;
	output reg [((((((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1) + (axi_req_t_DataWidth + (axi_req_t_DataWidth / 8))) + 2) + ((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2))) + 1:0] axi_req_o;
	input wire [(6 + ((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1))) + 0:0] axi_rsp_i;
	wire fifo_full;
	wire fifo_empty;
	reg aw_sent_q;
	reg aw_sent_d;
	reg w_sent_q;
	reg w_sent_d;
	function automatic [AxiAddrWidth - 1:0] sv2v_cast_BE85C;
		input reg [AxiAddrWidth - 1:0] inp;
		sv2v_cast_BE85C = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		axi_req_o[((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + (1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))))-:((((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + (1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))))) >= (1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 2)))) ? ((((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + (1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))))) - (1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 2))))) + 1 : ((1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 2)))) - (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + (1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1)))))) + 1)] = 1'sb0;
		axi_req_o[((axi_req_t_AxiAddrWidth + 2) >= 0 ? (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + (1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))))) - ((axi_req_t_AxiAddrWidth + 2) - (axi_req_t_AxiAddrWidth + 2)) : (((1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 2)))) - (axi_req_t_AxiAddrWidth + 2)) + ((axi_req_t_AxiAddrWidth + 2) >= 3 ? axi_req_t_AxiAddrWidth + 0 : 4 - (axi_req_t_AxiAddrWidth + 2))) - 1)-:((axi_req_t_AxiAddrWidth + 2) >= 3 ? axi_req_t_AxiAddrWidth + 0 : 4 - (axi_req_t_AxiAddrWidth + 2))] = sv2v_cast_BE85C(mem_addr_i);
		axi_req_o[((axi_req_t_AxiAddrWidth + 2) >= 0 ? (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + (1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))))) - (axi_req_t_AxiAddrWidth + 0) : 1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 2))))-:3] = AxiProt;
		axi_req_o[1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1)))] = 1'b0;
		axi_req_o[(axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))-:(((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))) >= (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 2)) ? (((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))) - (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 2))) + 1 : ((2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 2)) - ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1)))) + 1)] = 1'sb0;
		axi_req_o[((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))) - (((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) - 1) - (axi_req_t_DataWidth + ((axi_req_t_DataWidth / 8) - 1)))-:((axi_req_t_DataWidth + ((axi_req_t_DataWidth / 8) - 1)) >= ((axi_req_t_DataWidth / 8) + 0) ? ((axi_req_t_DataWidth + ((axi_req_t_DataWidth / 8) - 1)) - ((axi_req_t_DataWidth / 8) + 0)) + 1 : (((axi_req_t_DataWidth / 8) + 0) - (axi_req_t_DataWidth + ((axi_req_t_DataWidth / 8) - 1))) + 1)] = mem_wdata_i;
		axi_req_o[((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))) - (((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) - 1) - ((axi_req_t_DataWidth / 8) - 1))-:axi_req_t_DataWidth / 8] = mem_be_i;
		axi_req_o[2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1)] = 1'b0;
		axi_req_o[((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1-:((((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1) >= 2 ? ((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 0 : 3 - (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1))] = 1'sb0;
		axi_req_o[((axi_req_t_AxiAddrWidth + 2) >= 0 ? (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1) - ((axi_req_t_AxiAddrWidth + 2) - (axi_req_t_AxiAddrWidth + 2)) : ((2 - (axi_req_t_AxiAddrWidth + 2)) + ((axi_req_t_AxiAddrWidth + 2) >= 3 ? axi_req_t_AxiAddrWidth + 0 : 4 - (axi_req_t_AxiAddrWidth + 2))) - 1)-:((axi_req_t_AxiAddrWidth + 2) >= 3 ? axi_req_t_AxiAddrWidth + 0 : 4 - (axi_req_t_AxiAddrWidth + 2))] = sv2v_cast_BE85C(mem_addr_i);
		axi_req_o[((axi_req_t_AxiAddrWidth + 2) >= 0 ? (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1) - (axi_req_t_AxiAddrWidth + 0) : 2)-:3] = AxiProt;
		axi_req_o[1] = 1'b0;
		mem_gnt_o = 1'b0;
		aw_sent_d = aw_sent_q;
		w_sent_d = w_sent_q;
		if (mem_req_i && !fifo_full) begin
			if (!mem_we_i) begin
				axi_req_o[1] = 1'b1;
				mem_gnt_o = axi_rsp_i[1 + (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0)];
			end
			else
				(* full_case, parallel_case *)
				case ({aw_sent_q, w_sent_q})
					2'b00: begin
						axi_req_o[1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1)))] = 1'b1;
						axi_req_o[2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1)] = 1'b1;
						(* full_case, parallel_case *)
						case ({axi_rsp_i[6 + (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0)], axi_rsp_i[5 + (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0)]})
							2'b01: w_sent_d = 1'b1;
							2'b10: aw_sent_d = 1'b1;
							2'b11: mem_gnt_o = 1'b1;
							default:
								;
						endcase
					end
					2'b10: begin
						axi_req_o[2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1)] = 1'b1;
						if (axi_rsp_i[5 + (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0)]) begin
							aw_sent_d = 1'b0;
							mem_gnt_o = 1'b1;
						end
					end
					2'b01: begin
						axi_req_o[1 + ((axi_req_t_DataWidth + (axi_req_t_DataWidth / 8)) + (2 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1)))] = 1'b1;
						if (axi_rsp_i[6 + (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0)]) begin
							w_sent_d = 1'b0;
							mem_gnt_o = 1'b1;
						end
					end
					default: begin
						aw_sent_d = 1'b0;
						w_sent_d = 1'b0;
					end
				endcase
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			aw_sent_q <= 1'b0;
		else
			aw_sent_q <= aw_sent_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			w_sent_q <= 1'b0;
		else
			w_sent_q <= w_sent_d;
	wire rsp_sel;
	fifo_v3_78C92 #(
		.FALL_THROUGH(1'b0),
		.DEPTH(MaxRequests)
	) i_fifo_rsp_mux(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(1'b0),
		.testmode_i(1'b0),
		.full_o(fifo_full),
		.empty_o(fifo_empty),
		.usage_o(),
		.data_i(mem_we_i),
		.push_i(mem_gnt_o),
		.data_o(rsp_sel),
		.pop_i(mem_rsp_valid_o)
	);
	wire [1:1] sv2v_tmp_BD645;
	assign sv2v_tmp_BD645 = !fifo_empty && rsp_sel;
	always @(*) axi_req_o[1 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1)] = sv2v_tmp_BD645;
	wire [1:1] sv2v_tmp_B6699;
	assign sv2v_tmp_B6699 = !fifo_empty && !rsp_sel;
	always @(*) axi_req_o[0] = sv2v_tmp_B6699;
	assign mem_rsp_rdata_o = axi_rsp_i[((axi_rsp_t_DataWidth + 1) >= 0 ? (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0) - ((axi_rsp_t_DataWidth + 1) - (axi_rsp_t_DataWidth + 1)) : ((1 - (axi_rsp_t_DataWidth + 1)) + ((axi_rsp_t_DataWidth + 1) >= 2 ? axi_rsp_t_DataWidth + 0 : 3 - (axi_rsp_t_DataWidth + 1))) - 1)-:((axi_rsp_t_DataWidth + 1) >= 2 ? axi_rsp_t_DataWidth + 0 : 3 - (axi_rsp_t_DataWidth + 1))];
	localparam axi_pkg_RESP_DECERR = 2'b11;
	localparam axi_pkg_RESP_SLVERR = 2'b10;
	assign mem_rsp_error_o = (rsp_sel ? |{axi_rsp_i[4 + (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0)-:2] == axi_pkg_RESP_SLVERR, axi_rsp_i[4 + (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0)-:2] == axi_pkg_RESP_DECERR} : |{axi_rsp_i[((axi_rsp_t_DataWidth + 1) >= 0 ? (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0) - (axi_rsp_t_DataWidth + 0) : 1)-:2] == axi_pkg_RESP_SLVERR, axi_rsp_i[((axi_rsp_t_DataWidth + 1) >= 0 ? (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0) - (axi_rsp_t_DataWidth + 0) : 1)-:2] == axi_pkg_RESP_DECERR});
	assign mem_rsp_valid_o = (axi_rsp_i[2 + (((axi_rsp_t_DataWidth + 1) >= 0 ? axi_rsp_t_DataWidth + 2 : 1 - (axi_rsp_t_DataWidth + 1)) + 0)] && axi_req_o[1 + (((axi_req_t_AxiAddrWidth + 2) >= 0 ? axi_req_t_AxiAddrWidth + 3 : 1 - (axi_req_t_AxiAddrWidth + 2)) + 1)]) || (axi_rsp_i[0] && axi_req_o[0]);
	initial begin : proc_assert
		
	end
	initial _sv2v_0 = 0;
endmodule
