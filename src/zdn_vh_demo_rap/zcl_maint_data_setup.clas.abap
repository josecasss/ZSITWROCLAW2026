CLASS zcl_maint_data_setup DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    DATA mv_ts TYPE timestampl.

ENDCLASS.

CLASS zcl_maint_data_setup IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    GET TIME STAMP FIELD mv_ts.
    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    " ─── RESET ───────────────────────────────────────────────
    DELETE FROM zmaint_itemd.
    DELETE FROM zmaint_notifd.
    DELETE FROM zmaint_itema.
    DELETE FROM zmaint_notifa.
    DELETE FROM zmaint_equip.
    DELETE FROM zmaint_dmgc.
    DELETE FROM zmaint_plant.
    DELETE FROM zmaint_funcloca.
    DELETE FROM zmaint_techns.
    DELETE FROM zmaint_actcode.
    DELETE FROM zmaint_sparepart.

    " ─── PLANTS ──────────────────────────────────────────────
    INSERT zmaint_plant FROM TABLE @( VALUE #(
      ( plant_id = '1000' plant_name = 'Munich Power Plant'  country = 'DE' )
      ( plant_id = '2000' plant_name = 'Hamburg Substation'  country = 'DE' )
      ( plant_id = '3000' plant_name = 'Berlin Grid Center'  country = 'DE' )
      ( plant_id = '4000' plant_name = 'Vienna Hydro Site'   country = 'AT' ) ) ).
    out->write( |Plants:       { sy-dbcnt }| ).

    " ─── DAMAGE CODES ────────────────────────────────────────
    INSERT zmaint_dmgc FROM TABLE @( VALUE #(
      ( damage_code = 'DMG-0001' damage_text = 'Bearing Failure'           damage_group = 'MECH' )
      ( damage_code = 'DMG-0002' damage_text = 'Oil Seepage'               damage_group = 'MECH' )
      ( damage_code = 'DMG-0003' damage_text = 'Overheating'               damage_group = 'THRM' )
      ( damage_code = 'DMG-0004' damage_text = 'Insulation Breakdown'      damage_group = 'ELEC' )
      ( damage_code = 'DMG-0005' damage_text = 'Vibration Anomaly'         damage_group = 'MECH' )
      ( damage_code = 'DMG-0006' damage_text = 'Cooling System Failure'    damage_group = 'THRM' )
      ( damage_code = 'DMG-0007' damage_text = 'Corrosion Damage'          damage_group = 'MECH' )
      ( damage_code = 'DMG-0008' damage_text = 'Electrical Fault'          damage_group = 'ELEC' ) ) ).
    out->write( |Damage codes: { sy-dbcnt }| ).

    " ─── EQUIPMENT ───────────────────────────────────────────
    INSERT zmaint_equip FROM TABLE @( VALUE #(
      ( equipment_id = 'EQ-GT-0401' equip_text = 'Gas Turbine GT-04'    plant_id = '1000' equip_category = 'TURB' )
      ( equipment_id = 'EQ-GT-0402' equip_text = 'Gas Turbine GT-05'    plant_id = '1000' equip_category = 'TURB' )
      ( equipment_id = 'EQ-TR-1001' equip_text = 'Transformer T-100'    plant_id = '2000' equip_category = 'TRAN' )
      ( equipment_id = 'EQ-TR-1002' equip_text = 'Transformer T-101'    plant_id = '2000' equip_category = 'TRAN' )
      ( equipment_id = 'EQ-SW-2001' equip_text = 'Switchgear SW-200'    plant_id = '3000' equip_category = 'SWGR' )
      ( equipment_id = 'EQ-SW-2002' equip_text = 'Switchgear SW-201'    plant_id = '3000' equip_category = 'SWGR' )
      ( equipment_id = 'EQ-PM-3001' equip_text = 'Feed Pump P-300'      plant_id = '4000' equip_category = 'PUMP' )
      ( equipment_id = 'EQ-PM-3002' equip_text = 'Feed Pump P-301'      plant_id = '4000' equip_category = 'PUMP' ) ) ).
    out->write( |Equipment:    { sy-dbcnt }| ).

    " ─── FUNCTIONAL LOCATIONS ────────────────────────────────
    INSERT zmaint_funcloca FROM TABLE @( VALUE #(
      ( funcloc_id = 'FL-1000'            parent_funcloc_id = ''               description = 'Plant 1000 Root'              plant_id = '1000' fl_category = 'PLNT' )
      ( funcloc_id = 'FL-1000-TURB'       parent_funcloc_id = 'FL-1000'        description = 'Turbine Section'              plant_id = '1000' fl_category = 'AREA' )
      ( funcloc_id = 'FL-1000-TURB-GT04'  parent_funcloc_id = 'FL-1000-TURB'   description = 'Gas Turbine GT-04 Location'   plant_id = '1000' fl_category = 'UNIT' )
      ( funcloc_id = 'FL-1000-TURB-GT05'  parent_funcloc_id = 'FL-1000-TURB'   description = 'Gas Turbine GT-05 Location'   plant_id = '1000' fl_category = 'UNIT' )
      ( funcloc_id = 'FL-2000'            parent_funcloc_id = ''               description = 'Plant 2000 Root'              plant_id = '2000' fl_category = 'PLNT' )
      ( funcloc_id = 'FL-2000-TRANS'      parent_funcloc_id = 'FL-2000'        description = 'Transformer Section'          plant_id = '2000' fl_category = 'AREA' )
      ( funcloc_id = 'FL-2000-TRANS-T100' parent_funcloc_id = 'FL-2000-TRANS'  description = 'Transformer T-100 Location'   plant_id = '2000' fl_category = 'UNIT' )
      ( funcloc_id = 'FL-2000-TRANS-T101' parent_funcloc_id = 'FL-2000-TRANS'  description = 'Transformer T-101 Location'   plant_id = '2000' fl_category = 'UNIT' )
      ( funcloc_id = 'FL-3000'            parent_funcloc_id = ''               description = 'Plant 3000 Root'              plant_id = '3000' fl_category = 'PLNT' )
      ( funcloc_id = 'FL-3000-SWGR'       parent_funcloc_id = 'FL-3000'        description = 'Switchgear Section'           plant_id = '3000' fl_category = 'AREA' )
      ( funcloc_id = 'FL-3000-SWGR-SW200' parent_funcloc_id = 'FL-3000-SWGR'   description = 'Switchgear SW-200 Location'   plant_id = '3000' fl_category = 'UNIT' )
      ( funcloc_id = 'FL-4000'            parent_funcloc_id = ''               description = 'Plant 4000 Root'              plant_id = '4000' fl_category = 'PLNT' )
      ( funcloc_id = 'FL-4000-PUMP'       parent_funcloc_id = 'FL-4000'        description = 'Pump Section'                 plant_id = '4000' fl_category = 'AREA' )
      ( funcloc_id = 'FL-4000-PUMP-P300'  parent_funcloc_id = 'FL-4000-PUMP'   description = 'Feed Pump P-300 Location'     plant_id = '4000' fl_category = 'UNIT' ) ) ).
    out->write( |FuncLocs:     { sy-dbcnt }| ).

    " ─── TECHNICIANS ─────────────────────────────────────────
    INSERT zmaint_techns FROM TABLE @( VALUE #(
      ( technician_id = 'T_SWINDSLAND'  sap_user = 'SWINDSLAND'  first_name = 'Stian'   last_name = 'Windsland' email = 'stian@edu.cdv.pl'   phone = '+47 912 34 5' is_available = 'Available'   )
      ( technician_id = 'T_SOWINDSLAN'  sap_user = 'SOWINDSLAND' first_name = 'Solve'   last_name = 'Windsland' email = 'solve@edu.cdv.pl'   phone = '+47 415 88 2' is_available = 'Busy'        )
      ( technician_id = 'T_FCASAS'      sap_user = 'FCASAS'      first_name = 'Freddy'  last_name = 'Casas'     email = 'freddy@edu.cdv.pl'  phone = '+47 988 12 3' is_available = 'Unavailable' )
      ( technician_id = 'T_PSOBIK'      sap_user = 'PSOBIK'      first_name = 'Paulina' last_name = 'Sobik'     email = 'paulina@edu.cdv.pl' phone = '+47 905 43 2' is_available = 'Busy'        )
      ( technician_id = 'T_SUWINDSLAN'  sap_user = 'SUWINDSLAND' first_name = 'Susan'   last_name = 'Windsland' email = 'susan@edu.cdv.pl'   phone = '+47 481 99 8' is_available = 'Available'   ) ) ).
    out->write( |Technicians:  { sy-dbcnt }| ).

    " ─── ACTIVITY CODES ──────────────────────────────────────
    INSERT zmaint_actcode FROM TABLE @( VALUE #(
      ( activity_code = 'ACT-INSP'  activity_text = 'General Inspection'      activity_group = 'INSP' )
      ( activity_code = 'ACT-REPL'  activity_text = 'Component Replacement'   activity_group = 'MECH' )
      ( activity_code = 'ACT-COOL'  activity_text = 'Cooling System Service'  activity_group = 'THRM' )
      ( activity_code = 'ACT-TEST'  activity_text = 'Functional Testing'      activity_group = 'TEST' )
      ( activity_code = 'ACT-ISOL'  activity_text = 'Electrical Isolation'    activity_group = 'ELEC' )
      ( activity_code = 'ACT-SEAL'  activity_text = 'Seal Replacement'        activity_group = 'MECH' )
      ( activity_code = 'ACT-CLN'   activity_text = 'Deep Cleaning'           activity_group = 'MANT' )
      ( activity_code = 'ACT-LUB'   activity_text = 'Lubrication Service'     activity_group = 'MANT' )
      ( activity_code = 'ACT-CALI' activity_text = 'Sensor Calibration'      activity_group = 'TEST' )
      ( activity_code = 'ACT-WELD'  activity_text = 'Welding and Repair'      activity_group = 'MECH' ) ) ).
    out->write( |Activity codes: { sy-dbcnt }| ).

    " ─── SPARE PARTS (sin CAN) ───────────────────────────────
    INSERT zmaint_sparepart FROM TABLE @( VALUE #(
      ( spare_part_id = 'SP-BEARING-001'  spare_part_text = 'Main Bearing Set 6205'    part_category = 'MECH' base_uom = 'EA'  )
      ( spare_part_id = 'SP-LUBE-OIL-5L'  spare_part_text = 'Lubrication Oil 5L'       part_category = 'CONS' base_uom = 'L'   )
      ( spare_part_id = 'SP-COOLFAN-220'  spare_part_text = 'Cooling Fan 220V'          part_category = 'ELEC' base_uom = 'EA'  )
      ( spare_part_id = 'SP-THERMO-PR'    spare_part_text = 'Thermal Probe Sensor'      part_category = 'ELEC' base_uom = 'EA'  )
      ( spare_part_id = 'SP-INSUL-KIT'    spare_part_text = 'Insulation Repair Kit'     part_category = 'ELEC' base_uom = 'KIT' )
      ( spare_part_id = 'SP-CABLE-HV-10'  spare_part_text = 'High Voltage Cable 10m'    part_category = 'ELEC' base_uom = 'M'   )
      ( spare_part_id = 'SP-SEAL-PUMP-30' spare_part_text = 'Pump Seal Ring 30mm'       part_category = 'MECH' base_uom = 'EA'  )
      ( spare_part_id = 'SP-DEGREASER-1L' spare_part_text = 'Industrial Degreaser 1L'   part_category = 'CONS' base_uom = 'ML'  )
      ( spare_part_id = 'SP-VIBR-SENSOR'  spare_part_text = 'Vibration Sensor Module'   part_category = 'ELEC' base_uom = 'EA'  )
      ( spare_part_id = 'SP-FILTER-HYD'   spare_part_text = 'Hydraulic Filter Element'  part_category = 'MECH' base_uom = 'EA'  )
      ( spare_part_id = 'SP-GASKET-SET'   spare_part_text = 'Gasket Set Universal'      part_category = 'MECH' base_uom = 'KIT' )
      ( spare_part_id = 'SP-FUSE-32A'     spare_part_text = 'Industrial Fuse 32A'       part_category = 'ELEC' base_uom = 'EA'  )
      ( spare_part_id = 'SP-GREASE-500G'  spare_part_text = 'High Temp Grease 500g'     part_category = 'CONS' base_uom = 'EA'  )
      ( spare_part_id = 'SP-VALVE-CTRL'   spare_part_text = 'Control Valve Assembly'    part_category = 'MECH' base_uom = 'EA'  )
      ( spare_part_id = 'SP-BELT-V40'     spare_part_text = 'V-Belt Drive 40mm'         part_category = 'MECH' base_uom = 'EA'  ) ) ).
    out->write( |Spare parts:  { sy-dbcnt }| ).

    " ─── NOTIFICATIONS ───────────────────────────────────────
    DATA lt_notif TYPE STANDARD TABLE OF zmaint_notifa.
    DATA lt_map   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.

    DATA(u1) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(u2) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(u3) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(u4) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(u5) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(u6) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(u7) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(u8) = cl_system_uuid=>create_uuid_x16_static( ).

    lt_notif = VALUE #(
      ( notif_uuid = u1 plant_id = '1000' equipment_id = 'EQ-GT-0401' damage_code_id = 'DMG-0001' technician_id = 'T_SWINDSLAND' funcloc_id = 'FL-1000-TURB-GT04' priority = '1' status = '101' sla_hours = 4
      description = 'Gas Turbine GT-04 abnormal bearing noise detected during routine check'    created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u2 plant_id = '2000' equipment_id = 'EQ-TR-1001' damage_code_id = 'DMG-0003' technician_id = 'T_SOWINDSLAN' funcloc_id = 'FL-2000-TRANS-T100' priority = '2' status = '102' sla_hours = 8
       description = 'Transformer T-100 running 15 degrees above normal operating temperature'       created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u3 plant_id = '3000' equipment_id = 'EQ-SW-2001' damage_code_id = 'DMG-0004' technician_id = 'T_FCASAS'     funcloc_id = 'FL-3000-SWGR-SW200' priority = '2' status = '101' sla_hours = 8
      description = 'Switchgear SW-200 insulation alarm triggered on panel B circuit breaker'        created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u4 plant_id = '4000' equipment_id = 'EQ-PM-3001' damage_code_id = 'DMG-0002' technician_id = 'T_PSOBIK'     funcloc_id = 'FL-4000-PUMP-P300'  priority = '3' status = '103' sla_hours = 24
      description = 'Feed pump P-300 minor oil seepage from shaft seal — resolved after replacement'  created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u5 plant_id = '1000' equipment_id = 'EQ-GT-0402' damage_code_id = 'DMG-0005' technician_id = 'T_SUWINDSLAN' funcloc_id = 'FL-1000-TURB-GT05' priority = '4' status = '109' sla_hours = 72
      description = 'GT-05 vibration check completed — all readings within acceptable range'           created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u6 plant_id = '2000' equipment_id = 'EQ-TR-1002' damage_code_id = 'DMG-0006' technician_id = 'T_SWINDSLAND' funcloc_id = 'FL-2000-TRANS-T101' priority = '1' status = '102' sla_hours = 4
      description = 'URGENT: Transformer T-101 cooling fan failure — risk of shutdown if not resolved'   created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u7 plant_id = '3000' equipment_id = 'EQ-SW-2002' damage_code_id = 'DMG-0008' technician_id = 'T_SOWINDSLAN' funcloc_id = 'FL-3000-SWGR-SW200' priority = '1' status = '101' sla_hours = 4
      description = 'URGENT: Switchgear SW-201 electrical fault on main bus — immediate isolation required' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u8 plant_id = '4000' equipment_id = 'EQ-PM-3002' damage_code_id = 'DMG-0007' technician_id = 'T_PSOBIK'     funcloc_id = 'FL-4000-PUMP-P300'  priority = '3' status = '101' sla_hours = 24
      description = 'Feed pump P-301 surface corrosion observed on inlet manifold — schedule treatment'   created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts ) ).

    INSERT zmaint_notifa FROM TABLE @lt_notif.
    out->write( |Notifications: { sy-dbcnt }| ).

    " ─── ITEMS (sin CAN) ─────────────────────────────────────
    DATA lt_item TYPE STANDARD TABLE OF zmaint_itema.

    lt_item = VALUE #(
      " N1 — GT-04 bearing noise
      ( notif_uuid = u1 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0010' activity_code = 'ACT-INSP'  spare_part_id = 'SP-BEARING-001'
      required_qty = '2.000' qty_uom = 'EA'  item_status = 'OP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u1 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0020' activity_code = 'ACT-LUB'   spare_part_id = 'SP-LUBE-OIL-5L'
      required_qty = '5.000' qty_uom = 'L'   item_status = 'OP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      " N2 — Transformer overheating
      ( notif_uuid = u2 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0010' activity_code = 'ACT-COOL'  spare_part_id = 'SP-COOLFAN-220'
      required_qty = '1.000' qty_uom = 'EA'  item_status = 'IP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u2 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0020' activity_code = 'ACT-TEST'  spare_part_id = 'SP-THERMO-PR'
      required_qty = '3.000' qty_uom = 'EA'  item_status = 'OP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      " N3 — Switchgear insulation
      ( notif_uuid = u3 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0010' activity_code = 'ACT-ISOL'  spare_part_id = 'SP-INSUL-KIT'
      required_qty = '1.000' qty_uom = 'KIT' item_status = 'OP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u3 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0020' activity_code = 'ACT-INSP'  spare_part_id = 'SP-CABLE-HV-10'
      required_qty = '10.000' qty_uom = 'M'  item_status = 'OP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      " N4 — Pump seal (completed)
      ( notif_uuid = u4 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0010' activity_code = 'ACT-SEAL'  spare_part_id = 'SP-SEAL-PUMP-30'
      required_qty = '2.000' qty_uom = 'EA'  item_status = 'CO' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u4 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0020' activity_code = 'ACT-CLN'   spare_part_id = 'SP-DEGREASER-1L'
      required_qty = '2.000' qty_uom = 'ML'  item_status = 'CO' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      " N5 — GT-05 vibration (cancelled)
      ( notif_uuid = u5 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0010' activity_code = 'ACT-CALI' spare_part_id = 'SP-VIBR-SENSOR'
      required_qty = '1.000' qty_uom = 'EA'  item_status = 'CA' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      " N6 — Transformer cooling URGENT
      ( notif_uuid = u6 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0010' activity_code = 'ACT-COOL'  spare_part_id = 'SP-COOLFAN-220'
      required_qty = '2.000' qty_uom = 'EA'  item_status = 'IP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u6 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0020' activity_code = 'ACT-TEST'  spare_part_id = 'SP-FILTER-HYD'
      required_qty = '1.000' qty_uom = 'EA'  item_status = 'OP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      " N7 — Switchgear fault URGENT
      ( notif_uuid = u7 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0010' activity_code = 'ACT-ISOL'  spare_part_id = 'SP-FUSE-32A'
      required_qty = '4.000' qty_uom = 'EA'  item_status = 'OP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u7 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0020' activity_code = 'ACT-WELD'  spare_part_id = 'SP-GASKET-SET'
      required_qty = '1.000' qty_uom = 'KIT' item_status = 'OP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      " N8 — Pump corrosion
      ( notif_uuid = u8 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0010' activity_code = 'ACT-CLN'   spare_part_id = 'SP-GREASE-500G'
      required_qty = '2.000' qty_uom = 'EA'  item_status = 'OP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts )
      ( notif_uuid = u8 item_uuid = cl_system_uuid=>create_uuid_x16_static( ) item_no = '0020' activity_code = 'ACT-REPL'  spare_part_id = 'SP-VALVE-CTRL'
      required_qty = '1.000' qty_uom = 'EA'  item_status = 'OP' created_by = lv_user created_at = mv_ts last_changed_by = lv_user last_changed_at = mv_ts local_last_changed_at = mv_ts ) ).

    INSERT zmaint_itema FROM TABLE @lt_item.
    out->write( |Items:         { sy-dbcnt }| ).

    COMMIT WORK.
    out->write( '✅ Data setup complete.' ).

  ENDMETHOD.

ENDCLASS.
