`timescale 1ns/1ps
module test ();
//------parameters----------
parameter H_ACTIVE =640 ;
parameter H_FRONT_PORCH =16 ;
parameter H_SYNC_PORCH =800 ;
parameter H_SYNC_PULSE =96 ;
parameter H_BACK_PORCH =48 ;
parameter V_ACTIVE =480 ;
parameter V_FRONT_PORCH =10 ;
parameter V_SYNC_PULSE =2 ;
parameter V_SYNC_PORCH =525 ;
parameter V_BACK_PORCH =33 ;
parameter BPP =8 ;
parameter addr_w = $clog2(H_ACTIVE * V_ACTIVE);
reg clk,rstn;
wire h_sync,V_sync;
wire [BPP-1:0] rgb;
wire [addr_w-1:0] addr;
wire video_on;
wire [9:0] pixel_x,pixel_y;
//-----------ports--------------
vega #( H_ACTIVE,H_FRONT_PORCH ,H_SYNC_PORCH, H_SYNC_PULSE,H_BACK_PORCH,
        V_ACTIVE , V_FRONT_PORCH, V_SYNC_PULSE ,V_SYNC_PORCH,V_BACK_PORCH
        ,BPP,addr_w) dut (clk,rstn, h_sync,V_sync,rgb,addr,video_on,pixel_x,pixel_y);

//------clock--------
initial begin
begin
clk=0;
forever #20 clk = ~clk;
end
end
//------reseting and setting----------
initial begin
    rstn= 0;
repeat (2 ) @(posedge clk);
rstn = 1;
#64300
$stop;
end
//------display-------
initial begin
$monitor ( "time : %0t | clk : %b | rstn : %b | h_sync : %d : V_sync : %d |rgb : %b | addr : %d | video_on : %b | pixel_x : %d | pixel_y : %d | counter_x :%d | counter_y : %d ",$time ,clk,rstn,h_sync,V_sync,rgb,addr,video_on,pixel_x,pixel_y,dut.counter_x,dut.counter_y);
end
endmodule