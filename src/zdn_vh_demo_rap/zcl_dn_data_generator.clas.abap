CLASS zcl_dn_data_generator DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    INTERFACES zif_dn_data_generator.

  PRIVATE SECTION.
    DATA mv_ts TYPE timestampl.

    METHODS seed_plants    RETURNING VALUE(rv_cnt) TYPE i.
    METHODS seed_damage    RETURNING VALUE(rv_cnt) TYPE i.
    METHODS seed_equipment RETURNING VALUE(rv_cnt) TYPE i.
    METHODS seed_funcloc   RETURNING VALUE(rv_cnt) TYPE i.

    METHODS seed_notifs    RETURNING VALUE(rt_map) TYPE zif_dn_data_generator=>tt_notif_map.

    METHODS seed_items IMPORTING it_map        TYPE zif_dn_data_generator=>tt_notif_map
                       RETURNING VALUE(rv_cnt) TYPE i.
ENDCLASS.


CLASS zcl_dn_data_generator IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(ls) = zif_dn_data_generator~seed( ).
    out->write( |Seed complete | ).
    out->write( |  Plants:        { ls-plants }| ).
    out->write( |  Damage codes:  { ls-damage_codes }| ).
    out->write( |  Equipment:     { ls-equipment }| ).
    out->write( |  FuncLoc:     { ls-funclocs }| ).
    out->write( |  Notifications: { ls-notifications }| ).
    out->write( |  Items:         { ls-items }| ).
  ENDMETHOD.

  METHOD zif_dn_data_generator~reset.
    DELETE FROM zmaint_itemd.
    DELETE FROM zmaint_notifd.
    DELETE FROM zmaint_itema.
    DELETE FROM zmaint_notifa.
    DELETE FROM zmaint_equip.
    DELETE FROM zmaint_dmgc.
    DELETE FROM zmaint_plant.

    DELETE FROM zmaint_funcloca.
  ENDMETHOD.

  METHOD zif_dn_data_generator~seed.
    zif_dn_data_generator~reset( ).
    GET TIME STAMP FIELD mv_ts.

    rs_counts-plants       = seed_plants( ).
    rs_counts-damage_codes = seed_damage( ).
    rs_counts-equipment    = seed_equipment( ).
    rs_counts-funclocs     = seed_funcloc( ).
    DATA(lt_map)            = seed_notifs( ).
    rs_counts-notifications = lines( lt_map ).
    rs_counts-items         = seed_items( lt_map ).

    COMMIT WORK.
  ENDMETHOD.

  METHOD seed_plants.
    INSERT zmaint_plant FROM TABLE @( VALUE #( ( plant_id = '1000' plant_name = 'Munich Power Plant' country = 'DE' )
                                               ( plant_id = '2000' plant_name = 'Hamburg Substation' country = 'DE' )
                                               ( plant_id = '3000' plant_name = 'Berlin Grid Center' country = 'DE' )
                                               ( plant_id = '4000' plant_name = 'Vienna Hydro Site'  country = 'AT' ) ) ).
    rv_cnt = sy-dbcnt.
  ENDMETHOD.

  METHOD seed_damage.
    INSERT zmaint_dmgc FROM TABLE @( VALUE #(
                                         ( damage_code = 'DMG-0001' damage_text = 'Bearing wear'       damage_group = 'MECH' )
                                         ( damage_code = 'DMG-0002' damage_text = 'Oil leakage'        damage_group = 'MECH' )
                                         ( damage_code = 'DMG-0003' damage_text = 'Overheating'        damage_group = 'THRM' )
                                         ( damage_code = 'DMG-0004' damage_text = 'Insulation failure' damage_group = 'ELEC' )
                                         ( damage_code = 'DMG-0005' damage_text = 'Vibration anomaly'  damage_group = 'MECH' )
                                         ( damage_code = 'DMG-0006' damage_text = 'Corrosion'          damage_group = 'CHEM' ) ) ).
    rv_cnt = sy-dbcnt.
  ENDMETHOD.

  METHOD seed_equipment.
    INSERT zmaint_equip FROM TABLE @( VALUE #(
                                          ( equipment_id = 'EQ-GT-0401' equip_text = 'Gas Turbine GT-04' plant_id = '1000' equip_category = 'TURB' )
                                          ( equipment_id = 'EQ-GT-0402' equip_text = 'Gas Turbine GT-05' plant_id = '1000' equip_category = 'TURB' )
                                          ( equipment_id = 'EQ-TR-1001' equip_text = 'Transformer T-100' plant_id = '2000' equip_category = 'TRAN' )
                                          ( equipment_id = 'EQ-TR-1002' equip_text = 'Transformer T-101' plant_id = '2000' equip_category = 'TRAN' )
                                          ( equipment_id = 'EQ-SW-2001' equip_text = 'Switchgear SW-200' plant_id = '3000' equip_category = 'SWGR' )
                                          ( equipment_id = 'EQ-SW-2002' equip_text = 'Switchgear SW-201' plant_id = '3000' equip_category = 'SWGR' )
                                          ( equipment_id = 'EQ-PM-3001' equip_text = 'Feed Pump P-300'   plant_id = '4000' equip_category = 'PUMP' )
                                          ( equipment_id = 'EQ-PM-3002' equip_text = 'Feed Pump P-301'   plant_id = '4000' equip_category = 'PUMP' )
                                          ( equipment_id = 'EQ-PM-3003' equip_text = 'Feed Pump P-302'   plant_id = '4000' equip_category = 'PUMP' )
                                          ( equipment_id = 'EQ-PM-3004' equip_text = 'Feed Pump PT-20'   plant_id = '4000' equip_category = 'PUMP' ) ) ).
    rv_cnt = sy-dbcnt.
  ENDMETHOD.

  METHOD seed_notifs.
    TYPES: BEGIN OF ty_src,
             name  TYPE string,
             plant TYPE c LENGTH 4,
             equip TYPE c LENGTH 18,
             dmg   TYPE c LENGTH 8,
             tech  TYPE c LENGTH 12,
             prio  TYPE zdn_priority,
             stat  TYPE zdn_status,
             sla   TYPE int2,
             descr TYPE c LENGTH 60,
           END OF ty_src.
    TYPES tt_src TYPE STANDARD TABLE OF ty_src WITH EMPTY KEY.   " named table type

    DATA(lt_src) = VALUE tt_src( ( name  = 'N1'
                                   plant = '1000'
                                   equip = 'EQ-GT-0401'
                                   dmg   = 'DMG-0001'
                                   tech  = 'TECH-001'
                                   prio  = '1'
                                   stat  = '101'
                                   sla   = 4
                                   descr = 'Turbine GT-04 abnormal bearing noise' )
                                 ( name  = 'N2'
                                   plant = '2000'
                                   equip = 'EQ-TR-1001'
                                   dmg   = 'DMG-0003'
                                   tech  = 'TECH-002'
                                   prio  = '2'
                                   stat  = '102'
                                   sla   = 8
                                   descr = 'Transformer T-100 running hot' )
                                 ( name  = 'N3'
                                   plant = '3000'
                                   equip = 'EQ-SW-2001'
                                   dmg   = 'DMG-0004'
                                   tech  = 'TECH-003'
                                   prio  = '2'
                                   stat  = '101'
                                   sla   = 8
                                   descr = 'Switchgear SW-200 insulation alarm' )
                                 ( name  = 'N4'
                                   plant = '4000'
                                   equip = 'EQ-PM-3001'
                                   dmg   = 'DMG-0002'
                                   tech  = 'TECH-001'
                                   prio  = '3'
                                   stat  = '103'
                                   sla   = 24
                                   descr = 'Feed pump P-300 minor oil seepage' )
                                 ( name  = 'N5'
                                   plant = '1000'
                                   equip = 'EQ-GT-0402'
                                   dmg   = 'DMG-0005'
                                   tech  = 'TECH-004'
                                   prio  = '4'
                                   stat  = '109'
                                   sla   = 72
                                   descr = 'GT-05 vibration check completed' ) ).

    DATA lt_db TYPE STANDARD TABLE OF zmaint_notifa.
    LOOP AT lt_src REFERENCE INTO DATA(lr).
      DATA(lv_uuid) = cl_system_uuid=>create_uuid_x16_static( ).
      INSERT VALUE #( name       = lr->name
                      notif_uuid = lv_uuid ) INTO TABLE rt_map.
      APPEND VALUE #( notif_uuid            = lv_uuid
                      plant_id              = lr->plant
                      equipment_id          = lr->equip
                      damage_code_id        = lr->dmg
                      technician_id         = lr->tech
                      priority              = lr->prio
                      status                = lr->stat
                      description           = lr->descr
                      sla_hours             = lr->sla
                      created_by            = cl_abap_context_info=>get_user_technical_name( )
                      created_at            = mv_ts
                      last_changed_by       = cl_abap_context_info=>get_user_technical_name( )
                      last_changed_at       = mv_ts
                      local_last_changed_at = mv_ts ) TO lt_db.
    ENDLOOP.
    INSERT zmaint_notifa FROM TABLE @lt_db.
  ENDMETHOD.

  METHOD seed_items.
    DATA(u1) = it_map[ name = 'N1' ]-notif_uuid.
    DATA(u2) = it_map[ name = 'N2' ]-notif_uuid.
    DATA(u3) = it_map[ name = 'N3' ]-notif_uuid.
    DATA(u4) = it_map[ name = 'N4' ]-notif_uuid.
    DATA(u5) = it_map[ name = 'N5' ]-notif_uuid.
    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    DATA lt_item TYPE STANDARD TABLE OF zmaint_itema.   " ← explicit type
    TRY.
        lt_item = VALUE #(                                  " ← now # can infer
                           ( notif_uuid    = u1
                             item_uuid     = cl_system_uuid=>create_uuid_x16_static( )
                             item_no       = '0010'
                             activity_code = 'ACT-INSP'
                             spare_part_id = 'SP-BEARING-001'
                             required_qty  = '2.000'
                             qty_uom       = 'EA'
                             item_status   = 'OP' )
                           ( notif_uuid    = u1
                             item_uuid     = cl_system_uuid=>create_uuid_x16_static( )
                             item_no       = '0020'
                             activity_code = 'ACT-REPL'
                             spare_part_id = 'SP-LUBE-OIL-5L'
                             required_qty  = '1.000'
                             qty_uom       = 'CAN'
                             item_status   = 'OP' )
                           ( notif_uuid    = u2
                             item_uuid     = cl_system_uuid=>create_uuid_x16_static( )
                             item_no       = '0010'
                             activity_code = 'ACT-COOL'
                             spare_part_id = 'SP-COOLFAN-220'
                             required_qty  = '1.000'
                             qty_uom       = 'EA'
                             item_status   = 'IP' )
                           ( notif_uuid    = u2
                             item_uuid     = cl_system_uuid=>create_uuid_x16_static( )
                             item_no       = '0020'
                             activity_code = 'ACT-TEST'
                             spare_part_id = 'SP-THERMO-PR'
                             required_qty  = '3.000'
                             qty_uom       = 'EA'
                             item_status   = 'OP' )
                           ( notif_uuid    = u3
                             item_uuid     = cl_system_uuid=>create_uuid_x16_static( )
                             item_no       = '0010'
                             activity_code = 'ACT-ISOL'
                             spare_part_id = 'SP-INSUL-KIT'
                             required_qty  = '1.000'
                             qty_uom       = 'KIT'
                             item_status   = 'WP' )
                           ( notif_uuid    = u3
                             item_uuid     = cl_system_uuid=>create_uuid_x16_static( )
                             item_no       = '0020'
                             activity_code = 'ACT-INSP'
                             spare_part_id = 'SP-CABLE-HV-10'
                             required_qty  = '10.000'
                             qty_uom       = 'M'
                             item_status   = 'OP' )
                           ( notif_uuid    = u4
                             item_uuid     = cl_system_uuid=>create_uuid_x16_static( )
                             item_no       = '0010'
                             activity_code = 'ACT-SEAL'
                             spare_part_id = 'SP-SEAL-PUMP-30'
                             required_qty  = '2.000'
                             qty_uom       = 'EA'
                             item_status   = 'OP' )
                           ( notif_uuid    = u4
                             item_uuid     = cl_system_uuid=>create_uuid_x16_static( )
                             item_no       = '0020'
                             activity_code = 'ACT-CLN'
                             spare_part_id = 'SP-DEGREASER-1L'
                             required_qty  = '1.000'
                             qty_uom       = 'CAN'
                             item_status   = 'OP' )
                           ( notif_uuid    = u5
                             item_uuid     = cl_system_uuid=>create_uuid_x16_static( )
                             item_no       = '0010'
                             activity_code = 'ACT-INSP'
                             spare_part_id = 'SP-VIBR-SENSOR'
                             required_qty  = '1.000'
                             qty_uom       = 'EA'
                             item_status   = 'CA' )
                           ( notif_uuid    = u5
                             item_uuid     = cl_system_uuid=>create_uuid_x16_static( )
                             item_no       = '0020'
                             activity_code = 'ACT-TEST'
                             spare_part_id = 'SP-BEARING-001'
                             required_qty  = '2.000'
                             qty_uom       = 'EA'
                             item_status   = 'CA' ) ).
      CATCH cx_uuid_error.
        " handle exception
    ENDTRY.

    LOOP AT lt_item REFERENCE INTO DATA(li).
      li->created_by            = lv_user.
      li->created_at            = mv_ts.
      li->last_changed_by       = lv_user.
      li->last_changed_at       = mv_ts.
      li->local_last_changed_at = mv_ts.
    ENDLOOP.

    INSERT zmaint_itema FROM TABLE @lt_item.
    rv_cnt = sy-dbcnt.
  ENDMETHOD.

  METHOD seed_funcloc.
    DATA lt_fl TYPE STANDARD TABLE OF zmaint_funcloca.

    lt_fl = VALUE #( " PLANT 1000 – Turbine Area
                     ( funcloc_id        = 'FL-1000'
                       parent_funcloc_id = ''
                       description       = 'Plant 1000 Root'
                       plant_id          = '1000'
                       fl_category       = 'PLNT' )

                     ( funcloc_id        = 'FL-1000-TURB'
                       parent_funcloc_id = 'FL-1000'
                       description       = 'Turbine Section'
                       plant_id          = '1000'
                       fl_category       = 'AREA' )

                     ( funcloc_id        = 'FL-1000-TURB-GT04'
                       parent_funcloc_id = 'FL-1000-TURB'
                       description       = 'Gas Turbine GT-04 Location'
                       plant_id          = '1000'
                       fl_category       = 'UNIT' )

                     ( funcloc_id        = 'FL-1000-TURB-GT05'
                       parent_funcloc_id = 'FL-1000-TURB'
                       description       = 'Gas Turbine GT-05 Location'
                       plant_id          = '1000'
                       fl_category       = 'UNIT' )

                     " PLANT 2000 – Transformer Area
                     ( funcloc_id        = 'FL-2000'
                       parent_funcloc_id = ''
                       description       = 'Plant 2000 Root'
                       plant_id          = '2000'
                       fl_category       = 'PLNT' )

                     ( funcloc_id        = 'FL-2000-TRANS'
                       parent_funcloc_id = 'FL-2000'
                       description       = 'Transformer Section'
                       plant_id          = '2000'
                       fl_category       = 'AREA' )

                     ( funcloc_id        = 'FL-2000-TRANS-T100'
                       parent_funcloc_id = 'FL-2000-TRANS'
                       description       = 'Transformer T-100 Location'
                       plant_id          = '2000'
                       fl_category       = 'UNIT' )

                     " PLANT 3000 – Switchgear
                     ( funcloc_id        = 'FL-3000'
                       parent_funcloc_id = ''
                       description       = 'Plant 3000 Root'
                       plant_id          = '3000'
                       fl_category       = 'PLNT' )

                     ( funcloc_id        = 'FL-3000-SWGR'
                       parent_funcloc_id = 'FL-3000'
                       description       = 'Switchgear Section'
                       plant_id          = '3000'
                       fl_category       = 'AREA' )

                     " PLANT 4000 – Pump Area
                     ( funcloc_id        = 'FL-4000'
                       parent_funcloc_id = ''
                       description       = 'Plant 4000 Root'
                       plant_id          = '4000'
                       fl_category       = 'PLNT' )

                     ( funcloc_id        = 'FL-4000-PUMP'
                       parent_funcloc_id = 'FL-4000'
                       description       = 'Pump Section'
                       plant_id          = '4000'
                       fl_category       = 'AREA' )

                     ( funcloc_id        = 'FL-4000-PUMP-P300'
                       parent_funcloc_id = 'FL-4000-PUMP'
                       description       = 'Feed Pump P-300 Location'
                       plant_id          = '4000'
                       fl_category       = 'UNIT' ) ).

    INSERT zmaint_funcloca FROM TABLE @lt_fl.
    rv_cnt = sy-dbcnt.
  ENDMETHOD.
ENDCLASS.
