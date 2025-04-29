
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



`define ELEM_WIDTH 14
`define NUM_FEATURES 2
`define NUM_SAMPLES 3
`define RESULT_WIDTH 14

module color_gen (
    input  [9:0] x,
    input  [9:0] y,
    input  [3:0] slope_ten,
    input  [3:0] slope_one,
    input  [3:0] det_ten,
    input  [3:0] det_one,
    input  [3:0] b_ten,
    input  [3:0] b_one,
    input  [3:0] decode_value,
    input   ready_input_matrix,



    output reg [15:0] oled_data
);

    parameter X0 = 15;
    parameter Y0 = 15;

    reg [7:0] char_y     [0:7];
    reg [7:0] char_eq    [0:7];
    reg [7:0] char_0     [0:7];
    reg [7:0] char_slash [0:7];
    reg [7:0] char_x     [0:7];
    reg [7:0] char_space [0:7];
    reg [7:0] char_plus [0:7];
    reg [7:0] char_1     [0:7];
    reg [7:0] char_2     [0:7];
    reg [7:0] char_3     [0:7];
    reg [7:0] char_4     [0:7];
    reg [7:0] char_5     [0:7];
    reg [7:0] char_6     [0:7];
    reg [7:0] char_7     [0:7];
    reg [7:0] char_8    [0:7];
    reg [7:0] char_9     [0:7];
    reg [7:0] char_E    [0:7];

    initial begin
        // y
        char_y[0] = 8'b10000001;
        char_y[1] = 8'b01000010;
        char_y[2] = 8'b00100100;
        char_y[3] = 8'b00011000;
        char_y[4] = 8'b00011000;
        char_y[5] = 8'b00011000;
        char_y[6] = 8'b00011000;
        char_y[7] = 8'b00011000;

        // =
        char_eq[0] = 8'b00000000;
        char_eq[1] = 8'b11111111;
        char_eq[2] = 8'b00000000;
        char_eq[3] = 8'b00000000;
        char_eq[4] = 8'b11111111;
        char_eq[5] = 8'b00000000;
        char_eq[6] = 8'b00000000;
        char_eq[7] = 8'b00000000;

        // 0
        char_0[0] = 8'b00111100;
        char_0[1] = 8'b01000010;
        char_0[2] = 8'b10000101;
        char_0[3] = 8'b10001001;
        char_0[4] = 8'b10010001;
        char_0[5] = 8'b10100001;
        char_0[6] = 8'b01000010;
        char_0[7] = 8'b00111100;

        // /
        char_slash[0] = 8'b00000000;
        char_slash[1] = 8'b00000010;
        char_slash[2] = 8'b00000100;
        char_slash[3] = 8'b00001000;
        char_slash[4] = 8'b00010000;
        char_slash[5] = 8'b00100000;
        char_slash[6] = 8'b01000000;
        char_slash[7] = 8'b00000000;

        // x
        char_x[0] = 8'b10000001;
        char_x[1] = 8'b01000010;
        char_x[2] = 8'b00100100;
        char_x[3] = 8'b00011000;
        char_x[4] = 8'b00011000;
        char_x[5] = 8'b00100100;
        char_x[6] = 8'b01000010;
        char_x[7] = 8'b10000001;

        // space
        char_space[0] = 8'b00000000;
        char_space[1] = 8'b00000000;
        char_space[2] = 8'b00000000;
        char_space[3] = 8'b00000000;
        char_space[4] = 8'b00000000;
        char_space[5] = 8'b00000000;
        char_space[6] = 8'b00000000;
        char_space[7] = 8'b00000000;

        // +
        char_plus[0] = 8'b00000000;
        char_plus[1] = 8'b00011000;
        char_plus[2] = 8'b00011000;
        char_plus[3] = 8'b11111111;
        char_plus[4] = 8'b00011000;
        char_plus[5] = 8'b00011000;
        char_plus[6] = 8'b00000000;
        char_plus[7] = 8'b00000000;
       
        char_1[0] = 8'b00000010;
        char_1[1] = 8'b00000110;
        char_1[2] = 8'b00001010;
        char_1[3] = 8'b00010010;
        char_1[4] = 8'b00000010;
        char_1[5] = 8'b00000010;
        char_1[6] = 8'b00000010;
        char_1[7] = 8'b00011111;

        // 2
        char_2[0] = 8'b00111100;
        char_2[1] = 8'b01000010;
        char_2[2] = 8'b00000010;
        char_2[3] = 8'b00000010;
        char_2[4] = 8'b00000100;
        char_2[5] = 8'b00001000;
        char_2[6] = 8'b00010000;
        char_2[7] = 8'b00111111;

        // 3
        char_3[0] = 8'b00111100;
        char_3[1] = 8'b01000010;
        char_3[2] = 8'b00000010;
        char_3[3] = 8'b00011110;
        char_3[4] = 8'b00000010;
        char_3[5] = 8'b01000010;
        char_3[6] = 8'b01000010;
        char_3[7] = 8'b00111100;

        // 4
        char_4[0] = 8'b00100010;
        char_4[1] = 8'b00100010;
        char_4[2] = 8'b00100010;
        char_4[3] = 8'b00100010;
        char_4[4] = 8'b00111110;
        char_4[5] = 8'b00000010;
        char_4[6] = 8'b00000010;
        char_4[7] = 8'b00000010;

        // 5
        char_5[0] = 8'b00111110;
        char_5[1] = 8'b01000000;
        char_5[2] = 8'b01000000;
        char_5[3] = 8'b00111100;
        char_5[4] = 8'b00000010;
        char_5[5] = 8'b01000010;
        char_5[6] = 8'b01000010;
        char_5[7] = 8'b00111100;

        // 6
        char_6[0] = 8'b00111100;
        char_6[1] = 8'b01000000;
        char_6[2] = 8'b01000000;
        char_6[3] = 8'b00111100;
        char_6[4] = 8'b01000010;
        char_6[5] = 8'b01000010;
        char_6[6] = 8'b01000010;
        char_6[7] = 8'b00111100;

        // 7
        char_7[0] = 8'b00111110;
        char_7[1] = 8'b00000010;
        char_7[2] = 8'b00000010;
        char_7[3] = 8'b00000110;
        char_7[4] = 8'b00001000;
        char_7[5] = 8'b00010000;
        char_7[6] = 8'b00010000;
        char_7[7] = 8'b00010000;

        // 8
        char_8[0] = 8'b00111100;
        char_8[1] = 8'b01000010;
        char_8[2] = 8'b01000010;
        char_8[3] = 8'b00111100;
        char_8[4] = 8'b01000010;
        char_8[5] = 8'b01000010;
        char_8[6] = 8'b01000010;
        char_8[7] = 8'b00111100;

        // 9
        char_9[0] = 8'b00111100;
        char_9[1] = 8'b01000010;
        char_9[2] = 8'b01000010;
        char_9[3] = 8'b00111110;
        char_9[4] = 8'b00000010;
        char_9[5] = 8'b01000010;
        char_9[6] = 8'b01000010;
        char_9[7] = 8'b00111100;


        char_E[0] = 8'b01111100;
        char_E[1] = 8'b01000000;
        char_E[2] = 8'b01000000;
        char_E[3] = 8'b01111110;
        char_E[4] = 8'b01000000;
        char_E[5] = 8'b01000000;
        char_E[6] = 8'b01000000;
        char_E[7] = 8'b01111100;

    end

