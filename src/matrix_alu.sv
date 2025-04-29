

module inverse #(
    parameter ELEM_WIDTH = 32,
    parameter RESULT_WIDTH = 32
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic [4*ELEM_WIDTH-1:0] A_in,  
    output logic [4*RESULT_WIDTH-1:0] A_inv, 
    output logic done,
    output logic invalid,
  output logic signed [RESULT_WIDTH-1:0] det
);

    logic  [ELEM_WIDTH-1:0] a, b, c, d;
    assign {d, c, b, a} = A_in;

    logic  [RESULT_WIDTH-1:0] ad, bc;

    logic signed [RESULT_WIDTH-1:0] inv_a11, inv_a12, inv_a21, inv_a22;

    always_comb begin
        ad = a * d;  
        bc = b * c;  
        det = ad - bc;  

        if (det == 0) begin
            inv_a11 = 0;
            inv_a12 = 0;
            inv_a21 = 0;
            inv_a22 = 0;
            invalid = 1;
        end else begin
          inv_a11 = (1* d);
          inv_a12 = (-1 * $signed(b));
          inv_a21 = (-1 * $signed(c));
          inv_a22 = (1 * a);
            invalid = 0;

        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            A_inv <= '0;
            done <= 0;
        end else if (start) begin
          A_inv <= {inv_a22, inv_a21, inv_a12, inv_a11};
            done <= 1;
        end else begin
            done <= 0;
        end
    end

endmodule


module matrix_transpose #(
    parameter N_ROWS = 4, 
    parameter N_COLS = 2, 
    parameter ELEM_WIDTH = 4  
)(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [N_ROWS * N_COLS * ELEM_WIDTH - 1:0] A_in,  
    output reg [N_COLS * N_ROWS * ELEM_WIDTH - 1:0] A_transpose,  
    output reg done
);
    reg [N_COLS * N_ROWS * ELEM_WIDTH - 1:0] result_comb;

    integer i, j;

    always_comb begin
        for (i = 0; i < N_ROWS; i = i + 1) begin
            for (j = 0; j < N_COLS; j = j + 1) begin
                result_comb[(j * N_ROWS + i) * ELEM_WIDTH +: ELEM_WIDTH] = 
                    A_in[(i * N_COLS + j) * ELEM_WIDTH +: ELEM_WIDTH];
            end
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            A_transpose <= '0;
            done <= 1'b0;
        end else if (start) begin
            A_transpose <= result_comb;  
            done <= 1'b1;  
        end else begin
            done <= 1'b0;  
        end
    end

endmodule

module matrix_multiply #(
    parameter ROWS_A = 5,
    parameter COLS_A = 2,
    parameter COLS_B = 5,
    parameter ELEM_WIDTH = 4,
    parameter RESULT_WIDTH = 2 * ELEM_WIDTH
)(
    input  wire clk,
    input  wire rst,
    input  wire start,

    input  wire [(ROWS_A*COLS_A*ELEM_WIDTH)-1:0] A_in,
    input  wire [(COLS_A*COLS_B*ELEM_WIDTH)-1:0] B_in,
  
    
    output reg  [(ROWS_A*COLS_B*RESULT_WIDTH)-1:0] C_out,
    output reg  done
);

    logic [(ROWS_A*COLS_B*RESULT_WIDTH)-1:0] result_comb;
    integer i, j, k;
    logic [ELEM_WIDTH-1:0] a_elem, b_elem;
    logic [RESULT_WIDTH-1:0] sum;

always_comb begin
    result_comb = '0;
    for (i = 0; i < ROWS_A; i = i + 1) begin
        for (j = 0; j < COLS_B; j = j + 1) begin
            sum = '0;
            for (k = 0; k < COLS_A; k = k + 1) begin
                a_elem = A_in[(i*COLS_A + k)*ELEM_WIDTH +: ELEM_WIDTH];
                b_elem = B_in[(k*COLS_B + j)*ELEM_WIDTH +: ELEM_WIDTH];
                
                sum += a_elem * b_elem;
            end

            result_comb[(i*COLS_B + j)*RESULT_WIDTH +: RESULT_WIDTH] = sum;
        end
    end
end


    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            C_out <= '0;
            done  <= 1'b0;
        end else begin
            if (start) begin
                C_out <= result_comb;
                done  <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule




