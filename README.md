


## Project Name

Linear Regression Calculator

The user gives a 3x2 (x,y) datapoint on a KEYPAD and the OLED displays the linear regression equation. 

Here is a working demo:
https://youtube.com/shorts/59fyLhhhODE?si=8yNVz1InCA2EF3Xw

![image](https://github.com/user-attachments/assets/e77e799d-f0e9-41d6-bf23-ba0f8c90a0f2)

(The letter E indicates that we have inputted our data)


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

## More information in the docs section.
