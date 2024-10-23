module id_queue_17CB4_38A7A (
	clk_i,
	rst_ni,
	inp_id_i,
	inp_data_i,
	inp_req_i,
	inp_gnt_o,
	exists_data_i,
	exists_mask_i,
	exists_req_i,
	exists_o,
	exists_gnt_o,
	oup_id_i,
	oup_pop_i,
	oup_req_i,
	oup_data_o,
	oup_data_valid_o,
	oup_gnt_o
);
	parameter [31:0] data_t_CntIdxWidth = 0;
	reg _sv2v_0;
	parameter signed [31:0] ID_WIDTH = 0;
	parameter signed [31:0] CAPACITY = 0;
	parameter [0:0] FULL_BW = 0;
	parameter [0:0] CUT_OUP_POP_INP_GNT = 0;
	input wire clk_i;
	input wire rst_ni;
	input wire [ID_WIDTH - 1:0] inp_id_i;
	input wire [data_t_CntIdxWidth - 1:0] inp_data_i;
	input wire inp_req_i;
	output wire inp_gnt_o;
	input wire [data_t_CntIdxWidth - 1:0] exists_data_i;
	input wire [data_t_CntIdxWidth - 1:0] exists_mask_i;
	input wire exists_req_i;
	output reg exists_o;
	output reg exists_gnt_o;
	input wire [ID_WIDTH - 1:0] oup_id_i;
	input wire oup_pop_i;
	input wire oup_req_i;
	output reg [data_t_CntIdxWidth - 1:0] oup_data_o;
	output reg oup_data_valid_o;
	output reg oup_gnt_o;
	localparam signed [31:0] NIds = 2 ** ID_WIDTH;
	localparam signed [31:0] HtCapacity = (NIds <= CAPACITY ? NIds : CAPACITY);
	function automatic [31:0] cf_math_pkg_idx_width;
		input reg [31:0] num_idx;
		cf_math_pkg_idx_width = (num_idx > 32'd1 ? $unsigned($clog2(num_idx)) : 32'd1);
	endfunction
	localparam [31:0] HtIdxWidth = cf_math_pkg_idx_width(HtCapacity);
	localparam [31:0] LdIdxWidth = cf_math_pkg_idx_width(CAPACITY);
	reg [((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (HtCapacity * (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1)) - 1 : (HtCapacity * (1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) - 1)):((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)] head_tail_d;
	reg [((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (HtCapacity * (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1)) - 1 : (HtCapacity * (1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) - 1)):((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)] head_tail_q;
	reg [(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (CAPACITY * ((data_t_CntIdxWidth + LdIdxWidth) + 1)) - 1 : (CAPACITY * (1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + ((data_t_CntIdxWidth + LdIdxWidth) - 1)):(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0)] linked_data_d;
	reg [(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (CAPACITY * ((data_t_CntIdxWidth + LdIdxWidth) + 1)) - 1 : (CAPACITY * (1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + ((data_t_CntIdxWidth + LdIdxWidth) - 1)):(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0)] linked_data_q;
	wire full;
	reg match_in_id_valid;
	reg match_out_id_valid;
	wire no_in_id_match;
	wire no_out_id_match;
	wire [HtCapacity - 1:0] head_tail_free;
	wire [HtCapacity - 1:0] idx_matches_in_id;
	wire [HtCapacity - 1:0] idx_matches_out_id;
	wire [CAPACITY - 1:0] exists_match;
	wire [CAPACITY - 1:0] linked_data_free;
	reg [ID_WIDTH - 1:0] match_in_id;
	reg [ID_WIDTH - 1:0] match_out_id;
	wire [HtIdxWidth - 1:0] head_tail_free_idx;
	wire [HtIdxWidth - 1:0] match_in_idx;
	wire [HtIdxWidth - 1:0] match_out_idx;
	wire [LdIdxWidth - 1:0] linked_data_free_idx;
	wire [LdIdxWidth - 1:0] oup_data_free_idx;
	reg oup_data_popped;
	reg oup_ht_popped;
	genvar _gv_i_8;
	generate
		for (_gv_i_8 = 0; _gv_i_8 < HtCapacity; _gv_i_8 = _gv_i_8 + 1) begin : gen_idx_match
			localparam i = _gv_i_8;
			assign idx_matches_in_id[i] = (match_in_id_valid && (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (i * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0)) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0)))) : (((i * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0)) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0))))) + ((ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0))) >= (LdIdxWidth + (LdIdxWidth + 1)) ? ((ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0))) - (LdIdxWidth + (LdIdxWidth + 1))) + 1 : ((LdIdxWidth + (LdIdxWidth + 1)) - (ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0)))) + 1)) - 1)-:((ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0))) >= (LdIdxWidth + (LdIdxWidth + 1)) ? ((ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0))) - (LdIdxWidth + (LdIdxWidth + 1))) + 1 : ((LdIdxWidth + (LdIdxWidth + 1)) - (ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0)))) + 1)] == match_in_id)) && !head_tail_q[(i * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)];
			assign idx_matches_out_id[i] = (match_out_id_valid && (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (i * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0)) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0)))) : (((i * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0)) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0))))) + ((ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0))) >= (LdIdxWidth + (LdIdxWidth + 1)) ? ((ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0))) - (LdIdxWidth + (LdIdxWidth + 1))) + 1 : ((LdIdxWidth + (LdIdxWidth + 1)) - (ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0)))) + 1)) - 1)-:((ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0))) >= (LdIdxWidth + (LdIdxWidth + 1)) ? ((ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0))) - (LdIdxWidth + (LdIdxWidth + 1))) + 1 : ((LdIdxWidth + (LdIdxWidth + 1)) - (ID_WIDTH + (LdIdxWidth + (LdIdxWidth + 0)))) + 1)] == match_out_id)) && !head_tail_q[(i * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)];
		end
	endgenerate
	assign no_in_id_match = !(|idx_matches_in_id);
	assign no_out_id_match = !(|idx_matches_out_id);
	onehot_to_bin #(.ONEHOT_WIDTH(HtCapacity)) i_id_ohb_in(
		.onehot(idx_matches_in_id),
		.bin(match_in_idx)
	);
	onehot_to_bin #(.ONEHOT_WIDTH(HtCapacity)) i_id_ohb_out(
		.onehot(idx_matches_out_id),
		.bin(match_out_idx)
	);
	genvar _gv_i_9;
	generate
		for (_gv_i_9 = 0; _gv_i_9 < HtCapacity; _gv_i_9 = _gv_i_9 + 1) begin : gen_head_tail_free
			localparam i = _gv_i_9;
			assign head_tail_free[i] = head_tail_q[(i * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)];
		end
	endgenerate
	lzc #(
		.WIDTH(HtCapacity),
		.MODE(0)
	) i_ht_free_lzc(
		.in_i(head_tail_free),
		.cnt_o(head_tail_free_idx),
		.empty_o()
	);
	genvar _gv_i_10;
	generate
		for (_gv_i_10 = 0; _gv_i_10 < CAPACITY; _gv_i_10 = _gv_i_10 + 1) begin : gen_linked_data_free
			localparam i = _gv_i_10;
			assign linked_data_free[i] = linked_data_q[(i * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0)];
		end
	endgenerate
	lzc #(
		.WIDTH(CAPACITY),
		.MODE(0)
	) i_ld_free_lzc(
		.in_i(linked_data_free),
		.cnt_o(linked_data_free_idx),
		.empty_o()
	);
	assign full = !(|linked_data_free);
	assign oup_data_free_idx = head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)];
	assign inp_gnt_o = ~full || ((oup_data_popped && FULL_BW) && ~CUT_OUP_POP_INP_GNT);
	function automatic [ID_WIDTH - 1:0] sv2v_cast_64419;
		input reg [ID_WIDTH - 1:0] inp;
		sv2v_cast_64419 = inp;
	endfunction
	function automatic [LdIdxWidth - 1:0] sv2v_cast_1B5F4;
		input reg [LdIdxWidth - 1:0] inp;
		sv2v_cast_1B5F4 = inp;
	endfunction
	function automatic [ID_WIDTH - 1:0] sv2v_cast_73B57;
		input reg [ID_WIDTH - 1:0] inp;
		sv2v_cast_73B57 = inp;
	endfunction
	function automatic [LdIdxWidth - 1:0] sv2v_cast_F8816;
		input reg [LdIdxWidth - 1:0] inp;
		sv2v_cast_F8816 = inp;
	endfunction
	function automatic [data_t_CntIdxWidth - 1:0] sv2v_cast_27109;
		input reg [data_t_CntIdxWidth - 1:0] inp;
		sv2v_cast_27109 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		match_in_id = 1'sb0;
		match_out_id = 1'sb0;
		match_in_id_valid = 1'b0;
		match_out_id_valid = 1'b0;
		head_tail_d = head_tail_q;
		linked_data_d = linked_data_q;
		oup_gnt_o = 1'b0;
		oup_data_o = sv2v_cast_27109(1'sb0);
		oup_data_valid_o = 1'b0;
		oup_data_popped = 1'b0;
		oup_ht_popped = 1'b0;
		if (!FULL_BW) begin
			if (inp_req_i && !full) begin
				match_in_id = inp_id_i;
				match_in_id_valid = 1'b1;
				if (no_in_id_match)
					head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) + (head_tail_free_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)))+:((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))] = {sv2v_cast_64419(inp_id_i), sv2v_cast_1B5F4(linked_data_free_idx), sv2v_cast_1B5F4(linked_data_free_idx), 1'b0};
				else begin
					linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] = linked_data_free_idx;
					head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] = linked_data_free_idx;
				end
				linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (linked_data_free_idx * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] = {sv2v_cast_27109(inp_data_i), sv2v_cast_1B5F4(1'sb0), 1'b0};
			end
			else if (oup_req_i) begin
				match_in_id = oup_id_i;
				match_in_id_valid = 1'b1;
				if (!no_in_id_match) begin
					oup_data_o = sv2v_cast_27109(linked_data_q[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? data_t_CntIdxWidth + (LdIdxWidth + 0) : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (data_t_CntIdxWidth + (LdIdxWidth + 0))) : (((head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? data_t_CntIdxWidth + (LdIdxWidth + 0) : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (data_t_CntIdxWidth + (LdIdxWidth + 0)))) + ((data_t_CntIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((data_t_CntIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (data_t_CntIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((data_t_CntIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((data_t_CntIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (data_t_CntIdxWidth + (LdIdxWidth + 0))) + 1)]);
					oup_data_valid_o = 1'b1;
					if (oup_pop_i) begin
						linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] = 1'sb0;
						linked_data_d[(head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0)] = 1'b1;
						if (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] == head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))])
							head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) + (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)))+:((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))] = {sv2v_cast_73B57(1'sb0), sv2v_cast_F8816(1'sb0), sv2v_cast_F8816(1'sb0), 1'b1};
						else
							head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] = linked_data_q[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))];
					end
				end
				oup_gnt_o = 1'b1;
			end
		end
		else begin
			if (oup_req_i) begin
				match_out_id = oup_id_i;
				match_out_id_valid = 1'b1;
				if (!no_out_id_match) begin
					oup_data_o = sv2v_cast_27109(linked_data_q[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? data_t_CntIdxWidth + (LdIdxWidth + 0) : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (data_t_CntIdxWidth + (LdIdxWidth + 0))) : (((head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? data_t_CntIdxWidth + (LdIdxWidth + 0) : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (data_t_CntIdxWidth + (LdIdxWidth + 0)))) + ((data_t_CntIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((data_t_CntIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (data_t_CntIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((data_t_CntIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((data_t_CntIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (data_t_CntIdxWidth + (LdIdxWidth + 0))) + 1)]);
					oup_data_valid_o = 1'b1;
					if (oup_pop_i) begin
						oup_data_popped = 1'b1;
						linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] = 1'sb0;
						linked_data_d[(head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0)] = 1'b1;
						if (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] == head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))]) begin
							oup_ht_popped = 1'b1;
							head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) + (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)))+:((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))] = {sv2v_cast_73B57(1'sb0), sv2v_cast_F8816(1'sb0), sv2v_cast_F8816(1'sb0), 1'b1};
						end
						else
							head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] = linked_data_q[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0))) : (((match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + (LdIdxWidth + 0) : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + (LdIdxWidth + 0)))) + ((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)) - 1)-:((LdIdxWidth + (LdIdxWidth + 0)) >= (LdIdxWidth + 1) ? ((LdIdxWidth + (LdIdxWidth + 0)) - (LdIdxWidth + 1)) + 1 : ((LdIdxWidth + 1) - (LdIdxWidth + (LdIdxWidth + 0))) + 1)] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))];
					end
				end
				oup_gnt_o = 1'b1;
			end
			if (inp_req_i && inp_gnt_o) begin
				match_in_id = inp_id_i;
				match_in_id_valid = 1'b1;
				if (oup_ht_popped && (oup_id_i == inp_id_i)) begin
					head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) + (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)))+:((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))] = {sv2v_cast_64419(inp_id_i), sv2v_cast_1B5F4(oup_data_free_idx), sv2v_cast_1B5F4(oup_data_free_idx), 1'b0};
					linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (oup_data_free_idx * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] = {sv2v_cast_27109(inp_data_i), sv2v_cast_1B5F4(1'sb0), 1'b0};
				end
				else if (no_in_id_match) begin
					if (oup_ht_popped) begin
						head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) + (match_out_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)))+:((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))] = {sv2v_cast_64419(inp_id_i), sv2v_cast_1B5F4(oup_data_free_idx), sv2v_cast_1B5F4(oup_data_free_idx), 1'b0};
						linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (oup_data_free_idx * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] = {sv2v_cast_27109(inp_data_i), sv2v_cast_1B5F4(1'sb0), 1'b0};
					end
					else if (oup_data_popped) begin
						head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) + (head_tail_free_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)))+:((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))] = {sv2v_cast_64419(inp_id_i), sv2v_cast_1B5F4(oup_data_free_idx), sv2v_cast_1B5F4(oup_data_free_idx), 1'b0};
						linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (oup_data_free_idx * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] = {sv2v_cast_27109(inp_data_i), sv2v_cast_1B5F4(1'sb0), 1'b0};
					end
					else begin
						head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) + (head_tail_free_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)))+:((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))] = {sv2v_cast_64419(inp_id_i), sv2v_cast_1B5F4(linked_data_free_idx), sv2v_cast_1B5F4(linked_data_free_idx), 1'b0};
						linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (linked_data_free_idx * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] = {sv2v_cast_27109(inp_data_i), sv2v_cast_1B5F4(1'sb0), 1'b0};
					end
				end
				else if (oup_data_popped) begin
					linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] = oup_data_free_idx;
					head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] = oup_data_free_idx;
					linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (oup_data_free_idx * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] = {sv2v_cast_27109(inp_data_i), sv2v_cast_1B5F4(1'sb0), 1'b0};
				end
				else begin
					linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] = linked_data_free_idx;
					head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? (match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0)) : (((match_in_idx * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))) + ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? LdIdxWidth + 0 : (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) - (LdIdxWidth + 0))) + ((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))) - 1)-:((LdIdxWidth + 0) >= 1 ? LdIdxWidth + 0 : 2 - (LdIdxWidth + 0))] = linked_data_free_idx;
					linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (linked_data_free_idx * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] = {sv2v_cast_27109(inp_data_i), sv2v_cast_1B5F4(1'sb0), 1'b0};
				end
			end
		end
	end
	genvar _gv_i_11;
	generate
		for (_gv_i_11 = 0; _gv_i_11 < CAPACITY; _gv_i_11 = _gv_i_11 + 1) begin : gen_lookup
			localparam i = _gv_i_11;
			reg [data_t_CntIdxWidth - 1:0] exists_match_bits;
			genvar _gv_j_1;
			for (_gv_j_1 = 0; _gv_j_1 < data_t_CntIdxWidth; _gv_j_1 = _gv_j_1 + 1) begin : gen_mask
				localparam j = _gv_j_1;
				always @(*) begin
					if (_sv2v_0)
						;
					if (linked_data_q[(i * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0)])
						exists_match_bits[j] = 1'b0;
					else if (!exists_mask_i[j])
						exists_match_bits[j] = 1'b1;
					else
						exists_match_bits[j] = linked_data_q[(i * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + (LdIdxWidth + 0)) - ((data_t_CntIdxWidth - 1) - j) : ((data_t_CntIdxWidth + LdIdxWidth) + 0) - ((data_t_CntIdxWidth + (LdIdxWidth + 0)) - ((data_t_CntIdxWidth - 1) - j)))] == exists_data_i[j];
				end
			end
			assign exists_match[i] = &exists_match_bits;
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		exists_gnt_o = 1'b0;
		exists_o = 1'sb0;
		if (exists_req_i) begin
			exists_gnt_o = 1'b1;
			exists_o = |exists_match;
		end
	end
	genvar _gv_i_12;
	generate
		for (_gv_i_12 = 0; _gv_i_12 < HtCapacity; _gv_i_12 = _gv_i_12 + 1) begin : gen_ht_ffs
			localparam i = _gv_i_12;
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) + (i * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)))+:((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))] <= {sv2v_cast_73B57(1'sb0), sv2v_cast_F8816(1'sb0), sv2v_cast_F8816(1'sb0), 1'b1};
				else
					head_tail_q[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) + (i * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)))+:((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))] <= head_tail_d[((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? 0 : ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) + (i * ((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0)))+:((((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0) >= 0 ? ((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 1 : 1 - (((ID_WIDTH + LdIdxWidth) + LdIdxWidth) + 0))];
		end
	endgenerate
	genvar _gv_i_13;
	generate
		for (_gv_i_13 = 0; _gv_i_13 < CAPACITY; _gv_i_13 = _gv_i_13 + 1) begin : gen_data_ffs
			localparam i = _gv_i_13;
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni) begin
					linked_data_q[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (i * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] <= 1'sb0;
					linked_data_q[(i * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))) + (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0)] <= 1'b1;
				end
				else
					linked_data_q[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (i * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))] <= linked_data_d[(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? 0 : (data_t_CntIdxWidth + LdIdxWidth) + 0) + (i * (((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0)))+:(((data_t_CntIdxWidth + LdIdxWidth) + 0) >= 0 ? (data_t_CntIdxWidth + LdIdxWidth) + 1 : 1 - ((data_t_CntIdxWidth + LdIdxWidth) + 0))];
		end
	endgenerate
	initial begin : validate_params
		
	end
	initial _sv2v_0 = 0;
endmodule
