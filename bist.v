//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//                               Name: Biplab Das S                                     //
//                                  BIST MODULE                                         //
//                   https://www.github.com/crazyhrzero8/BIST/                          //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
//`define LOG2(x) $clog2(x)

module bist #(
    parameter DATA_WIDTH=32,                              //in bits
    parameter c2dr=3                                      //1,2,4,8,16,32,64,128.
)(
    input  wire                          clk,             //clock
    input  wire                          rst_n,           //rst_n
    output reg [DATA_WIDTH-1:0]          data_out,        //data to be output
    output reg                           valid_out,       //valid signal aligned with data out
    output wire                          sync,            //to show if the data is starting from 1
    input  wire                          enable,          //to enable the incoming data
    input  wire                          capture_start,   //capture input to start capturing data
    input  wire                          pattern_sel      //0-incremental pattern and 1-pseudo random sequence 
 );

//localparam CNT_WIDTH = `LOG2(c2dr);

reg  [DATA_WIDTH-1:0]         inc_data;                   //
reg  [DATA_WIDTH-1:0]         lfsr_data;                  //
wire                          feedback;                   //
reg                           enable_d;                   //
reg                           pattern_sel_d;              //
wire [DATA_WIDTH-1:0]         data_out_temp;              //
reg  [DATA_WIDTH-1:0]         data_out_d;                 //
reg                           valid_temp;                 //
wire                          en_d_inv;                   //for enable 1d invert
wire                          pulse;                      //for the start of the valid data
reg [($clog2(c2dr))-1:0]           cnt;

//valid out logic
always@(posedge clk) begin
    if (~rst_n) 
        valid_out <= 0;
    else if (enable==1)
        valid_out <= valid_temp;
    else if(enable==0)
        valid_out <= valid_out;
    else
        valid_out <= 0;
end

//for enable, pattern, valid delays
always@(posedge clk) begin
    if (~rst_n) begin
        enable_d      <=        1'b0;
        pattern_sel_d <=        1'b0;
    end
    else begin
        enable_d      <=      enable;
        pattern_sel_d <= pattern_sel;
        data_out      <=  data_out_d;
    end
end

//for data delay 
always@(posedge clk) begin
    if (~rst_n) 
        data_out_d   <= {DATA_WIDTH{1'b0}};
    else
        data_out_d   <=      data_out_temp;
end

//for enable selection
always@(posedge clk) begin
    if (~rst_n) begin
        valid_out   <=      1'b0;
    end
    else begin 
        valid_out   <=    ~cnt;
    end
end

//counter for c2dr 1,2,4...
always@(posedge clk) begin
    if (~rst_n) begin
        cnt <= 0;
    end else if (capture_start && enable) begin
        if (cnt == c2dr-1) begin
            cnt <= 0;
        end else if ((cnt != c2dr-1) || (cnt != 0)) begin
            cnt <= cnt + 1;
        end
    end
end

//for incremental data register for both enable continuous and toggle
always@(posedge clk) begin
    if (~rst_n) begin
        inc_data <= {DATA_WIDTH{1'b0}};
    end else if (capture_start && enable) begin
        //if (cnt!=0) begin
            inc_data <= inc_data + 1;
        //end else begin
            //inc_data <= {DATA_WIDTH{1'b0}};
        //end
    end
    else begin
        inc_data <= inc_data;
    end
end

//for linear feedback shift register data for both enable continuous and toggle
always@(posedge clk) begin
    if((enable == 1'b1 && pulse == 1'b1 && capture_start == 1'b1) || (~rst_n)) begin
        lfsr_data <= {DATA_WIDTH{1'b0}};
    end else if ((enable == 1'b1)) begin
        case (DATA_WIDTH)
            8: begin
                lfsr_data <= {lfsr_data[6:0], feedback};
            end
            16: begin
                lfsr_data <= {lfsr_data[14:0], feedback};
            end
            32: begin
                lfsr_data <= {lfsr_data[30:0], feedback};
            end
            64: begin
                lfsr_data <= {lfsr_data[62:0], feedback};
            end
            default: begin
                lfsr_data <=  lfsr_data;
            end
        endcase
    end else begin
        lfsr_data <=  lfsr_data;
   end
end

assign feedback = (DATA_WIDTH == 8) ? ~(lfsr_data[7] ^ lfsr_data[5] ^ lfsr_data[4] ^ lfsr_data[3]) :
                  (DATA_WIDTH == 16) ? ~(lfsr_data[15] ^ lfsr_data[14] ^ lfsr_data[12] ^ lfsr_data[3]) :
                  (DATA_WIDTH == 32) ? ~(lfsr_data[31] ^ lfsr_data[21] ^ lfsr_data[1] ^ lfsr_data[0]) :
                  (DATA_WIDTH == 32) ? ~(lfsr_data[63] ^ lfsr_data[62] ^ lfsr_data[60] ^ lfsr_data[59]) :
                                                                                               'b0;

assign data_out_temp = (pattern_sel_d == 1'b1) ? lfsr_data : 
                                                  inc_data ;
//assign data_out = data_out_d;
assign sync = ((inc_data[15:0] || lfsr_data[15:0]) == 'h1);
assign en_d_inv = ~enable_d;                              //for inverting the enable for pulse
assign pulse = enable & en_d_inv;                         //pulse to be on at the start of the enable posedge

endmodule
//feedback taps for 8-bit maximum length LFSR sequence
//assign feedback = ~(lfsr_data[7] ^ lfsr_data[5] ^ lfsr_data[4] ^ lfsr_data[3]);
//feedback taps for 16-bit maximum length LFSR sequence
//assign feedback = ~(lfsr_data[15] ^ lfsr_data[14] ^ lfsr_data[12] ^ lfsr_data[3]);
//feedback taps for 32-bit maximum length LFSR sequence
//assign feedback = ~(lfsr_data[31] ^ lfsr_data[21] ^ lfsr_data[1] ^ lfsr_data[0]);
//feedback taps for 64-bit maximum length LFSR sequence
//assign feedback = ~(lfsr_data[63] ^ lfsr_data[62] ^ lfsr_data[60] ^ lfsr_data[59]);