
`define WIDTH 96
`define HEIGHT 64
`define BLACK 16'b0
`define WHITE ~`BLACK
`define MAGENTA 16'b11111_000000_11111
`define CYAN 16'b00000_111111_11111
`define YELLOW 16'b11111_111111_00000
`define GREEN 16'b00000_111111_00000
`define RED 16'b11111_000000_00000
`define BLUE 16'b00000_000000_11111
`define ORANGE 16'b11111_100110_00000
`define GREY 16'b01100_011000_01100

// Bit numbers for various
`define LDBIT       15
`define OLEDBIT     15
`define ANBIT       3
`define SEGDPBIT    7
`define SEGBIT      6 
`define COLBIT      15 
`define PIXELBIT    12 
`define PIXELXYBIT  6
`define CLR_AN  ~4'b0
`define CLR_SEG ~8'b0

// 7SEG DIGITS
`define DIG0    7'b1000000
`define DIG1    7'b1111001
`define DIG2    7'b0100100
`define DIG3    7'b0110000
`define DIG4    7'b0011001
`define DIG5    7'b0010010
`define DIG6    7'b0000010
`define DIG7    7'b1111000
`define DIG8    7'b0
`define DIG9    7'b0010000   
// char
`define CHAR_P  7'b0001100
`define CHAR_O  7'b1000000
`define CHAR_N  7'b0101011
`define CHAR_G  7'b0010000


`define ELEM_WIDTH 12
`define NUM_FEATURES 2
`define NUM_SAMPLES 3
`define RESULT_WIDTH 12



module my_chip (
    input  logic [11:0] io_in,
    output logic [11:0] io_out,
    input  logic clock,
    input  logic reset
);

wire gp14 = io_in[0];
wire gn14 = io_in[1];
wire gp15 = io_in[2];
wire gn15 = io_in[3];
wire gp16 = io_in[4];
wire gn16 = io_in[5];
wire gp17 = io_in[6];
wire gn17 = io_in[7];

wire gp21; assign io_out[0] = gp21;
wire gn21; assign io_out[1] = gn21;
wire gp22; assign io_out[2] = gp22;
wire gn22; assign io_out[3] = gn22;
wire gp23; assign io_out[4] = gp23;
wire gn23; assign io_out[5] = gn23;
wire gp24; assign io_out[6] = gp24;
wire gn24; assign io_out[7] = gn24;





logic clk6p25m;
clk_divider c1(clock, 4, clk6p25m);
wire frame_begin, sending_pixels, sample_pixel;
wire [`PIXELBIT:0] pixel_index;
wire [`PIXELXYBIT:0] x, y;
wire [`OLEDBIT:0] oled_data;
logic enter, input_done;
logic ready_input_matrix;
logic  [3:0] slope_ten;
logic  [3:0] slope_one;
logic  [3:0] det_ten;
logic  [3:0] det_one;
logic  [3:0] b_ten;
logic  [3:0] b_one;
logic error_det,error_values,done_multiply_iny;
logic [2 * `ELEM_WIDTH - 1:0] C_out_iny;
logic [`ELEM_WIDTH-1:0] data_in;
logic [`NUM_SAMPLES * `NUM_FEATURES * `ELEM_WIDTH - 1:0] X_in;
logic [`NUM_SAMPLES * `NUM_FEATURES * `ELEM_WIDTH - 1:0] y_in;
logic signed [`ELEM_WIDTH-1:0] det;



linear_regression #(
    .ELEM_WIDTH(`ELEM_WIDTH),
    .RESULT_WIDTH(`RESULT_WIDTH),
    .NUM_SAMPLES(`NUM_SAMPLES),
    .NUM_FEATURES(`NUM_FEATURES)
) u1 (
    .clk(clock),
    .rst(reset),
    .enter(enter),                          
    .data_in(data_in),       
    .input_done(input_done),  
    .ready_input_matrix(ready_input_matrix), //output
    .X_in(X_in), 
    .y_in(y_in), 
    .error_det(error_det),                     
    .error_values(error_values),
    .C_out_iny(C_out_iny),  
    .slope_ten(slope_ten),
    .slope_one(slope_one),
    .b_ten(b_ten),
    .b_one(b_one),
    .det_ten(det_ten), 
    .det_one(det_one),
    .det(det),       
    .done_multiply_iny(done_multiply_iny)
);

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        data_in <= '0;
    end else begin 
        if (decode_value != 4'b1101 && decode_value != 4'b1110) begin
            data_in <= decode_value;
        end
    end
end

assign enter = (decode_value == 4'b1110)? 1 : 0;
assign input_done = (decode_value == 4'b1101)? 1 : 0;


color_gen my_color_gen (

    .x(x),
    .y(y),
    .slope_ten(slope_ten),
    .slope_one(slope_one),
    .det_ten(det_ten),
    .det_one(det_one),
    .b_ten(b_ten),
    .b_one(b_one),
    .decode_value(decode_value),
    .ready_input_matrix(ready_input_matrix),
    .oled_data(oled_data)
);


convertXY xy0(pixel_index, x, y);
Oled_Display od0 (
    .clk(clk6p25m), .reset(reset), .pixel_data(oled_data),
    .frame_begin(frame_begin), .sending_pixels(sending_pixels),
    .sample_pixel(sample_pixel), .pixel_index(pixel_index),
    .cs(gn24), .sdin(gn23), .sclk(gn21), .d_cn(gp24),
    .resn(gp23), .vccen(gp22), .pmoden(gp21)
);

logic [3:0] decode_value;
logic [3:0] col;
logic [3:0] row;
assign row = {gp14 ,gp15,gp16,gp17};
assign col = {gn14,gn15,gn16,gn17};


Decoder keypad(
.clk(clock),
.Row(row),
.Col(col),
.rst(reset),
.DecodeOut(decode_value)
);
endmodule
