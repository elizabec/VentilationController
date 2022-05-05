*** Settings ***
Library     Collections
Library     String
Library     Dialogs

Library     MyMQTT.py
Library     read_i2c.py
Library     MyModbus.py
Library     MySerial.py

*** Variables ***

${DIP_1}     0
${DIP_2}     1
${POWER}     2
${BOOST}     3

${ON}        1
${OFF}       0

${FUNC_3}    3
${FUNC_4}    4

${FAN_VOLT}     0
${QUERY_ON}     5

${NO_DEC}       0

${TOPIC_STATUS}      controller/status
${TOPIC_SETTING}     controller/settings

${speed_50}          {"auto": false, "speed": 50} 
${speed_30}          {"auto": false, "speed": 30}
${speed_5}           {"auto": false, "speed": 5}
${speed_10}          {"auto": false, "speed": 10}

${pressure_70}       {"auto": true, "pressure": 70}
${pressure_50}       {"auto": true, "pressure": 50}

${RPI_LPC_PORT}          /dev/ttyACM0


*** Keywords ***

Get I2C Pressure
    ${i2c_pressure}=    Run Keyword    Read I2C Data
    [Return]    ${i2c_pressure}

Write MODBUS Bits    [Arguments]    ${REGISTER}    ${MODE}
    ${VENT}=    Run Keyword    Setup
    Run Keyword    Write Modbits    ${VENT}    ${REGISTER}    ${MODE}

Read MODBUS Bits    [Arguments]    ${REGISTER}    ${FUNCTION}
    ${VENT}=    Run Keyword    Setup
    ${output}=    Run Keyword    Read Modbits     ${VENT}    ${REGISTER}    ${FUNCTION}
    Log    ${output}

Read Fan Volts    [Arguments]    ${DECIMALS}    ${FUNCTION}
    ${VENT}=    Run Keyword    Setup
    ${output}=    Run Keyword    Get Fan Volt    ${VENT}    ${DECIMALS}    ${FUNCTION}
    Log    ${output}
    [Return]    ${output}

Query Fan Status    [Arguments]    ${DECIMALS}    ${FUNCTION}
    ${VENT}=    Run Keyword    Setup
    ${output}=    Run Keyword   Query Fan    ${VENT}    ${DECIMALS}    ${FUNCTION}
    [Return]    ${output}

Open KSOM Vent
    ${VENT}=    Run Keyword    Setup
    FOR    ${i}    IN RANGE    3
        Run Keyword    Write Modbits    ${VENT}    ${POWER}    ${ON}
        Sleep    1.5s
        Run Keyword    Write Modbits    ${VENT}    ${POWER}    ${OFF}
        Sleep    0.5s
    END

Close KSOM Vent
    ${VENT}=    Run Keyword    Setup
    Run Keyword    Write Modbits    ${VENT}    ${POWER}    ${ON}
    Sleep    8s
    Run Keyword    Write Modbits    ${VENT}    ${POWER}    ${OFF}
