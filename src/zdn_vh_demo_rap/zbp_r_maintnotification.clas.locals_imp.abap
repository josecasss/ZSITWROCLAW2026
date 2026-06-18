class lhc_maintitem definition inheriting from cl_abap_behavior_handler.

  private section.

    methods setItemNo for determine on modify
      importing keys for MaintItem~setItemNo.

endclass.

CLASS lhc_maintitem IMPLEMENTATION.

  METHOD setItemNo.

    DATA: max_item_no TYPE i.
    DATA update_table TYPE TABLE FOR UPDATE zr_maintnotificationtp\\MaintItem.

    " Leer todos los items que necesitan ItemNo (incluye los nuevos del mismo lote)
    READ ENTITIES OF zr_maintnotificationtp IN LOCAL MODE
      ENTITY MaintItem
        FIELDS ( ItemNo NotifUuid )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    " Filtrar solo los que aún no tienen ItemNo
    DELETE items WHERE ItemNo IS NOT INITIAL.
    CHECK items IS NOT INITIAL.

    " --- FIX: si NotifUuid llegó vacío en algún item (puede pasar cuando
    "     notificación + items se crean juntos en el mismo draft), lo
    "     completamos con el NotifUuid que viene en la clave técnica %tky
    "     del propio item (NotifUuid es parte de esa clave compuesta).
    "     Solo se usa LOOP ... ASSIGNING, válido en ABAP Cloud.
    LOOP AT items ASSIGNING FIELD-SYMBOL(<it_fix>).
      IF <it_fix>-NotifUuid IS INITIAL.
        <it_fix>-NotifUuid = <it_fix>-%tky-NotifUuid.
      ENDIF.
    ENDLOOP.
    " --- fin del fix ---

    " Notificaciones únicas a procesar
    DATA(notif_uuids) = items.
    SORT notif_uuids BY NotifUuid.
    DELETE ADJACENT DUPLICATES FROM notif_uuids COMPARING NotifUuid.

    LOOP AT notif_uuids INTO DATA(notif_entry).

      " --- FIX 2: cuando agregás filas una por una en el draft (Fiori
      "     dispara una determinación por cada fila nueva, no en lote),
      "     READ ENTITIES BY \_MaintItem no alcanza a ver el ItemNo que
      "     se le asignó al hermano anterior en la llamada previa, porque
      "     esa lectura pasa por la capa transaccional RAP que puede no
      "     estar sincronizada todavía dentro de la misma sesión de draft.
      "     Por eso, en vez de READ ENTITIES, leemos el máximo directamente
      "     de la tabla de draft con SELECT, que sí ve lo que ya se grabó
      "     en la transacción anterior (mismo usuario, mismo draft).
      max_item_no = 0.

      " 1. Select into an inline variable (inherits the exact DB type, e.g., NUMC)
      SELECT SINGLE MAX( itemno )
        FROM zmaint_itemd
        WHERE notifuuid = @notif_entry-NotifUuid
        INTO @DATA(lv_max_draft).

      " 2. Assign to integer (ABAP handles the conversion safely)
      max_item_no = lv_max_draft.

      " 3. Do the same for the active table (por si el padre ya fue
      "    activado alguna vez y se sigue editando en un nuevo draft).
      SELECT SINGLE MAX( item_no )
        FROM zmaint_itema
        WHERE notif_uuid = @notif_entry-NotifUuid
        INTO @DATA(lv_max_act_field).

      " 4. Compare and assign
      IF lv_max_act_field > max_item_no.
        max_item_no = lv_max_act_field.
      ENDIF.
      " --- fin del fix 2 ---

      " Asignar números secuenciales a los items nuevos de este mismo lote.
      " Como 'items' ya tiene el NotifUuid corregido arriba, todos los
      " hermanos nuevos de la misma notificación caen aquí juntos y se
      " numeran en cadena: max+10, max+20, max+30...
      LOOP AT items INTO DATA(item) WHERE NotifUuid = notif_entry-NotifUuid.
        max_item_no = max_item_no + 10.
        APPEND VALUE #(
          %tky   = item-%tky
          ItemNo = max_item_no
        ) TO update_table.
      ENDLOOP.

    ENDLOOP.

    " Update all items with new ItemNo in a single MODIFY statement
    IF update_table IS NOT INITIAL.
      MODIFY ENTITIES OF zr_maintnotificationtp IN LOCAL MODE
        ENTITY MaintItem
          UPDATE FIELDS ( ItemNo )
          WITH update_table.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
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
endclass.

