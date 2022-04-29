import time
import serial
import json

 # port for LPC1549 microcontroller
#send {"auto: false,  speed: 30"} OR {"auto: true,  pressure: 30"}

def serial_send(sendstr, port):
    ser = serial.Serial(port, 9600)
    ser.write(sendstr.encode())
    print(sendstr)

if __name__ == '__main__':
    port = '/dev/ttyACM0'
    sendstr = '{"auto": false, "speed": 30}'
    serial_send(sendstr, port)