module input_matrix #(
    parameter ELEM_WIDTH = 32,
    parameter NUM_SAMPLES = 5
)(
    input  logic clk,
    input  logic rst,
    input  logic enter,
    input  logic input_done, 
    input  logic [`ELEM_WIDTH-1:0] data_in,
    output logic [(`NUM_SAMPLES*2*`ELEM_WIDTH)-1:0] x_data,  
    output logic [(`NUM_SAMPLES*`ELEM_WIDTH)-1:0] y_data,
    output logic error,
    output logic ready
);

    typedef enum logic [1:0] {
      IDLE   = 2'd1,
      READ_X = 2'd2,
      READ_Y = 2'd3
    } state_t;

    logic enter_d;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            enter_d <= 0;
        end else begin
            enter_d <= enter;
        end
    end

    wire enter_pulse = enter & ~enter_d;  

    state_t state, next_state;

    logic [$clog2(`NUM_SAMPLES*2+1)-1:0] x_index;  
    logic [$clog2(`NUM_SAMPLES+1)-1:0] y_index;    
    logic [(`NUM_SAMPLES*2*`ELEM_WIDTH)-1:0] x_reg;
    logic [(`NUM_SAMPLES*`ELEM_WIDTH)-1:0] y_reg;

    assign x_data = x_reg;
    assign y_data = y_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= READ_X;
            x_index <= 0;
            y_index <= 0;
            x_reg <= 0;
            y_reg <= 0;
            error <= 0;
            ready <= 0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    x_index <= 0;
                    y_index <= 0;
                    ready <= 1;

                end

                READ_X: begin
                    if(input_done) begin 
                        error <= 1;
                    end

                    if (enter_pulse && x_index < `NUM_SAMPLES * 2) begin
                        x_reg[(x_index)*`ELEM_WIDTH +: `ELEM_WIDTH] <= 'd1;  //Include the bias
                        x_reg[(x_index+1)*`ELEM_WIDTH +: `ELEM_WIDTH] <= data_in;
                        x_index <= x_index + 2;
                    end
                end

                READ_Y: begin
                    if(input_done) begin 
                        error <= 1;
                    end

                    if (enter_pulse && y_index < `NUM_SAMPLES) begin
                        y_reg[y_index*`ELEM_WIDTH +: `ELEM_WIDTH] <= data_in;
                        y_index <= y_index + 1;
                    end
                end
            endcase

        end
    end


    always_comb begin
        next_state = state;
        case (state)
            IDLE: 
                if (y_index >= 1) begin
                    next_state = READ_X;
                end
            READ_X: 
                if (x_index >= `NUM_SAMPLES * 2) begin
                    next_state = READ_Y;
                end
            READ_Y: 
                if (y_index >= `NUM_SAMPLES) begin
                    next_state = IDLE;
                end
        endcase
    end

endmodule






module linear_regression #(
    parameter ELEM_WIDTH = 32,
    parameter RESULT_WIDTH = 32,
    parameter NUM_SAMPLES = 5,
    parameter NUM_FEATURES = 2
)(
    input logic clk,
    input logic rst,
    input logic enter,                          
    input logic [`ELEM_WIDTH-1:0] data_in,       
    input logic input_done,  
    output logic  ready_input_matrix, 
    output logic [`NUM_SAMPLES * `NUM_FEATURES * `ELEM_WIDTH - 1:0] X_in,
    output logic [`NUM_SAMPLES * `NUM_FEATURES * `ELEM_WIDTH - 1:0] y_in,
    output logic error_det,                     
    output logic error_values,
    output logic [2 * `ELEM_WIDTH - 1:0] C_out_iny,  
    output logic [3:0] slope_ten, slope_one,
    output logic [3:0] b_ten, b_one,
    output logic [3:0] det_ten, det_one,
    output logic signed [`ELEM_WIDTH-1:0] det,       
    output logic done_multiply_iny
);

    logic error_input_matrix;
    logic done_transpose, done_multiply_XTX, done_multiply_XTy, done_inverse;
    logic [`NUM_FEATURES * `NUM_SAMPLES * `ELEM_WIDTH - 1:0] X_transpose;   
    logic [`NUM_FEATURES * `NUM_FEATURES * `ELEM_WIDTH - 1:0] X_transpose_X; 
    logic [`NUM_FEATURES * `ELEM_WIDTH - 1:0] XT_y;                
    logic [`NUM_FEATURES * `NUM_FEATURES * `ELEM_WIDTH - 1:0] X_inv; 
    logic invalid;
    logic flag_final;
    logic signed [`RESULT_WIDTH-1:0] C00, C10;

  unpack_C #(.RESULT_WIDTH(`RESULT_WIDTH))
  uut_unpack (
    .C_packed(C_out_iny),
    .C00(C00),
    .C10(C10)
  );
  

  split_digits #(.RESULT_WIDTH(`RESULT_WIDTH)) sd_slope (
    .num  (C10),
      .tens (slope_ten),
      .ones (slope_one)
  );

  split_digits #(.RESULT_WIDTH(`RESULT_WIDTH)) sd_b (
    .num  (C00),
      .tens (b_ten),
      .ones (b_one)
  );

  split_digits #(.RESULT_WIDTH(`RESULT_WIDTH)) sd_det (
      .num  (det),
      .tens (det_ten),
      .ones (det_one)
  );
