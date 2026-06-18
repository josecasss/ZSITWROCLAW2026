class lhc_maintitem definition inheriting from cl_abap_behavior_handler.

  private section.

    methods setItemNo for determine on modify
      importing keys for MaintItem~setItemNo.
    methods get_instance_features for instance features
      importing keys request requested_features for MaintItem result result.

    methods markItemCancelled for modify
      importing keys for action MaintItem~markItemCancelled result result.

    methods markItemCompleted for modify
      importing keys for action MaintItem~markItemCompleted result result.
    methods setItemInitialStatus for determine on modify
      importing keys for MaintItem~setItemInitialStatus.

endclass.

class lhc_maintitem implementation.

  method setItemNo.

    data update_table type table for update zr_maintnotificationtp\\MaintItem.

    read entities of zr_maintnotificationtp in local mode
      entity MaintItem
        fields ( ItemNo NotifUuid )
        with corresponding #( keys )
      result data(items).

    delete items where ItemNo is not initial.
    check items is not initial.

    loop at items assigning field-symbol(<it_fix>).
      if <it_fix>-NotifUuid is initial.
        <it_fix>-NotifUuid = <it_fix>-%tky-NotifUuid.
      endif.
    endloop.

    data(notif_uuids) = items.
    sort notif_uuids by NotifUuid.
    delete adjacent duplicates from notif_uuids comparing NotifUuid.

    loop at notif_uuids into data(notif_entry).

      " Leer todos los hermanos de la tabla draft para esta notificación
      select * from zmaint_itemd
        where notifuuid = @notif_entry-NotifUuid
        into table @data(draft_siblings).

      " Calcular máximo manualmente
      data(max_item_no) = 0.
      loop at draft_siblings into data(sib).
        if sib-itemno > max_item_no.
          max_item_no = sib-itemno.
        endif.
      endloop.

      " Considerar lo ya asignado en este mismo lote
      loop at update_table into data(already_assigned)
        where %tky-NotifUuid = notif_entry-NotifUuid.
        if already_assigned-ItemNo > max_item_no.
          max_item_no = already_assigned-ItemNo.
        endif.
      endloop.

      data(batch_items) = items.
      delete batch_items where NotifUuid <> notif_entry-NotifUuid.
      sort batch_items by %tky.

      loop at batch_items into data(item).
        max_item_no = max_item_no + 10.
        append value #(
          %tky   = item-%tky
          ItemNo = max_item_no
        ) to update_table.
      endloop.

    endloop.

    if update_table is not initial.
      modify entities of zr_maintnotificationtp in local mode
        entity MaintItem
          update fields ( ItemNo )
          with update_table.
    endif.

  endmethod.

  method get_instance_features.
  endmethod.

  method markItemCancelled.

    read entities of zr_maintnotificationtp in local mode
      entity MaintItem
      fields ( ItemStatus )
      with corresponding #( keys )
      result data(items).

    data update_table type table for update zr_maintnotificationtp\\MaintItem.

    loop at items into data(item).

      if item-ItemStatus = 'CO'.

        append value #( %tky = item-%tky ) to failed-maintitem.
        append value #( %tky = item-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Completed items cannot be cancelled' )
                      ) to reported-maintitem.

        continue.

      endif.

      append value #( %tky       = item-%tky
                      ItemStatus = 'CA' ) to update_table.

    endloop.

    if update_table is not initial.

      modify entities of zr_maintnotificationtp in local mode
        entity MaintItem
          update fields ( ItemStatus )
          with update_table.

    endif.

    read entities of zr_maintnotificationtp in local mode
      entity MaintItem
      all fields with corresponding #( keys )
      result data(result_items).

    result = value #( for r in result_items ( %tky   = r-%tky
                                              %param = r ) ).

  endmethod.

  method markItemCompleted.

    read entities of zr_maintnotificationtp in local mode
      entity MaintItem
      fields ( ItemStatus )
      with corresponding #( keys )
      result data(items).

    data update_table type table for update zr_maintnotificationtp\\MaintItem.

    loop at items into data(item).

      if item-ItemStatus = 'CA'.

        append value #( %tky = item-%tky ) to failed-maintitem.
        append value #( %tky = item-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Cancelled items cannot be completed' )
                      ) to reported-maintitem.

        continue.

      endif.

      append value #( %tky       = item-%tky
                      ItemStatus = 'CO' ) to update_table.

    endloop.

    if update_table is not initial.

      modify entities of zr_maintnotificationtp in local mode
        entity MaintItem
          update fields ( ItemStatus )
          with update_table.

    endif.

    read entities of zr_maintnotificationtp in local mode
      entity MaintItem
      all fields with corresponding #( keys )
      result data(result_items).

    result = value #( for r in result_items ( %tky   = r-%tky
                                              %param = r ) ).

  endmethod.

  method setItemInitialStatus.

    read entities of zr_maintnotificationtp in local mode
      entity MaintItem
      fields ( ItemStatus )
      with corresponding #( keys )
      result data(items).

    data update_table type table for update zr_maintnotificationtp\\MaintItem.

    update_table = value #( for item in items where ( ItemStatus is initial )
                                                    ( %tky       = item-%tky
                                                      ItemStatus = 'OP' ) ).

    if update_table is not initial.

      modify entities of zr_maintnotificationtp in local mode
        entity MaintItem
          update fields ( ItemStatus )
          with update_table.

    endif.

  endmethod.

