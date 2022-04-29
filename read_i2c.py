import smbus
import numpy as np


def read_i2c_data():
    i2c_ch = 1 # channel
    i2c_address = 0x40
    i2c_readreg = 0xF1
    bus = smbus.SMBus(i2c_ch)
    val = bus.read_i2c_block_data(i2c_address, i2c_readreg, 3) # read 3 bits from I2C
    val = np.uint8(val) # convert values to uint8
    shiftbit = val[0] << 8
    tot = shiftbit + val[1]
    pressure = round((tot / 240), 1)
    return pressure

