module spill_register_flushable_9D7FB_6DF18 (
	clk_i,
	rst_ni,
	valid_i,
	flush_i,
	ready_o,
	data_i,
	valid_o,
	ready_i,
	data_o
);
	parameter [31:0] T_T_w_chan_t_DataWidth = 0;
	parameter [31:0] T_T_w_chan_t_UserWidth = 0;
	parameter [0:0] Bypass = 1'b0;
	input wire clk_i;
	input wire rst_ni;
	input wire valid_i;
	input wire flush_i;
	output wire ready_o;
	input wire [(((T_T_w_chan_t_DataWidth + (T_T_w_chan_t_DataWidth / 8)) + 1) + T_T_w_chan_t_UserWidth) - 1:0] data_i;
	output wire valid_o;
	input wire ready_i;
	output wire [(((T_T_w_chan_t_DataWidth + (T_T_w_chan_t_DataWidth / 8)) + 1) + T_T_w_chan_t_UserWidth) - 1:0] data_o;
	function automatic [(((T_T_w_chan_t_DataWidth + (T_T_w_chan_t_DataWidth / 8)) + 1) + T_T_w_chan_t_UserWidth) - 1:0] sv2v_cast_C9890;
		input reg [(((T_T_w_chan_t_DataWidth + (T_T_w_chan_t_DataWidth / 8)) + 1) + T_T_w_chan_t_UserWidth) - 1:0] inp;
		sv2v_cast_C9890 = inp;
	endfunction
	generate
		if (Bypass) begin : gen_bypass
			assign valid_o = valid_i;
			assign ready_o = ready_i;
			assign data_o = data_i;
		end
		else begin : gen_spill_reg
			reg [(((T_T_w_chan_t_DataWidth + (T_T_w_chan_t_DataWidth / 8)) + 1) + T_T_w_chan_t_UserWidth) - 1:0] a_data_q;
			reg a_full_q;
			wire a_fill;
			wire a_drain;
			always @(posedge clk_i or negedge rst_ni) begin : ps_a_data
				if (!rst_ni)
					a_data_q <= sv2v_cast_C9890(1'sb0);
				else if (a_fill)
					a_data_q <= data_i;
			end
			always @(posedge clk_i or negedge rst_ni) begin : ps_a_full
				if (!rst_ni)
					a_full_q <= 0;
				else if (a_fill || a_drain)
					a_full_q <= a_fill;
			end
			reg [(((T_T_w_chan_t_DataWidth + (T_T_w_chan_t_DataWidth / 8)) + 1) + T_T_w_chan_t_UserWidth) - 1:0] b_data_q;
			reg b_full_q;
			wire b_fill;
			wire b_drain;
			always @(posedge clk_i or negedge rst_ni) begin : ps_b_data
				if (!rst_ni)
					b_data_q <= sv2v_cast_C9890(1'sb0);
				else if (b_fill)
					b_data_q <= a_data_q;
			end
			always @(posedge clk_i or negedge rst_ni) begin : ps_b_full
				if (!rst_ni)
					b_full_q <= 0;
				else if (b_fill || b_drain)
					b_full_q <= b_fill;
			end
			assign a_fill = (valid_i && ready_o) && !flush_i;
			assign a_drain = (a_full_q && !b_full_q) || flush_i;
			assign b_fill = (a_drain && !ready_i) && !flush_i;
			assign b_drain = (b_full_q && ready_i) || flush_i;
			assign ready_o = !a_full_q || !b_full_q;
			assign valid_o = a_full_q | b_full_q;
			assign data_o = (b_full_q ? b_data_q : a_data_q);
		end
	endgenerate
endmodule
