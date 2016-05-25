PROGRAM_NAME='mainline_comp_city_room'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/25/2016  AT: 13:38:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
#INCLUDE 'SNAPI'
#INCLUDE 'CHAPI'
#INCLUDE 'deviceDefinitions'
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

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

//rms information for location registration
CHAR rmsConfigIpAddress[] 		= '192.168.5.177'
CHAR rmsConfigLocationName[] 	= 'Lab-Kris'

//videoSwitcher data (even if particular input/output deosn't exists output number have to a value '0')
INTEGER swVideo_noOfTxDx = 0
INTEGER swVideo_noOfRxDx = 1
INTEGER swVideo_inputVga[] = {1,2}
INTEGER swVideo_inputHdmi[] = {4,5}
INTEGER swVideo_inputVideoConference[] = {3,6}
INTEGER swVideo_outputMonitor[] = {1,2}
INTEGER swVideo_outputProjector[] = {4}
INTEGER swVideo_outputContent[] = {3}
//audioSwitcher data (even if particular input/output deosn't exists output number have to a value '0')
INTEGER swAudio_inputVga[] = {1,2}
INTEGER swAudio_inputHdmi[] = {4,5}
INTEGER swAudio_inputVideoConference[] = {2}
INTEGER swAudio_outputRoom[] = {1}
INTEGER swAudio_outputVideoConference[] = {3}

__DEVDEFINITIONS rmsPanel	//used for rmsMonitoring
__DEVDEFINITIONS rmsDxTx

(***********************************************************)
(*                INCLUDE DEFINITIONS GO BELOW             *)
(***********************************************************)

(***********************************************************)
(*                MODULE CODE GOES BELOW                   *)
(***********************************************************)
//----------------------------------------------------------------------------------------------------
// 																																								   rmsAdapterModule
//----------------------------------------------------------------------------------------------------
DEFINE_MODULE 'RmsNetLinxAdapter_dr4_0_0' mdlRms01(vdvRMS)
//----------------------------------------------------------------------------------------------------
//  																																								 		rmsCommModule
//----------------------------------------------------------------------------------------------------
DEFINE_MODULE 'commRms' rmsComm01(vdvRms,rmsConfigIpAddress,rmsConfigLocationName)
//----------------------------------------------------------------------------------------------------
//  																																						    duetDeviceModules
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'Polycom_HDX7000_Comm_dr2_0_0' mdl04(vdvPolycom,dvPolycom)
//----------------------------------------------------------------------------------------------------
//  																																				 		 netlinxDeviceModules
//----------------------------------------------------------------------------------------------------
//#IF_DEFINED IS_MONITOR_DUET
//
//#ELSE
//	#IF_DEFINED HAS_MONITOR_NEC
//		DEFINE_MODULE 'Nec_Monitor_Comm_nl3_0_0' mdlMonitor01(vdvMonitorLeft,dvMonitorLeft)
//		DEFINE_MODULE 'Nec_Monitor_Comm_nl3_0_0' mdlMonitor02(vdvMonitorRight,dvMonitorRight)
//	#END_IF
//#END_IF
//
//#IF_DEFINED IS_PROJECTOR_DUET
//
//#ELSE
//	#IF_DEFINED HAS_PROJECTOR_NEC
//		DEFINE_MODULE 'Nec_Projector_Comm_nl1_0_0' mdlProjector01(vdvProjector,dvProjector)
//	#END_IF
//	#IF_DEFINED HAS_PROJECTOR_MITSUBISHI
//
//	#END_IF
//#END_IF
//----------------------------------------------------------------------------------------------------
//																																											switerModules
//----------------------------------------------------------------------------------------------------
DEFINE_MODULE 'AMX_DxTx_Comm_nl2_0_0' dxRx01(vdvTransmitter,dvTransmitter)
//DEFINE_MODULE 'AMX_DxRx_Comm_nl2_0_0' dxRx02(vdvReceiver2,dvReceiver2)

