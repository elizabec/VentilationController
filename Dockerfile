FROM python:3

RUN python3 -m pip install robotframework && python3 -m pip install smbus && python3 -m pip install paho-mqtt 

RUN python3 -m pip install pyserial && python3 -m pip install minimalmodbus && python3 -m pip install numpy

RUN apt-get -y update && apt-get -y install git

RUN git clone https://gitlab.metropolia.fi/elizabec/ventilation-controller-tests.git

CMD ["cd", "ventilation-controller-tests", "|", "python3", "robot_gui.py"]

