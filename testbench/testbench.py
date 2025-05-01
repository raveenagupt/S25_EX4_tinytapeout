import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock

ELEM_WIDTH = 32
NUM_SAMPLES = 5
NUM_FEATURES = 2

async def apply_input(dut, value):
    dut.data_in.value = value
    dut.enter.value = 1
    await Timer(10, units='ns')
    dut.enter.value = 0
    await Timer(10, units='ns')

async def run_test(dut, x_values, y_values, case_name="N/A"):
    print(f"\nRunning Test Case: {case_name}")

    clock = Clock(dut.clk, 10, units="ns")  
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.enter.value = 0
    dut.input_done.value = 0
    dut.data_in.value = 0
    await Timer(10, units='ns')
    dut.rst.value = 0
    await Timer(10, units='ns')

    for x in x_values:
        await apply_input(dut, x)

    for y in y_values:
        await apply_input(dut, y)

    dut.input_done.value = 1
    await Timer(10, units='ns')
    dut.input_done.value = 0

    for _ in range(1000):
        if dut.done_multiply_iny.value:
            break
        await RisingEdge(dut.clk)

    result = dut.C_out_iny.value
    det = dut.det.value.signed_integer
    error_det = dut.error_det.value.integer
    error_values = dut.error_values.value.integer

    val_64 = result.integer & ((1 << 64) - 1)
    low_32 = val_64 & 0xFFFFFFFF
    high_32 = (val_64 >> 32) & 0xFFFFFFFF

    def to_signed(val, bits=32):
        if val & (1 << (bits - 1)):
            return val - (1 << bits)
        return val

    c10 = to_signed(high_32)
    c00 = to_signed(low_32)

    print("\n==== Simulation Output ====")
    print(f"Regression Output (C_out_iny): {format(val_64, '064b')}")
    print(f"Determinant: {det}")
    print(f"Error Detected (det): {error_det}")
    print(f"Error in Values: {error_values}")
    print(f"C[0][0] = {c00}")
    print(f"C[1][0] = {c10}")
    print(f"The final linear equation is y = {c10}/{det}x + {c00}/{det}")

    assert error_det == 0, "Determinant calculation error flagged"
    assert error_values == 0, "Input matrix error flagged"
    assert dut.done_multiply_iny.value, "Final multiplication not done"

@cocotb.test()
async def input_matrix_error(dut):
    print(f"\nRunning Test Case: Invalid Input")
    x_values = [1, 2, 3, 4, 5]
    y_values = [5, 4, 3, 2, 1]

    clock = Clock(dut.clk, 10, units="ns")  
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.enter.value = 0
    dut.input_done.value = 0
    dut.data_in.value = 0
    await Timer(10, units='ns')
    dut.rst.value = 0
    await Timer(10, units='ns')

    for x in x_values:
        await apply_input(dut, x)

    dut.input_done.value = 0
    for y in y_values:
        await apply_input(dut, y)

    dut.input_done.value = 1
    await Timer(10, units='ns')

    for _ in range(1000):
        if dut.done_multiply_iny.value:
            break
        await RisingEdge(dut.clk)

    result = dut.C_out_iny.value
    det = dut.det.value.signed_integer
    error_det = dut.error_det.value.integer
    error_values = dut.error_values.value.integer

    val_64 = result.integer & ((1 << 64) - 1)
    low_32 = val_64 & 0xFFFFFFFF
    high_32 = (val_64 >> 32) & 0xFFFFFFFF

    def to_signed(val, bits=32):
        if val & (1 << (bits - 1)):
            return val - (1 << bits)
        return val

    c10 = to_signed(high_32)
    c00 = to_signed(low_32)
    if(error_values == 1):
        print("PASS: We did not input all the data or invalid data was inserted")




async def wrong_det(dut, x_values, y_values, case_name="N/A"):
    print(f"\nRunning Test Case: {case_name}")

    clock = Clock(dut.clk, 10, units="ns")  
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.enter.value = 0
    dut.input_done.value = 0
    dut.data_in.value = 0
    await Timer(10, units='ns')
    dut.rst.value = 0
    await Timer(10, units='ns')

    for x in x_values:
        await apply_input(dut, x)

    for y in y_values:
        await apply_input(dut, y)

    dut.input_done.value = 1
    await Timer(10, units='ns')
    dut.input_done.value = 0

    for _ in range(1000):
        if dut.done_multiply_iny.value:
            break
        await RisingEdge(dut.clk)

    result = dut.C_out_iny.value
    det = dut.det.value.signed_integer
    error_det = dut.error_det.value.integer
    error_values = dut.error_values.value.integer

    val_64 = result.integer & ((1 << 64) - 1)
    low_32 = val_64 & 0xFFFFFFFF
    high_32 = (val_64 >> 32) & 0xFFFFFFFF

    def to_signed(val, bits=32):
        if val & (1 << (bits - 1)):
            return val - (1 << bits)
        return val

    c10 = to_signed(high_32)
    c00 = to_signed(low_32)

    print("\n==== Simulation Output ====")
    print(f"Regression Output (C_out_iny): {format(val_64, '064b')}")
    print(f"Determinant: {det}")
    print(f"Error Detected (det): {error_det}")
    print(f"Error in Values: {error_values}")
    print(f"C[0][0] = {c00}")
    print(f"C[1][0] = {c10}")
    print(f"The final linear equation is y = {c10}/{det}x + {c00}/{det}")
    if error_det == 1:
        print("PASS: Determinant error flagged (likely non-invertible matrix). Check input data.")


@cocotb.test()

async def test_all_cases(dut):
    test_all_cases_valid = [{
        "x_values": [1, 2, 3, 4, 5],
        "y_values": [5, 4, 3, 2, 1],
        "name": "Easy"
    },
    {
        "x_values": [5, 4, 23, 13, 32],
        "y_values": [12, 32, 32, 43, 8],
        "name": "Hard"
    },
    {
        "x_values": [1, 1, 24, 1, 423],
        "y_values": [1, 5, 0, 3, 1],
        "name": "Hard"

    }
    ]

    test_all_cases_invalid = [{
        "x_values": [1, 1, 1, 1, 1],
        "y_values": [1, 1, 1, 1, 1],
        "name": "INVALID"
    },
    ]


    for case in test_all_cases_valid:
        await run_test(dut, case["x_values"], case["y_values"], case["name"])
    for case in test_all_cases_invalid:
        await wrong_det(dut, case["x_values"], case["y_values"], case["name"])

