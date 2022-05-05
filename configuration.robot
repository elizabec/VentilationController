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

Write MODBUS Bits    [Arguments]    ${VENT}    ${REGISTER}    ${MODE}
    Run Keyword    Write Modbits    ${VENT}    ${REGISTER}    ${MODE}

Read MODBUS Bits    [Arguments]    ${VENT}    ${REGISTER}    ${FUNCTION}
    ${output}=    Run Keyword    Read Modbits     ${VENT}    ${REGISTER}    ${FUNCTION}
    Log    ${output}

Read Fan Volts    [Arguments]    ${VENT}    ${DECIMALS}    ${FUNCTION}
    ${output}=    Run Keyword    Get Fan Volt    ${VENT}    ${DECIMALS}    ${FUNCTION}
    Log    ${output}
    [Return]    ${output}

Query Fan Status    [Arguments]    ${VENT}   ${DECIMALS}    ${FUNCTION}
    ${output}=    Run Keyword   Query Fan    ${VENT}    ${DECIMALS}    ${FUNCTION}
    [Return]    ${output}

Open KSOM Vent    [Arguments]    ${VENT}
    Run Keyword    Write Modbits    ${VENT}    ${BOOST}    ${ON}
    Sleep    10s

Close KSOM Vent    [Arguments]    ${VENT}
    Run Keyword    Write Modbits    ${VENT}    ${BOOST}    ${OFF}
    Sleep    13s
    Run Keyword    Write Modbits    ${VENT}    ${POWER}    ${OFF}
    Sleep    0.5s
    Run Keyword    Write Modbits    ${VENT}    ${DIP_1}    ${OFF}
    Run Keyword    Write Modbits    ${VENT}    ${DIP_2}    ${OFF}

Set KSOM Dip Switches    [Arguments]    ${VENT}    ${DIPS}
    IF    "${DIPS}" == "NODIP"
        Run Keyword    Write Modbits    ${VENT}    ${POWER}    ${ON}
        Sleep    30s
    ELSE IF    "${DIPS}" == "DIP1" 
        Run Keyword    Write Modbits    ${VENT}    ${DIP_1}    ${ON}
        Sleep    0.5s
        Run Keyword    Write Modbits    ${VENT}    ${POWER}    ${ON}
        Sleep    30s
    ELSE IF    "${DIPS}" == "DIP2"
        Run Keyword    Write Modbits    ${VENT}    ${DIP_2}    ${ON}
        Sleep    0.5s
        Run Keyword    Write Modbits    ${VENT}    ${POWER}    ${ON}
        Sleep    30s
    ELSE IF    "${DIPS}" == "BOTHDIP"
        Run Keyword    Write Modbits    ${VENT}    ${DIP_1}    ${ON}
        Run Keyword    Write Modbits    ${VENT}    ${DIP_2}    ${ON}
        Sleep    0.5s
        Run Keyword    Write Modbits    ${VENT}    ${POWER}    ${ON}
        Sleep    30s
    END