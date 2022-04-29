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

${LPC_PORT}          /dev/ttyACM0


*** Keywords ***

Get MQTT Payload
    ${PAYLOAD}=    Run Keyword    Get Message
    Log    ${PAYLOAD}
    [Return]    ${PAYLOAD}

Publish MQTT Payload    [Arguments]    ${MESSAGE}
    ${TEST_MSG}=    Run Keyword    Send Message    ${MESSAGE}
    Log    ${TEST_MSG}

Get JSON Value    [Arguments]    ${payload}
    ${value}=    Get Value From User    Input Desired Value
    Variable Should Exist    ${value}
    ${key}=    Read MQTT Message    ${payload}    ${value}
    Log    ${value}
    Log    ${key}

Get Fan Speed    [Arguments]    ${payload}
    ${speed}=    Run Keyword    Read Speed    ${payload}
    Log    ${speed}
    [Return]    ${speed}

Get Air Pressure    [Arguments]    ${payload}
    ${pressure}=    Run Keyword    Read Pressure    ${payload}
    Log    ${pressure}
    [Return]    ${pressure}

Get Set Point    [Arguments]    ${payload}
    ${setpoint}=    Run Keyword    Read Setpoint    ${payload}
    Log    ${setpoint}
    [Return]    ${setpoint}

Get Controller Mode    [Arguments]    ${payload}
    ${mode}=    Run Keyword    Read Mode    ${payload}
    Log    ${mode}
    [Return]    ${mode}

Get MQTT Error    [Arguments]    ${payload}
    ${error_flag}=    Run Keyword   Read Error    ${payload}
    Log    ${error_flag}
    [Return]    ${error_flag}


Get I2C Pressure
    ${i2c_pressure}=    Run Keyword    Read I2C Data
    [Return]    ${i2c_pressure}

Send Serial Command    [Arguments]    ${payload}    ${PORT} 
    Run Keyword    Serial Send    ${payload}    ${PORT}   


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
    FOR    ${i}    IN RANGE    4
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

MQTT Get Speed Values
    ${PAYLOAD}=    Get MQTT Payload
    ${MQTT_SPEED}=    Get Fan Speed    ${PAYLOAD}
    ${FAN_VOLT}=    Read Fan Volts    ${NO_DEC}    ${FUNC_4}

MQTT Get Pressure Values
    ${PAYLOAD}=    Get MQTT Payload
    ${MQTT_PRESSURE}=    Get Air Pressure    ${PAYLOAD}
    ${I2C_PRESSURE}=    Get I2C Pressure

MQTT Compare Speed Values
    ${PAYLOAD}=    Get MQTT Payload
    ${MQTT_SPEED}=    Get Fan Speed    ${PAYLOAD}
    ${FAN_VOLT}=    Read Fan Volts    ${NO_DEC}    ${FUNC_4}
    ${DIFF}=     Evaluate    ${MQTT_SPEED} - ${FAN_VOLT}
    ${ABS_DIFF}=    Evaluate    abs(${DIFF})
    Should be True    ${ABS_DIFF} < 2 

MQTT Compare Pressure Values
    ${PAYLOAD}=    Get MQTT Payload
    ${MQTT_PRESSURE}=    Get Air Pressure    ${PAYLOAD}
    ${I2C_PRESSURE}=    Get I2C Pressure
    ${DIFF}=     Evaluate    ${MQTT_PRESSURE} - ${I2C_PRESSURE}
    ${ABS_DIFF}=    Evaluate    abs(${DIFF})
    Should be True    ${ABS_DIFF} < 3 

MQTT Open Vent and Compare Speed
    Open KSOM Vent
    Sleep    5s
    MQTT Compare Speed Values
    MQTT Get Pressure Values

MQTT Open Vent and Compare Pressure
    Open KSOM Vent
    Sleep    10s
    MQTT Get Speed Values
    MQTT Compare Pressure Values


Serial Compare Speed Values    [Arguments]    ${FAN_SPEED}
    ${FAN_VOLT}=    Read Fan Volts    ${NO_DEC}    ${FUNC_4}
    ${DIFF}=     Evaluate    ${FAN_SPEED} - ${FAN_VOLT}
    ${ABS_DIFF}=    Evaluate    abs(${DIFF})
    Should be True    ${ABS_DIFF} < 2 

Serial Compare Pressure Values    [Arguments]    ${AIR_PRESSURE}
    ${I2C_PRESSURE}=    Get I2C Pressure
    ${DIFF}=     Evaluate    ${AIR_PRESSURE} - ${I2C_PRESSURE}
    ${ABS_DIFF}=    Evaluate    abs(${DIFF})
    Should be True    ${ABS_DIFF} < 3 

Serial Open Vent and Compare Speed    [Arguments]    ${FAN_SPEED}
    Open KSOM Vent
    Sleep    5s
    Serial Compare Speed Values    ${FAN_SPEED}
    ${I2C_PRESSURE}=    Get I2C Pressure

Serial Open Vent and Compare Pressure    [Arguments]    ${AIR_PRESSURE}
    Open KSOM Vent
    Sleep    10s
    ${FAN_VOLT}=    Read Fan Volts    ${NO_DEC}    ${FUNC_4}
    Serial Compare Pressure Values    ${AIR_PRESSURE}