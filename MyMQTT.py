import time
import paho.mqtt.client as mqtt
import json

class MyMQTT:
    ROBOT_LIBRARY_SCOPE = 'SUITE'
    def on_connect(self, client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT")
        else:
            print("Bad connection, returned code = ", rc)
        self.client.subscribe(self.sub_topic)

    def on_message(self, client, userdata, message):
        self.rec_message = json.loads(message.payload)

    def on_publish(self, client, userdata, m_id):
        print("Message sent")

    def __init__(self, client_name='VentCtrl', broker_address='192.168.1.254', sub_topic='controller/status', pub_topic='controller/settings'):
        self.client_name = client_name
        self.broker = broker_address
        self.sub_topic = sub_topic
        self.pub_topic = pub_topic
        self.client = mqtt.Client(self.client_name)
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        self.client.on_publish = self.on_publish

    def mqtt_begin(self):
        self.client.connect(self.broker)
        self.client.loop_start()

    def mqtt_end(self): 
        self.client.disconnect()
        self.client.loop_stop()

    def get_message(self):
        m = self.rec_message
        return m
    
    def send_message(self, msg_str):
        m = msg_str 
        self.client.publish(self.pub_topic, msg_str)
        time.sleep(1)
        return m

    def read_mqtt_message(self, mqtt_payload, value):
        ret_value = mqtt_payload[value]
        return ret_value

    def read_speed(self, mqtt_payload):
        fan_speed = mqtt_payload['speed']
        return fan_speed

    def read_pressure(self, mqtt_payload):
        pressure = mqtt_payload['pressure']
        return pressure

    def read_setpoint(self, mqtt_payload):
        setpoint = mqtt_payload['setpoint']
        return setpoint

    def read_mode(self, mqtt_payload):
        mode = mqtt_payload['auto'] 
        return mode

    def read_error(self, mqtt_payload):
        error_flag = mqtt_payload['error']
        return error_flag



    



