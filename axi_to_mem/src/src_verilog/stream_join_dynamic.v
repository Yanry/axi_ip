module stream_join_dynamic (
	inp_valid_i,
	inp_ready_o,
	sel_i,
	oup_valid_o,
	oup_ready_i
);
	parameter [31:0] N_INP = 32'd0;
	input wire [N_INP - 1:0] inp_valid_i;
	output wire [N_INP - 1:0] inp_ready_o;
	input wire [N_INP - 1:0] sel_i;
	output wire oup_valid_o;
	input wire oup_ready_i;
	assign oup_valid_o = &(inp_valid_i | ~sel_i) && |sel_i;
	genvar _gv_i_20;
	generate
		for (_gv_i_20 = 0; _gv_i_20 < N_INP; _gv_i_20 = _gv_i_20 + 1) begin : gen_inp_ready
			localparam i = _gv_i_20;
			assign inp_ready_o[i] = oup_valid_o & oup_ready_i;
		end
	endgenerate
	initial begin : p_assertions
		
	end
endmodule