DEFINE_MODULE 'switcherDvxVideo' OrlenVideoSw01(dvDvx,vdvVideoSwitcher,
																								swVideo_noOfTxDx, swVideo_noOfRxDx,
																								swVideo_inputVga, swVideo_inputHdmi, swVideo_inputVideoConference,
																								swVideo_outputMonitor, swVideo_outputProjector, swVideo_outputContent)

DEFINE_MODULE 'switcherDvxAudio' OrlenAudioSw01(dvDvx,vdvVideoSwitcher,
																								swAudio_inputVga,swAudio_inputHdmi,swAudio_inputVideoConference,
																								swAudio_outputRoom,swAudio_outputVideoConference)
//----------------------------------------------------------------------------------------------------
// 																																												commModules
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'commOrlenPlockBiuroTechniki115Light' commLight01(vdvLight,dvRelays)

//#IF_DEFINED HAS_SCREEN_HIGH_VOLTAGE
//	DEFINE_MODULE 'commOrlenPlockBaseScreen' commScreen01(vdvScreen,dvRelayHighVoltage)
//#ELSE
//	DEFINE_MODULE 'commOrlenPlockBaseScreen' commScreen01(vdvScreen,dvRelayNative)
//#END_IF
//----------------------------------------------------------------------------------------------------
//	 																																												uiModules
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'uiOrlenRoomPanelCustomization' uiOrlenPanelCustomization01

//DEFINE_MODULE 'uiOrlenPlockBiuroTechniki115PanelMenu' uiOrlenPanelMenu01
//DEFINE_MODULE 'uiOrlenPlockBiuroTechniki115PanelPresentation' uiOrlenPanelPresentation01
//DEFINE_MODULE 'uiOrlenPlockBiuroTechniki115PanelPolycom' uiOrlenPanelPolycom01
//DEFINE_MODULE 'uiOrlenRoomPanelAudio' uiOrlenPanelAudio01
//DEFINE_MODULE 'uiOrlenPlockBiuroTechniki115PanelLight' uiOrlenPanelLight01


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

//rmsKeypad.name = ''

rmsPanel.name = 'iPad'
rmsPanel.type = 'TPC'

rmsDxTx.name = 'MyTransmitter'

//
//	#IF_DEFINED HAS_PROJECTOR
//		//rmsProjector[1].name = 'Projector'
//	#END_IF
//
//	#IF_DEFINED HAS_MONITOR
//		//rmsMonitor[1].name = 'Monitor Left'
//	//	rmsMonitor[2].name = 'Monitor Right'
//	#END_IF
//
//	#IF_DEFINED HAS_VIDEOCONFERENCE
//		//rmsVideoconference[1].name = 'Polycom'
//	#END_IF
//
//	#IF_DEFINED HAS_DX_TX
//
//	#END_IF
//
//	#IF_DEFINED HAS_DX_RX
//
//	#END_IF
//
//
//
//	#IF_DEFINED HAS_SOURCE_USAGE
//		rmsSourceUsage[1].name = 'Source - VGA1'
//		rmsSourceUsage[1].description = 'Auxillary VGA1 Input on Table'
//		rmsSourceUsage[2].name = 'Source - VGA2'
//		rmsSourceUsage[2].description = 'Auxillary VGA2 Input on Table'
//		rmsSourceUsage[3].name = 'Source - VGA3'
//		rmsSourceUsage[3].description = 'Auxillary VGA3 Input on Table'
//		rmsSourceUsage[4].name = 'Source - VGA4'
//		rmsSourceUsage[4].description = 'Auxillary VGA4 Input on Table'
//		rmsSourceUsage[5].name = 'Source - HDMI1'
//		rmsSourceUsage[5].description = 'Auxillary HDMI1 Input on Table'
//		rmsSourceUsage[6].name = 'Source - HDMI2'
//		rmsSourceUsage[6].description = 'Auxillary HDMI2 Input on Table'
//		rmsSourceUsage[7].name = 'Source - HDMI3'
//		rmsSourceUsage[7].description = 'Auxillary HDMI3 Input on Table'
//		rmsSourceUsage[8].name = 'Source - HDMI4'
//		rmsSourceUsage[8].description = 'Auxillary HDMI4 Input on Table'
//	#END_IF
//----------------------------------------------------------------------------------------------------
//  																																				 rmsNetlinxDeviceMonitors
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//																																								 rmsPanelMonitoring
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'RmsGenericNetLinxDeviceNameMonitor' rmsKeypad01(vdvRms,dvKeyPad1,rmsKeypad[1].name)

