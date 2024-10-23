`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 10:21:08 PM
// Design Name: 
// Module Name: axi_to_mem_v
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

module axi_to_mem_v #(
  /// Address width, has to be less or equal than the width off the AXI address field.
  /// Determines the width of `mem_addr_o`. Has to be wide enough to emit the memory region
  /// which should be accessible.
  parameter AddrWidth  = 32,
  /// AXI4+ATOP data width.
  parameter DataWidth  = 32,
  /// AXI4+ATOP user width.
  parameter UserWidth     = 32'd0,
  /// AXI4+ATOP ID width.
  parameter IdWidth    = 12,
  /// Number of banks at output, must evenly divide `DataWidth`.
  parameter NumBanks   = 1,
  /// Depth of memory response buffer. This should be equal to the memory response latency.
  parameter BufDepth   = 1,
  /// Hide write requests if the strb == '0
  parameter HideStrb   = 1'b0,
  /// Depth of output fifo/fall_through_register. Increase for asymmetric backpressure (contention) on banks.
  parameter OutFifoDepth = 1
) (
  /// Clock input.
  input                             clk_i,
  /// Asynchronous reset, active low.
  input                             rst_ni,
  /// Memory stream master, request is valid for this bank.
  output            [NumBanks-1:0]  mem_en_o,
  /// Memory stream master, byte address of the request.
  output [AddrWidth-1:0] [NumBanks-1:0]  mem_addr_o,
  /// Memory stream master, write data for this bank. Valid when `mem_req_o`.
  output [DataWidth/NumBanks-1:0]      [NumBanks-1:0]  mem_wdata_o,
  /// Memory stream master, write enable. Then asserted store of `mem_w_data` is requested.
  output [DataWidth/8-1:0]           [NumBanks-1:0]  mem_we_o,
  /// Memory stream master, read response data.
  input  [DataWidth/NumBanks-1:0]      [NumBanks-1:0]  mem_rdata_i,
  output                            mem_clk_o,
  output                            mem_rst_o,
  
  input  [IdWidth-1:0] axi_awid,
  input  [AddrWidth-1:0] axi_awaddr,
  input  [7:0] axi_awlen,
  input  [2:0] axi_awsize,
  input  [1:0] axi_awburst,
  input  [1:0] axi_awlock,
  input  [3:0] axi_awcache,
  input  [2:0] axi_awprot,
  input  [3:0] axi_awregion,
  input  [3:0] axi_awqos,
  input  [UserWidth-1:0] axi_awuser,
  input  axi_awvalid,
  output  axi_awready,
  
  input  [DataWidth-1:0] axi_wdata,
  input  [DataWidth/8-1:0] axi_wstrb,
  input  axi_wlast,
  input  [UserWidth-1:0] axi_wuser,
  input  axi_wvalid,
  output  axi_wready,
  
  output  [IdWidth-1:0] axi_bid,
  output  [1:0] axi_bresp,
  output  [UserWidth-1:0] axi_buser,
  output  axi_bvalid,
  input  axi_bready,
  
  input  [IdWidth-1:0] axi_arid,
  input  [AddrWidth-1:0] axi_araddr,
  input  [7:0] axi_arlen,
  input  [2:0] axi_arsize,
  input  [1:0] axi_arburst,
  input  [1:0] axi_arlock,
  input  [3:0] axi_arcache,
  input  [2:0] axi_arprot,
  input  [3:0] axi_arregion,
  input  [3:0] axi_arqos,
  input  [UserWidth-1:0] axi_aruser,
  input  axi_arvalid,
  output  axi_arready,
  
  output  [IdWidth-1:0] axi_rid,
  output  [1:0] axi_rresp,
  output  [UserWidth-1:0] axi_ruser,
  output  [DataWidth-1:0] axi_rdata,
  output  axi_rlast,
  output  axi_rvalid,
  input   axi_rready
);

  
  assign mem_clk_o = clk_i;
  assign mem_rst_o = !rst_ni;

  axi_to_mem_sv #(
    .AddrWidth    ( AddrWidth      ),
    .DataWidth    ( DataWidth      ),
    .IdWidth      ( IdWidth        ),
    .NumBanks     ( NumBanks       ),
    .BufDepth     ( BufDepth       ),
    .HideStrb     ( HideStrb       ),
    .OutFifoDepth ( OutFifoDepth   )
  ) i_axi_to_mem (
    .clk_i (clk_i),
    .rst_ni (rst_ni),
    .mem_req_o (mem_en_o),
    .mem_addr_o (mem_addr_o),
    .mem_wdata_o (mem_wdata_o),
    .mem_we_o (mem_we_o),
    .mem_rdata_i (mem_rdata_i),
    
    .axi_awid (axi_awid),
    .axi_awaddr (axi_awaddr),
    .axi_awlen (axi_awlen),
    .axi_awsize (axi_awsize),
    .axi_awburst (axi_awburst),
    .axi_awlock (axi_awlock),
    .axi_awcache (axi_awcache),
    .axi_awprot (axi_awprot),
    .axi_awregion (axi_awregion),
    .axi_awqos (axi_awqos),
    .axi_awuser (axi_awuser),
    .axi_awvalid (axi_awvalid),
    .axi_awready (axi_awready),
    
    .axi_wdata (axi_wdata),
    .axi_wstrb (axi_wstrb),
    .axi_wlast (axi_wlast),
    .axi_wuser (axi_wuser),
    .axi_wvalid (axi_wvalid),
    .axi_wready (axi_wready),
    
    .axi_bid (axi_bid),
    .axi_bresp (axi_bresp),
    .axi_buser (axi_buser),
    .axi_bvalid (axi_bvalid),
    .axi_bready (axi_bready),
    
    .axi_arid (axi_arid),
    .axi_araddr (axi_araddr),
    .axi_arlen (axi_arlen),
    .axi_arsize (axi_arsize),
    .axi_arburst (axi_arburst),
    .axi_arlock (axi_arlock),
    .axi_arcache (axi_arcache),
    .axi_arprot (axi_arprot),
    .axi_arregion (axi_arregion),
    .axi_arqos (axi_arqos),
    .axi_aruser (axi_aruser),
    .axi_arvalid (axi_arvalid),
    .axi_arready (axi_arready),
    
    .axi_rid (axi_rid),
    .axi_rresp (axi_rresp),
    .axi_ruser (axi_ruser),
    .axi_rdata (axi_rdata),
    .axi_rlast (axi_rlast),
    .axi_rvalid (axi_rvalid),
    .axi_rready (axi_rready)
  );

endmodule