module axi_atop_filter_24B4D (
	clk_i,
	rst_ni,
	slv_req_i,
	slv_resp_o,
	mst_req_o,
	mst_resp_i
);
	reg _sv2v_0;
	parameter [31:0] AxiIdWidth = 0;
	parameter [31:0] AxiMaxWriteTxns = 0;
	input wire clk_i;
	input wire rst_ni;
	input wire slv_req_i;
	output reg slv_resp_o;
	output reg mst_req_o;
	input wire mst_resp_i;
	localparam [31:0] COUNTER_WIDTH = (AxiMaxWriteTxns == 1 ? 2 : $clog2(AxiMaxWriteTxns + 1));
	reg [(1 + COUNTER_WIDTH) - 1:0] w_cnt_d;
	reg [(1 + COUNTER_WIDTH) - 1:0] w_cnt_q;
	reg [2:0] w_state_d;
	reg [2:0] w_state_q;
	reg [1:0] r_state_d;
	reg [1:0] r_state_q;
	reg [AxiIdWidth - 1:0] id_d;
	reg [AxiIdWidth - 1:0] id_q;
	reg [7:0] r_beats_d;
	reg [7:0] r_beats_q;
	wire [7:0] r_resp_cmd_push;
	wire [7:0] r_resp_cmd_pop;
	wire aw_without_complete_w_downstream;
	wire complete_w_without_aw_downstream;
	reg r_resp_cmd_push_valid;
	wire r_resp_cmd_push_ready;
	wire r_resp_cmd_pop_valid;
	reg r_resp_cmd_pop_ready;
	assign aw_without_complete_w_downstream = !w_cnt_q[COUNTER_WIDTH + 0] && (w_cnt_q[COUNTER_WIDTH - 1-:COUNTER_WIDTH] > 0);
	assign complete_w_without_aw_downstream = w_cnt_q[COUNTER_WIDTH + 0] && &w_cnt_q[COUNTER_WIDTH - 1-:COUNTER_WIDTH];
	localparam axi_pkg_ATOP_NONE = 2'b00;
	localparam axi_pkg_ATOP_R_RESP = 32'd5;
	localparam axi_pkg_RESP_SLVERR = 2'b10;
	always @(*) begin
		if (_sv2v_0)
			;
		mst_req_o.aw_valid = 1'b0;
		slv_resp_o.aw_ready = 1'b0;
		mst_req_o.w_valid = 1'b0;
		slv_resp_o.w_ready = 1'b0;
		mst_req_o.b_ready = slv_req_i.b_ready;
		slv_resp_o.b_valid = mst_resp_i.b_valid;
		slv_resp_o.b = mst_resp_i.b;
		id_d = id_q;
		r_resp_cmd_push_valid = 1'b0;
		w_state_d = w_state_q;
		(* full_case, parallel_case *)
		case (w_state_q)
			3'd0: w_state_d = 3'd1;
			3'd1: begin
				if (complete_w_without_aw_downstream || (w_cnt_q[COUNTER_WIDTH - 1-:COUNTER_WIDTH] < AxiMaxWriteTxns)) begin
					mst_req_o.aw_valid = slv_req_i.aw_valid;
					slv_resp_o.aw_ready = mst_resp_i.aw_ready;
				end
				if (aw_without_complete_w_downstream || ((slv_req_i.aw_valid && (slv_req_i.aw.atop[5:4] == axi_pkg_ATOP_NONE)) && !complete_w_without_aw_downstream)) begin
					mst_req_o.w_valid = slv_req_i.w_valid;
					slv_resp_o.w_ready = mst_resp_i.w_ready;
				end
				if (slv_req_i.aw_valid && (slv_req_i.aw.atop[5:4] != axi_pkg_ATOP_NONE)) begin
					mst_req_o.aw_valid = 1'b0;
					slv_resp_o.aw_ready = 1'b1;
					id_d = slv_req_i.aw.id;
					if (slv_req_i.aw.atop[axi_pkg_ATOP_R_RESP])
						r_resp_cmd_push_valid = 1'b1;
					if (aw_without_complete_w_downstream)
						w_state_d = 3'd2;
					else begin
						mst_req_o.w_valid = 1'b0;
						slv_resp_o.w_ready = 1'b1;
						if (slv_req_i.w_valid && slv_req_i.w.last) begin
							if (slv_resp_o.b_valid && !slv_req_i.b_ready)
								w_state_d = 3'd4;
							else
								w_state_d = 3'd5;
						end
						else
							w_state_d = 3'd3;
					end
				end
			end
			3'd2:
				if (aw_without_complete_w_downstream) begin
					mst_req_o.w_valid = slv_req_i.w_valid;
					slv_resp_o.w_ready = mst_resp_i.w_ready;
				end
				else begin
					slv_resp_o.w_ready = 1'b1;
					if (slv_req_i.w_valid && slv_req_i.w.last) begin
						if (slv_resp_o.b_valid && !slv_req_i.b_ready)
							w_state_d = 3'd4;
						else
							w_state_d = 3'd5;
					end
					else
						w_state_d = 3'd3;
				end
			3'd3: begin
				slv_resp_o.w_ready = 1'b1;
				if (slv_req_i.w_valid && slv_req_i.w.last) begin
					if (slv_resp_o.b_valid && !slv_req_i.b_ready)
						w_state_d = 3'd4;
					else
						w_state_d = 3'd5;
				end
			end
			3'd4:
				if (slv_resp_o.b_valid && slv_req_i.b_ready)
					w_state_d = 3'd5;
			3'd5: begin
				mst_req_o.b_ready = 1'b0;
				slv_resp_o.b = 1'sb0;
				slv_resp_o.b.id = id_q;
				slv_resp_o.b.resp = axi_pkg_RESP_SLVERR;
				slv_resp_o.b_valid = 1'b1;
				if (slv_req_i.b_ready) begin
					if (r_resp_cmd_pop_valid && !r_resp_cmd_pop_ready)
						w_state_d = 3'd6;
					else
						w_state_d = 3'd1;
				end
			end
			3'd6:
				if (!r_resp_cmd_pop_valid)
					w_state_d = 3'd1;
			default: w_state_d = 3'd0;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		mst_req_o.aw = slv_req_i.aw;
		mst_req_o.aw.atop = 1'sb0;
	end
	wire [$bits(type(mst_req_o.w)):1] sv2v_tmp_78014;
	assign sv2v_tmp_78014 = slv_req_i.w;
	always @(*) mst_req_o.w = sv2v_tmp_78014;
	always @(*) begin
		if (_sv2v_0)
			;
		slv_resp_o.r = mst_resp_i.r;
		slv_resp_o.r_valid = mst_resp_i.r_valid;
		mst_req_o.r_ready = slv_req_i.r_ready;
		r_resp_cmd_pop_ready = 1'b0;
		r_beats_d = r_beats_q;
		r_state_d = r_state_q;
		(* full_case, parallel_case *)
		case (r_state_q)
			2'd0: r_state_d = 2'd1;
			2'd1:
				if (mst_resp_i.r_valid && !slv_req_i.r_ready)
					r_state_d = 2'd3;
				else if (r_resp_cmd_pop_valid) begin
					r_beats_d = r_resp_cmd_pop[7-:8];
					r_state_d = 2'd2;
				end
			2'd2: begin
				mst_req_o.r_ready = 1'b0;
				slv_resp_o.r = 1'sb0;
				slv_resp_o.r.id = id_q;
				slv_resp_o.r.resp = axi_pkg_RESP_SLVERR;
				slv_resp_o.r.last = r_beats_q == {8 {1'sb0}};
				slv_resp_o.r_valid = 1'b1;
				if (slv_req_i.r_ready) begin
					if (slv_resp_o.r.last) begin
						r_resp_cmd_pop_ready = 1'b1;
						r_state_d = 2'd1;
					end
					else
						r_beats_d = r_beats_d - 1;
				end
			end
			2'd3:
				if (mst_resp_i.r_valid && slv_req_i.r_ready)
					r_state_d = 2'd1;
			default: r_state_d = 2'd0;
		endcase
	end
	wire [$bits(type(mst_req_o.ar)):1] sv2v_tmp_93666;
	assign sv2v_tmp_93666 = slv_req_i.ar;
	always @(*) mst_req_o.ar = sv2v_tmp_93666;
	wire [$bits(type(mst_req_o.ar_valid)):1] sv2v_tmp_113EA;
	assign sv2v_tmp_113EA = slv_req_i.ar_valid;
	always @(*) mst_req_o.ar_valid = sv2v_tmp_113EA;
	wire [$bits(type(slv_resp_o.ar_ready)):1] sv2v_tmp_EF1C4;
	assign sv2v_tmp_EF1C4 = mst_resp_i.ar_ready;
	always @(*) slv_resp_o.ar_ready = sv2v_tmp_EF1C4;
	always @(*) begin
		if (_sv2v_0)
			;
		w_cnt_d = w_cnt_q;
		if (mst_req_o.aw_valid && mst_resp_i.aw_ready)
			w_cnt_d[COUNTER_WIDTH - 1-:COUNTER_WIDTH] = w_cnt_d[COUNTER_WIDTH - 1-:COUNTER_WIDTH] + 1;
		if ((mst_req_o.w_valid && mst_resp_i.w_ready) && mst_req_o.w.last)
			w_cnt_d[COUNTER_WIDTH - 1-:COUNTER_WIDTH] = w_cnt_d[COUNTER_WIDTH - 1-:COUNTER_WIDTH] - 1;
		if (w_cnt_q[COUNTER_WIDTH + 0] && (w_cnt_d[COUNTER_WIDTH - 1-:COUNTER_WIDTH] == {COUNTER_WIDTH * 1 {1'sb0}}))
			w_cnt_d[COUNTER_WIDTH + 0] = 1'b0;
		else if ((w_cnt_q[COUNTER_WIDTH - 1-:COUNTER_WIDTH] == {COUNTER_WIDTH * 1 {1'sb0}}) && &w_cnt_d[COUNTER_WIDTH - 1-:COUNTER_WIDTH])
			w_cnt_d[COUNTER_WIDTH + 0] = 1'b1;
	end
	function automatic [COUNTER_WIDTH - 1:0] sv2v_cast_B90DC;
		input reg [COUNTER_WIDTH - 1:0] inp;
		sv2v_cast_B90DC = inp;
	endfunction
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			id_q <= 1'sb0;
			r_beats_q <= 1'sb0;
			r_state_q <= 2'd0;
			w_cnt_q <= {1'b0, sv2v_cast_B90DC(1'sb0)};
			w_state_q <= 3'd0;
		end
		else begin
			id_q <= id_d;
			r_beats_q <= r_beats_d;
			r_state_q <= r_state_d;
			w_cnt_q <= w_cnt_d;
			w_state_q <= w_state_d;
		end
	stream_register_11179 r_resp_cmd(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.clr_i(1'b0),
		.testmode_i(1'b0),
		.valid_i(r_resp_cmd_push_valid),
		.ready_o(r_resp_cmd_push_ready),
		.data_i(r_resp_cmd_push),
		.valid_o(r_resp_cmd_pop_valid),
		.ready_i(r_resp_cmd_pop_ready),
		.data_o(r_resp_cmd_pop)
	);
	assign r_resp_cmd_push[7-:8] = slv_req_i.aw.len;
	initial begin : p_assertions
		
	end
	initial _sv2v_0 = 0;
endmodule
