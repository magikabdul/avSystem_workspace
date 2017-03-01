PROGRAM_NAME='dvxConfiguration'
(***********************************************************)
(*  FILE CREATED ON: 10/21/2016  AT: 13:08:38              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 10/21/2016  AT: 16:15:48        *)
(***********************************************************)

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
DEFINE_FUNCTION CHAR[20] checkDvxModel()
{
	STACK_VAR CHAR recognizedModel[20]
	
	SWITCH(DEVICE_ID(dvDvx))
	{
		CASE $162:	recognizedModel = 'DVX-3150HD_SP'
		CASE $183:	recognizedModel = 'DVX-3150HD_T'
		CASE $184:	recognizedModel = 'DVX-3155HD_SP'
		CASE $185:	recognizedModel = 'DVX-3155HD_T'
		CASE $186:	recognizedModel = 'DVX-2150HD_SP'
		CASE $187:	recognizedModel = 'DVX-2150HD_T'
		CASE $188:	recognizedModel = 'DVX-2155HD_SP'
		CASE $189:	recognizedModel = 'DVX-2155HD_T'
		CASE $1A3:	recognizedModel = 'DVX-3156HD_SP'
		CASE $1A4:	recognizedModel = 'DVX-3156HD_T'
		CASE $1AB:	recognizedModel = 'DVX-2110HD_SP'
		CASE $1AC:	recognizedModel = 'DVX-2110HD_T'
		CASE $1CA:	recognizedModel = 'DVX-2210HD_SP'
		CASE $1CB:	recognizedModel = 'DVX-2210HD_T'
		CASE $1B6:	recognizedModel = 'DVX-3250HD_SP'
		CASE $1C1:	recognizedModel = 'DVX-3250HD_T'
		CASE $1C2:	recognizedModel = 'DVX-3255HD_SP'
		CASE $1C3:	recognizedModel = 'DVX-3255HD_T'
		CASE $1C4:	recognizedModel = 'DVX-2250HD_SP'
		CASE $1C5:	recognizedModel = 'DVX-2250HD_T'
		CASE $1C6:	recognizedModel = 'DVX-2255HD_SP'
		CASE $1C7:	recognizedModel = 'DVX-2255HD_T'
		CASE $1C8:	recognizedModel = 'DVX-3256HD_SP'
		CASE $1C9:	recognizedModel = 'DVX-3256HD_T'
		
		DEFAULT:		recognizedModel = "'Unrecognized, ',ITOHEX(DEVICE_ID(dvDvx))"
	}
	
	RETURN recognizedModel
}


DEFINE_FUNCTION setDvxConfiguration()
{
	LOCAL_VAR IP_ADDRESS_STRUCT masterIP
	LOCAL_VAR DEV_INFO_STRUCT masterInfo
	
	LOCAL_VAR INTEGER idx
	
	WAIT_UNTIL (DEVICE_ID(dvDvx)<>false)
	{
		av.dvx.info.model = checkDvxModel()
		
		GET_IP_ADDRESS(dvMaster,masterIP)
		av.dvx.info.ip = masterIP.IPADDRESS
		
		DEVICE_INFO(dvMaster,masterInfo)
		av.dvx.info.serial = masterInfo.SERIAL_NUMBER

		FOR(idx=1;idx<=10;idx++)
		{
			IF(av.dvx.config.input[idx].name<>'')
				SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,"'VIDIN_NAME-',av.dvx.config.input[idx].name"
			ELSE
				SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,'VIDIN_NAME-None'
				
			SWITCH(UPPER_STRING(av.dvx.config.input[idx].type))
			{
				CASE 'HDMI':
				CASE 'DVI':
				CASE 'S-VIDEO':
				CASE 'COMPONENT':
				CASE 'COMPOSITE':
				CASE 'VGA':
					SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,"'VIDIN_FORMAT-',UPPER_STRING(av.dvx.config.input[idx].type)"
			}
			
			IF(av.dvx.config.input[idx].edid<>'')
				SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,"'VIDIN_PREF_EDID-',av.dvx.config.input[idx].edid"
			
			IF(UPPER_STRING(av.dvx.config.input[idx].hdcp)=='ENABLE' || UPPER_STRING(av.dvx.config.input[idx].hdcp)=='DISABLE')
				SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,"'VIDIN_PREF_EDID-',UPPER_STRING(av.dvx.config.input[idx].hdcp)"
			
			
			IF(UPPER_STRING(av.dvx.config.input[idx].hdcp)=='ENABLE' || UPPER_STRING(av.dvx.config.input[idx].hdcp)=='DISABLE')
				SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,"'VIDIN_HDCP-',UPPER_STRING(av.dvx.config.input[idx].hdcp)"
				
			SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,'DXLINK_IN_ETH-AUTO'
		}
		
		FOR(idx=1;idx<=4;idx++)
		{
			SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,'VIDOUT_MUTE-DISABLE'
			SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,'VIDOUT_FREEZE-DISABLE'
			SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,'VIDOUT_TESTPAT-OFF'
			SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,'VIDOUT_BLANK-LOGO 1'
			
			
			SWITCH(UPPER_STRING(av.dvx.config.output[idx].scaling))
			{
				CASE 'AUTO':
				CASE 'MANUAL':
				CASE 'BYPASS':
					SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,"'VIDOUT_SCALE-',UPPER_STRING(av.dvx.config.output[idx].scaling)"
			}
			
			IF(UPPER_STRING(av.dvx.config.output[idx].scaling)=='MANUAL')
				SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,"'VIDOUT_RES_REF-',UPPER_STRING(av.dvx.config.output[idx].resolution)"
			
			
			SWITCH(UPPER_STRING(av.dvx.config.output[idx].ratio))
			{
				CASE 'MAINTAIN':
				CASE 'STRETCH':
				CASE 'ZOOM':
				CASE 'ANAMORPHIC':
					SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,"'VIDOUT_ASPECT_RATIO-',UPPER_STRING(av.dvx.config.output[idx].ratio)"
			}
			
			SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,'AUDOUT_MUTE-DISABLE'
			SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,'AUDOUT_TESTTONE-OFF'
			
			SEND_COMMAND dvDvx.NUMBER:idx:dvDvx.SYSTEM,'DXLINK_ETH-AUTO'
		}
		
		IF(UPPER_STRING(av.dvx.info.lockout)=='ENABLE' || UPPER_STRING(av.dvx.info.lockout)=='DISABLE')
		{
			SEND_COMMAND dvDvx,'FP_LOCKTYPE-3'
			SEND_COMMAND dvDvx,"'FP_LOCKOUT',UPPER_STRING(av.dvx.info.lockout)"
		}
	}
}