always @(*) begin
    oled_data = 16'hFFFF; 


    if ((y >= Y0 && y < Y0 + 8) && (x >= X0 && x < X0 + 104)) begin
        integer col_index, bit_col, bit_row;
        col_index = (x - X0) / 8;
        bit_col = (x - X0) % 8;
        bit_row = y - Y0;

        case (col_index)
            0: oled_data = char_y[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF;
            1: oled_data = char_eq[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF;
            2: oled_data = (slope_ten == 1) ? (char_1[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 2) ? (char_2[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 3) ? (char_3[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 4) ? (char_4[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 5) ? (char_5[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 6) ? (char_6[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 7) ? (char_7[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 8) ? (char_8[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 9) ? (char_9[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 10) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 11) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 12) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 13) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 14) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_ten == 15) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (char_0[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF);  
            3: oled_data = (slope_one == 1) ? (char_1[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 2) ? (char_2[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 3) ? (char_3[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 4) ? (char_4[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 5) ? (char_5[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 6) ? (char_6[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 7) ? (char_7[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 8) ? (char_8[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 9) ? (char_9[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 10) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 11) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 12) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 13) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 14) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (slope_one == 15) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (char_0[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF);
            4: oled_data = char_slash[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF;
            5: oled_data = (det_ten == 1) ? (char_1[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 2) ? (char_2[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 3) ? (char_3[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 4) ? (char_4[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 5) ? (char_5[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 6) ? (char_6[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 7) ? (char_7[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 8) ? (char_8[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 9) ? (char_9[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (char_0[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF);
            6: oled_data = (det_one == 1) ? (char_1[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 2) ? (char_2[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 3) ? (char_3[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 4) ? (char_4[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 5) ? (char_5[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 6) ? (char_6[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 7) ? (char_7[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 8) ? (char_8[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 9) ? (char_9[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (char_0[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF);
            7: oled_data = char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF;

            default: oled_data = 16'hFFFF;
        endcase
    end
    // Update for second row (y = Y0 + 8 to Y0 + 15)
    else if ((y >= Y0 + 8 && y < Y0 + 16) && (x >= X0 && x < X0 + 104)) begin
        integer col_index, bit_col, bit_row;
        col_index = (x - X0) / 8;
        bit_col = (x - X0) % 8;
        bit_row = y - (Y0 + 8);  // Adjust bit row to display second line of text

        case (col_index)
            0: oled_data = char_plus[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF;
            1: oled_data =(b_ten == 1) ? (char_1[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_ten == 2) ? (char_2[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_ten == 3) ? (char_3[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_ten == 4) ? (char_4[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_ten == 5) ? (char_5[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_ten == 6) ? (char_6[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_ten == 7) ? (char_7[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_ten == 8) ? (char_8[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_ten == 9) ? (char_9[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (char_0[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF);  
            2: oled_data =(b_one == 1) ? (char_1[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_one == 2) ? (char_2[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_one == 3) ? (char_3[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_one == 4) ? (char_4[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_one == 5) ? (char_5[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_one == 6) ? (char_6[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_one == 7) ? (char_7[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_one == 8) ? (char_8[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (b_one == 9) ? (char_9[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (char_0[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF);  
            3: oled_data = char_slash[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF;
            4: oled_data = (det_ten == 1) ? (char_1[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 2) ? (char_2[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 3) ? (char_3[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 4) ? (char_4[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 5) ? (char_5[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 6) ? (char_6[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 7) ? (char_7[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 8) ? (char_8[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_ten == 9) ? (char_9[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (char_0[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF);
            5: oled_data =  (det_one == 1) ? (char_1[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 2) ? (char_2[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 3) ? (char_3[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 4) ? (char_4[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 5) ? (char_5[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 6) ? (char_6[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 7) ? (char_7[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 8) ? (char_8[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (det_one == 9) ? (char_9[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (char_0[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF);
            8: oled_data =  (decode_value == 1) ? (char_1[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 2) ? (char_2[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 3) ? (char_3[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 4) ? (char_4[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 5) ? (char_5[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 6) ? (char_6[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 7) ? (char_7[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 8) ? (char_8[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 9) ? (char_9[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 10) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 11) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 12) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 13) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 14) ? (char_E[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (decode_value == 15) ? (char_x[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF) :
                          (char_0[bit_row][7 - bit_col] ? 16'h0000 : 16'hFFFF);

            default: oled_data = 16'hFFFF;
        endcase
    end
end

endmodule



module convertXY(
    input [`PIXELBIT:0] pixel_index,
    output [`PIXELXYBIT:0] x, y
    );
    
    assign x = pixel_index % `WIDTH;
    assign y = pixel_index / `WIDTH;
    
endmodule



module clk_divider(
    input CLOCK, 
    input [31:0] m,
    output reg slowclk = 0
    );
    reg [31:0] count = 0;
    
    always @ (posedge CLOCK) begin
        count <= (count == m) ? 0 : count + 1;
        slowclk <= (count == 0) ? ~slowclk : slowclk;
    end
endmodule






module Oled_Display(clk, reset, frame_begin, sending_pixels,
  sample_pixel, pixel_index, pixel_data, cs, sdin, sclk, d_cn, resn, vccen,
  pmoden);
localparam Width = 96;
localparam Height = 64;
localparam PixelCount = Width * Height;
localparam PixelCountWidth = $clog2(PixelCount);

parameter ClkFreq = 6250000; // Hz
input clk, reset;
output frame_begin, sending_pixels, sample_pixel;
output [PixelCountWidth-1:0] pixel_index;
input [15:0] pixel_data;
output cs, sdin, sclk, d_cn, resn, vccen, pmoden;

// Frame begin event
localparam FrameFreq = 60;
localparam FrameDiv = ClkFreq / FrameFreq;
localparam FrameDivWidth = $clog2(FrameDiv);

reg [FrameDivWidth-1:0] frame_counter;
assign frame_begin = frame_counter == 0;

// State Machine
localparam PowerDelay = 20; // ms
localparam ResetDelay = 3; // us
localparam VccEnDelay = 20; // ms
localparam StartupCompleteDelay = 100; // ms

localparam MaxDelay = StartupCompleteDelay;
localparam MaxDelayCount = (ClkFreq * MaxDelay) / 1000;
reg [$clog2(MaxDelayCount)-1:0] delay;

localparam StateCount = 32;
localparam StateWidth = $clog2(StateCount);

localparam PowerUp = 5'b00000;
localparam Reset = 5'b00001;
localparam ReleaseReset = 5'b00011;
localparam EnableDriver = 5'b00010;
localparam DisplayOff = 5'b00110;
localparam SetRemapDisplayFormat = 5'b00111;
localparam SetStartLine = 5'b00101;
localparam SetOffset = 5'b00100;
localparam SetNormalDisplay = 5'b01100;
localparam SetMultiplexRatio = 5'b01101;
localparam SetMasterConfiguration = 5'b01111;
localparam DisablePowerSave = 5'b01110;
localparam SetPhaseAdjust = 5'b01010;
localparam SetDisplayClock = 5'b01011;
localparam SetSecondPrechargeA = 5'b01001;
localparam SetSecondPrechargeB = 5'b01000;
localparam SetSecondPrechargeC = 5'b11000;
localparam SetPrechargeLevel = 5'b11001;
localparam SetVCOMH = 5'b11011;
localparam SetMasterCurrent = 5'b11010;
localparam SetContrastA = 5'b11110;
localparam SetContrastB = 5'b11111;
localparam SetContrastC = 5'b11101;
localparam DisableScrolling = 5'b11100;
localparam ClearScreen = 5'b10100;
localparam VccEn = 5'b10101;
localparam DisplayOn = 5'b10111;
localparam PrepareNextFrame = 5'b10110;
localparam SetColAddress = 5'b10010;
localparam SetRowAddress = 5'b10011;
localparam WaitNextFrame = 5'b10001;
localparam SendPixel = 5'b10000;

assign sending_pixels = state == SendPixel;

assign resn = state != Reset;
assign d_cn = sending_pixels;
assign vccen = state == VccEn || state == DisplayOn ||
  state == PrepareNextFrame || state == SetColAddress ||
  state == SetRowAddress || state == WaitNextFrame || state == SendPixel;
assign pmoden = !reset;

reg [15:0] color;

reg [StateWidth-1:0] state;
wire [StateWidth-1:0] next_state = fsm_next_state(state, frame_begin, pixel_index);

function [StateWidth-1:0] fsm_next_state;
  input [StateWidth-1:0] state;
  input frame_begin;
  input [PixelCountWidth-1:0] pixels_remain;
  case (state)
    PowerUp: fsm_next_state = Reset;
    Reset: fsm_next_state = ReleaseReset;
    ReleaseReset: fsm_next_state = EnableDriver;
    EnableDriver: fsm_next_state = DisplayOff;
    DisplayOff: fsm_next_state = SetRemapDisplayFormat;
    SetRemapDisplayFormat: fsm_next_state = SetStartLine;
    SetStartLine: fsm_next_state = SetOffset;
    SetOffset: fsm_next_state = SetNormalDisplay;
    SetNormalDisplay: fsm_next_state = SetMultiplexRatio;
    SetMultiplexRatio: fsm_next_state = SetMasterConfiguration;
    SetMasterConfiguration: fsm_next_state = DisablePowerSave;
    DisablePowerSave: fsm_next_state = SetPhaseAdjust;
    SetPhaseAdjust: fsm_next_state = SetDisplayClock;
    SetDisplayClock: fsm_next_state = SetSecondPrechargeA;
    SetSecondPrechargeA: fsm_next_state = SetSecondPrechargeB;
    SetSecondPrechargeB: fsm_next_state = SetSecondPrechargeC;
    SetSecondPrechargeC: fsm_next_state = SetPrechargeLevel;
    SetPrechargeLevel: fsm_next_state = SetVCOMH;
    SetVCOMH: fsm_next_state = SetMasterCurrent;
    SetMasterCurrent: fsm_next_state = SetContrastA;
    SetContrastA: fsm_next_state = SetContrastB;
    SetContrastB: fsm_next_state = SetContrastC;
    SetContrastC: fsm_next_state = DisableScrolling;
    DisableScrolling: fsm_next_state = ClearScreen;
    ClearScreen: fsm_next_state = VccEn;
    VccEn: fsm_next_state = DisplayOn;
    DisplayOn: fsm_next_state = PrepareNextFrame;
    PrepareNextFrame: fsm_next_state = SetColAddress;
    SetColAddress: fsm_next_state = SetRowAddress;
    SetRowAddress: fsm_next_state = WaitNextFrame;
    WaitNextFrame: fsm_next_state = frame_begin ? SendPixel : WaitNextFrame;
    SendPixel: fsm_next_state = (pixel_index == PixelCount-1) ?
      PrepareNextFrame : SendPixel;
    default: fsm_next_state = PowerUp;
  endcase
endfunction

// SPI Master
localparam SpiCommandMaxWidth = 40;
localparam SpiCommandBitCountWidth = $clog2(SpiCommandMaxWidth);

reg [SpiCommandBitCountWidth-1:0] spi_word_bit_count;
reg [SpiCommandMaxWidth-1:0] spi_word;

wire spi_busy = spi_word_bit_count != 0;
assign cs = !spi_busy;
assign sclk = clk | !spi_busy;
assign sdin = spi_word[SpiCommandMaxWidth-1] & spi_busy;

// Video
assign sample_pixel = (state == WaitNextFrame && frame_begin) ||
  (sending_pixels && frame_counter[3:0] == 0);
assign pixel_index = sending_pixels ?
  frame_counter[FrameDivWidth-1:$clog2(16)] : 0;

always @(negedge clk) begin
  if (reset) begin
    frame_counter <= 0;
    delay <= 0;
    state <= 0;
    spi_word <= 0;
    spi_word_bit_count <= 0;
  end else begin
    frame_counter <= (frame_counter == FrameDiv-1) ? 0 : frame_counter + 1;

    if (spi_word_bit_count > 1) begin
      spi_word_bit_count <= spi_word_bit_count - 1;
      spi_word <= {spi_word[SpiCommandMaxWidth-2:0], 1'b0};
    end else if (delay != 0) begin
      spi_word <= 0;
      spi_word_bit_count <= 0;
      delay <= delay - 1;
    end else begin
      state <= next_state;
      case (next_state)
        PowerUp: begin
          spi_word <= 0;
          spi_word_bit_count <= 0;
          delay <= (ClkFreq * PowerDelay) / 1000;
        end
        Reset: begin
          spi_word <= 0;
          spi_word_bit_count <= 0;
          delay <= (ClkFreq * ResetDelay) / 1000;
        end
        ReleaseReset: begin
          spi_word <= 0;
          spi_word_bit_count <= 0;
          delay <= (ClkFreq * ResetDelay) / 1000;
        end
        EnableDriver: begin
          // Enable the driver
          spi_word <= {16'hFD12, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        DisplayOff: begin
          // Turn the display off
          spi_word <= {8'hAE, {SpiCommandMaxWidth-8{1'b0}}};
          spi_word_bit_count <= 8;
          delay <= 1;
        end
        SetRemapDisplayFormat: begin
          // Set the remap and display formats
          spi_word <= {16'hA072, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetStartLine: begin
          // Set the display start line to the top line
          spi_word <= {16'hA100, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetOffset: begin
          // Set the display offset to no vertical offset
          spi_word <= {16'hA200, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetNormalDisplay: begin
          // Make it a normal display with no color inversion or forcing
          // pixels on/off
          spi_word <= {8'hA4, {SpiCommandMaxWidth-8{1'b0}}};
          spi_word_bit_count <= 8;
          delay <= 1;
        end
        SetMultiplexRatio: begin
          // Set the multiplex ratio to enable all of the common pins
          // calculated by thr 1+register value
          spi_word <= {16'hA83F, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetMasterConfiguration: begin
          // Set the master configuration to use a required a required
          // external Vcc supply.
          spi_word <= {16'hAD8E, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        DisablePowerSave: begin
          // Disable power saving mode.
          spi_word <= {16'hB00B, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetPhaseAdjust: begin
          // Set the phase length of the charge and dischare rates of
          // an OLED pixel.
          spi_word <= {16'hB131, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetDisplayClock: begin
          // Set the display clock divide ration and oscillator frequency
          spi_word <= {16'hB3F0, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetSecondPrechargeA: begin
          // Set the second pre-charge speed of color A
          spi_word <= {16'h8A64, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetSecondPrechargeB: begin
          // Set the second pre-charge speed of color B
          spi_word <= {16'h8B78, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetSecondPrechargeC: begin
          // Set the second pre-charge speed of color C
          spi_word <= {16'h8C64, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetPrechargeLevel: begin
          // Set the pre-charge voltage to approximately 45% of Vcc
          spi_word <= {16'hBB3A, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetVCOMH: begin
          // Set the VCOMH deselect level
          spi_word <= {16'hBE3E, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetMasterCurrent: begin
          // Set the master current attenuation
          spi_word <= {16'h8706, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetContrastA: begin
          // Set the contrast for color A
          spi_word <= {16'h8191, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetContrastB: begin
          // Set the contrast for color B
          spi_word <= {16'h8250, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        SetContrastC: begin
          // Set the contrast for color C
          spi_word <= {16'h837D, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 1;
        end
        DisableScrolling: begin
          // Disable scrolling
          spi_word <= {8'h25, {SpiCommandMaxWidth-8{1'b0}}};
          spi_word_bit_count <= 8;
          delay <= 1;
        end
        ClearScreen: begin
          // Clear the screen
          spi_word <= {40'h2500005F3F, {SpiCommandMaxWidth-40{1'b0}}};
          spi_word_bit_count <= 40;
          delay <= 1;
        end
        VccEn: begin
          spi_word <= 0;
          spi_word_bit_count <= 0;
          delay <= (ClkFreq * VccEnDelay) / 1000;
        end
        DisplayOn: begin
          // Turn the display on
          spi_word <= {8'hAF, {SpiCommandMaxWidth-8{1'b0}}};
          spi_word_bit_count <= 8;
          delay <= (ClkFreq * StartupCompleteDelay) / 1000;
        end
        PrepareNextFrame: begin
          // Deassert CS before beginning next frame
          spi_word <= 0;
          spi_word_bit_count <= 0;
          delay <= 1;
        end
        SetColAddress: begin
          // Set the column address
          spi_word <= {24'h15005F, {SpiCommandMaxWidth-24{1'b0}}};
          spi_word_bit_count <= 24;
          delay <= 1;
        end
        SetRowAddress: begin
          // Set the row address
          spi_word <= {24'h75003F, {SpiCommandMaxWidth-24{1'b0}}};
          spi_word_bit_count <= 24;
          delay <= 1;
        end
        WaitNextFrame: begin
          spi_word <= 0;
          spi_word_bit_count <= 0;
          delay <= 0;
        end
        SendPixel: begin
          spi_word <= {pixel_data, {SpiCommandMaxWidth-16{1'b0}}};
          spi_word_bit_count <= 16;
          delay <= 0;
        end
        default: begin
          spi_word <= 0;
          spi_word_bit_count <= 0;
          delay <= 0;
        end
      endcase
    end
  end
end

endmodule

