import time
import paho.mqtt.client as mqtt
import json


def on_message(client, userdata, message):
    global rec_message
    rec_message = json.loads(message.payload)


def on_publish(client, userdata, m_id):
    print("Message sent")


def get_message():
    broker_address = '192.168.1.254'
    client = mqtt.Client("Test1")
    client.on_message = on_message
    client.connect(broker_address)
    client.loop_start()
    client.subscribe('controller/status')
    time.sleep(3)
    m = rec_message
    client.loop_stop()
    return m
    
def send_message(msg_str):
    broker_address = '192.168.1.254'
    client = mqtt.Client("Test1")
    client.on_message = on_message
    client.on_publish = on_publish
    m = msg_str
    client.connect(broker_address)
    client.loop_start()
    client.subscribe('controller/settings')
    client.publish('controller/settings', msg_str)
    time.sleep(1)
    client.loop_stop()
    return m


def read_mqtt_message(mqtt_payload, value):
    ret_value = mqtt_payload[value]
    return ret_value


def read_speed(mqtt_payload):
    fan_speed = mqtt_payload['speed']
    print("Speed: ", mqtt_payload['speed'])

    return fan_speed


def read_pressure(mqtt_payload):
    pressure = mqtt_payload['pressure']
    print("Pressure: ", mqtt_payload['pressure'])

    return pressure


def read_setpoint(mqtt_payload):
    setpoint = mqtt_payload['setpoint']

    return setpoint


def read_mode(mqtt_payload):
    mode = mqtt_payload['auto']
    
    return mode

def read_error(mqtt_payload):
    error_flag = mqtt_payload['error']

    return error_flag


if __name__ == '__main__':
    x = get_message
    read_speed(x)
    read_pressure(x)
    



