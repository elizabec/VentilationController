FROM python:3

RUN python3 -m pip install robotframework && python3 -m pip install smbus && python3 -m pip install paho-mqtt 

RUN python3 -m pip install pyserial && python3 -m pip install minimalmodbus && python3 -m pip install numpy

ADD VentilationController/MyMQTT.py /usr/src/ventcontroller/

ADD VentilationController/MyModbus.py /usr/src/ventcontroller/

ADD VentilationController/MySerial.py /usr/src/ventcontroller/

ADD VentilationController/read_i2c.py /usr/src/ventcontroller/

ADD VentilationController/configuration.robot /usr/src/ventcontroller/

ADD VentilationController/keywords_MQTT.robot /usr/src/ventcontroller

ADD VentilationController/keywords_serial.robot /usr/src/ventcontroller

ADD VentilationController/vent_tests_MQTT.robot /usr/src/ventcontroller/

ADD VentilationController/vent_tests_USB.robot /usr/src/ventcontroller/