endclass.
*=================================================

class lhc_zr_maintnotificationtp definition inheriting from cl_abap_behavior_handler.
  private section.
    methods:
      get_global_authorizations for global authorization
        importing
        request requested_authorizations for MaintNotification
        result result,
      setInitialStatus for determine on modify
        importing keys for MaintNotification~setInitialStatus.

    methods setSlaFromPriority for determine on modify
      importing keys for MaintNotification~setSlaFromPriority.

    methods validatePlant for validate on save
      importing keys for MaintNotification~validatePlant.
    methods get_instance_features for instance features
      importing keys request requested_features for MaintNotification result result.

    methods changePriority for modify
      importing keys for action MaintNotification~changePriority result result.

*    methods createFromTemplate for modify
*      importing keys for action MaintNotification~createFromTemplate result result.

    methods reassignTechnician for modify
      importing keys for action MaintNotification~reassignTechnician result result.
    methods cancelNotification for modify
      importing keys for action MaintNotification~cancelNotification result result.

    methods complete for modify
      importing keys for action MaintNotification~complete result result.

*    methods markItemCancelled for modify
*      importing keys for action MaintNotification~markItemCancelled result result.
*
*    methods markItemCompleted for modify
*      importing keys for action MaintNotification~markItemCompleted result result.

    methods reOpen for modify
      importing keys for action MaintNotification~reOpen result result.

    methods startWork for modify
      importing keys for action MaintNotification~startWork result result.

    methods validateDamageCode for validate on save
      importing keys for MaintNotification~validateDamageCode.

    methods validateEquipment for validate on save
      importing keys for MaintNotification~validateEquipment.

    methods validateFuncLoc for validate on save
      importing keys for MaintNotification~validateFuncLoc.

    methods validateTechnician for validate on save
      importing keys for MaintNotification~validateTechnician.
    methods setPriorityFromUrgentKeyword for determine on modify
      importing keys for MaintNotification~setPriorityFromUrgentKeyword.
    methods createFromTemplate for modify
      importing keys for action MaintNotification~createFromTemplate.

endclass.

