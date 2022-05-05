*** Settings ***

Resource    configuration.robot


*** Keywords ***

Send Serial Command    [Arguments]    ${payload}    ${PORT} 
    Run Keyword    Serial Send    ${payload}    ${PORT}  
    
Read Serial Message    [Arguments]    ${PORT}
    ${JSON_OBJ}=    Run Keyword    Serial Read    ${PORT}
    [Return]    ${JSON_OBJ}

Get Serial Fan Speed    [Arguments]    ${payload}
    ${speed}=    Run Keyword    Read Serial Speed    ${payload}
    Log    ${speed}
    [Return]    ${speed}

Get Serial Air Pressure    [Arguments]    ${payload}
    ${pressure}=    Run Keyword    Read Serial Pressure    ${payload}
    Log    ${pressure}
    [Return]    ${pressure}

Get Serial Set Point    [Arguments]    ${payload}
    ${setpoint}=    Run Keyword    Read Serial Setpoint    ${payload}
    Log    ${setpoint}
    [Return]    ${setpoint}

Get Serial Controller Mode    [Arguments]    ${payload}
    ${mode}=    Run Keyword    Read Serial Mode    ${payload}
    Log    ${mode}
    [Return]    ${mode}

Get Serial Error    [Arguments]    ${payload}
    ${error_flag}=    Run Keyword   Read Serial Error    ${payload}
    Log    ${error_flag}
    [Return]    ${error_flag}

Serial Get Speed Values    [Arguments]    ${VENT}    ${PORT} 
    ${PAYLOAD}=    Read Serial Message    ${PORT}
    ${SERIAL_SPEED}=    Get Serial Fan Speed    ${PAYLOAD}
    ${FAN_VOLT}=    Read Fan Volts    ${VENT}    ${NO_DEC}    ${FUNC_4}

Serial Get Pressure Values    [Arguments]    ${PORT}
    ${PAYLOAD}=    Read Serial Message    ${PORT}
    ${SERIAL_PRESSURE}=    Get Serial Air Pressure    ${PAYLOAD}
    ${I2C_PRESSURE}=    Get I2C Pressure

Serial Compare Speed Values    [Arguments]    ${VENT}    ${PORT}
    ${PAYLOAD}=    Read Serial Message    ${PORT}
    ${SERIAL_SPEED}=    Get Serial Fan Speed    ${PAYLOAD}
    ${FAN_VOLT}=    Read Fan Volts    ${VENT}    ${NO_DEC}    ${FUNC_4}
    ${DIFF}=     Evaluate    ${SERIAL_SPEED} - ${FAN_VOLT}
    ${ABS_DIFF}=    Evaluate    abs(${DIFF})
    Should be True    ${ABS_DIFF} < 2 

Serial Compare Pressure Values    [Arguments]    ${PORT}
    ${PAYLOAD}=    Read Serial Message    ${PORT}
    ${SERIAL_PRESSURE}=    Get Serial Air Pressure    ${PAYLOAD}
    ${I2C_PRESSURE}=    Get I2C Pressure
    ${DIFF}=     Evaluate    ${SERIAL_PRESSURE} - ${I2C_PRESSURE}
    ${ABS_DIFF}=    Evaluate    abs(${DIFF})
    Should be True    ${ABS_DIFF} < 3 

Serial Open Vent and Compare Speed    [Arguments]    ${VENT}    ${PORT}
    Open KSOM Vent    ${VENT}
    Sleep    10s
    Serial Compare Speed Values    ${VENT}    ${PORT}
    Serial Get Pressure Values    ${PORT}

Serial Open Vent and Compare Pressure    [Arguments]    ${VENT}    ${PORT}
    Open KSOM Vent    ${VENT}
    Sleep    20s
    Serial Get Speed Values    ${PORT}
    Serial Compare Pressure Values    ${VENT}    ${PORT}


