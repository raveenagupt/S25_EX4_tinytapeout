# 18-224/624 S25 Tapeout Template


1. Add your verilog source files to `source_files` in `info.yaml`. The top level of your chip should remain in `chip.sv` and be named `my_chip`

  
  

2. Optionally add other details about your project to `info.yaml` as well (this is only for GitHub - your final project submission will involve submitting these in a different format)

3. Do NOT edit `toplevel_chip.v`  `config.tcl` or `pin_order.cfg`

 # Final Project Submission Details 
  
1. Your design must synthesize at 30MHz but you can run it at any arbitrarily-slow frequency (including single-stepping the clock) on the manufactured chip. If your design must run at an exact frequency, it is safest to choose a lower frequency (i.e. 5MHz)

  

2. For your final project, we will ask you to submit some sort of testbench to verify your design. Include all relevant testing files inside the `testbench` repository

  
  

3. For your final project, we will ask you to submit documentation on how to run/test your design, as well as include your project proposal and progress reports. Include all these files inside the `docs` repository

  
  

4. Optionally, if you use any images in your documentation (diagrams, waveforms, etc) please include them in a separate `img` repository


  

5. Feel free to edit this file and include some basic information about your project (short description, inputs and outputs, diagrams, how to run, etc). An outline is provided below

# Final Project Example Template


## Project Name

Linear Regression Calculator

The user gives a 3x2 (x,y) datapoint on a KEYPAD and the OLED displays the linear regression equation. 

Here is a working demo:
https://youtube.com/shorts/59fyLhhhODE?si=8yNVz1InCA2EF3Xw

![image](https://github.com/user-attachments/assets/e77e799d-f0e9-41d6-bf23-ba0f8c90a0f2)


## IO

An IO table listing all of your inputs and outputs and their function, like the one below:

| Input/Output | Description                                      |
|--------------|--------------------------------------------------|
| io_in[0]     | Keypad COL4                                      |
| io_in[1]     | Keypad COL3                                      |
| io_in[2]     | Keypad COL2                                      |
| io_in[3]     | Keypad COL1                                      |
| io_in[4]     | Keypad ROW4                                      |
| io_in[5]     | Keypad ROW3                                      |
| io_in[6]     | Keypad ROW2                                      |
| io_in[7]     | Keypad ROW1                                      |
| io_out[0]    | OLED CS (Chip Select)                            |
| io_out[1]    | OLED SPI / SDIN (MOSI)                           |
| io_out[2]    | OLED SCLK (Clock)                                |
| io_out[3]    | OLED D/C (Data/Command select)                   |
| io_out[4]    | OLED RES (Reset)                                 |
| io_out[5]    | OLED VBATC (Power Control)                       |
| io_out[6]    | OLED VDDC (Power Control)                        |



## How to Test

Connect the PMODs. Toggle the reset button. Insert the three X values (with a corresponding "Enter" button afterwards). Insert the three Y values (with corresponding "Enter".) Watch the OLED display the value.
