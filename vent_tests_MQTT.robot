*** Settings ***

Resource    keywords_MQTT.robot

Suite Setup       Run Keyword    MQTT Begin
Suite Teardown    Run Keyword    MQTT End

*** Test Cases ***

Manual Test Speed 50 MQTT
    [Tags]    manual    mqtt    speed
    Publish MQTT Payload    ${speed_50}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    MQTT Compare Speed Values    ${VENT}

Manual Test Vent Control No Dip Switches
    [Tags]    manual    mqtt    ventcontrol    nodips
    Publish MQTT Payload    ${speed_30}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    NODIP
    MQTT Open Vent and Compare Speed    ${VENT}    
    Close KSOM Vent    ${VENT}
    MQTT Compare Speed Values    ${VENT}    
    MQTT Get Pressure Values   

Manual Test Vent Control Dip Switch 1
    [Tags]    manual    mqtt    ventcontrol    dipone
    Publish MQTT Payload    ${speed_30}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    DIP1
    MQTT Open Vent and Compare Speed    ${VENT}   
    Close KSOM Vent    ${VENT}
    MQTT Compare Speed Values    ${VENT}    
    MQTT Get Pressure Values    

Manual Test Vent Control Dip Switch 2
    [Tags]    manual    mqtt    ventcontrol    diptwo
    Publish MQTT Payload    ${speed_30}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    DIP2
    MQTT Open Vent and Compare Speed    ${VENT}
    Close KSOM Vent    ${VENT}
    MQTT Compare Speed Values    ${VENT}    
    MQTT Get Pressure Values    

Manual Test Vent Control Both Dip Switches
    [Tags]    manual    mqtt    ventcontrol    bothdip
    Publish MQTT Payload    ${speed_30}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    BOTHDIP
    MQTT Open Vent and Compare Speed    ${VENT}
    Close KSOM Vent    ${VENT}
    MQTT Compare Speed Values    ${VENT}
    MQTT Get Pressure Values

Manual Test Low Speed MQTT
    [Tags]    manual    mqtt    errorflag
    Publish MQTT Payload    ${speed_5}
    Sleep    20s
    ${VENT}=    Run Keyword    Setup
    MQTT Get Speed Values    ${VENT}
    ${FAN_STATUS}=    Query Fan Status    ${VENT}    ${NO_DEC}    ${FUNC_4}
    Should be Equal as Strings    ${FAN_STATUS}    OFF
    Sleep    45s
    ${PAYLOAD}=    Get MQTT Payload
    ${error_flag}=    Get MQTT Error    ${PAYLOAD}
    Should be Equal as Strings    ${error_flag}    True

    Publish MQTT Payload    ${speed_10}
    Sleep    20s
    MQTT Get Speed Values    ${VENT}
    ${FAN_STATUS}=    Query Fan Status    ${VENT}    ${NO_DEC}    ${FUNC_4}
    Should be Equal as Strings    ${FAN_STATUS}    ON
    Sleep    10s
    ${PAYLOAD}=    Get MQTT Payload
    ${error_flag}=    Get MQTT Error    ${PAYLOAD}
    Should be Equal as Strings    ${error_flag}    False

Read Message From MQTT
    [Tags]    mqtt    read
    ${PAYLOAD}=    Run Keyword    Get MQTT Payload
    Log    ${PAYLOAD}

Automatic Test Pressure 70 MQTT
    [Tags]    automatic    mqtt    pressure
    Publish MQTT Payload    ${pressure_70}
    Sleep    20s
    MQTT Compare Pressure Values

Automatic Test Vent Control No Dip Switches
    [Tags]    automatic    mqtt    ventcontrol    nodips
    Publish MQTT Payload    ${pressure_50}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    NODIP
    MQTT Open Vent and Compare Pressure    ${VENT}
    Close KSOM Vent    ${VENT}
    MQTT Get Speed Values    ${VENT}
    MQTT Compare Pressure Values

Automatic Test Vent Control Dip Switch 1
    [Tags]    automatic    mqtt    ventcontrol    onedip
    Publish MQTT Payload    ${pressure_50}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    DIP1
    MQTT Open Vent and Compare Pressure    ${VENT}
    Close KSOM Vent    ${VENT}
    MQTT Get Speed Values    ${VENT}
    MQTT Compare Pressure Values

Automatic Test Vent Control Dip Switch 2
    [Tags]    automatic    mqtt    ventcontrol    onedip
    Publish MQTT Payload    ${pressure_50}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    DIP2
    MQTT Open Vent and Compare Pressure    ${VENT}
    Close KSOM Vent    ${VENT}
    MQTT Get Speed Values    ${VENT}
    MQTT Compare Pressure Values

Automatic Test Vent Control Both Dip Switches
    [Tags]    automatic    mqtt    ventcontrol    bothdip
    Publish MQTT Payload    ${pressure_50}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    BOTHDIP
    MQTT Open Vent and Compare Pressure    ${VENT}
    Close KSOM Vent    ${VENT}
    MQTT Get Speed Values    ${VENT}
    MQTT Compare Pressure Values    



