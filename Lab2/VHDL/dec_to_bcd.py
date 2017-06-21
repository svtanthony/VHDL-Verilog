bcd_nums = ["0000",
            "0001",
            "0010",
            "0011",
            "0100",
            "0101",
            "0110",
            "0111",
            "1000",
            "1001"]

# To use, enter the number to be converted followed by bits
# Sample input "99 8" output: "10011001"
while(True):
    inputs = raw_input().split(" ")
    dec = int(inputs[0])
    bits = int(inputs[1])
    bcd_result = ""
    for i in range(0, bits/4):
        bcd_result = bcd_nums[dec % 10] + bcd_result
        dec = dec / 10

    print bcd_result
