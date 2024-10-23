module axi_burst_splitter_ax_chan_9FA46_A74B7 (
	clk_i,
	rst_ni,
	ax_i,
	ax_valid_i,
	ax_ready_o,
	ax_o,
	ax_valid_o,
	ax_ready_i,
	cnt_id_i,
	cnt_len_o,
	cnt_set_err_i,
	cnt_err_o,
	cnt_dec_i,
	cnt_req_i,
	cnt_gnt_o
);
	parameter [31:0] chan_t_AddrWidth = 0;
	parameter [31:0] chan_t_IdWidth = 0;
	parameter [31:0] chan_t_UserWidth = 0;
	reg _sv2v_0;
	parameter [31:0] IdWidth = 0;
	parameter [31:0] MaxTxns = 0;
	parameter [0:0] FullBW = 0;
	input wire clk_i;
	input wire rst_ni;
	input wire [(((chan_t_IdWidth + chan_t_AddrWidth) + 29) + chan_t_UserWidth) - 1:0] ax_i;
	input wire ax_valid_i;
	output reg ax_ready_o;
	output reg [(((chan_t_IdWidth + chan_t_AddrWidth) + 29) + chan_t_UserWidth) - 1:0] ax_o;
	output reg ax_valid_o;
	input wire ax_ready_i;
	input wire [IdWidth - 1:0] cnt_id_i;
	output wire [7:0] cnt_len_o;
	input wire cnt_set_err_i;
	output wire cnt_err_o;
	input wire cnt_dec_i;
	input wire cnt_req_i;
	output wire cnt_gnt_o;
	reg cnt_alloc_req;
	wire cnt_alloc_gnt;
	axi_burst_splitter_counters #(
		.MaxTxns(MaxTxns),
		.FullBW(FullBW),
		.IdWidth(IdWidth)
	) i_axi_burst_splitter_counters(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.alloc_id_i(ax_i[chan_t_IdWidth + (chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7)))-:((chan_t_IdWidth + (chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7)))) >= (chan_t_AddrWidth + (29 + (chan_t_UserWidth + 0))) ? ((chan_t_IdWidth + (chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7)))) - (chan_t_AddrWidth + (29 + (chan_t_UserWidth + 0)))) + 1 : ((chan_t_AddrWidth + (29 + (chan_t_UserWidth + 0))) - (chan_t_IdWidth + (chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))))) + 1)]),
		.alloc_len_i(ax_i[21 + (chan_t_UserWidth + 7)-:((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1)]),
		.alloc_req_i(cnt_alloc_req),
		.alloc_gnt_o(cnt_alloc_gnt),
		.cnt_id_i(cnt_id_i),
		.cnt_len_o(cnt_len_o),
		.cnt_set_err_i(cnt_set_err_i),
		.cnt_err_o(cnt_err_o),
		.cnt_dec_i(cnt_dec_i),
		.cnt_req_i(cnt_req_i),
		.cnt_gnt_o(cnt_gnt_o)
	);
	reg [(((chan_t_IdWidth + chan_t_AddrWidth) + 29) + chan_t_UserWidth) - 1:0] ax_d;
	reg [(((chan_t_IdWidth + chan_t_AddrWidth) + 29) + chan_t_UserWidth) - 1:0] ax_q;
	reg state_d;
	reg state_q;
	localparam axi_pkg_BURST_INCR = 2'b01;
	always @(*) begin
		if (_sv2v_0)
			;
		cnt_alloc_req = 1'b0;
		ax_d = ax_q;
		state_d = state_q;
		ax_o = 1'sb0;
		ax_valid_o = 1'b0;
		ax_ready_o = 1'b0;
		(* full_case, parallel_case *)
		case (state_q)
			1'd0:
				if (ax_valid_i && cnt_alloc_gnt) begin
					if (ax_i[21 + (chan_t_UserWidth + 7)-:((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1)] == {((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1) * 1 {1'sb0}}) begin
						ax_o = ax_i;
						ax_valid_o = 1'b1;
						if (ax_ready_i) begin
							cnt_alloc_req = 1'b1;
							ax_ready_o = 1'b1;
						end
					end
					else begin
						ax_d = ax_i;
						cnt_alloc_req = 1'b1;
						ax_ready_o = 1'b1;
						ax_o = ax_d;
						ax_o[21 + (chan_t_UserWidth + 7)-:((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1)] = 1'sb0;
						ax_valid_o = 1'b1;
						if (ax_ready_i) begin
							ax_d[21 + (chan_t_UserWidth + 7)-:((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1)] = ax_d[21 + (chan_t_UserWidth + 7)-:((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1)] - 1;
							if (ax_d[10 + (chan_t_UserWidth + 7)-:((10 + (chan_t_UserWidth + 7)) >= (16 + (chan_t_UserWidth + 0)) ? ((10 + (chan_t_UserWidth + 7)) - (16 + (chan_t_UserWidth + 0))) + 1 : ((16 + (chan_t_UserWidth + 0)) - (10 + (chan_t_UserWidth + 7))) + 1)] == axi_pkg_BURST_INCR)
								ax_d[chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))-:((chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))) >= (29 + (chan_t_UserWidth + 0)) ? ((chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))) - (29 + (chan_t_UserWidth + 0))) + 1 : ((29 + (chan_t_UserWidth + 0)) - (chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7)))) + 1)] = ax_d[chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))-:((chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))) >= (29 + (chan_t_UserWidth + 0)) ? ((chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))) - (29 + (chan_t_UserWidth + 0))) + 1 : ((29 + (chan_t_UserWidth + 0)) - (chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7)))) + 1)] + (1 << ax_d[17 + (chan_t_UserWidth + 3)-:((17 + (chan_t_UserWidth + 3)) >= (18 + (chan_t_UserWidth + 0)) ? ((17 + (chan_t_UserWidth + 3)) - (18 + (chan_t_UserWidth + 0))) + 1 : ((18 + (chan_t_UserWidth + 0)) - (17 + (chan_t_UserWidth + 3))) + 1)]);
						end
						state_d = 1'd1;
					end
				end
			1'd1: begin
				ax_o = ax_q;
				ax_o[21 + (chan_t_UserWidth + 7)-:((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1)] = 1'sb0;
				ax_valid_o = 1'b1;
				if (ax_ready_i) begin
					if (ax_q[21 + (chan_t_UserWidth + 7)-:((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1)] == {((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1) * 1 {1'sb0}})
						state_d = 1'd0;
					else begin
						ax_d[21 + (chan_t_UserWidth + 7)-:((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1)] = ax_d[21 + (chan_t_UserWidth + 7)-:((21 + (chan_t_UserWidth + 7)) >= (21 + (chan_t_UserWidth + 0)) ? ((21 + (chan_t_UserWidth + 7)) - (21 + (chan_t_UserWidth + 0))) + 1 : ((21 + (chan_t_UserWidth + 0)) - (21 + (chan_t_UserWidth + 7))) + 1)] - 1;
						if (ax_q[10 + (chan_t_UserWidth + 7)-:((10 + (chan_t_UserWidth + 7)) >= (16 + (chan_t_UserWidth + 0)) ? ((10 + (chan_t_UserWidth + 7)) - (16 + (chan_t_UserWidth + 0))) + 1 : ((16 + (chan_t_UserWidth + 0)) - (10 + (chan_t_UserWidth + 7))) + 1)] == axi_pkg_BURST_INCR)
							ax_d[chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))-:((chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))) >= (29 + (chan_t_UserWidth + 0)) ? ((chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))) - (29 + (chan_t_UserWidth + 0))) + 1 : ((29 + (chan_t_UserWidth + 0)) - (chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7)))) + 1)] = ax_d[chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))-:((chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))) >= (29 + (chan_t_UserWidth + 0)) ? ((chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7))) - (29 + (chan_t_UserWidth + 0))) + 1 : ((29 + (chan_t_UserWidth + 0)) - (chan_t_AddrWidth + (21 + (chan_t_UserWidth + 7)))) + 1)] + (1 << ax_q[17 + (chan_t_UserWidth + 3)-:((17 + (chan_t_UserWidth + 3)) >= (18 + (chan_t_UserWidth + 0)) ? ((17 + (chan_t_UserWidth + 3)) - (18 + (chan_t_UserWidth + 0))) + 1 : ((18 + (chan_t_UserWidth + 0)) - (17 + (chan_t_UserWidth + 3))) + 1)]);
					end
				end
			end
			default:
				;
		endcase
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			ax_q <= 1'sb0;
		else
			ax_q <= ax_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			state_q <= 1'd0;
		else
			state_q <= state_d;
	initial _sv2v_0 = 0;
endmodule
