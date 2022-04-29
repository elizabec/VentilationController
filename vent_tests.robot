*** Settings ***

Resource    configuration.robot


*** Test Cases ***

Manual Test Speed 50 MQTT
    [Tags]    manual    mqtt
    Publish MQTT Payload    ${speed_50}
    Sleep    10s
    Compare Speed Values 

Manual Test Vent Control MQTT
    [Tags]    manual    mqtt    ventcontrol
    Publish MQTT Payload    ${speed_30}
    Sleep    10s
    MQTT Open Vent and Compare Speed
    MQTT Open Vent and Compare Speed
    Close KSOM Vent
    MQTT Compare Speed Values
    MQTT Get Pressure Values

Manual Test Low Speed MQTT
    [Tags]    manual    mqtt    errorflag
    Publish MQTT Payload    ${speed_5}
    Sleep    20s
    MQTT Get Speed Values
    ${FAN_STATUS}=    Query Fan Status    ${NO_DEC}    ${FUNC_4}
    Should be Equal as Strings    ${FAN_STATUS}    OFF
    Sleep    45s
    ${PAYLOAD}=    Get MQTT Payload
    ${error_flag}=    Get MQTT Error    ${PAYLOAD}
    Should be Equal as Strings    ${error_flag}    True

    Publish MQTT Payload    ${speed_10}
    Sleep    20s
    MQTT Get Speed Values
    ${FAN_STATUS}=    Query Fan Status    ${NO_DEC}    ${FUNC_4}
    Should be Equal as Strings    ${FAN_STATUS}    ON
    Sleep    10s
    ${PAYLOAD}=    Get MQTT Payload
    ${error_flag}=    Get MQTT Error    ${PAYLOAD}
    Should be Equal as Strings    ${error_flag}    False


Automatic Test Pressure 70 MQTT
    [Tags]    automatic    mqtt
    Publish MQTT Payload    ${pressure_70}
    Sleep    20s
    MQTT Compare Pressure Values

Automatic Test Vent Control MQTT
    [Tags]    automatic    mqtt    ventcontrol
    Publish MQTT Payload    ${pressure_50}
    Sleep    20s
    MQTT Open Vent and Compare Pressure
    MQTT Open Vent and Compare Pressure
    Close KSOM Vent
    MQTT Get Speed Values
    MQTT Compare Pressure Values


Manual Test Speed 50 Serial
    [Tags]    manual    serial
    Send Serial Command    ${speed_50}    ${LPC_PORT}
    Sleep    10s
    Serial Compare Speed Values    50 

Manual Test Vent Control Serial
    [Tags]    manual    serial    ventcontrol
    Send Serial Command    ${speed_30}    ${LPC_PORT}
    Sleep    10s
    Serial Open Vent and Compare Speed    30
    Serial Open Vent and Compare Speed    30
    Close KSOM Vent
    Serial Compare Speed Values    30
    ${cur_pressure}=    Get I2C Pressure

Manual Test Low Speed Serial
    [Tags]    manual    serial    lowspeed
    Send Serial Command    ${speed_5}    ${LPC_PORT}
    Sleep    20s
    ${cur_speed}=    Read Fan Volts    ${NO_DEC}    ${FUNC_4}
    ${FAN_STATUS}=    Query Fan Status    ${NO_DEC}    ${FUNC_4}
    Should be Equal as Strings    ${FAN_STATUS}    OFF
    Sleep    10s

    Send Serial Command    ${speed_10}    ${LPC_PORT}
    Sleep    10s
    ${cur_speed}=    Read Fan Volts    ${NO_DEC}    ${FUNC_4}
    ${FAN_STATUS}=    Query Fan Status    ${NO_DEC}    ${FUNC_4}
    Should be Equal as Strings    ${FAN_STATUS}    ON
    Sleep    10s


Automatic Test Pressure 70 Serial
    [Tags]    automatic    serial
    Send Serial Command    ${pressure_70}    ${LPC_PORT}
    Sleep    20s
    Serial Compare Pressure Values    70

Automatic Test Vent Control Serial
    [Tags]    automatic    serial    ventcontrol
    Send Serial Command    ${pressure_50}    ${LPC_PORT}
    Sleep    20s
    Serial Open Vent and Compare Pressure    50
    Serial Open Vent and Compare Pressure    50
    Close KSOM Vent
    ${cur_speed}=    Read Fan Volts    ${NO_DEC}    ${FUNC_4}
    Serial Compare Pressure Values    50
