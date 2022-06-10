FROM python:3

RUN apt-get -y update && apt-get -y install git && apt-get install tk -y

RUN git clone https://gitlab.metropolia.fi/elizabec/ventilation-controller-tests.git

RUN mkdir VentControl

ADD ventilation-controller-tests /VentControl

RUN cd VentControl && python3 -m pip install -r req.txt