DEFINE_MODULE 'RmsTouchPanelMonitor' rmsPanel01(vdvRMS,dvPanelCustomization,rmsPanel.name,rmsPanel.type)
//----------------------------------------------------------------------------------------------------
//																																								 	 systemMonitoring
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'RmsSystemPowerMonitor' rmsSystemPower01(vdvRMS,dvMaster)
DEFINE_MODULE 'RmsDvxSwitcherMonitor' rmsDvxSwticher01(vdvRMS)
//----------------------------------------------------------------------------------------------------
//																																					  nativeDevicesMonitoring
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'RmsGenericNetLinxDeviceMonitor' rmsGeneric01(vdvRMS,dvMasterVeracomp)
//----------------------------------------------------------------------------------------------------
//																																								avDevicesMonitoring
//----------------------------------------------------------------------------------------------------
DEFINE_MODULE 'RmsDistanceTransportTxMonitor' rmsDxTx01(vdvRms,vdvTransmitter,dvTransmitter,rmsDxTx.name)

//DEFINE_MODULE 'RmsDistanceTransportRxMonitor' rmsDxRx01(vdvRms,vdvReceiverProjector,dvReceiverProjector,rmsDxRx[1].name)
//----------------------------------------------------------------------------------------------------
//																																								 monitorsMonitoring
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'RmsNlMonitorMonitor'  rmsMonitor01(vdvRMS,vdvMonitor_A1,dvMonitor_A,rmsMonitor[1].name)
//----------------------------------------------------------------------------------------------------
//																																							 projectorsMonitoring
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'RmsNlVideoProjectorMonitor' rmsVideoProjectorMon03(vdvRMS,vdvProjector_D,dvProjector_D,rmsProjector[3].name)
//DEFINE_MODULE 'RmsDuetVideoProjectorMonitor' rmsVideoProjectorMon01(vdvRMS,vdvProjector_B,dvProjector_B,rmsProjector[1].name)

//DEFINE_MODULE 'RmsScreenMonitor' rmsScreen01(vdvRMS,vdvScreen)
//DEFINE_MODULE 'RmsLfitMonitor' rmsScreen01(vdvRMS,vdvLift)
//----------------------------------------------------------------------------------------------------
//																																				  videoconferenceMonitoring
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'RmsDuetVideoConferencerMonitor' rMSVideoConferenceMonitorMod01(vdvRMS,vdvPolycom_A,dvPolycom_A,rmsVideoconference[1].name)
//----------------------------------------------------------------------------------------------------
//																																							     othersMonitoring
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'RmsNlLightMonitor' rmsLight01(vdvRMS,vdvLight,dvRelays)
//----------------------------------------------------------------------------------------------------
//																																										 rmsSourceUsage
//----------------------------------------------------------------------------------------------------
//DEFINE_MODULE 'RmsVirtualDeviceMonitor' rmsVirtualInput01(vdvRMS,vdvVga1,rmsSourceUsage[1].name,rmsSourceUsage[1].description)
//DEFINE_MODULE 'RmsVirtualDeviceMonitor' rmsVirtualInput02(vdvRMS,vdvVga2,rmsSourceUsage[2].name,rmsSourceUsage[2].description)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

