FROM python:3

RUN apt-get -y update && apt-get -y install git && apt-get install tk -y && apt-get install numpy

RUN git clone https://github.com/elizabec/VentilationController.git

RUN cd VentilationController && pip install -r req.txt




