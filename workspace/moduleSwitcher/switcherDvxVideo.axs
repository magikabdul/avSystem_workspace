MODULE_NAME='switcherDvxVideo' (DEV dvDvx, DEV vdvSwitcherVideo,
																INTEGER noOfTxDx,	INTEGER noOfRxDx,
																INTEGER inputVga[], INTEGER inputHdmi[], INTEGER inputVideoconference[],
																INTEGER outputMonitor[], INTEGER outputProjector[], INTEGER outputContent[])
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/24/2016  AT: 13:28:37        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
#INCLUDE 'SNAPI'
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

INTEGER tlConfiguration = 1
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCTURE __INPUT
{
	CHAR none[3]
	CHAR vga1[3]
	CHAR vga2[3]
	CHAR vga3[3]
	CHAR vga4[3]
	CHAR hdmi1[3]
	CHAR hdmi2[3]
	CHAR hdmi3[3]
	CHAR hdmi4[3]
	CHAR polycom[3]
	CHAR content[3]
}

STRUCTURE __OUTPUT
{
	CHAR monitor1[3]
	CHAR monitor2[3]
	CHAR projector[3]
	CHAR content[3]
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

LONG ltimesConfiguration[] = {5000}

DEV dvTxDx[] 	= { 8001:1:0, 8002:1:0, 8003:1:0, 8004:1:0, 8005:1:0}
DEV vdvTxDx[] = {33301:1:0,33302:1:0,33303:1:0,33304:1:0,33305:1:0}

DEV dvRxDx[] 	= { 7001:1:0, 7002:1:0, 7003:1:0, 7004:1:0, 7005:1:0}
DEV vdvRxDx[] = {33201:1:0,33202:1:0,33203:1:0,33204:1:0,33205:1:0}

__INPUT dvxVideoInput
__OUTPUT dvxVideoOutput
(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

dvxVideoInput.none = '0'

TIMELINE_CREATE(tlConfiguration,ltimesConfiguration,LENGTH_ARRAY(ltimesConfiguration),TIMELINE_ABSOLUTE,TIMELINE_ONCE)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

TIMELINE_EVENT[tlConfiguration]
{
	LOCAL_VAR INTEGER idx

	IF(noOfTxDx>0)	//initial configuration of DxLink Transmitter
	{

	}
	IF(noOfRxDx>0)	//initial configuration of DxLink Receiver
	{
		FOR(idx=1;idx<=noOfRxDx;idx++)
		{
			WAIT_UNTIL(DEVICE_ID(dvRxDx[idx])<>0)
			{
				SEND_COMMAND vdvRxDx[idx],'VIDEO-SCALE,MANUAL'
				SEND_COMMAND vdvRxDx[idx],'VIDEO-ASPECT,STRETCH'
				SEND_COMMAND vdvRxDx[idx],'VIDEO-RESOLUTION,1920x1080p,60'
			}
		}
	}
	IF(LENGTH_ARRAY(inputVga)>0 && inputVga[1]<>0)	//initial configuration of vga inputs
	{
		IF(LENGTH_ARRAY(inputVga)>=1)		dvxVideoInput.vga1 = ITOA(inputVga[1])
		IF(LENGTH_ARRAY(inputVga)>=2)		dvxVideoInput.vga2 = ITOA(inputVga[2])
		IF(LENGTH_ARRAY(inputVga)>=3)		dvxVideoInput.vga3 = ITOA(inputVga[3])
		IF(LENGTH_ARRAY(inputVga)>=4)		dvxVideoInput.vga4 = ITOA(inputVga[4])
	}
	IF(LENGTH_ARRAY(inputHdmi)>0 && inputHdmi[1]<>0)	//initial configuration of vga inputs
	{
		IF(LENGTH_ARRAY(inputHdmi)>=1)	dvxVideoInput.hdmi1 = ITOA(inputHdmi[1])
		IF(LENGTH_ARRAY(inputHdmi)>=2)	dvxVideoInput.hdmi2 = ITOA(inputHdmi[2])
		IF(LENGTH_ARRAY(inputHdmi)>=3)	dvxVideoInput.hdmi3 = ITOA(inputHdmi[3])
		IF(LENGTH_ARRAY(inputHdmi)>=4)	dvxVideoInput.hdmi4 = ITOA(inputHdmi[4])
	}

	IF(LENGTH_ARRAY(inputVideoconference)>0 && inputVideoconference[1]<>0)	//initial configuration of videoconference inputs
	{
		dvxVideoInput.polycom = ITOA(inputVideoconference[1])
		dvxVideoInput.content = ITOA(inputVideoconference[2])
	}

	IF(LENGTH_ARRAY(outputMonitor)>0 && outputMonitor[1]<>0)	//initial configuration of display monitor
	{
		IF(LENGTH_ARRAY(outputMonitor)>=1)	dvxVideoOutput.monitor1 = ITOA(outputMonitor[1])
		IF(LENGTH_ARRAY(outputMonitor)>=2)	dvxVideoOutput.monitor2 = ITOA(outputMonitor[2])
	}

	IF(LENGTH_ARRAY(outputProjector)>0 && outputProjector[1]<>0)	//initial configuration of display projector
	{
		IF(LENGTH_ARRAY(outputProjector)>=1)	dvxVideoOutput.projector = ITOA(outputProjector[1])
	}

	IF(LENGTH_ARRAY(outputContent)>0 && outputContent[1]<>0)	//initial configuration of videoconference content
	{
		IF(LENGTH_ARRAY(outputContent)>=1)	dvxVideoOutput.content = ITOA(outputContent[1])
	}
}

DATA_EVENT[vdvSwitcherVideo]
{
	COMMAND:
	{
		IF(FIND_STRING(DATA.TEXT,'INPUT-',1))
		{
			REMOVE_STRING(DATA.TEXT,'INPUT-',1)

			IF(FIND_STRING(DATA.TEXT,'OFF,',1))
			{
				REMOVE_STRING(DATA.TEXT,'OFF,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.none,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.none,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.none,'O',dvxVideoOutput.monitor2"
						ACTIVE(DATA.TEXT=='CONTENT'):					SEND_COMMAND dvDVX,"'VI',dvxVideoInput.none,'O',dvxVideoOutput.content"
					}
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'VGA1,',1))
			{
				REMOVE_STRING(DATA.TEXT,'VGA1,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga1,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga1,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga1,'O',dvxVideoOutput.monitor2"
						ACTIVE(DATA.TEXT=='CONTENT'):					SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga1,'O',dvxVideoOutput.content"
					}
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'VGA2,',1))
			{
				REMOVE_STRING(DATA.TEXT,'VGA2,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga2,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga2,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga2,'O',dvxVideoOutput.monitor2"
						ACTIVE(DATA.TEXT=='CONTENT'):					SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga2,'O',dvxVideoOutput.content"
					}
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'VGA3,',1))
			{
				REMOVE_STRING(DATA.TEXT,'VGA3,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga3,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga3,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga3,'O',dvxVideoOutput.monitor2"
						ACTIVE(DATA.TEXT=='CONTENT'):					SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga3,'O',dvxVideoOutput.content"
					}
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'VGA4,',1))
			{
				REMOVE_STRING(DATA.TEXT,'VGA4,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga4,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga4,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga4,'O',dvxVideoOutput.monitor2"
						ACTIVE(DATA.TEXT=='CONTENT'):					SEND_COMMAND dvDVX,"'VI',dvxVideoInput.vga4,'O',dvxVideoOutput.content"
					}
				}
			}


			ELSE IF(FIND_STRING(DATA.TEXT,'HDMI1,',1))
			{
				REMOVE_STRING(DATA.TEXT,'HDMI1,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi1,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi1,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi1,'O',dvxVideoOutput.monitor2"
						ACTIVE(DATA.TEXT=='CONTENT'):					SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi1,'O',dvxVideoOutput.content"
					}
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'HDMI2,',1))
			{
				REMOVE_STRING(DATA.TEXT,'HDMI2,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi2,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi2,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi2,'O',dvxVideoOutput.monitor2"
						ACTIVE(DATA.TEXT=='CONTENT'):					SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi2,'O',dvxVideoOutput.content"
					}
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'HDMI3,',1))
			{
				REMOVE_STRING(DATA.TEXT,'HDMI3,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi3,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi3,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi3,'O',dvxVideoOutput.monitor2"
						ACTIVE(DATA.TEXT=='CONTENT'):					SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi3,'O',dvxVideoOutput.content"
					}
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'HDMI4,',1))
			{
				REMOVE_STRING(DATA.TEXT,'HDMI4,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi4,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi4,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi4,'O',dvxVideoOutput.monitor2"
						ACTIVE(DATA.TEXT=='CONTENT'):					SEND_COMMAND dvDVX,"'VI',dvxVideoInput.hdmi4,'O',dvxVideoOutput.content"
					}
				}
			}


			ELSE IF(FIND_STRING(DATA.TEXT,'POLYCOM,',1))
			{
				REMOVE_STRING(DATA.TEXT,'POLYCOM,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.polycom,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.polycom,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.polycom,'O',dvxVideoOutput.monitor2"
					}
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'CONTENT,',1))
			{
				REMOVE_STRING(DATA.TEXT,'CONTENT,',1)
				{
					SELECT
					{
						ACTIVE(DATA.TEXT=='PROJECTOR'):				SEND_COMMAND dvDVX,"'VI',dvxVideoInput.content,'O',dvxVideoOutput.projector"
						ACTIVE(DATA.TEXT=='MONITOR_LEFT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.content,'O',dvxVideoOutput.monitor1"
						ACTIVE(DATA.TEXT=='MONITOR_RIGHT'):		SEND_COMMAND dvDVX,"'VI',dvxVideoInput.content,'O',dvxVideoOutput.monitor2"
					}
				}
			}
		}
	}
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
