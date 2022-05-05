*** Settings ***

Resource    keywords_MQTT.robot

Suite Setup    Run Keyword    MQTT Begin

*** Test Cases ***

Manual Test Speed 50 MQTT
    [Tags]    manual    mqtt    speed
    Publish MQTT Payload    ${speed_50}
    Sleep    10s
    MQTT Compare Speed Values 

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



