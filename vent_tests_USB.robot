*** Settings ***

Resource    keywords_serial.robot

*** Test Cases ***
    
Manual Test Speed 50 
    [Tags]    manual    serial    speed
    Send Serial Command    ${speed_50}    ${RPI_LPC_PORT}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Serial Compare Speed Values    ${VENT}    ${RPI_LPC_PORT} 

Manual Test Vent Control No Dip Switches
    [Tags]    manual    serial    ventcontrol    nodips
    Send Serial Command    ${speed_30}    ${RPI_LPC_PORT}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    NODIP
    Serial Open Vent and Compare Speed    ${VENT}    ${RPI_LPC_PORT}
    Close KSOM Vent    ${VENT}
    Serial Compare Speed Values    ${VENT}    ${RPI_LPC_PORT}
    Serial Get Pressure Values    ${RPI_LPC_PORT}

Manual Test Vent Control Dip Switch 1
    [Tags]    manual    serial    ventcontrol    dipone
    Send Serial Command    ${speed_30}    ${RPI_LPC_PORT}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    DIP1
    Serial Open Vent and Compare Speed    ${VENT}    ${RPI_LPC_PORT}
    Close KSOM Vent    ${VENT}
    Serial Compare Speed Values    ${VENT}    ${RPI_LPC_PORT}
    Serial Get Pressure Values    ${RPI_LPC_PORT}

Manual Test Vent Control Dip Switch 2
    [Tags]    manual    serial    ventcontrol    diptwo
    Send Serial Command    ${speed_30}    ${RPI_LPC_PORT}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    DIP2
    Serial Open Vent and Compare Speed    ${VENT}    ${RPI_LPC_PORT}
    Close KSOM Vent    ${VENT}
    Serial Compare Speed Values    ${VENT}    ${RPI_LPC_PORT}
    Serial Get Pressure Values    ${RPI_LPC_PORT}

Manual Test Vent Control Both Dip Switches
    [Tags]    manual    serial    ventcontrol    bothdip
    Send Serial Command    ${speed_30}    ${RPI_LPC_PORT}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    BOTHDIP
    Serial Open Vent and Compare Speed    ${VENT}    ${RPI_LPC_PORT}
    Close KSOM Vent    ${VENT}
    Serial Compare Speed Values    ${VENT}    ${RPI_LPC_PORT}
    Serial Get Pressure Values    ${RPI_LPC_PORT}

Manual Test Low Speed
    [Tags]    manual    serial    lowspeed    errorcheck
    Send Serial Command    ${speed_5}    ${RPI_LPC_PORT}
    Sleep    20s
    ${VENT}=    Run Keyword    Setup
    Serial Get Speed Values    ${VENT}    ${RPI_LPC_PORT}
    ${FAN_STATUS}=    Query Fan Status    ${VENT}    ${NO_DEC}    ${FUNC_4}
    Should be Equal as Strings    ${FAN_STATUS}    OFF
    Sleep    45s
    ${PAYLOAD}=    Read Serial Message    ${RPI_LPC_PORT}
    ${error_flag}=     Get Serial Error    ${PAYLOAD}
    Should be Equal as Strings    ${error_flag}    True

    Send Serial Command    ${speed_10}    ${RPI_LPC_PORT}
    Sleep    10s
    Serial Get Speed Values    ${VENT}    ${RPI_LPC_PORT}
    ${FAN_STATUS}=    Query Fan Status    ${VENT}    ${NO_DEC}    ${FUNC_4}
    Should be Equal as Strings    ${FAN_STATUS}    ON
    Sleep    10s
    ${PAYLOAD}=    Read Serial Message    ${RPI_LPC_PORT}
    ${error_flag}=     Get Serial Error    ${PAYLOAD}
    Should be Equal as Strings    ${error_flag}    False

Read Message From USB
    [Tags]    serial    read
    ${serial_msg}=    Run Keyword    Read Serial Message    ${RPI_LPC_PORT}
    Log    ${serial_msg}
    Should Not Be Empty    ${serial_msg}
    [Teardown]    Log to Console    ${TEST_STATUS}

Automatic Test Pressure 70
    [Tags]    automatic    serial    pressure
    Send Serial Command    ${pressure_70}    ${RPI_LPC_PORT}
    Sleep    20s
    Serial Compare Pressure Values    ${RPI_LPC_PORT}

Automatic Test Vent Control No Dip Switches
    [Tags]    automatic    serial    ventcontrol    nodips
    Send Serial Command    ${pressure_50}    ${RPI_LPC_PORT}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    NODIP
    Serial Open Vent and Compare Pressure    ${VENT}    ${RPI_LPC_PORT}
    Close KSOM Vent    ${VENT}
    Serial Get Speed Values    ${VENT}    ${RPI_LPC_PORT}
    Serial Compare Pressure Values    ${RPI_LPC_PORT} 

Automatic Test Vent Control Dip Switch 1
    [Tags]    automatic    serial    ventcontrol    onedip
    Send Serial Command    ${pressure_50}    ${RPI_LPC_PORT}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    DIP1
    Serial Open Vent and Compare Pressure    ${VENT}    ${RPI_LPC_PORT}
    Close KSOM Vent    ${VENT}
    Serial Get Speed Values    ${VENT}    ${RPI_LPC_PORT}
    Serial Compare Pressure Values    ${RPI_LPC_PORT}

Automatic Test Vent Control Dip Switch 2
    [Tags]    automatic    serial    ventcontrol    onedip
    Send Serial Command    ${pressure_50}    ${RPI_LPC_PORT}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    DIP2
    Serial Open Vent and Compare Pressure    ${VENT}    ${RPI_LPC_PORT}
    Close KSOM Vent    ${VENT}
    Serial Get Speed Values    ${VENT}    ${RPI_LPC_PORT}
    Serial Compare Pressure Values    ${RPI_LPC_PORT}

Automatic Test Vent Control Both Dip Switches
    [Tags]    automatic    serial    ventcontrol    bothdip
    Send Serial Command    ${pressure_50}    ${RPI_LPC_PORT}
    Sleep    10s
    ${VENT}=    Run Keyword    Setup
    Set KSOM Dip Switches    ${VENT}    BOTHDIP
    Serial Open Vent and Compare Pressure    ${VENT}    ${RPI_LPC_PORT}
    Close KSOM Vent    ${VENT}
    Serial Get Speed Values    ${VENT}    ${RPI_LPC_PORT}
    Serial Compare Pressure Values    ${RPI_LPC_PORT}