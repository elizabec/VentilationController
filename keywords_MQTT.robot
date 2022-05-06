*** Settings ***

Resource    configuration.robot

Library     MyMQTT.py

*** Keywords ***

Get MQTT Payload
    ${PAYLOAD}=    Run Keyword    Get Message    
    Log    ${PAYLOAD}
    [Return]    ${PAYLOAD}

Publish MQTT Payload    [Arguments]    ${MESSAGE}
    ${SEND_MSG}=    Run Keyword    Send Message    ${MESSAGE}
    Log    ${SEND_MSG}

Get MQTT JSON Value    [Arguments]    ${payload}
    ${value}=    Get Value From User    Input Desired Value
    Variable Should Exist    ${value}
    ${key}=    Read MQTT Message    ${payload}    ${value}
    Log    ${value}
    Log    ${key}

Get MQTT Fan Speed    [Arguments]    ${payload}
    ${speed}=    Run Keyword    Read Speed    ${payload}
    Log    ${speed}
    [Return]    ${speed}

Get MQTT Air Pressure    [Arguments]    ${payload}
    ${pressure}=    Run Keyword    Read Pressure    ${payload}
    Log    ${pressure}
    [Return]    ${pressure}

Get MQTT Set Point    [Arguments]    ${payload}
    ${setpoint}=    Run Keyword    Read Setpoint    ${payload}
    Log    ${setpoint}
    [Return]    ${setpoint}

Get MQTT Controller Mode    [Arguments]    ${payload}
    ${mode}=    Run Keyword    Read Mode    ${payload}
    Log    ${mode}
    [Return]    ${mode}

Get MQTT Error    [Arguments]    ${payload}
    ${error_flag}=    Run Keyword   Read Error    ${payload}
    Log    ${error_flag}
    [Return]    ${error_flag}

MQTT Get Speed Values    [Arguments]    ${VENT}
    ${PAYLOAD}=    Get MQTT Payload
    ${MQTT_SPEED}=    Get MQTT Fan Speed    ${PAYLOAD}
    ${FAN_VOLT}=    Read Fan Volts    ${VENT}    ${NO_DEC}    ${FUNC_4}

MQTT Get Pressure Values
    ${PAYLOAD}=    Get MQTT Payload
    ${MQTT_PRESSURE}=    Get MQTT Air Pressure    ${PAYLOAD}
    ${I2C_PRESSURE}=    Get I2C Pressure

MQTT Compare Speed Values    [Arguments]    ${VENT}
    ${PAYLOAD}=    Get MQTT Payload
    ${MQTT_SPEED}=    Get MQTT Fan Speed    ${PAYLOAD}
    ${FAN_VOLT}=    Read Fan Volts    ${VENT}    ${NO_DEC}    ${FUNC_4}
    ${DIFF}=     Evaluate    ${MQTT_SPEED} - ${FAN_VOLT}
    ${ABS_DIFF}=    Evaluate    abs(${DIFF})
    Should be True    ${ABS_DIFF} <= 2 

MQTT Compare Pressure Values
    ${PAYLOAD}=    Get MQTT Payload
    ${MQTT_PRESSURE}=    Get MQTT Air Pressure    ${PAYLOAD}
    ${I2C_PRESSURE}=    Get I2C Pressure
    ${DIFF}=     Evaluate    ${MQTT_PRESSURE} - ${I2C_PRESSURE}
    ${ABS_DIFF}=    Evaluate    abs(${DIFF})
    Should be True    ${ABS_DIFF} <= 3 

MQTT Open Vent and Compare Speed    [Arguments]    ${VENT}
    Open KSOM Vent    ${VENT}
    Sleep    10s
    MQTT Compare Speed Values    ${VENT}
    MQTT Get Pressure Values

MQTT Open Vent and Compare Pressure    [Arguments]    ${VENT}
    Open KSOM Vent    ${VENT}
    Sleep    20s
    MQTT Get Speed Values    ${VENT}
    MQTT Compare Pressure Values


