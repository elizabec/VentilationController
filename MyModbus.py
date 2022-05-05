import minimalmodbus
import serial
import time

def setup():
    vent_ctrl = minimalmodbus.Instrument('/dev/ttyUSB0', 1)
    vent_ctrl.serial.baudrate = 9600
    vent_ctrl.serial.stopbits = 2
    vent_ctrl.serial.parity = serial.PARITY_NONE
    vent_ctrl.mode = minimalmodbus.MODE_RTU

    return vent_ctrl

def get_fan_volt(ins, decimals, fcode):
    #reg = 5 = count since last read = is the fan on?
    #reg = 0 = voltage
    fcode = int(fcode)
    decimals = int(decimals)
    val  = ins.read_register(0, decimals, fcode)
    fan_volt = int(round(val / 10))
    return fan_volt

def query_fan(ins, decimals, fcode):
    fcode = int(fcode)
    decimals = int(decimals)
    val1  = ins.read_register(5, decimals, fcode)
    print(val1)
    time.sleep(0.5)
    val2 = ins.read_register(5, decimals, fcode)
    print(val2)
    if val2 == 0:
        return 'OFF'
    if val1 == 0:
        return 'OFF'
    if val1 > val2:
        return 'ON'

def write_modbits(ins, reg, mode):

    reg = int(reg)
    mode = int(mode)
    ins.write_bit(reg, mode)

def read_modbits(ins, reg, mode):

    reg = int(reg)
    mode = int(mode)
    ins.read_bit(reg, mode, 2)


if __name__ == '__main__':
    vent = setup()
    write_modbits(vent, 2, 0)
    time.sleep(0.5)
    write_modbits(vent, 0, 0)
    write_modbits(vent, 1, 0)
    write_modbits(vent, 3, 0)
    
    