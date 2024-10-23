`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 10:21:08 PM
// Design Name: 
// Module Name: axi_to_mem_sv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "axi/typedef.svh"
module axi_to_mem_sv #(
  /// Address width, has to be less or equal than the width off the AXI address field.
  /// Determines the width of `mem_addr_o`. Has to be wide enough to emit the memory region
  /// which should be accessible.
  parameter int unsigned AddrWidth  = 32,
  /// AXI4+ATOP data width.
  parameter int unsigned DataWidth  = 32,
  /// AXI4+ATOP user width.
  parameter int unsigned UserWidth     = 32'd0,
  /// AXI4+ATOP ID width.
  parameter int unsigned IdWidth    = 12,
  /// Number of banks at output, must evenly divide `DataWidth`.
  parameter int unsigned NumBanks   = 1,
  /// Depth of memory response buffer. This should be equal to the memory response latency.
  parameter int unsigned BufDepth   = 1,
  /// Hide write requests if the strb == '0
  parameter bit          HideStrb   = 1'b0,
  /// Depth of output fifo/fall_through_register. Increase for asymmetric backpressure (contention) on banks.
  parameter int unsigned OutFifoDepth = 1,
  /// Dependent parameter, do not override. Memory address type.
  localparam type addr_t     = logic [AddrWidth-1:0],
  /// Dependent parameter, do not override. Memory data type.
  localparam type mem_data_t = logic [DataWidth/NumBanks-1:0]
) (
  /// Clock input.
  input  logic                           clk_i,
  /// Asynchronous reset, active low.
  input  logic                           rst_ni,
  /// Memory stream master, request is valid for this bank.
  output logic           [NumBanks-1:0]  mem_req_o,
  /// Memory stream master, byte address of the request.
  output addr_t          [NumBanks-1:0]  mem_addr_o,
  /// Memory stream master, write data for this bank. Valid when `mem_req_o`.
  output mem_data_t      [NumBanks-1:0]  mem_wdata_o,
  /// Memory stream master, write enable. Then asserted store of `mem_w_data` is requested.
  output [DataWidth/8-1:0]           [NumBanks-1:0]  mem_we_o,
  /// Memory stream master, read response data.
  input  mem_data_t      [NumBanks-1:0]  mem_rdata_i,
  
  input logic [IdWidth-1:0] axi_awid,
  input logic [AddrWidth-1:0] axi_awaddr,
  input logic [7:0] axi_awlen,
  input logic [2:0] axi_awsize,
  input logic [1:0] axi_awburst,
  input logic [1:0] axi_awlock,
  input logic [3:0] axi_awcache,
  input logic [2:0] axi_awprot,
  input logic [3:0] axi_awregion,
  input logic [3:0] axi_awqos,
  input logic [UserWidth-1:0] axi_awuser,
  input logic axi_awvalid,
  output logic axi_awready,
  
  input logic [DataWidth-1:0] axi_wdata,
  input logic [DataWidth/8-1:0] axi_wstrb,
  input logic axi_wlast,
  input logic [UserWidth-1:0] axi_wuser,
  input logic axi_wvalid,
  output logic axi_wready,
  
  output logic [IdWidth-1:0] axi_bid,
  output logic [1:0] axi_bresp,
  output logic [UserWidth-1:0] axi_buser,
  output logic axi_bvalid,
  input logic axi_bready,
  
  input logic [IdWidth-1:0] axi_arid,
  input logic [AddrWidth-1:0] axi_araddr,
  input logic [7:0] axi_arlen,
  input logic [2:0] axi_arsize,
  input logic [1:0] axi_arburst,
  input logic [1:0] axi_arlock,
  input logic [3:0] axi_arcache,
  input logic [2:0] axi_arprot,
  input logic [3:0] axi_arregion,
  input logic [3:0] axi_arqos,
  input logic [UserWidth-1:0] axi_aruser,
  input logic axi_arvalid,
  output logic axi_arready,
  
  output logic [IdWidth-1:0] axi_rid,
  output logic [1:0] axi_rresp,
  output logic [UserWidth-1:0] axi_ruser,
  output logic [DataWidth-1:0] axi_rdata,
  output logic axi_rlast,
  output logic axi_rvalid,
  input logic axi_rready
  );
  
  typedef logic [IdWidth-1:0]     id_t;
  typedef logic [DataWidth-1:0]   data_t;
  typedef logic [DataWidth/8-1:0] strb_t;
  typedef logic [UserWidth-1:0]   user_t;
  `AXI_TYPEDEF_AW_CHAN_T(aw_chan_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_W_CHAN_T(w_chan_t, data_t, strb_t, user_t)
  `AXI_TYPEDEF_B_CHAN_T(b_chan_t, id_t, user_t)
  `AXI_TYPEDEF_AR_CHAN_T(ar_chan_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_R_CHAN_T(r_chan_t, data_t, id_t, user_t)
  `AXI_TYPEDEF_REQ_T(req_t, aw_chan_t, w_chan_t, ar_chan_t)
  `AXI_TYPEDEF_RESP_T(resp_t, b_chan_t, r_chan_t)
  req_t   req;
  resp_t  resp;
  
  assign req.aw.atop = 'b0;
  assign req.aw.id = axi_awid;
  assign req.aw.addr = axi_awaddr;
  assign req.aw.len = axi_awlen;
  assign req.aw.size = axi_awsize;
  assign req.aw.burst = axi_awburst;
  assign req.aw.lock = axi_awlock[0];
  assign req.aw.cache = axi_awcache;
  assign req.aw.prot = axi_awprot;
  assign req.aw.region = axi_awregion;
  assign req.aw.qos = axi_awqos;
  assign req.aw.user = axi_awuser;
  assign req.aw_valid = axi_awvalid;
  assign axi_awready = resp.aw_ready;
  
  assign req.w.data = axi_wdata;
  assign req.w.strb = axi_wstrb;
  assign req.w.last = axi_wlast;
  assign req.w.user = axi_wuser;
  assign req.w_valid = axi_wvalid;
  assign axi_wready = resp.w_ready;
  
  assign axi_bid = resp.b.id;
  assign axi_bresp = resp.b.resp;
  assign axi_buser = resp.b.user;
  assign axi_bvalid = resp.b_valid;
  assign req.b_ready = axi_bready;
  
  assign req.ar.id = axi_arid;
  assign req.ar.addr = axi_araddr;
  assign req.ar.len = axi_arlen;
  assign req.ar.size = axi_arsize;
  assign req.ar.burst = axi_arburst;
  assign req.ar.lock = axi_arlock[0];
  assign req.ar.cache = axi_arcache;
  assign req.ar.prot = axi_arprot;
  assign req.ar.region = axi_arregion;
  assign req.ar.qos = axi_arqos;
  assign req.ar.user = axi_aruser;
  assign req.ar_valid = axi_arvalid;
  assign axi_arready = resp.ar_ready;
  
  assign axi_rid = resp.r.id;
  assign axi_rresp = resp.r.resp;
  assign axi_ruser = resp.r.user;
  assign axi_rdata = resp.r.data;
  assign axi_rlast = resp.r.last;
  assign axi_rvalid = resp.r_valid;
  assign req.r_ready = axi_rready;
  
  reg mem_rvalid_i;
  always @(posedge clk_i) begin
    if (!rst_ni) begin
        mem_rvalid_i <= 0;
    end
    else begin
        mem_rvalid_i <= (resp.w_ready && req.w_valid && req.w.last) || (resp.ar_ready && req.ar_valid);
    end
  end
  
  wire mem_we, mem_gnt;
  wire [DataWidth/8-1:0] mem_strb;
  assign mem_we_o = mem_we?mem_strb:'b0;
  assign mem_gnt = 1'b1;
  
  axi_to_mem #(
    .axi_req_t    ( req_t          ),
    .axi_resp_t   ( resp_t         ),
    .AddrWidth    ( AddrWidth      ),
    .DataWidth    ( DataWidth      ),
    .IdWidth      ( IdWidth        ),
    .NumBanks     ( NumBanks       ),
    .BufDepth     ( BufDepth       ),
    .HideStrb     ( HideStrb       ),
    .OutFifoDepth ( OutFifoDepth   )
  ) i_axi_to_mem (
    .clk_i,
    .rst_ni,
    .busy_o (),
    .axi_req_i  ( req  ),
    .axi_resp_o ( resp ),
    .mem_req_o,
    .mem_gnt_i  ( mem_gnt ),
    .mem_addr_o,
    .mem_wdata_o,
    .mem_strb_o (mem_strb),
    .mem_atop_o (),
    .mem_we_o (mem_we),
    .mem_rvalid_i (mem_rvalid_i),
    .mem_rdata_i
  );
endmodule
