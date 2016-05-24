MODULE_NAME='switcherDvxAudio' (DEV dvDvx, DEV vdvSwitcherAudio,
																INTEGER inputVga[], INTEGER inputHdmi[], INTEGER inputVideoconference[],
																INTEGER outputRoom[], INTEGER outputVideoconference[])
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/24/2016  AT: 13:28:09        *)
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
	CHAR room[3]
	CHAR content[3]
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

LONG ltimesConfiguration[] = {5000}

__INPUT dvxAudioInput
__OUTPUT dvxAudioOutput
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

dvxAudioInput.none = '0'

TIMELINE_CREATE(tlConfiguration,ltimesConfiguration,LENGTH_ARRAY(ltimesConfiguration),TIMELINE_ABSOLUTE,TIMELINE_ONCE)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

TIMELINE_EVENT[tlConfiguration]
{
	IF(LENGTH_ARRAY(inputVga)>0 && inputVga[1]<>0)	//initial configuration of vga inputs
	{
		IF(LENGTH_ARRAY(inputVga)>=1) 	dvxAudioInput.vga1 = ITOA(inputVga[1])
		IF(LENGTH_ARRAY(inputVga)>=2) 	dvxAudioInput.vga2 = ITOA(inputVga[2])
		IF(LENGTH_ARRAY(inputVga)>=3) 	dvxAudioInput.vga3 = ITOA(inputVga[3])
		IF(LENGTH_ARRAY(inputVga)>=4) 	dvxAudioInput.vga4 = ITOA(inputVga[4])
	}
	IF(LENGTH_ARRAY(inputHdmi)>0 && inputHdmi[1]<>0)	//initial configuration of hdmi inputs
	{
		IF(LENGTH_ARRAY(inputHdmi)>=1) 	dvxAudioInput.hdmi1 = ITOA(inputHdmi[1])
		IF(LENGTH_ARRAY(inputHdmi)>=2) 	dvxAudioInput.hdmi2 = ITOA(inputHdmi[2])
		IF(LENGTH_ARRAY(inputHdmi)>=3) 	dvxAudioInput.hdmi3 = ITOA(inputHdmi[3])
		IF(LENGTH_ARRAY(inputHdmi)>=4) 	dvxAudioInput.hdmi4 = ITOA(inputHdmi[4])
	}
	IF(LENGTH_ARRAY(inputVideoconference)>0 && inputVideoconference[1]<>0)	//initial configuration of video conference
	{
		IF(LENGTH_ARRAY(inputVideoconference)>=1) 	dvxAudioInput.polycom = ITOA(inputVideoconference[1])
	}

	IF(LENGTH_ARRAY(outputRoom)>0 && outputRoom[1]<>0)	//initial configuration of output room
	{
		IF(LENGTH_ARRAY(outputRoom)>=1) 	dvxAudioOutput.room = ITOA(outputRoom[1])
	}
	IF(LENGTH_ARRAY(outputVideoconference)>0 && outputVideoconference[1]<>0)	//initial configuration of output room
	{
		IF(LENGTH_ARRAY(outputVideoconference)>=1) 	dvxAudioOutput.content = ITOA(outputVideoconference[1])
	}
}

