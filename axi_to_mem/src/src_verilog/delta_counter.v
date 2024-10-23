module delta_counter (
	clk_i,
	rst_ni,
	clear_i,
	en_i,
	load_i,
	down_i,
	delta_i,
	d_i,
	q_o,
	overflow_o
);
	reg _sv2v_0;
	parameter [31:0] WIDTH = 4;
	parameter [0:0] STICKY_OVERFLOW = 1'b0;
	input wire clk_i;
	input wire rst_ni;
	input wire clear_i;
	input wire en_i;
	input wire load_i;
	input wire down_i;
	input wire [WIDTH - 1:0] delta_i;
	input wire [WIDTH - 1:0] d_i;
	output wire [WIDTH - 1:0] q_o;
	output wire overflow_o;
	reg [WIDTH:0] counter_q;
	reg [WIDTH:0] counter_d;
	generate
		if (STICKY_OVERFLOW) begin : gen_sticky_overflow
			reg overflow_d;
			reg overflow_q;
			always @(posedge clk_i or negedge rst_ni) overflow_q <= (~rst_ni ? 1'b0 : overflow_d);
			always @(*) begin
				if (_sv2v_0)
					;
				overflow_d = overflow_q;
				if (clear_i || load_i)
					overflow_d = 1'b0;
				else if (!overflow_q && en_i) begin
					if (down_i)
						overflow_d = delta_i > counter_q[WIDTH - 1:0];
					else
						overflow_d = counter_q[WIDTH - 1:0] > ({WIDTH {1'b1}} - delta_i);
				end
			end
			assign overflow_o = overflow_q;
		end
		else begin : gen_transient_overflow
			assign overflow_o = counter_q[WIDTH];
		end
	endgenerate
	assign q_o = counter_q[WIDTH - 1:0];
	always @(*) begin
		if (_sv2v_0)
			;
		counter_d = counter_q;
		if (clear_i)
			counter_d = 1'sb0;
		else if (load_i)
			counter_d = {1'b0, d_i};
		else if (en_i) begin
			if (down_i)
				counter_d = counter_q - delta_i;
			else
				counter_d = counter_q + delta_i;
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			counter_q <= 1'sb0;
		else
			counter_q <= counter_d;
	initial _sv2v_0 = 0;
endmodule
