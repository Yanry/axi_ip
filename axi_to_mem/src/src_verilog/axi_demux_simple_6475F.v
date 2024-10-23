module axi_demux_simple_6475F (
	clk_i,
	rst_ni,
	test_i,
	slv_req_i,
	slv_aw_select_i,
	slv_ar_select_i,
	slv_resp_o,
	mst_reqs_o,
	mst_resps_i
);
	reg _sv2v_0;
	parameter [31:0] AxiIdWidth = 32'd0;
	parameter [0:0] AtopSupport = 1'b1;
	parameter [31:0] NoMstPorts = 32'd0;
	parameter [31:0] MaxTrans = 32'd8;
	parameter [31:0] AxiLookBits = 32'd3;
	parameter [0:0] UniqueIds = 1'b0;
	parameter [31:0] SelectWidth = (NoMstPorts > 32'd1 ? $clog2(NoMstPorts) : 32'd1);
	input wire clk_i;
	input wire rst_ni;
	input wire test_i;
	input wire slv_req_i;
	input wire [SelectWidth - 1:0] slv_aw_select_i;
	input wire [SelectWidth - 1:0] slv_ar_select_i;
	output reg slv_resp_o;
	output reg [NoMstPorts - 1:0] mst_reqs_o;
	input wire [NoMstPorts - 1:0] mst_resps_i;
	function automatic [31:0] cf_math_pkg_idx_width;
		input reg [31:0] num_idx;
		cf_math_pkg_idx_width = (num_idx > 32'd1 ? $unsigned($clog2(num_idx)) : 32'd1);
	endfunction
	localparam [31:0] IdCounterWidth = cf_math_pkg_idx_width(MaxTrans);
	localparam axi_pkg_ATOP_R_RESP = 32'd5;
	function automatic [SelectWidth - 1:0] sv2v_cast_1C590;
		input reg [SelectWidth - 1:0] inp;
		sv2v_cast_1C590 = inp;
	endfunction
	generate
		if (NoMstPorts == 32'h00000001) begin : gen_no_demux
			wire [$bits(type(mst_reqs_o[0].aw.id)):1] sv2v_tmp_06E5D;
			assign sv2v_tmp_06E5D = slv_req_i.aw.id;
			always @(*) mst_reqs_o[0].aw.id = sv2v_tmp_06E5D;
			wire [$bits(type(mst_reqs_o[0].aw.addr)):1] sv2v_tmp_DED91;
			assign sv2v_tmp_DED91 = slv_req_i.aw.addr;
			always @(*) mst_reqs_o[0].aw.addr = sv2v_tmp_DED91;
			wire [$bits(type(mst_reqs_o[0].aw.len)):1] sv2v_tmp_D322F;
			assign sv2v_tmp_D322F = slv_req_i.aw.len;
			always @(*) mst_reqs_o[0].aw.len = sv2v_tmp_D322F;
			wire [$bits(type(mst_reqs_o[0].aw.size)):1] sv2v_tmp_A2771;
			assign sv2v_tmp_A2771 = slv_req_i.aw.size;
			always @(*) mst_reqs_o[0].aw.size = sv2v_tmp_A2771;
			wire [$bits(type(mst_reqs_o[0].aw.burst)):1] sv2v_tmp_81173;
			assign sv2v_tmp_81173 = slv_req_i.aw.burst;
			always @(*) mst_reqs_o[0].aw.burst = sv2v_tmp_81173;
			wire [$bits(type(mst_reqs_o[0].aw.lock)):1] sv2v_tmp_217F1;
			assign sv2v_tmp_217F1 = slv_req_i.aw.lock;
			always @(*) mst_reqs_o[0].aw.lock = sv2v_tmp_217F1;
			wire [$bits(type(mst_reqs_o[0].aw.cache)):1] sv2v_tmp_07093;
			assign sv2v_tmp_07093 = slv_req_i.aw.cache;
			always @(*) mst_reqs_o[0].aw.cache = sv2v_tmp_07093;
			wire [$bits(type(mst_reqs_o[0].aw.prot)):1] sv2v_tmp_F0A31;
			assign sv2v_tmp_F0A31 = slv_req_i.aw.prot;
			always @(*) mst_reqs_o[0].aw.prot = sv2v_tmp_F0A31;
			wire [$bits(type(mst_reqs_o[0].aw.qos)):1] sv2v_tmp_6460F;
			assign sv2v_tmp_6460F = slv_req_i.aw.qos;
			always @(*) mst_reqs_o[0].aw.qos = sv2v_tmp_6460F;
			wire [$bits(type(mst_reqs_o[0].aw.region)):1] sv2v_tmp_FDF55;
			assign sv2v_tmp_FDF55 = slv_req_i.aw.region;
			always @(*) mst_reqs_o[0].aw.region = sv2v_tmp_FDF55;
			wire [$bits(type(mst_reqs_o[0].aw.atop)):1] sv2v_tmp_E6C51;
			assign sv2v_tmp_E6C51 = slv_req_i.aw.atop;
			always @(*) mst_reqs_o[0].aw.atop = sv2v_tmp_E6C51;
			wire [$bits(type(mst_reqs_o[0].aw.user)):1] sv2v_tmp_529F1;
			assign sv2v_tmp_529F1 = slv_req_i.aw.user;
			always @(*) mst_reqs_o[0].aw.user = sv2v_tmp_529F1;
			wire [$bits(type(mst_reqs_o[0].aw_valid)):1] sv2v_tmp_9C9A3;
			assign sv2v_tmp_9C9A3 = slv_req_i.aw_valid;
			always @(*) mst_reqs_o[0].aw_valid = sv2v_tmp_9C9A3;
			wire [$bits(type(mst_reqs_o[0].w.data)):1] sv2v_tmp_44EAF;
			assign sv2v_tmp_44EAF = slv_req_i.w.data;
			always @(*) mst_reqs_o[0].w.data = sv2v_tmp_44EAF;
			wire [$bits(type(mst_reqs_o[0].w.strb)):1] sv2v_tmp_385FF;
			assign sv2v_tmp_385FF = slv_req_i.w.strb;
			always @(*) mst_reqs_o[0].w.strb = sv2v_tmp_385FF;
			wire [$bits(type(mst_reqs_o[0].w.last)):1] sv2v_tmp_606AF;
			assign sv2v_tmp_606AF = slv_req_i.w.last;
			always @(*) mst_reqs_o[0].w.last = sv2v_tmp_606AF;
			wire [$bits(type(mst_reqs_o[0].w.user)):1] sv2v_tmp_2C5FF;
			assign sv2v_tmp_2C5FF = slv_req_i.w.user;
			always @(*) mst_reqs_o[0].w.user = sv2v_tmp_2C5FF;
			wire [$bits(type(mst_reqs_o[0].w_valid)):1] sv2v_tmp_EBA11;
			assign sv2v_tmp_EBA11 = slv_req_i.w_valid;
			always @(*) mst_reqs_o[0].w_valid = sv2v_tmp_EBA11;
			wire [$bits(type(mst_reqs_o[0].b_ready)):1] sv2v_tmp_E90D1;
			assign sv2v_tmp_E90D1 = slv_req_i.b_ready;
			always @(*) mst_reqs_o[0].b_ready = sv2v_tmp_E90D1;
			wire [$bits(type(mst_reqs_o[0].ar.id)):1] sv2v_tmp_B55DD;
			assign sv2v_tmp_B55DD = slv_req_i.ar.id;
			always @(*) mst_reqs_o[0].ar.id = sv2v_tmp_B55DD;
			wire [$bits(type(mst_reqs_o[0].ar.addr)):1] sv2v_tmp_35E11;
			assign sv2v_tmp_35E11 = slv_req_i.ar.addr;
			always @(*) mst_reqs_o[0].ar.addr = sv2v_tmp_35E11;
			wire [$bits(type(mst_reqs_o[0].ar.len)):1] sv2v_tmp_829FF;
			assign sv2v_tmp_829FF = slv_req_i.ar.len;
			always @(*) mst_reqs_o[0].ar.len = sv2v_tmp_829FF;
			wire [$bits(type(mst_reqs_o[0].ar.size)):1] sv2v_tmp_AD6D1;
			assign sv2v_tmp_AD6D1 = slv_req_i.ar.size;
			always @(*) mst_reqs_o[0].ar.size = sv2v_tmp_AD6D1;
			wire [$bits(type(mst_reqs_o[0].ar.burst)):1] sv2v_tmp_95563;
			assign sv2v_tmp_95563 = slv_req_i.ar.burst;
			always @(*) mst_reqs_o[0].ar.burst = sv2v_tmp_95563;
			wire [$bits(type(mst_reqs_o[0].ar.lock)):1] sv2v_tmp_35491;
			assign sv2v_tmp_35491 = slv_req_i.ar.lock;
			always @(*) mst_reqs_o[0].ar.lock = sv2v_tmp_35491;
			wire [$bits(type(mst_reqs_o[0].ar.cache)):1] sv2v_tmp_B85A3;
			assign sv2v_tmp_B85A3 = slv_req_i.ar.cache;
			always @(*) mst_reqs_o[0].ar.cache = sv2v_tmp_B85A3;
			wire [$bits(type(mst_reqs_o[0].ar.prot)):1] sv2v_tmp_0D111;
			assign sv2v_tmp_0D111 = slv_req_i.ar.prot;
			always @(*) mst_reqs_o[0].ar.prot = sv2v_tmp_0D111;
			wire [$bits(type(mst_reqs_o[0].ar.qos)):1] sv2v_tmp_0779F;
			assign sv2v_tmp_0779F = slv_req_i.ar.qos;
			always @(*) mst_reqs_o[0].ar.qos = sv2v_tmp_0779F;
			wire [$bits(type(mst_reqs_o[0].ar.region)):1] sv2v_tmp_9C815;
			assign sv2v_tmp_9C815 = slv_req_i.ar.region;
			always @(*) mst_reqs_o[0].ar.region = sv2v_tmp_9C815;
			wire [$bits(type(mst_reqs_o[0].ar.user)):1] sv2v_tmp_B6731;
			assign sv2v_tmp_B6731 = slv_req_i.ar.user;
			always @(*) mst_reqs_o[0].ar.user = sv2v_tmp_B6731;
			wire [$bits(type(mst_reqs_o[0].ar_valid)):1] sv2v_tmp_495F3;
			assign sv2v_tmp_495F3 = slv_req_i.ar_valid;
			always @(*) mst_reqs_o[0].ar_valid = sv2v_tmp_495F3;
			wire [$bits(type(mst_reqs_o[0].r_ready)):1] sv2v_tmp_2FA31;
			assign sv2v_tmp_2FA31 = slv_req_i.r_ready;
			always @(*) mst_reqs_o[0].r_ready = sv2v_tmp_2FA31;
			wire [$bits(type(slv_resp_o.aw_ready)):1] sv2v_tmp_E03A5;
			assign sv2v_tmp_E03A5 = mst_resps_i[0].aw_ready;
			always @(*) slv_resp_o.aw_ready = sv2v_tmp_E03A5;
			wire [$bits(type(slv_resp_o.ar_ready)):1] sv2v_tmp_57B25;
			assign sv2v_tmp_57B25 = mst_resps_i[0].ar_ready;
			always @(*) slv_resp_o.ar_ready = sv2v_tmp_57B25;
			wire [$bits(type(slv_resp_o.w_ready)):1] sv2v_tmp_6B373;
			assign sv2v_tmp_6B373 = mst_resps_i[0].w_ready;
			always @(*) slv_resp_o.w_ready = sv2v_tmp_6B373;
			wire [$bits(type(slv_resp_o.b_valid)):1] sv2v_tmp_1C9D3;
			assign sv2v_tmp_1C9D3 = mst_resps_i[0].b_valid;
			always @(*) slv_resp_o.b_valid = sv2v_tmp_1C9D3;
			wire [$bits(type(slv_resp_o.b.id)):1] sv2v_tmp_1D90D;
			assign sv2v_tmp_1D90D = mst_resps_i[0].b.id;
			always @(*) slv_resp_o.b.id = sv2v_tmp_1D90D;
			wire [$bits(type(slv_resp_o.b.resp)):1] sv2v_tmp_8D7C1;
			assign sv2v_tmp_8D7C1 = mst_resps_i[0].b.resp;
			always @(*) slv_resp_o.b.resp = sv2v_tmp_8D7C1;
			wire [$bits(type(slv_resp_o.b.user)):1] sv2v_tmp_B1A61;
			assign sv2v_tmp_B1A61 = mst_resps_i[0].b.user;
			always @(*) slv_resp_o.b.user = sv2v_tmp_B1A61;
			wire [$bits(type(slv_resp_o.r_valid)):1] sv2v_tmp_4C5F3;
			assign sv2v_tmp_4C5F3 = mst_resps_i[0].r_valid;
			always @(*) slv_resp_o.r_valid = sv2v_tmp_4C5F3;
			wire [$bits(type(slv_resp_o.r.id)):1] sv2v_tmp_0518D;
			assign sv2v_tmp_0518D = mst_resps_i[0].r.id;
			always @(*) slv_resp_o.r.id = sv2v_tmp_0518D;
			wire [$bits(type(slv_resp_o.r.data)):1] sv2v_tmp_1B8E1;
			assign sv2v_tmp_1B8E1 = mst_resps_i[0].r.data;
			always @(*) slv_resp_o.r.data = sv2v_tmp_1B8E1;
			wire [$bits(type(slv_resp_o.r.resp)):1] sv2v_tmp_62FE1;
			assign sv2v_tmp_62FE1 = mst_resps_i[0].r.resp;
			always @(*) slv_resp_o.r.resp = sv2v_tmp_62FE1;
			wire [$bits(type(slv_resp_o.r.last)):1] sv2v_tmp_17F01;
			assign sv2v_tmp_17F01 = mst_resps_i[0].r.last;
			always @(*) slv_resp_o.r.last = sv2v_tmp_17F01;
			wire [$bits(type(slv_resp_o.r.user)):1] sv2v_tmp_DCB41;
			assign sv2v_tmp_DCB41 = mst_resps_i[0].r.user;
			always @(*) slv_resp_o.r.user = sv2v_tmp_DCB41;
		end
		else begin : genblk1
			reg lock_aw_valid_d;
			reg lock_aw_valid_q;
			reg load_aw_lock;
			reg aw_valid;
			wire aw_ready;
			wire [SelectWidth - 1:0] lookup_aw_select;
			wire aw_select_occupied;
			wire aw_id_cnt_full;
			reg atop_inject;
			wire [SelectWidth - 1:0] w_select;
			reg [SelectWidth - 1:0] w_select_q;
			wire w_select_valid;
			wire [IdCounterWidth - 1:0] w_open;
			reg w_cnt_up;
			reg w_cnt_down;
			wire [NoMstPorts - 1:0] mst_b_valids;
			wire [NoMstPorts - 1:0] mst_b_readies;
			wire [SelectWidth - 1:0] lookup_ar_select;
			wire ar_select_occupied;
			wire ar_id_cnt_full;
			reg ar_push;
			reg lock_ar_valid_d;
			reg lock_ar_valid_q;
			reg load_ar_lock;
			reg ar_valid;
			wire ar_ready;
			wire [NoMstPorts - 1:0] mst_r_valids;
			wire [NoMstPorts - 1:0] mst_r_readies;
			always @(*) begin
				if (_sv2v_0)
					;
				slv_resp_o.aw_ready = 1'b0;
				aw_valid = 1'b0;
				lock_aw_valid_d = lock_aw_valid_q;
				load_aw_lock = 1'b0;
				w_cnt_up = 1'b0;
				atop_inject = 1'b0;
				if (lock_aw_valid_q) begin
					aw_valid = 1'b1;
					if (aw_ready) begin
						slv_resp_o.aw_ready = 1'b1;
						lock_aw_valid_d = 1'b0;
						load_aw_lock = 1'b1;
						atop_inject = slv_req_i.aw.atop[axi_pkg_ATOP_R_RESP] & AtopSupport;
					end
				end
				else if ((!aw_id_cnt_full && (w_open != {IdCounterWidth {1'b1}})) && (!(ar_id_cnt_full && slv_req_i.aw.atop[axi_pkg_ATOP_R_RESP]) || !AtopSupport)) begin
					if ((slv_req_i.aw_valid && ((w_open == {IdCounterWidth {1'sb0}}) || (w_select == slv_aw_select_i))) && (!aw_select_occupied || (slv_aw_select_i == lookup_aw_select))) begin
						aw_valid = 1'b1;
						w_cnt_up = 1'b1;
						if (aw_ready) begin
							slv_resp_o.aw_ready = 1'b1;
							atop_inject = slv_req_i.aw.atop[axi_pkg_ATOP_R_RESP] & AtopSupport;
						end
						else begin
							lock_aw_valid_d = 1'b1;
							load_aw_lock = 1'b1;
						end
					end
				end
			end
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					lock_aw_valid_q <= 1'sb0;
				else if (load_aw_lock)
					lock_aw_valid_q <= lock_aw_valid_d;
			if (UniqueIds) begin : gen_unique_ids_aw
				assign lookup_aw_select = slv_aw_select_i;
				assign aw_select_occupied = 1'b0;
				assign aw_id_cnt_full = 1'b0;
			end
			else begin : gen_aw_id_counter
				localparam [31:0] sv2v_uu_i_aw_id_counter_AxiIdBits = AxiLookBits;
				localparam [sv2v_uu_i_aw_id_counter_AxiIdBits - 1:0] sv2v_uu_i_aw_id_counter_ext_inject_axi_id_i_0 = 1'sb0;
				axi_demux_id_counters_2349C_D3F56 #(
					.mst_port_select_t_SelectWidth(SelectWidth),
					.AxiIdBits(AxiLookBits),
					.CounterWidth(IdCounterWidth)
				) i_aw_id_counter(
					.clk_i(clk_i),
					.rst_ni(rst_ni),
					.lookup_axi_id_i(slv_req_i.aw.id[0+:AxiLookBits]),
					.lookup_mst_select_o(lookup_aw_select),
					.lookup_mst_select_occupied_o(aw_select_occupied),
					.full_o(aw_id_cnt_full),
					.inject_axi_id_i(sv2v_uu_i_aw_id_counter_ext_inject_axi_id_i_0),
					.inject_i(1'b0),
					.push_axi_id_i(slv_req_i.aw.id[0+:AxiLookBits]),
					.push_mst_select_i(slv_aw_select_i),
					.push_i(w_cnt_up),
					.pop_axi_id_i(slv_resp_o.b.id[0+:AxiLookBits]),
					.pop_i(slv_resp_o.b_valid & slv_req_i.b_ready)
				);
			end
			localparam [31:0] sv2v_uu_i_counter_open_w_WIDTH = IdCounterWidth;
			localparam [sv2v_uu_i_counter_open_w_WIDTH - 1:0] sv2v_uu_i_counter_open_w_ext_d_i_0 = 1'sb0;
			counter #(
				.WIDTH(IdCounterWidth),
				.STICKY_OVERFLOW(1'b0)
			) i_counter_open_w(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.clear_i(1'b0),
				.en_i(w_cnt_up ^ w_cnt_down),
				.load_i(1'b0),
				.down_i(w_cnt_down),
				.d_i(sv2v_uu_i_counter_open_w_ext_d_i_0),
				.q_o(w_open),
				.overflow_o()
			);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					w_select_q <= sv2v_cast_1C590(0);
				else if (w_cnt_up)
					w_select_q <= slv_aw_select_i;
			assign w_select = (|w_open ? w_select_q : slv_aw_select_i);
			assign w_select_valid = w_cnt_up | (|w_open);
			wire [cf_math_pkg_idx_width(NoMstPorts) - 1:0] b_idx;
			localparam [31:0] sv2v_uu_i_b_mux_NumIn = NoMstPorts;
			localparam [31:0] sv2v_uu_i_b_mux_IdxWidth = (sv2v_uu_i_b_mux_NumIn > 32'd1 ? $unsigned($clog2(sv2v_uu_i_b_mux_NumIn)) : 32'd1);
			localparam [sv2v_uu_i_b_mux_IdxWidth - 1:0] sv2v_uu_i_b_mux_ext_rr_i_0 = 1'sb0;
			localparam [sv2v_uu_i_b_mux_NumIn - 1:0] sv2v_uu_i_b_mux_ext_data_i_0 = 1'sb0;
			wire [$bits(type(slv_resp_o.b_valid)):1] sv2v_tmp_i_b_mux_req_o;
			always @(*) slv_resp_o.b_valid = sv2v_tmp_i_b_mux_req_o;
			rr_arb_tree_93F52 #(
				.NumIn(NoMstPorts),
				.AxiVldRdy(1'b1),
				.LockIn(1'b1)
			) i_b_mux(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.flush_i(1'b0),
				.rr_i(sv2v_uu_i_b_mux_ext_rr_i_0),
				.req_i(mst_b_valids),
				.gnt_o(mst_b_readies),
				.data_i(sv2v_uu_i_b_mux_ext_data_i_0),
				.gnt_i(slv_req_i.b_ready),
				.req_o(sv2v_tmp_i_b_mux_req_o),
				.data_o(),
				.idx_o(b_idx)
			);
			always @(*) begin
				if (_sv2v_0)
					;
				if (slv_resp_o.b_valid) begin
					slv_resp_o.b.id = mst_resps_i[b_idx].b.id;
					slv_resp_o.b.resp = mst_resps_i[b_idx].b.resp;
					slv_resp_o.b.user = mst_resps_i[b_idx].b.user;
				end
				else
					slv_resp_o.b = 1'sb0;
			end
			always @(*) begin
				if (_sv2v_0)
					;
				slv_resp_o.ar_ready = 1'b0;
				ar_valid = 1'b0;
				lock_ar_valid_d = lock_ar_valid_q;
				load_ar_lock = 1'b0;
				ar_push = 1'b0;
				if (lock_ar_valid_q) begin
					ar_valid = 1'b1;
					if (ar_ready) begin
						slv_resp_o.ar_ready = 1'b1;
						ar_push = 1'b1;
						lock_ar_valid_d = 1'b0;
						load_ar_lock = 1'b1;
					end
				end
				else if (!ar_id_cnt_full) begin
					if (slv_req_i.ar_valid && (!ar_select_occupied || (slv_ar_select_i == lookup_ar_select))) begin
						ar_valid = 1'b1;
						if (ar_ready) begin
							slv_resp_o.ar_ready = 1'b1;
							ar_push = 1'b1;
						end
						else begin
							lock_ar_valid_d = 1'b1;
							load_ar_lock = 1'b1;
						end
					end
				end
			end
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					lock_ar_valid_q <= 1'sb0;
				else if (load_ar_lock)
					lock_ar_valid_q <= lock_ar_valid_d;
			if (UniqueIds) begin : gen_unique_ids_ar
				assign lookup_ar_select = slv_ar_select_i;
				assign ar_select_occupied = 1'b0;
				assign ar_id_cnt_full = 1'b0;
			end
			else begin : gen_ar_id_counter
				axi_demux_id_counters_2349C_D3F56 #(
					.mst_port_select_t_SelectWidth(SelectWidth),
					.AxiIdBits(AxiLookBits),
					.CounterWidth(IdCounterWidth)
				) i_ar_id_counter(
					.clk_i(clk_i),
					.rst_ni(rst_ni),
					.lookup_axi_id_i(slv_req_i.ar.id[0+:AxiLookBits]),
					.lookup_mst_select_o(lookup_ar_select),
					.lookup_mst_select_occupied_o(ar_select_occupied),
					.full_o(ar_id_cnt_full),
					.inject_axi_id_i(slv_req_i.aw.id[0+:AxiLookBits]),
					.inject_i(atop_inject),
					.push_axi_id_i(slv_req_i.ar.id[0+:AxiLookBits]),
					.push_mst_select_i(slv_ar_select_i),
					.push_i(ar_push),
					.pop_axi_id_i(slv_resp_o.r.id[0+:AxiLookBits]),
					.pop_i((slv_resp_o.r_valid & slv_req_i.r_ready) & slv_resp_o.r.last)
				);
			end
			wire [cf_math_pkg_idx_width(NoMstPorts) - 1:0] r_idx;
			localparam [31:0] sv2v_uu_i_r_mux_NumIn = NoMstPorts;
			localparam [31:0] sv2v_uu_i_r_mux_IdxWidth = (sv2v_uu_i_r_mux_NumIn > 32'd1 ? $unsigned($clog2(sv2v_uu_i_r_mux_NumIn)) : 32'd1);
			localparam [sv2v_uu_i_r_mux_IdxWidth - 1:0] sv2v_uu_i_r_mux_ext_rr_i_0 = 1'sb0;
			localparam [sv2v_uu_i_r_mux_NumIn - 1:0] sv2v_uu_i_r_mux_ext_data_i_0 = 1'sb0;
			wire [$bits(type(slv_resp_o.r_valid)):1] sv2v_tmp_i_r_mux_req_o;
			always @(*) slv_resp_o.r_valid = sv2v_tmp_i_r_mux_req_o;
			rr_arb_tree_93F52 #(
				.NumIn(NoMstPorts),
				.AxiVldRdy(1'b1),
				.LockIn(1'b1)
			) i_r_mux(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.flush_i(1'b0),
				.rr_i(sv2v_uu_i_r_mux_ext_rr_i_0),
				.req_i(mst_r_valids),
				.gnt_o(mst_r_readies),
				.data_i(sv2v_uu_i_r_mux_ext_data_i_0),
				.gnt_i(slv_req_i.r_ready),
				.req_o(sv2v_tmp_i_r_mux_req_o),
				.data_o(),
				.idx_o(r_idx)
			);
			always @(*) begin
				if (_sv2v_0)
					;
				if (slv_resp_o.r_valid) begin
					slv_resp_o.r.id = mst_resps_i[r_idx].r.id;
					slv_resp_o.r.data = mst_resps_i[r_idx].r.data;
					slv_resp_o.r.resp = mst_resps_i[r_idx].r.resp;
					slv_resp_o.r.last = mst_resps_i[r_idx].r.last;
					slv_resp_o.r.user = mst_resps_i[r_idx].r.user;
				end
				else
					slv_resp_o.r = 1'sb0;
			end
			assign ar_ready = ar_valid & mst_resps_i[slv_ar_select_i].ar_ready;
			assign aw_ready = aw_valid & mst_resps_i[slv_aw_select_i].aw_ready;
			always @(*) begin
				if (_sv2v_0)
					;
				mst_reqs_o = 1'sb0;
				slv_resp_o.w_ready = 1'b0;
				w_cnt_down = 1'b0;
				begin : sv2v_autoblock_1
					reg [31:0] i;
					for (i = 0; i < NoMstPorts; i = i + 1)
						begin
							mst_reqs_o[i].aw = slv_req_i.aw;
							mst_reqs_o[i].aw_valid = 1'b0;
							if (aw_valid && (slv_aw_select_i == i))
								mst_reqs_o[i].aw_valid = 1'b1;
							mst_reqs_o[i].w = slv_req_i.w;
							mst_reqs_o[i].w_valid = 1'b0;
							if (w_select_valid && (w_select == i)) begin
								mst_reqs_o[i].w_valid = slv_req_i.w_valid;
								slv_resp_o.w_ready = mst_resps_i[i].w_ready;
								w_cnt_down = (slv_req_i.w_valid & mst_resps_i[i].w_ready) & slv_req_i.w.last;
							end
							mst_reqs_o[i].b_ready = mst_b_readies[i];
							mst_reqs_o[i].ar = slv_req_i.ar;
							mst_reqs_o[i].ar_valid = 1'b0;
							if (ar_valid && (slv_ar_select_i == i))
								mst_reqs_o[i].ar_valid = 1'b1;
							mst_reqs_o[i].r_ready = mst_r_readies[i];
						end
				end
			end
			genvar _gv_i_2;
			for (_gv_i_2 = 0; _gv_i_2 < NoMstPorts; _gv_i_2 = _gv_i_2 + 1) begin : gen_b_channels
				localparam i = _gv_i_2;
				assign mst_b_valids[i] = mst_resps_i[i].b_valid;
				assign mst_r_valids[i] = mst_resps_i[i].r_valid;
			end
			initial begin : validate_params
				begin : no_mst_ports
					
				end
				begin : AXI_ID_BITS
					
				end
			end
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
