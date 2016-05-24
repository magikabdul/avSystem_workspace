MODULE_NAME='commRms' (DEV vdvRms, CHAR serverIp[], CHAR locationName[])
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/24/2016  AT: 11:55:45        *)
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

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCTURE __RMSCONFIG
{
	CHAR serverUrl[100]
	CHAR serverPassword[20]

	CHAR locationName[100]
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

__RMSCONFIG rms
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

rms.serverPassword = 'password'
rms.serverUrl = "'http://',serverIp,':8080/rms'"
rms.locationName = locationName
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvRms]
{
	ONLINE:
	{
		SEND_COMMAND vdvRms,"'CONFIG.SERVER.URL-',rms.serverUrl"
		SEND_COMMAND vdvRms,"'CONFIG.SERVER.PASSWORD-',rms.serverPassword"
		SEND_COMMAND vdvRms,"'CONFIG.CLIENT.NAME-',rms.locationName"

		SEND_COMMAND vdvRms,"'CONFIG.CLIENT.ENABLED-1'"
		SEND_COMMAND vdvRms,'CONFIG.DEVICE.AUTO.REGISTER-false'
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