input_matrix #(
        .ELEM_WIDTH(`ELEM_WIDTH),
        .NUM_SAMPLES(`NUM_SAMPLES)
    ) matrix_xy (
        .clk(clk),
        .rst(rst),
        .enter(enter),
        .input_done(input_done),
        .data_in(data_in),
        .x_data(X_in),
        .y_data(y_in),
        .error(error_values),
        .ready(ready_input_matrix)
    );

    // Transpose of X
    matrix_transpose #(
        .N_ROWS(`NUM_SAMPLES),
        .N_COLS(`NUM_FEATURES),
        .ELEM_WIDTH(`ELEM_WIDTH)
    ) transpose_X (
        .clk(clk),
        .rst(rst),
        .start(ready_input_matrix),
        .A_in(X_in),
        .A_transpose(X_transpose),
        .done(done_transpose)
    );

    // Compute X^T * X
    matrix_multiply #(
        .ROWS_A(`NUM_FEATURES),
        .COLS_A(`NUM_SAMPLES),
        .COLS_B(`NUM_FEATURES),
        .ELEM_WIDTH(`ELEM_WIDTH),
        .RESULT_WIDTH(`RESULT_WIDTH)
    ) multiply_XTX (
        .clk(clk),
        .rst(rst),
        .start(done_transpose),
        .A_in(X_transpose),
        .B_in(X_in),
        .C_out(X_transpose_X),
        .done(done_multiply_XTX)
    );

    // Compute X^T * y
    matrix_multiply #(
        .ROWS_A(`NUM_FEATURES),
        .COLS_A(`NUM_SAMPLES),
        .COLS_B(1),
        .ELEM_WIDTH(`ELEM_WIDTH),
        .RESULT_WIDTH(`RESULT_WIDTH)
    ) multiply_XTy (
        .clk(clk),
        .rst(rst),
        .start(done_transpose),
        .A_in(X_transpose),
        .B_in(y_in),
        .C_out(XT_y),
        .done(done_multiply_XTy)
    );

    // Inverse of X^T * X
    inverse #(
        .ELEM_WIDTH(`RESULT_WIDTH),
        .RESULT_WIDTH(`RESULT_WIDTH)
    ) inverse_XTX (
        .clk(clk),
        .rst(rst),
        .start(done_multiply_XTX),
        .A_in(X_transpose_X),
        .A_inv(X_inv),
        .invalid(error_det),
        .done(done_inverse),
        .det(det)
    );

    // Final Regression: (X^T X)^-1 * (X^T y)
    matrix_multiply #(
      .ROWS_A(`NUM_SAMPLES),
        .COLS_A(`NUM_FEATURES),
        .COLS_B(1),
        .ELEM_WIDTH(`ELEM_WIDTH),
        .RESULT_WIDTH(`RESULT_WIDTH)
    ) multiply_final (
        .clk(clk),
        .rst(rst),
        .start(done_multiply_XTy),
        .A_in(X_inv),
        .B_in(XT_y),
        .C_out(C_out_iny),
        .done(done_multiply_iny)
    );

  
endmodule



module unpack_C
  #(
    parameter RESULT_WIDTH = 32  // width of each matrix element
  )
  (
    input  logic [2*`RESULT_WIDTH-1:0] C_packed,
    output logic signed [`RESULT_WIDTH-1:0] C00,  // element [0][0]
    output logic signed [`RESULT_WIDTH-1:0] C10   // element [1][0]
  );

  // LSB chunk = C[0][0], MSB chunk = C[1][0]
  assign C00 = C_packed[`RESULT_WIDTH-1 : 0];
  assign C10 = C_packed[2*`RESULT_WIDTH-1 : `RESULT_WIDTH];

endmodule

module split_digits #(
    parameter RESULT_WIDTH = 8  // Width of the input number
)(
    input  logic signed [`RESULT_WIDTH-1:0] num,  // Input number (signed)
    output logic [3:0] tens,                     // Tens place
    output logic [3:0] ones                      // Ones place
);

    // Get absolute value for display purposes
    logic [`RESULT_WIDTH-1:0] abs_num;

    always_comb begin
        abs_num = (num < 0) ? -num : num;
    end

    // Tens and ones extraction
    assign tens = abs_num / 10;
    assign ones = abs_num % 10;

endmodule












































