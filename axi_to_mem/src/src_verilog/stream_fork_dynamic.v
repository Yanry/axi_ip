module stream_fork_dynamic (
	clk_i,
	rst_ni,
	valid_i,
	ready_o,
	sel_i,
	sel_valid_i,
	sel_ready_o,
	valid_o,
	ready_i
);
	reg _sv2v_0;
	parameter [31:0] N_OUP = 32'd0;
	input wire clk_i;
	input wire rst_ni;
	input wire valid_i;
	output reg ready_o;
	input wire [N_OUP - 1:0] sel_i;
	input wire sel_valid_i;
	output reg sel_ready_o;
	output reg [N_OUP - 1:0] valid_o;
	input wire [N_OUP - 1:0] ready_i;
	reg int_inp_valid;
	wire int_inp_ready;
	wire [N_OUP - 1:0] int_oup_valid;
	reg [N_OUP - 1:0] int_oup_ready;
	genvar _gv_i_18;
	generate
		for (_gv_i_18 = 0; _gv_i_18 < N_OUP; _gv_i_18 = _gv_i_18 + 1) begin : gen_oups
			localparam i = _gv_i_18;
			always @(*) begin
				if (_sv2v_0)
					;
				valid_o[i] = 1'b0;
				int_oup_ready[i] = 1'b0;
				if (sel_valid_i) begin
					if (sel_i[i]) begin
						valid_o[i] = int_oup_valid[i];
						int_oup_ready[i] = ready_i[i];
					end
					else
						int_oup_ready[i] = 1'b1;
				end
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		int_inp_valid = 1'b0;
		ready_o = 1'b0;
		sel_ready_o = 1'b0;
		if (sel_valid_i) begin
			int_inp_valid = valid_i;
			ready_o = int_inp_ready;
			sel_ready_o = int_inp_ready;
		end
	end
	stream_fork #(.N_OUP(N_OUP)) i_fork(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.valid_i(int_inp_valid),
		.ready_o(int_inp_ready),
		.valid_o(int_oup_valid),
		.ready_i(int_oup_ready)
	);
	initial begin : p_assertions
		
	end
	initial _sv2v_0 = 0;
endmodule
