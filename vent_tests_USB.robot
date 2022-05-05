*** Settings ***

Resource    keywords_serial.robot

*** Test Cases ***

Manual Test Speed 50 Serial
    [Tags]    manual    serial
    Send Serial Command    ${speed_50}    ${RPI_LPC_PORT}
    Sleep    10s
    Serial Compare Speed Values    ${RPI_LPC_PORT} 

Manual Test Vent Control Serial
    [Tags]    manual    serial    ventcontrol
    Send Serial Command    ${speed_30}    ${RPI_LPC_PORT}
    Sleep    10s
    Serial Open Vent and Compare Speed    ${RPI_LPC_PORT}
    Serial Open Vent and Compare Speed    ${RPI_LPC_PORT}
    Close KSOM Vent
    Serial Compare Speed Values    ${RPI_LPC_PORT}
    Serial Get Pressure Values    ${RPI_LPC_PORT}

Manual Test Low Speed Serial
    [Tags]    manual    serial    lowspeed
    Send Serial Command    ${speed_5}    ${RPI_LPC_PORT}
    Sleep    20s
    Serial Get Speed Values    ${RPI_LPC_PORT}
    ${FAN_STATUS}=    Query Fan Status    ${NO_DEC}    ${FUNC_4}
    Should be Equal as Strings    ${FAN_STATUS}    OFF
    Sleep    45s
    ${PAYLOAD}=    Read Serial Message    ${RPI_LPC_PORT}
    ${error_flag}=     Get Serial Error    ${PAYLOAD}
    Should be Equal as Strings    ${error_flag}    True

    Send Serial Command    ${speed_10}    ${RPI_LPC_PORT}
    Sleep    10s
    Serial Get Speed Values    ${RPI_LPC_PORT}
    ${FAN_STATUS}=    Query Fan Status    ${NO_DEC}    ${FUNC_4}
    Should be Equal as Strings    ${FAN_STATUS}    ON
    Sleep    10s
    ${PAYLOAD}=    Read Serial Message    ${RPI_LPC_PORT}
    ${error_flag}=     Get Serial Error    ${PAYLOAD}
    Should be Equal as Strings    ${error_flag}    False


Automatic Test Pressure 70 Serial
    [Tags]    automatic    serial
    Send Serial Command    ${pressure_70}    ${RPI_LPC_PORT}
    Sleep    20s
    Serial Compare Pressure Values    ${RPI_LPC_PORT}

Automatic Test Vent Control Serial
    [Tags]    automatic    serial    ventcontrol
    Send Serial Command    ${pressure_50}    ${RPI_LPC_PORT}
    Sleep    20s
    Serial Open Vent and Compare Pressure    ${RPI_LPC_PORT}
    Serial Open Vent and Compare Pressure    ${RPI_LPC_PORT}
    Close KSOM Vent
    Serial Get Speed Values    ${RPI_LPC_PORT}
    Serial Compare Pressure Values    ${RPI_LPC_PORT}