DATA_EVENT[vdvSwitcherAudio]
{
	COMMAND:
	{
		IF(FIND_STRING(DATA.TEXT,'INPUT-',1))
		{
			REMOVE_STRING(DATA.TEXT,'INPUT-',1)

			IF(FIND_STRING(DATA.TEXT,'OFF,',1))
			{
				REMOVE_STRING(DATA.TEXT,'OFF,',1)
				SELECT
				{
					ACTIVE(DATA.TEXT=='ROOM'):		SEND_COMMAND dvDVX,"'AI',dvxAudioInput.none,'O',dvxAudioOutput.room"
					ACTIVE(DATA.TEXT=='CONTENT'):	SEND_COMMAND dvDVX,"'AI',dvxAudioInput.none,'O',dvxAudioOutput.content"
				}
			}

			ELSE IF(FIND_STRING(DATA.TEXT,'VGA1,',1))
			{
				REMOVE_STRING(DATA.TEXT,'VGA1,',1)
				SELECT
				{
					ACTIVE(DATA.TEXT=='ROOM'):		SEND_COMMAND dvDVX,"'AI',dvxAudioInput.vga1,'O',dvxAudioOutput.room"
					ACTIVE(DATA.TEXT=='CONTENT'):	SEND_COMMAND dvDVX,"'AI',dvxAudioInput.vga1,'O',dvxAudioOutput.content"
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'VGA2,',1))
			{
				REMOVE_STRING(DATA.TEXT,'VGA2,',1)
				SELECT
				{
					ACTIVE(DATA.TEXT=='ROOM'):		SEND_COMMAND dvDVX,"'AI',dvxAudioInput.vga2,'O',dvxAudioOutput.room"
					ACTIVE(DATA.TEXT=='CONTENT'):	SEND_COMMAND dvDVX,"'AI',dvxAudioInput.vga2,'O',dvxAudioOutput.content"
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'VGA3,',1))
			{
				REMOVE_STRING(DATA.TEXT,'VGA3,',1)
				SELECT
				{
					ACTIVE(DATA.TEXT=='ROOM'):		SEND_COMMAND dvDVX,"'AI',dvxAudioInput.vga3,'O',dvxAudioOutput.room"
					ACTIVE(DATA.TEXT=='CONTENT'):	SEND_COMMAND dvDVX,"'AI',dvxAudioInput.vga3,'O',dvxAudioOutput.content"
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'VGA4,',1))
			{
				REMOVE_STRING(DATA.TEXT,'VGA4,',1)
				SELECT
				{
					ACTIVE(DATA.TEXT=='ROOM'):		SEND_COMMAND dvDVX,"'AI',dvxAudioInput.vga4,'O',dvxAudioOutput.room"
					ACTIVE(DATA.TEXT=='CONTENT'):	SEND_COMMAND dvDVX,"'AI',dvxAudioInput.vga4,'O',dvxAudioOutput.content"
				}
			}


			ELSE IF(FIND_STRING(DATA.TEXT,'HDMI1,',1))
			{
				REMOVE_STRING(DATA.TEXT,'HDMI1,',1)
				SELECT
				{
					ACTIVE(DATA.TEXT=='ROOM'):		SEND_COMMAND dvDVX,"'AI',dvxAudioInput.hdmi1,'O',dvxAudioOutput.room"
					ACTIVE(DATA.TEXT=='CONTENT'):	SEND_COMMAND dvDVX,"'AI',dvxAudioInput.hdmi1,'O',dvxAudioOutput.content"
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'HDMI2,',1))
			{
				REMOVE_STRING(DATA.TEXT,'HDMI2,',1)
				SELECT
				{
					ACTIVE(DATA.TEXT=='ROOM'):		SEND_COMMAND dvDVX,"'AI',dvxAudioInput.hdmi2,'O',dvxAudioOutput.room"
					ACTIVE(DATA.TEXT=='CONTENT'):	SEND_COMMAND dvDVX,"'AI',dvxAudioInput.hdmi2,'O',dvxAudioOutput.content"
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'HDMI3,',1))
			{
				REMOVE_STRING(DATA.TEXT,'HDMI3,',1)
				SELECT
				{
					ACTIVE(DATA.TEXT=='ROOM'):		SEND_COMMAND dvDVX,"'AI',dvxAudioInput.hdmi3,'O',dvxAudioOutput.room"
					ACTIVE(DATA.TEXT=='CONTENT'):	SEND_COMMAND dvDVX,"'AI',dvxAudioInput.hdmi3,'O',dvxAudioOutput.content"
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT,'HDMI4,',1))
			{
				REMOVE_STRING(DATA.TEXT,'HDMI4,',1)
				SELECT
				{
					ACTIVE(DATA.TEXT=='ROOM'):		SEND_COMMAND dvDVX,"'AI',dvxAudioInput.hdmi4,'O',dvxAudioOutput.room"
					ACTIVE(DATA.TEXT=='CONTENT'):	SEND_COMMAND dvDVX,"'AI',dvxAudioInput.hdmi4,'O',dvxAudioOutput.content"
				}
			}


			ELSE IF(FIND_STRING(DATA.TEXT,'POLYCOM,',1))
			{
				REMOVE_STRING(DATA.TEXT,'POLYCOM,',1)
				SELECT
				{
					ACTIVE(DATA.TEXT=='ROOM'):		SEND_COMMAND dvDVX,"'AI',dvxAudioInput.polycom,'O',dvxAudioOutput.room"
					ACTIVE(DATA.TEXT=='CONTENT'):	SEND_COMMAND dvDVX,"'AI',dvxAudioInput.polycom,'O',dvxAudioOutput.content"
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
