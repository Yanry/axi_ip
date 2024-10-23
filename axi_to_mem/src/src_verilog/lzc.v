module lzc (
	in_i,
	cnt_o,
	empty_o
);
	reg _sv2v_0;
	parameter [31:0] WIDTH = 2;
	parameter [0:0] MODE = 1'b0;
	function automatic [31:0] cf_math_pkg_idx_width;
		input reg [31:0] num_idx;
		cf_math_pkg_idx_width = (num_idx > 32'd1 ? $unsigned($clog2(num_idx)) : 32'd1);
	endfunction
	parameter [31:0] CNT_WIDTH = cf_math_pkg_idx_width(WIDTH);
	input wire [WIDTH - 1:0] in_i;
	output wire [CNT_WIDTH - 1:0] cnt_o;
	output wire empty_o;
	generate
		if (WIDTH == 1) begin : gen_degenerate_lzc
			assign cnt_o[0] = !in_i[0];
			assign empty_o = !in_i[0];
		end
		else begin : gen_lzc
			localparam [31:0] NumLevels = $clog2(WIDTH);
			wire [(WIDTH * NumLevels) - 1:0] index_lut;
			wire [(2 ** NumLevels) - 1:0] sel_nodes;
			wire [((2 ** NumLevels) * NumLevels) - 1:0] index_nodes;
			reg [WIDTH - 1:0] in_tmp;
			always @(*) begin : flip_vector
				if (_sv2v_0)
					;
				begin : sv2v_autoblock_1
					reg [31:0] i;
					for (i = 0; i < WIDTH; i = i + 1)
						in_tmp[i] = (MODE ? in_i[(WIDTH - 1) - i] : in_i[i]);
				end
			end
			genvar _gv_j_2;
			for (_gv_j_2 = 0; $unsigned(_gv_j_2) < WIDTH; _gv_j_2 = _gv_j_2 + 1) begin : g_index_lut
				localparam j = _gv_j_2;
				function automatic [NumLevels - 1:0] sv2v_cast_677FF;
					input reg [NumLevels - 1:0] inp;
					sv2v_cast_677FF = inp;
				endfunction
				assign index_lut[j * NumLevels+:NumLevels] = sv2v_cast_677FF($unsigned(j));
			end
			genvar _gv_level_1;
			for (_gv_level_1 = 0; $unsigned(_gv_level_1) < NumLevels; _gv_level_1 = _gv_level_1 + 1) begin : g_levels
				localparam level = _gv_level_1;
				if ($unsigned(level) == (NumLevels - 1)) begin : g_last_level
					genvar _gv_k_1;
					for (_gv_k_1 = 0; _gv_k_1 < (2 ** level); _gv_k_1 = _gv_k_1 + 1) begin : g_level
						localparam k = _gv_k_1;
						if (($unsigned(k) * 2) < (WIDTH - 1)) begin : g_reduce
							assign sel_nodes[((2 ** level) - 1) + k] = in_tmp[k * 2] | in_tmp[(k * 2) + 1];
							assign index_nodes[(((2 ** level) - 1) + k) * NumLevels+:NumLevels] = (in_tmp[k * 2] == 1'b1 ? index_lut[(k * 2) * NumLevels+:NumLevels] : index_lut[((k * 2) + 1) * NumLevels+:NumLevels]);
						end
						if (($unsigned(k) * 2) == (WIDTH - 1)) begin : g_base
							assign sel_nodes[((2 ** level) - 1) + k] = in_tmp[k * 2];
							assign index_nodes[(((2 ** level) - 1) + k) * NumLevels+:NumLevels] = index_lut[(k * 2) * NumLevels+:NumLevels];
						end
						if (($unsigned(k) * 2) > (WIDTH - 1)) begin : g_out_of_range
							assign sel_nodes[((2 ** level) - 1) + k] = 1'b0;
							assign index_nodes[(((2 ** level) - 1) + k) * NumLevels+:NumLevels] = 1'sb0;
						end
					end
				end
				else begin : g_not_last_level
					genvar _gv_l_1;
					for (_gv_l_1 = 0; _gv_l_1 < (2 ** level); _gv_l_1 = _gv_l_1 + 1) begin : g_level
						localparam l = _gv_l_1;
						assign sel_nodes[((2 ** level) - 1) + l] = sel_nodes[((2 ** (level + 1)) - 1) + (l * 2)] | sel_nodes[(((2 ** (level + 1)) - 1) + (l * 2)) + 1];
						assign index_nodes[(((2 ** level) - 1) + l) * NumLevels+:NumLevels] = (sel_nodes[((2 ** (level + 1)) - 1) + (l * 2)] == 1'b1 ? index_nodes[(((2 ** (level + 1)) - 1) + (l * 2)) * NumLevels+:NumLevels] : index_nodes[((((2 ** (level + 1)) - 1) + (l * 2)) + 1) * NumLevels+:NumLevels]);
					end
				end
			end
			assign cnt_o = (NumLevels > $unsigned(0) ? index_nodes[0+:NumLevels] : {$clog2(WIDTH) {1'b0}});
			assign empty_o = (NumLevels > $unsigned(0) ? ~sel_nodes[0] : ~(|in_i));
		end
	endgenerate
	initial begin : validate_params
		
	end
	initial _sv2v_0 = 0;
endmodule
