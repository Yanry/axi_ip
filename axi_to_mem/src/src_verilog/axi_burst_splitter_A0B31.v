module axi_burst_splitter_A0B31 (
	clk_i,
	rst_ni,
	slv_req_i,
	slv_resp_o,
	mst_req_o,
	mst_resp_i
);
	reg _sv2v_0;
	parameter [31:0] MaxReadTxns = 32'd0;
	parameter [31:0] MaxWriteTxns = 32'd0;
	parameter [0:0] FullBW = 0;
	parameter [31:0] AddrWidth = 32'd0;
	parameter [31:0] DataWidth = 32'd0;
	parameter [31:0] IdWidth = 32'd0;
	parameter [31:0] UserWidth = 32'd0;
	input wire clk_i;
	input wire rst_ni;
	input wire slv_req_i;
	output wire slv_resp_o;
	output reg mst_req_o;
	input wire mst_resp_i;
	wire act_req;
	wire unsupported_req;
	reg act_resp;
	wire unsupported_resp;
	wire sel_aw_unsupported;
	wire sel_ar_unsupported;
	localparam [31:0] MaxTxns = (MaxReadTxns > MaxWriteTxns ? MaxReadTxns : MaxWriteTxns);
	axi_demux_4E7B0_F61E2 #(
		.ar_chan_t_AddrWidth(AddrWidth),
		.ar_chan_t_IdWidth(IdWidth),
		.ar_chan_t_UserWidth(UserWidth),
		.aw_chan_t_AddrWidth(AddrWidth),
		.aw_chan_t_IdWidth(IdWidth),
		.aw_chan_t_UserWidth(UserWidth),
		.b_chan_t_IdWidth(IdWidth),
		.b_chan_t_UserWidth(UserWidth),
		.r_chan_t_DataWidth(DataWidth),
		.r_chan_t_IdWidth(IdWidth),
		.r_chan_t_UserWidth(UserWidth),
		.w_chan_t_DataWidth(DataWidth),
		.w_chan_t_UserWidth(UserWidth),
		.AxiIdWidth(IdWidth),
		.NoMstPorts(2),
		.MaxTrans(MaxTxns),
		.AxiLookBits(IdWidth),
		.SpillAw(1'b0),
		.SpillW(1'b0),
		.SpillB(1'b0),
		.SpillAr(1'b0),
		.SpillR(1'b0)
	) i_demux_supported_vs_unsupported(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.test_i(1'b0),
		.slv_req_i(slv_req_i),
		.slv_aw_select_i(sel_aw_unsupported),
		.slv_ar_select_i(sel_ar_unsupported),
		.slv_resp_o(slv_resp_o),
		.mst_reqs_o({unsupported_req, act_req}),
		.mst_resps_i({unsupported_resp, act_resp})
	);
	localparam axi_pkg_BURST_INCR = 2'b01;
	localparam axi_pkg_BURST_WRAP = 2'b10;
	localparam axi_pkg_CACHE_MODIFIABLE = 4'b0010;
	function automatic axi_pkg_modifiable;
		input reg [3:0] cache;
		axi_pkg_modifiable = |(cache & axi_pkg_CACHE_MODIFIABLE);
	endfunction
	function txn_supported;
		input reg [5:0] atop;
		input reg [1:0] burst;
		input reg [3:0] cache;
		input reg [7:0] len;
		reg [0:1] _sv2v_jump;
		begin
			_sv2v_jump = 2'b00;
			if (len == {8 {1'sb0}}) begin
				txn_supported = 1'b1;
				_sv2v_jump = 2'b11;
			end
			if (_sv2v_jump == 2'b00) begin
				if (burst == axi_pkg_BURST_WRAP) begin
					txn_supported = 1'b0;
					_sv2v_jump = 2'b11;
				end
				if (_sv2v_jump == 2'b00) begin
					if (atop != {6 {1'sb0}}) begin
						txn_supported = 1'b0;
						_sv2v_jump = 2'b11;
					end
					if (_sv2v_jump == 2'b00) begin
						if (!axi_pkg_modifiable(cache)) begin
							txn_supported = (burst == axi_pkg_BURST_INCR) & (len > 16);
							_sv2v_jump = 2'b11;
						end
						if (_sv2v_jump == 2'b00) begin
							txn_supported = 1'b1;
							_sv2v_jump = 2'b11;
						end
					end
				end
			end
		end
	endfunction
	assign sel_aw_unsupported = ~txn_supported(slv_req_i.aw.atop, slv_req_i.aw.burst, slv_req_i.aw.cache, slv_req_i.aw.len);
	assign sel_ar_unsupported = ~txn_supported(1'sb0, slv_req_i.ar.burst, slv_req_i.ar.cache, slv_req_i.ar.len);
	localparam axi_pkg_RESP_SLVERR = 2'b10;
	axi_err_slv_13737 #(
		.AxiIdWidth(IdWidth),
		.Resp(axi_pkg_RESP_SLVERR),
		.ATOPs(1'b0),
		.MaxTrans(1)
	) i_err_slv(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.test_i(1'b0),
		.slv_req_i(unsupported_req),
		.slv_resp_o(unsupported_resp)
	);
	reg w_cnt_dec;
	reg w_cnt_req;
	wire w_cnt_gnt;
	wire w_cnt_err;
	wire [7:0] w_cnt_len;
	wire [$bits(type(act_resp.aw_ready)):1] sv2v_tmp_i_axi_burst_splitter_aw_chan_ax_ready_o;
	always @(*) act_resp.aw_ready = sv2v_tmp_i_axi_burst_splitter_aw_chan_ax_ready_o;
	wire [$bits(type(mst_req_o.aw)):1] sv2v_tmp_i_axi_burst_splitter_aw_chan_ax_o;
	always @(*) mst_req_o.aw = sv2v_tmp_i_axi_burst_splitter_aw_chan_ax_o;
	wire [$bits(type(mst_req_o.aw_valid)):1] sv2v_tmp_i_axi_burst_splitter_aw_chan_ax_valid_o;
	always @(*) mst_req_o.aw_valid = sv2v_tmp_i_axi_burst_splitter_aw_chan_ax_valid_o;
	axi_burst_splitter_ax_chan_20BEE_E73DB #(
		.chan_t_AddrWidth(AddrWidth),
		.chan_t_IdWidth(IdWidth),
		.chan_t_UserWidth(UserWidth),
		.IdWidth(IdWidth),
		.MaxTxns(MaxWriteTxns),
		.FullBW(FullBW)
	) i_axi_burst_splitter_aw_chan(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.ax_i(act_req.aw),
		.ax_valid_i(act_req.aw_valid),
		.ax_ready_o(sv2v_tmp_i_axi_burst_splitter_aw_chan_ax_ready_o),
		.ax_o(sv2v_tmp_i_axi_burst_splitter_aw_chan_ax_o),
		.ax_valid_o(sv2v_tmp_i_axi_burst_splitter_aw_chan_ax_valid_o),
		.ax_ready_i(mst_resp_i.aw_ready),
		.cnt_id_i(mst_resp_i.b.id),
		.cnt_len_o(w_cnt_len),
		.cnt_set_err_i(mst_resp_i.b.resp[1]),
		.cnt_err_o(w_cnt_err),
		.cnt_dec_i(w_cnt_dec),
		.cnt_req_i(w_cnt_req),
		.cnt_gnt_o(w_cnt_gnt)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		mst_req_o.w = act_req.w;
		mst_req_o.w.last = 1'b1;
	end
	wire [$bits(type(mst_req_o.w_valid)):1] sv2v_tmp_D7467;
	assign sv2v_tmp_D7467 = act_req.w_valid;
	always @(*) mst_req_o.w_valid = sv2v_tmp_D7467;
	wire [$bits(type(act_resp.w_ready)):1] sv2v_tmp_68627;
	assign sv2v_tmp_68627 = mst_resp_i.w_ready;
	always @(*) act_resp.w_ready = sv2v_tmp_68627;
	reg b_state_d;
	reg b_state_q;
	reg b_err_d;
	reg b_err_q;
	always @(*) begin
		if (_sv2v_0)
			;
		mst_req_o.b_ready = 1'b0;
		act_resp.b = 1'sb0;
		act_resp.b_valid = 1'b0;
		w_cnt_dec = 1'b0;
		w_cnt_req = 1'b0;
		b_err_d = b_err_q;
		b_state_d = b_state_q;
		(* full_case, parallel_case *)
		case (b_state_q)
			1'd0:
				if (mst_resp_i.b_valid) begin
					w_cnt_req = 1'b1;
					if (w_cnt_gnt) begin
						if (w_cnt_len == 8'd0) begin
							act_resp.b = mst_resp_i.b;
							if (w_cnt_err)
								act_resp.b.resp = axi_pkg_RESP_SLVERR;
							act_resp.b_valid = 1'b1;
							w_cnt_dec = 1'b1;
							if (act_req.b_ready)
								mst_req_o.b_ready = 1'b1;
							else begin
								b_state_d = 1'd1;
								b_err_d = w_cnt_err;
							end
						end
						else begin
							mst_req_o.b_ready = 1'b1;
							w_cnt_dec = 1'b1;
						end
					end
				end
			1'd1: begin
				act_resp.b = mst_resp_i.b;
				if (b_err_q)
					act_resp.b.resp = axi_pkg_RESP_SLVERR;
				act_resp.b_valid = 1'b1;
				if (mst_resp_i.b_valid && act_req.b_ready) begin
					mst_req_o.b_ready = 1'b1;
					b_state_d = 1'd0;
				end
			end
			default:
				;
		endcase
	end
	reg r_cnt_dec;
	reg r_cnt_req;
	wire r_cnt_gnt;
	wire [7:0] r_cnt_len;
	wire [$bits(type(act_resp.ar_ready)):1] sv2v_tmp_i_axi_burst_splitter_ar_chan_ax_ready_o;
	always @(*) act_resp.ar_ready = sv2v_tmp_i_axi_burst_splitter_ar_chan_ax_ready_o;
	wire [$bits(type(mst_req_o.ar)):1] sv2v_tmp_i_axi_burst_splitter_ar_chan_ax_o;
	always @(*) mst_req_o.ar = sv2v_tmp_i_axi_burst_splitter_ar_chan_ax_o;
	wire [$bits(type(mst_req_o.ar_valid)):1] sv2v_tmp_i_axi_burst_splitter_ar_chan_ax_valid_o;
	always @(*) mst_req_o.ar_valid = sv2v_tmp_i_axi_burst_splitter_ar_chan_ax_valid_o;
	axi_burst_splitter_ax_chan_9FA46_A74B7 #(
		.chan_t_AddrWidth(AddrWidth),
		.chan_t_IdWidth(IdWidth),
		.chan_t_UserWidth(UserWidth),
		.IdWidth(IdWidth),
		.MaxTxns(MaxReadTxns),
		.FullBW(FullBW)
	) i_axi_burst_splitter_ar_chan(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.ax_i(act_req.ar),
		.ax_valid_i(act_req.ar_valid),
		.ax_ready_o(sv2v_tmp_i_axi_burst_splitter_ar_chan_ax_ready_o),
		.ax_o(sv2v_tmp_i_axi_burst_splitter_ar_chan_ax_o),
		.ax_valid_o(sv2v_tmp_i_axi_burst_splitter_ar_chan_ax_valid_o),
		.ax_ready_i(mst_resp_i.ar_ready),
		.cnt_id_i(mst_resp_i.r.id),
		.cnt_len_o(r_cnt_len),
		.cnt_set_err_i(1'b0),
		.cnt_err_o(),
		.cnt_dec_i(r_cnt_dec),
		.cnt_req_i(r_cnt_req),
		.cnt_gnt_o(r_cnt_gnt)
	);
	reg r_last_d;
	reg r_last_q;
	reg r_state_d;
	reg r_state_q;
	always @(*) begin
		if (_sv2v_0)
			;
		r_cnt_dec = 1'b0;
		r_cnt_req = 1'b0;
		r_last_d = r_last_q;
		r_state_d = r_state_q;
		mst_req_o.r_ready = 1'b0;
		act_resp.r = mst_resp_i.r;
		act_resp.r.last = 1'b0;
		act_resp.r_valid = 1'b0;
		(* full_case, parallel_case *)
		case (r_state_q)
			1'd0:
				if (mst_resp_i.r_valid) begin
					r_cnt_req = 1'b1;
					if (r_cnt_gnt) begin
						r_last_d = r_cnt_len == 8'd0;
						act_resp.r.last = r_last_d;
						r_cnt_dec = 1'b1;
						act_resp.r_valid = 1'b1;
						if (act_req.r_ready)
							mst_req_o.r_ready = 1'b1;
						else
							r_state_d = 1'd1;
					end
				end
			1'd1: begin
				act_resp.r.last = r_last_q;
				act_resp.r_valid = mst_resp_i.r_valid;
				if (mst_resp_i.r_valid && act_req.r_ready) begin
					mst_req_o.r_ready = 1'b1;
					r_state_d = 1'd0;
				end
			end
			default:
				;
		endcase
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			b_err_q <= 1'b0;
		else
			b_err_q <= b_err_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			b_state_q <= 1'd0;
		else
			b_state_q <= b_state_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			r_last_q <= 1'b0;
		else
			r_last_q <= r_last_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			r_state_q <= 1'd0;
		else
			r_state_q <= r_state_d;
	initial _sv2v_0 = 0;
endmodule
