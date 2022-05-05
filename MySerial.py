import serial
import json

 # port for LPC1549 microcontroller
#send {"auto: false,  speed: 30"} OR {"auto: true,  pressure: 30"}

def serial_send(sendstr, port):
    ser = serial.Serial(port, 9600)
    ser.write(sendstr.encode())

def serial_read(port):
    ser = serial.Serial(port, 9600)
    val = ser.readline()
    j_val = json.loads(val) 
    return j_val

def read_serial_speed(j_str):
    fan_speed = j_str['speed']
    return fan_speed

def read_serial_pressure(j_str):
    pressure = j_str['pressure']
    return pressure

def read_serial_setpoint(j_str):
    setpoint = j_str['setpoint']
    return setpoint


def read_serial_mode(j_str):
    mode = j_str['auto'] 
    return mode


def read_serial_error(j_str):
    error_flag = j_str['error']
    return error_flag

if __name__ == '__main__':
    port = '/dev/ttyACM0'
    sendstr = '{"auto": false, "speed": 30}'
    j_str = serial_read(port)
    read_serial_speed(j_str)