module axi_demux_id_counters_2349C_D3F56 (
	clk_i,
	rst_ni,
	lookup_axi_id_i,
	lookup_mst_select_o,
	lookup_mst_select_occupied_o,
	full_o,
	push_axi_id_i,
	push_mst_select_i,
	push_i,
	inject_axi_id_i,
	inject_i,
	pop_axi_id_i,
	pop_i
);
	parameter [31:0] mst_port_select_t_SelectWidth = 0;
	reg _sv2v_0;
	parameter [31:0] AxiIdBits = 2;
	parameter [31:0] CounterWidth = 4;
	input clk_i;
	input rst_ni;
	input wire [AxiIdBits - 1:0] lookup_axi_id_i;
	output wire [mst_port_select_t_SelectWidth - 1:0] lookup_mst_select_o;
	output wire lookup_mst_select_occupied_o;
	output wire full_o;
	input wire [AxiIdBits - 1:0] push_axi_id_i;
	input wire [mst_port_select_t_SelectWidth - 1:0] push_mst_select_i;
	input wire push_i;
	input wire [AxiIdBits - 1:0] inject_axi_id_i;
	input wire inject_i;
	input wire [AxiIdBits - 1:0] pop_axi_id_i;
	input wire pop_i;
	localparam [31:0] NoCounters = 2 ** AxiIdBits;
	reg [(NoCounters * mst_port_select_t_SelectWidth) - 1:0] mst_select_q;
	wire [NoCounters - 1:0] push_en;
	wire [NoCounters - 1:0] inject_en;
	wire [NoCounters - 1:0] pop_en;
	wire [NoCounters - 1:0] occupied;
	wire [NoCounters - 1:0] cnt_full;
	assign lookup_mst_select_o = mst_select_q[lookup_axi_id_i * mst_port_select_t_SelectWidth+:mst_port_select_t_SelectWidth];
	assign lookup_mst_select_occupied_o = occupied[lookup_axi_id_i];
	assign push_en = (push_i ? 1 << push_axi_id_i : {NoCounters {1'sb0}});
	assign inject_en = (inject_i ? 1 << inject_axi_id_i : {NoCounters {1'sb0}});
	assign pop_en = (pop_i ? 1 << pop_axi_id_i : {NoCounters {1'sb0}});
	assign full_o = |cnt_full;
	genvar _gv_i_3;
	function automatic [CounterWidth - 1:0] sv2v_cast_9AD3B;
		input reg [CounterWidth - 1:0] inp;
		sv2v_cast_9AD3B = inp;
	endfunction
	generate
		for (_gv_i_3 = 0; _gv_i_3 < NoCounters; _gv_i_3 = _gv_i_3 + 1) begin : gen_counters
			localparam i = _gv_i_3;
			reg cnt_en;
			reg cnt_down;
			wire overflow;
			reg [CounterWidth - 1:0] cnt_delta;
			wire [CounterWidth - 1:0] in_flight;
			always @(*) begin
				if (_sv2v_0)
					;
				(* full_case, parallel_case *)
				case ({push_en[i], inject_en[i], pop_en[i]})
					3'b001: begin
						cnt_en = 1'b1;
						cnt_down = 1'b1;
						cnt_delta = sv2v_cast_9AD3B(1);
					end
					3'b010: begin
						cnt_en = 1'b1;
						cnt_down = 1'b0;
						cnt_delta = sv2v_cast_9AD3B(1);
					end
					3'b100: begin
						cnt_en = 1'b1;
						cnt_down = 1'b0;
						cnt_delta = sv2v_cast_9AD3B(1);
					end
					3'b110: begin
						cnt_en = 1'b1;
						cnt_down = 1'b0;
						cnt_delta = sv2v_cast_9AD3B(2);
					end
					3'b111: begin
						cnt_en = 1'b1;
						cnt_down = 1'b0;
						cnt_delta = sv2v_cast_9AD3B(1);
					end
					default: begin
						cnt_en = 1'b0;
						cnt_down = 1'b0;
						cnt_delta = sv2v_cast_9AD3B(0);
					end
				endcase
			end
			localparam [31:0] sv2v_uu_i_in_flight_cnt_WIDTH = CounterWidth;
			localparam [CounterWidth - 1:0] sv2v_uu_i_in_flight_cnt_ext_d_i_0 = 1'sb0;
			delta_counter #(
				.WIDTH(CounterWidth),
				.STICKY_OVERFLOW(1'b0)
			) i_in_flight_cnt(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.clear_i(1'b0),
				.en_i(cnt_en),
				.load_i(1'b0),
				.down_i(cnt_down),
				.delta_i(cnt_delta),
				.d_i(sv2v_uu_i_in_flight_cnt_ext_d_i_0),
				.q_o(in_flight),
				.overflow_o(overflow)
			);
			assign occupied[i] = |in_flight;
			assign cnt_full[i] = overflow | &in_flight;
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mst_select_q[i * mst_port_select_t_SelectWidth+:mst_port_select_t_SelectWidth] <= 1'sb0;
				else if (push_en[i])
					mst_select_q[i * mst_port_select_t_SelectWidth+:mst_port_select_t_SelectWidth] <= push_mst_select_i;
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
