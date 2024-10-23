module onehot_to_bin (
	onehot,
	bin
);
	parameter [31:0] ONEHOT_WIDTH = 16;
	parameter [31:0] BIN_WIDTH = (ONEHOT_WIDTH == 1 ? 1 : $clog2(ONEHOT_WIDTH));
	input wire [ONEHOT_WIDTH - 1:0] onehot;
	output wire [BIN_WIDTH - 1:0] bin;
	genvar _gv_j_3;
	function automatic signed [BIN_WIDTH - 1:0] sv2v_cast_B4C80_signed;
		input reg signed [BIN_WIDTH - 1:0] inp;
		sv2v_cast_B4C80_signed = inp;
	endfunction
	generate
		for (_gv_j_3 = 0; _gv_j_3 < BIN_WIDTH; _gv_j_3 = _gv_j_3 + 1) begin : gen_jl
			localparam j = _gv_j_3;
			wire [ONEHOT_WIDTH - 1:0] tmp_mask;
			genvar _gv_i_16;
			for (_gv_i_16 = 0; _gv_i_16 < ONEHOT_WIDTH; _gv_i_16 = _gv_i_16 + 1) begin : gen_il
				localparam i = _gv_i_16;
				wire [BIN_WIDTH - 1:0] tmp_i;
				assign tmp_i = sv2v_cast_B4C80_signed(i);
				assign tmp_mask[i] = tmp_i[j];
			end
			assign bin[j] = |(tmp_mask & onehot);
		end
	endgenerate
endmodule
