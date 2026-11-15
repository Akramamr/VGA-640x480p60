module vega
#( //------parameters----------
parameter H_ACTIVE =640 ,
parameter H_FRONT_PORCH =16 ,
parameter H_SYNC_PORCH =800 ,
parameter H_SYNC_PULSE =96 ,
parameter H_BACK_PORCH =48 ,
parameter V_ACTIVE =480 ,
parameter V_FRONT_PORCH =10 ,
parameter V_SYNC_PULSE =2 ,
parameter V_SYNC_PORCH =525 ,
parameter V_BACK_PORCH =33 ,
parameter BPP =8,
parameter addr_w = $clog2(H_ACTIVE * V_ACTIVE)
)
//-------signals-------------
(
input clk,rstn,
output reg h_sync,V_sync,
output reg [BPP-1:0] rgb,
output reg [addr_w-1:0] addr,
output wire video_on,
output wire [9:0] pixel_x,pixel_y
);
//---------counter declaration-------------
reg [9:0] counter_x,counter_y;
assign pixel_x = counter_x;
assign pixel_y = counter_y;
//-------------x counter------------------
always @(posedge clk or negedge rstn) begin
if(!rstn)
counter_x <= 10'b0;
else if(counter_x == H_SYNC_PORCH-1)
counter_x <= 10'b0;
else
counter_x <= counter_x +1;
end

//----------------y counter---------------
always @(posedge clk or negedge rstn) begin
if(!rstn)
counter_y <= 10'b0;
else if(counter_x == H_SYNC_PORCH-1) begin
if(counter_y == V_SYNC_PORCH-1)
counter_y <= 10'b0;
else
counter_y <= counter_y +1;
end
end
//-----------HV SYNC SIGNALS-----------
always @(*) begin
if ( counter_x >= H_ACTIVE + H_FRONT_PORCH-1 && counter_x < H_SYNC_PORCH -
H_BACK_PORCH-1 )
h_sync <=1'b0;
else
h_sync <=1'b1;
if ( counter_y >= V_ACTIVE + V_FRONT_PORCH -1 && counter_y < V_SYNC_PORCH -
V_BACK_PORCH-1 )
V_sync <=1'b0;
else
V_sync <=1'b1;
end
assign video_on = ( counter_x < H_ACTIVE && counter_y < V_ACTIVE ) ;
//--------address---------
always @(*) begin
if(video_on && rstn) begin
addr <= counter_y * H_ACTIVE + counter_x;
rgb <= {BPP{1'b1}} ; //white screen
end
else begin
addr <= {addr_w{1'b0}};
rgb <= {BPP{1'b0}}; //black screen
end
end
endmodule