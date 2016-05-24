PROGRAM_NAME='mainline_comp_city_room'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/24/2016  AT: 13:34:58        *)
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

//__DEVDEFINITIONS rmsPanel	//used for rmsMonitoring
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
//DEFINE_MODULE 'AMX_DxRx_Comm_nl2_0_0' dxRx01(vdvReceiver1,dvReceiver1)
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

//----------------------------------------------------------------------------------------------------
//  																																				 rmsNetlinxDeviceMonitors
//----------------------------------------------------------------------------------------------------
//#IF_DEFINED HAS_RMS
//
//	#IF_DEFINED HAS_KEYPAD
//
//	#END_IF
//
//	#IF_DEFINED HAS_PANEL
//		rmsPanel.name = 'iPad mini'
//		rmsPanel.type = 'TPC'
//	#END_IF
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
////----------------------------------------------------------------------------------------------------
////																																								 	 systemMonitoring
////----------------------------------------------------------------------------------------------------
//	//DEFINE_MODULE 'RmsSystemPowerMonitor' rmsSystemPower01(vdvRMS,dvMaster)
//	//DEFINE_MODULE 'RmsDvxSwitcherMonitor' rmsDvxSwticher01(vdvRMS)
////----------------------------------------------------------------------------------------------------
////																																					  nativeDevicesMonitoring
////----------------------------------------------------------------------------------------------------
//	//DEFINE_MODULE 'RmsGenericNetLinxDeviceMonitor' rmsGeneric01(vdvRMS,dvMasterVeracomp)
////----------------------------------------------------------------------------------------------------
////																																								 rmsPanelMonitoring
////----------------------------------------------------------------------------------------------------
//	#IF_DEFINED HAS_KEYPAD
//		DEFINE_MODULE 'RmsGenericNetLinxDeviceNameMonitor' rmsKeypad01(vdvRms,dvKeyPad1,rmsKeypad[1].name)
//	#END_IF
//
//
//	#IF_DEFINED HAS_PANEL
//		DEFINE_MODULE 'RmsTouchPanelMonitor' rmsPanel01(vdvRMS,dvPanelCustomization,rmsPanel.name,rmsPanel.type)
//	#END_IF
////----------------------------------------------------------------------------------------------------
////																																								avDevicesMonitoring
////----------------------------------------------------------------------------------------------------
//	#IF_DEFINED HAS_DX_TX
//		DEFINE_MODULE 'RmsDistanceTransportTxMonitor' rmsDxTx01(vdvRms,vdvTransmitterTable1,dvTransmitterTable1,rmsDxTx[1].name)
//		DEFINE_MODULE 'RmsDistanceTransportTxMonitor' rmsDxTx02(vdvRms,vdvTransmitterTable2,dvTransmitterTable2,rmsDxTx[2].name)
//		DEFINE_MODULE 'RmsDistanceTransportTxMonitor' rmsDxTx03(vdvRms,vdvTransmitterTable3,dvTransmitterTable3,rmsDxTx[3].name)
//		DEFINE_MODULE 'RmsDistanceTransportTxMonitor' rmsDxTx04(vdvRms,vdvTransmitterLifeSize,dvTransmitterLifeSize,rmsDxTx[4].name)
//
//		DEFINE_MODULE 'RmsDistanceTransportTxMonitor' rmsDxTx05(vdvRms,vdvTransmitterService,dvTransmitterService,rmsDxTx[5].name)
//	#END_IF
//
//	#IF_DEFINED HAS_DX_RX
//		DEFINE_MODULE 'RmsDistanceTransportRxMonitor' rmsDxRx01(vdvRms,vdvReceiverProjector,dvReceiverProjector,rmsDxRx[1].name)
//	#END_IF
////----------------------------------------------------------------------------------------------------
////																																								 monitorsMonitoring
////----------------------------------------------------------------------------------------------------
//	#IF_DEFINED HAS_MONITOR
//		//DEFINE_MODULE 'RmsNlMonitorMonitor'  rmsMonitor01(vdvRMS,vdvMonitor_A1,dvMonitor_A,rmsMonitor[1].name)
//	#END_IF
////----------------------------------------------------------------------------------------------------
////																																							 projectorsMonitoring
////----------------------------------------------------------------------------------------------------
//	#IF_DEFINED HAS_PROJECTOR
//		//DEFINE_MODULE 'RmsNlVideoProjectorMonitor' rmsVideoProjectorMon03(vdvRMS,vdvProjector_D,dvProjector_D,rmsProjector[3].name)
//
//		//#IF_DEFINED IS_PROJECTOR_DUET
//			//DEFINE_MODULE 'RmsDuetVideoProjectorMonitor' rmsVideoProjectorMon01(vdvRMS,vdvProjector_B,dvProjector_B,rmsProjector[1].name)
//			//DEFINE_MODULE 'RmsDuetVideoProjectorMonitor' rmsVideoProjectorMon02(vdvRMS,vdvProjector_C,dvProjector_C,rmsProjector[2].name)
//		//#END_IF
//
//	#END_IF
////
////	#IF_DEFINED HAS_SCREEN
////			//DEFINE_MODULE 'RmsScreenMonitor' rmsScreen01(vdvRMS,vdvScreen)
////		#END_IF
////
////
////		#IF_DEFINED HAS_LIFT
////			//DEFINE_MODULE 'RmsLfitMonitor' rmsScreen01(vdvRMS,vdvLift)
////		#END_IF
////----------------------------------------------------------------------------------------------------
////																																							 projectorsMonitoring
////----------------------------------------------------------------------------------------------------
//	#IF_DEFINED HAS_VIDEOCONFERENCE
//		//DEFINE_MODULE 'RmsDuetVideoConferencerMonitor' rMSVideoConferenceMonitorMod01(vdvRMS,vdvPolycom_A,dvPolycom_A,rmsVideoconference[1].name)
//	#END_IF
////----------------------------------------------------------------------------------------------------
////																																							     othersMonitoring
////----------------------------------------------------------------------------------------------------
////	#IF_DEFINED HAS_OTHERS
////		//DEFINE_MODULE 'RmsNlLightMonitor' rmsLight01(vdvRMS,vdvLight,dvRelays)
////	#END_IF
////----------------------------------------------------------------------------------------------------
////																																										 rmsSourceUsage
////----------------------------------------------------------------------------------------------------
//	#IF_DEFINED HAS_SOURCE_VGA1
//		DEFINE_MODULE 'RmsVirtualDeviceMonitor' rmsVirtualInput01(vdvRMS,vdvVga1,rmsSourceUsage[1].name,rmsSourceUsage[1].description)
//	#END_IF
//
//	#IF_DEFINED HAS_SOURCE_VGA2
//		DEFINE_MODULE 'RmsVirtualDeviceMonitor' rmsVirtualInput02(vdvRMS,vdvVga2,rmsSourceUsage[2].name,rmsSourceUsage[2].description)
//	#END_IF
//
//	#IF_DEFINED HAS_SOURCE_VGA3
//		DEFINE_MODULE 'RmsVirtualDeviceMonitor' rmsVirtualInput03(vdvRMS,vdvVga3,rmsSourceUsage[3].name,rmsSourceUsage[3].description)
//	#END_IF
//
//	#IF_DEFINED HAS_SOURCE_VGA4
//		DEFINE_MODULE 'RmsVirtualDeviceMonitor' rmsVirtualInput04(vdvRMS,vdvVga4,rmsSourceUsage[4].name,rmsSourceUsage[4].description)
//	#END_IF
//
//	#IF_DEFINED HAS_SOURCE_HDMI1
//		DEFINE_MODULE 'RmsVirtualDeviceMonitor' rmsVirtualInput05(vdvRMS,vdvHdmi1,rmsSourceUsage[5].name,rmsSourceUsage[5].description)
//	#END_IF
//
//	#IF_DEFINED HAS_SOURCE_HDMI2
//		DEFINE_MODULE 'RmsVirtualDeviceMonitor' rmsVirtualInput06(vdvRMS,vdvHdmi2,rmsSourceUsage[6].name,rmsSourceUsage[6].description)
//	#END_IF
//
//	#IF_DEFINED HAS_SOURCE_HDMI3
//		DEFINE_MODULE 'RmsVirtualDeviceMonitor' rmsVirtualInput07(vdvRMS,vdvHdmi3,rmsSourceUsage[7].name,rmsSourceUsage[7].description)
//	#END_IF
//
//	#IF_DEFINED HAS_SOURCE_HDMI4
//		DEFINE_MODULE 'RmsVirtualDeviceMonitor' rmsVirtualInput08(vdvRMS,vdvHdmi4,rmsSourceUsage[8].name,rmsSourceUsage[8].description)
//	#END_IF
////----------------------------------------------------------------------------------------------------
////  																																				 rmsNetlinxDeviceMonitors
////----------------------------------------------------------------------------------------------------
//#END_IF	//HAS_RMS
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