class lhc_zr_maintnotificationtp implementation.
  method get_global_authorizations.
  endmethod.
  method setInitialStatus.
    read entities of ZR_MaintNotificationTP in local mode
      entity MaintNotification fields ( Status ) with corresponding #( keys )
      result data(notifs).
    modify entities of ZR_MaintNotificationTP in local mode
      entity MaintNotification update fields ( Status )
      with value #( for n in notifs where ( Status is initial )
                                          ( %tky = n-%tky Status = '101' ) ).
  endmethod.

  method setSlaFromPriority.
    read entities of ZR_MaintNotificationTP in local mode
      entity MaintNotification fields ( Priority ) with corresponding #( keys )
      result data(notifs).
    modify entities of ZR_MaintNotificationTP in local mode
      entity MaintNotification update fields ( SlaHours )
      with value #( for n in notifs
                    ( %tky     = n-%tky
                      SlaHours = switch #( n-Priority
                                           when '1' then 4
                                           when '2' then 8
                                           when '3' then 24
                                           when '4' then 72
                                           else 72 ) ) ).
  endmethod.

  method validatePlant.
    read entities of ZR_MaintNotificationTP in local mode
      entity MaintNotification fields ( PlantId ) with corresponding #( keys )
      result data(notifs).

    " 1) ALWAYS clear this validation's state area first — removes stale messages
    loop at notifs assigning field-symbol(<n>).
      append value #( %tky        = <n>-%tky
                      %state_area = 'VALIDATE_PLANT' ) to reported-maintnotification.
    endloop.

    types: begin of ty_plant,
             plant_id type zmaint_plant-plant_id,
           end of ty_plant.
    data plants type sorted table of ty_plant with unique key plant_id.

    if notifs is not initial.
      select plant_id from zmaint_plant
        for all entries in @notifs
        where plant_id = @notifs-PlantId
        into table @plants.
    endif.

    loop at notifs into data(n).
      if n-PlantId is initial or not line_exists( plants[ plant_id = n-PlantId ] ).
        append value #( %tky = n-%tky ) to failed-maintnotification.
        append value #( %tky             = n-%tky
                        %state_area      = 'VALIDATE_PLANT'      " ← same area as the reset
                        %msg             = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Plant { n-PlantId } is not valid| )
                        %element-PlantId = if_abap_behv=>mk-on ) to reported-maintnotification.
      endif.
    endloop.
  endmethod.
  method get_instance_features.
  endmethod.

  method changePriority.

    data: notifs_for_update type table for update zr_maintnotificationtp\\MaintNotification.

    "Validación: la nueva prioridad no puede venir vacía
    data(keys_valid_priority) = keys.

    loop at keys_valid_priority assigning field-symbol(<fs_key_valid_priority>)
       where %param-priority is initial.

      append value #( %tky = <fs_key_valid_priority>-%tky ) to failed-maintnotification.

      append value #( %tky = <fs_key_valid_priority>-%tky
                      %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     = 'Please select a Priority' )
                    ) to reported-maintnotification.

      data(lv_error) = abap_true.

    endloop.

    check lv_error ne abap_true.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( Status )
      with corresponding #( keys )
      result data(notifs).

    loop at notifs assigning field-symbol(<fs_notif>).

      data(new_priority) = keys[ key id %tky = <fs_notif>-%tky ]-%param-priority.

      if <fs_notif>-Status = '109' or <fs_notif>-Status = '103'.

        append value #( %tky = <fs_notif>-%tky ) to failed-maintnotification.
        append value #( %tky = <fs_notif>-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Cannot change Priority on Completed/Cancelled notifications' )
                      ) to reported-maintnotification.

        continue.

      endif.

      append value #( %tky     = <fs_notif>-%tky
                      Priority = new_priority ) to notifs_for_update.

    endloop.

    if notifs_for_update is not initial.

      modify entities of zr_maintnotificationtp in local mode
        entity MaintNotification
          update fields ( Priority )
          with notifs_for_update.

    endif.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      all fields with corresponding #( keys )
      result data(result_notifs).

    result = value #( for r in result_notifs ( %tky   = r-%tky
                                               %param = r ) ).

  endmethod.

