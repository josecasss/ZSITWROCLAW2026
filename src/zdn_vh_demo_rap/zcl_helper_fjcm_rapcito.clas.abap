class zcl_helper_fjcm_rapcito definition
  public
  final
  create public .

  public section.

    interfaces if_oo_adt_classrun .
  protected section.
  private section.
endclass.



class zcl_helper_fjcm_rapcito implementation.


  method if_oo_adt_classrun~main.

*  DELETE FROM zmaint_itemstat.
*  DELETE FROM zmaint_techns.
*
*
*    insert zmaint_itemstat from table @( value #(
*                                           ( item_status = 'OP' status_text = 'Open'       )
*                                           ( item_status = 'IP' status_text = 'In Process'        )
*                                           ( item_status = 'WP' status_text = 'Waiting Parts'        )
*                                           ( item_status = 'CO' status_text = 'Completed' )
*                                           ( item_status = 'CA' status_text = 'Canceled'  ) ) ).
*
*    if sy-subrc = 0.
*      out->write( 'Damage codes inserted successfully.' ).
*    else.
*      out->write( 'Error inserting damage codes.' ).
*    endif.
*
*    insert zmaint_techns from table @( value #(
*          ( technician_id = 'T_SWINDSLAND'
*            sap_user      = 'SWINDSLAND'
*            first_name    = 'Stian'
*            last_name     = 'Windsland'
*            email         = 'stian@edu.cdv.pl'
*            phone         = '+47 912 34 567'
*            is_available  = 'Available' )
*
*          ( technician_id = 'T_SOWINDSLAN'
*            sap_user      = 'SOWINDSLAND'
*            first_name    = 'Solve'
*            last_name     = 'Windsland'
*            email         = 'solve@edu.cdv.pl'
*            phone         = '+47 415 88 234'
*            is_available  = 'Busy' )
*
*          ( technician_id = 'T_FCASAS'
*            sap_user      = 'FCASAS'
*            first_name    = 'Freddy'
*            last_name     = 'Casas'
*            email         = 'freddy@edu.cdv.pl'
*            phone         = '+47 988 12 345'
*            is_available  = 'Unavailable' )
*
*          ( technician_id = 'T_PSOBIK'
*            sap_user      = 'PSOBIK'
*            first_name    = 'Paulina'
*            last_name     = 'Sobik'
*            email         = 'paulina@edu.cdv.pl'
*            phone         = '+47 905 43 210'
*            is_available  = 'Busy' )
*
*          ( technician_id = 'T_SUWINDSLAN'
*            sap_user      = 'SUWINDSLAND'
*            first_name    = 'Susan'
*            last_name     = 'Windsland'
*            email         = 'susan@edu.cdv.pl'
*            phone         = '+47 481 99 876'
*            is_available  = 'Available' )
*    ) ).

    DELETE FROM zmaint_actcode.
DELETE FROM zmaint_sparepart.

INSERT zmaint_actcode FROM TABLE @( VALUE #(
  ( activity_code = 'ACT-INSP'  activity_text = 'General Inspection'        activity_group = 'INSP' )
  ( activity_code = 'ACT-REPL'  activity_text = 'Component Replacement'     activity_group = 'MECH' )
  ( activity_code = 'ACT-COOL'  activity_text = 'Cooling System Service'    activity_group = 'THRM' )
  ( activity_code = 'ACT-TEST'  activity_text = 'Functional Testing'        activity_group = 'TEST' )
  ( activity_code = 'ACT-ISOL'  activity_text = 'Electrical Isolation'      activity_group = 'ELEC' )
  ( activity_code = 'ACT-SEAL'  activity_text = 'Seal Replacement'          activity_group = 'MECH' )
  ( activity_code = 'ACT-CLN'   activity_text = 'Deep Cleaning'             activity_group = 'MANT' )
  ( activity_code = 'ACT-LUB'   activity_text = 'Lubrication Service'       activity_group = 'MANT' )
  ( activity_code = 'ACT-CALIB' activity_text = 'Sensor Calibration'        activity_group = 'TEST' )
  ( activity_code = 'ACT-WELD'  activity_text = 'Welding and Repair'        activity_group = 'MECH' )
) ).

INSERT zmaint_sparepart FROM TABLE @( VALUE #(
  ( spare_part_id = 'SP-BEARING-001'  spare_part_text = 'Main Bearing Set 6205'      part_category = 'MECH' base_uom = 'EA' )
  ( spare_part_id = 'SP-LUBE-OIL-5L'  spare_part_text = 'Lubrication Oil 5L'         part_category = 'CONS' base_uom = 'CAN' )
  ( spare_part_id = 'SP-COOLFAN-220'  spare_part_text = 'Cooling Fan 220V'            part_category = 'ELEC' base_uom = 'EA' )
  ( spare_part_id = 'SP-THERMO-PR'    spare_part_text = 'Thermal Probe Sensor'        part_category = 'ELEC' base_uom = 'EA' )
  ( spare_part_id = 'SP-INSUL-KIT'    spare_part_text = 'Insulation Repair Kit'       part_category = 'ELEC' base_uom = 'KIT' )
  ( spare_part_id = 'SP-CABLE-HV-10'  spare_part_text = 'High Voltage Cable 10m'      part_category = 'ELEC' base_uom = 'M' )
  ( spare_part_id = 'SP-SEAL-PUMP-30' spare_part_text = 'Pump Seal Ring 30mm'         part_category = 'MECH' base_uom = 'EA' )
  ( spare_part_id = 'SP-DEGREASER-1L' spare_part_text = 'Industrial Degreaser 1L'     part_category = 'CONS' base_uom = 'CAN' )
  ( spare_part_id = 'SP-VIBR-SENSOR'  spare_part_text = 'Vibration Sensor Module'     part_category = 'ELEC' base_uom = 'EA' )
  ( spare_part_id = 'SP-FILTER-HYD'   spare_part_text = 'Hydraulic Filter Element'    part_category = 'MECH' base_uom = 'EA' )
  ( spare_part_id = 'SP-GASKET-SET'   spare_part_text = 'Gasket Set Universal'        part_category = 'MECH' base_uom = 'KIT' )
  ( spare_part_id = 'SP-FUSE-32A'     spare_part_text = 'Industrial Fuse 32A'         part_category = 'ELEC' base_uom = 'EA' )
  ( spare_part_id = 'SP-GREASE-500G'  spare_part_text = 'High Temp Grease 500g'       part_category = 'CONS' base_uom = 'EA' )
  ( spare_part_id = 'SP-VALVE-CTRL'   spare_part_text = 'Control Valve Assembly'      part_category = 'MECH' base_uom = 'EA' )
  ( spare_part_id = 'SP-BELT-V40'     spare_part_text = 'V-Belt Drive 40mm'           part_category = 'MECH' base_uom = 'EA' )
) ).

  endmethod.

endclass.