*  METHOD createFromTemplate.
*  ENDMETHOD.

  method reassignTechnician.

    data: notifs_for_update type table for update zr_maintnotificationtp\\MaintNotification.

    "Validación: el nuevo técnico no puede venir vacío
    data(keys_valid_tech) = keys.

    loop at keys_valid_tech assigning field-symbol(<fs_key_valid_tech>)
       where %param-new_technician is initial.

      append value #( %tky = <fs_key_valid_tech>-%tky ) to failed-maintnotification.

      append value #( %tky = <fs_key_valid_tech>-%tky
                      %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     = 'Please select a Technician' )
                    ) to reported-maintnotification.

      data(lv_error) = abap_true.

    endloop.

    check lv_error ne abap_true.

    "Leer Status actual de las notificaciones seleccionadas
    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( Status )
      with corresponding #( keys )
      result data(notifs).

    "Validar que el técnico nuevo exista en la tabla maestra
    data technicians type sorted table of zmaint_techns with unique key client technician_id.

    select from zmaint_techns as ddbb
             fields ddbb~technician_id, ddbb~is_available
             into table @data(all_technicians).

    loop at notifs assigning field-symbol(<fs_notif>).

      data(new_tech) = keys[ key id %tky = <fs_notif>-%tky ]-%param-new_technician.

      if <fs_notif>-Status = '109' or <fs_notif>-Status = '103'.

        append value #( %tky = <fs_notif>-%tky ) to failed-maintnotification.
        append value #( %tky = <fs_notif>-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Cannot reassign Technician on Completed/Cancelled notifications' )
                      ) to reported-maintnotification.

        continue.

      endif.

      read table all_technicians into data(tech_master) with key technician_id = new_tech.

      if sy-subrc <> 0.

        append value #( %tky = <fs_notif>-%tky ) to failed-maintnotification.
        append value #( %tky = <fs_notif>-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Technician { new_tech } is not valid| )
                      ) to reported-maintnotification.

        continue.

      endif.

      if tech_master-is_available <> 'Available'.

        "Warning, no bloquea
        append value #( %tky = <fs_notif>-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-warning
                        text     = |Technician { new_tech } is currently { tech_master-is_available }| )
                      ) to reported-maintnotification.

      endif.

      append value #( %tky         = <fs_notif>-%tky
                      TechnicianID = new_tech ) to notifs_for_update.

    endloop.

    if notifs_for_update is not initial.

      modify entities of zr_maintnotificationtp in local mode
        entity MaintNotification
          update fields ( TechnicianID )
          with notifs_for_update.

    endif.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      all fields with corresponding #( keys )
      result data(result_notifs).

    result = value #( for r in result_notifs ( %tky   = r-%tky
                                               %param = r ) ).

  endmethod.

  method cancelNotification.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( Status )
      with corresponding #( keys )
      result data(notifs).

    loop at notifs into data(notif).
      if notif-Status = '103'.
        append value #( %tky = notif-%tky ) to failed-maintnotification.
        append value #( %tky = notif-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Completed notifications cannot be cancelled' )
                      ) to reported-maintnotification.
      endif.
    endloop.

    modify entities of zr_maintnotificationtp in local mode
      entity MaintNotification
        update fields ( Status )
        with value #( for n in notifs where ( Status <> '103' )
                                            ( %tky   = n-%tky
                                              Status = '109' ) ).

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      all fields with corresponding #( keys )
      result data(result_notifs).

    result = value #( for r in result_notifs ( %tky   = r-%tky
                                               %param = r ) ).

  endmethod.

  method complete.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( Status )
      with corresponding #( keys )
      result data(notifs).

    " Leer los items hijos de cada notificación seleccionada vía la asociación
    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      by \_MaintItem
      fields ( ItemStatus )
      with corresponding #( keys )
      result data(items)
      link data(links).

    data update_table type table for update zr_maintnotificationtp\\MaintNotification.

    loop at notifs into data(notif).

      if notif-Status = '109'.

        append value #( %tky = notif-%tky ) to failed-maintnotification.
        append value #( %tky = notif-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Cancelled notifications cannot be completed' )
                      ) to reported-maintnotification.

        continue.

      endif.

      " Contar items que aún no están cerrados (CO/CA)
      data(open_item_count) = 0.

      loop at links into data(link) where source-%tky = notif-%tky.

        read table items into data(item)
          with key %tky = link-target-%tky.

        if sy-subrc = 0 and item-ItemStatus <> 'CO' and item-ItemStatus <> 'CA'.
          open_item_count = open_item_count + 1.
        endif.

      endloop.

      if open_item_count > 0.

        data(item_word) = cond string( when open_item_count = 1 then 'item is' else 'items are' ).

        append value #( %tky = notif-%tky ) to failed-maintnotification.
        append value #( %tky = notif-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |{ open_item_count } { item_word } still Open, In Process, or Waiting for Parts| )
                      ) to reported-maintnotification.

        continue.

      endif.

      " Si llegó hasta aquí: status no es Cancelled y todos los items están cerrados
      append value #( %tky   = notif-%tky
                      Status = '103' ) to update_table.

    endloop.

    if update_table is not initial.

      modify entities of zr_maintnotificationtp in local mode
        entity MaintNotification
          update fields ( Status )
          with update_table.

    endif.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      all fields with corresponding #( keys )
      result data(result_notifs).

    result = value #( for r in result_notifs ( %tky   = r-%tky
                                               %param = r ) ).

  endmethod.

  method reOpen.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( Status )
      with corresponding #( keys )
      result data(notifs).

    loop at notifs into data(notif).
      if notif-Status <> '103' and notif-Status <> '109'.
        append value #( %tky = notif-%tky ) to failed-maintnotification.
        append value #( %tky = notif-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Only Completed or Cancelled notifications can be reopened' )
                      ) to reported-maintnotification.
      endif.
    endloop.

    modify entities of zr_maintnotificationtp in local mode
      entity MaintNotification
        update fields ( Status )
        with value #( for n in notifs where ( Status = '103' or Status = '109' )
                                            ( %tky   = n-%tky
                                              Status = '101' ) ).

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      all fields with corresponding #( keys )
      result data(result_notifs).

    result = value #( for r in result_notifs ( %tky   = r-%tky
                                               %param = r ) ).

  endmethod.

  method startWork.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( Status )
      with corresponding #( keys )
      result data(notifs).

    loop at notifs into data(notif).
      if notif-Status <> '101'.
        append value #( %tky = notif-%tky ) to failed-maintnotification.
        append value #( %tky = notif-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Only Open notifications can start work' )
                      ) to reported-maintnotification.
      endif.
    endloop.

    modify entities of zr_maintnotificationtp in local mode
      entity MaintNotification
        update fields ( Status )
        with value #( for n in notifs where ( Status = '101' )
                                            ( %tky   = n-%tky
                                              Status = '102' ) ).

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      all fields with corresponding #( keys )
      result data(result_notifs).

    result = value #( for r in result_notifs ( %tky   = r-%tky
                                               %param = r ) ).

  endmethod.

  method validateDamageCode.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( DamageCodeID )
      with corresponding #( keys )
      result data(notifs).

    data damage_codes type sorted table of zmaint_dmgc with unique key client damage_code.

    damage_codes = corresponding #( notifs discarding duplicates mapping damage_code = DamageCodeID except * ).
    delete damage_codes where damage_code is initial.

    if damage_codes is not initial.

      select from zmaint_dmgc as ddbb
               inner join @damage_codes as http_req on ddbb~damage_code eq http_req~damage_code
               fields ddbb~damage_code
               into table @data(valid_damage_codes).

    endif.

    loop at notifs into data(notif).

      append value #( %tky        = notif-%tky
                      %state_area = 'VALIDATE_DAMAGE_CODE' ) to reported-maintnotification.

      if notif-DamageCodeID is initial.

        append value #( %tky = notif-%tky ) to failed-maintnotification.

        append value #( %tky                  = notif-%tky
                        %state_area           = 'VALIDATE_DAMAGE_CODE'
                        %msg                  = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Please enter a Damage Code' )
                        %element-DamageCodeID = if_abap_behv=>mk-on
                      ) to reported-maintnotification.

      elseif notif-DamageCodeID is not initial and not line_exists( valid_damage_codes[ damage_code = notif-DamageCodeID ] ).

        append value #( %tky = notif-%tky ) to failed-maintnotification.

        append value #( %tky                  = notif-%tky
                        %state_area           = 'VALIDATE_DAMAGE_CODE'
                        %msg                  = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Damage Code { notif-DamageCodeID } is not valid| )
                        %element-DamageCodeID = if_abap_behv=>mk-on
                      ) to reported-maintnotification.

      endif.

    endloop.

  endmethod.
  method validateTechnician.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( TechnicianID )
      with corresponding #( keys )
      result data(notifs).

    data technicians type sorted table of zmaint_techns with unique key client technician_id.

    technicians = corresponding #( notifs discarding duplicates mapping technician_id = TechnicianID except * ).
    delete technicians where technician_id is initial.

    if technicians is not initial.

      select from zmaint_techns as ddbb
               inner join @technicians as http_req on ddbb~technician_id eq http_req~technician_id
               fields ddbb~technician_id
               into table @data(valid_technicians).

    endif.

    loop at notifs into data(notif).

      append value #( %tky        = notif-%tky
                      %state_area = 'VALIDATE_TECHNICIAN' ) to reported-maintnotification.

      if notif-TechnicianID is initial.

        append value #( %tky = notif-%tky ) to failed-maintnotification.

        append value #( %tky                  = notif-%tky
                        %state_area           = 'VALIDATE_TECHNICIAN'
                        %msg                  = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Please enter a Technician' )
                        %element-TechnicianID = if_abap_behv=>mk-on
                      ) to reported-maintnotification.

      elseif notif-TechnicianID is not initial and not line_exists( valid_technicians[ technician_id = notif-TechnicianID ] ).

        append value #( %tky = notif-%tky ) to failed-maintnotification.

        append value #( %tky                  = notif-%tky
                        %state_area           = 'VALIDATE_TECHNICIAN'
                        %msg                  = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Technician { notif-TechnicianID } is not valid| )
                        %element-TechnicianID = if_abap_behv=>mk-on
                      ) to reported-maintnotification.

      endif.

    endloop.

  endmethod.

  method validateEquipment.

    "Lee el EquipmentID y PlantId
    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( EquipmentID PlantId )
      with corresponding #( keys )
      result data(notifs).

    data equipments type sorted table of zmaint_equip with unique key client equipment_id.

    equipments = corresponding #( notifs discarding duplicates mapping equipment_id = EquipmentID except * ).
    delete equipments where equipment_id is initial.

    if equipments is not initial.

      select from zmaint_equip as ddbb
               inner join @equipments as http_req on ddbb~equipment_id eq http_req~equipment_id
               fields ddbb~equipment_id, ddbb~plant_id
               into table @data(valid_equipments).

    endif.

    loop at notifs into data(notif).

      append value #( %tky        = notif-%tky
                      %state_area = 'VALIDATE_EQUIPMENT' ) to reported-maintnotification.

      if notif-EquipmentID is initial.

        append value #( %tky = notif-%tky ) to failed-maintnotification.

        append value #( %tky                 = notif-%tky
                        %state_area          = 'VALIDATE_EQUIPMENT'
                        %msg                 = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Please enter an Equipment' )
                        %element-EquipmentID = if_abap_behv=>mk-on
                      ) to reported-maintnotification.

      elseif notif-EquipmentID is not initial and not line_exists( valid_equipments[ equipment_id = notif-EquipmentID ] ).

        append value #( %tky = notif-%tky ) to failed-maintnotification.

        append value #( %tky                 = notif-%tky
                        %state_area          = 'VALIDATE_EQUIPMENT'
                        %msg                 = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Equipment { notif-EquipmentID } is not valid| )
                        %element-EquipmentID = if_abap_behv=>mk-on
                      ) to reported-maintnotification.

      elseif valid_equipments[ equipment_id = notif-EquipmentID ]-plant_id <> notif-PlantId.

        append value #( %tky = notif-%tky ) to failed-maintnotification.

        append value #( %tky                 = notif-%tky
                        %state_area          = 'VALIDATE_EQUIPMENT'
                        %msg                 = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Equipment { notif-EquipmentID } does not belong to Plant { notif-PlantId }| )
                        %element-EquipmentID = if_abap_behv=>mk-on
                      ) to reported-maintnotification.

      endif.

    endloop.

  endmethod.

  method validateFuncLoc.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( FuncLocId PlantId )
      with corresponding #( keys )
      result data(notifs).

    data funclocs type sorted table of zmaint_funcloca with unique key client funcloc_id.

    funclocs = corresponding #( notifs discarding duplicates mapping funcloc_id = FuncLocId except * ).
    delete funclocs where funcloc_id is initial.

    if funclocs is not initial.

      select from zmaint_funcloca as ddbb
               inner join @funclocs as http_req on ddbb~funcloc_id eq http_req~funcloc_id
               fields ddbb~funcloc_id, ddbb~plant_id
               into table @data(valid_funclocs).

    endif.

    loop at notifs into data(notif).

      append value #( %tky        = notif-%tky
                      %state_area = 'VALIDATE_FUNC_LOC' ) to reported-maintnotification.

      if notif-FuncLocId is initial.

        append value #( %tky = notif-%tky ) to failed-maintnotification.

        append value #( %tky               = notif-%tky
                        %state_area        = 'VALIDATE_FUNC_LOC'
                        %msg               = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Please enter a Functional Location' )
                        %element-FuncLocId = if_abap_behv=>mk-on
                      ) to reported-maintnotification.

      elseif notif-FuncLocId is not initial and not line_exists( valid_funclocs[ funcloc_id = notif-FuncLocId ] ).

        append value #( %tky = notif-%tky ) to failed-maintnotification.

        append value #( %tky               = notif-%tky
                        %state_area        = 'VALIDATE_FUNC_LOC'
                        %msg               = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Functional Location { notif-FuncLocId } is not valid| )
                        %element-FuncLocId = if_abap_behv=>mk-on
                      ) to reported-maintnotification.

      elseif valid_funclocs[ funcloc_id = notif-FuncLocId ]-plant_id <> notif-PlantId.

        append value #( %tky = notif-%tky ) to failed-maintnotification.

        append value #( %tky               = notif-%tky
                        %state_area        = 'VALIDATE_FUNC_LOC'
                        %msg               = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Functional Location { notif-FuncLocId } does not belong to Plant { notif-PlantId }| )
                        %element-FuncLocId = if_abap_behv=>mk-on
                      ) to reported-maintnotification.

      endif.

    endloop.

  endmethod.


  method setPriorityFromUrgentKeyword.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( Description Priority )
      with corresponding #( keys )
      result data(notifs).

    data update_table type table for update zr_maintnotificationtp\\MaintNotification.

    loop at notifs into data(notif).
      if to_upper( notif-Description ) cs 'URGENT' and notif-Priority <> '1'.
        append value #( %tky     = notif-%tky
                        Priority = '1' ) to update_table.
      endif.
    endloop.

    if update_table is not initial.

      modify entities of zr_maintnotificationtp in local mode
        entity MaintNotification
          update fields ( Priority )
          with update_table.

    endif.

  endmethod.

  method createFromTemplate.

    read entities of zr_maintnotificationtp in local mode
      entity MaintNotification
      fields ( PlantID EquipmentID DamageCodeID FuncLocId Priority Description )
      with corresponding #( keys )
      result data(templates).

    data create_table type table for create zr_maintnotificationtp\\MaintNotification.

    loop at templates into data(template).

      data(copy_desc) = keys[ key id %tky = template-%tky ]-%param-copy_description.

      append value #(
        %cid                   = keys[ key id %tky = template-%tky ]-%cid
        %is_draft              = if_abap_behv=>mk-on
        %control-PlantID       = if_abap_behv=>mk-on
        %control-EquipmentID   = if_abap_behv=>mk-on
        %control-DamageCodeID  = if_abap_behv=>mk-on
        %control-FuncLocId     = if_abap_behv=>mk-on
        %control-Priority      = if_abap_behv=>mk-on
        %control-Description   = if_abap_behv=>mk-on
        PlantID                = template-PlantID
        EquipmentID            = template-EquipmentID
        DamageCodeID           = template-DamageCodeID
        FuncLocId              = template-FuncLocId
        Priority               = template-Priority
        Description            = cond #( when copy_desc = abap_true then template-Description else '' )
      ) to create_table.

    endloop.

    modify entities of zr_maintnotificationtp in local mode
      entity MaintNotification
        create fields ( PlantID EquipmentID DamageCodeID FuncLocId Priority Description )
        with create_table
      mapped data(create_mapped)
      failed data(create_failed)
      reported data(create_reported).

    insert lines of create_mapped-maintnotification into table mapped-maintnotification.
    insert lines of create_failed-maintnotification into table failed-maintnotification.
    insert lines of create_reported-maintnotification into table reported-maintnotification.

  endmethod.


endclass.

