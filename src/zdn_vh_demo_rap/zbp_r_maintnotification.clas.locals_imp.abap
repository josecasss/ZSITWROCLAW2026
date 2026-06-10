CLASS lhc_maintitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setItemNo FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MaintItem~setItemNo.

ENDCLASS.

CLASS lhc_maintitem IMPLEMENTATION.

  METHOD setItemNo.
  ENDMETHOD.

ENDCLASS.
*=================================================

CLASS lhc_zr_maintnotificationtp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR MaintNotification
        RESULT result,
      setInitialStatus FOR DETERMINE ON MODIFY
        IMPORTING keys FOR MaintNotification~setInitialStatus.

    METHODS setSlaFromPriority FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MaintNotification~setSlaFromPriority.

    METHODS validatePlant FOR VALIDATE ON SAVE
      IMPORTING keys FOR MaintNotification~validatePlant.
ENDCLASS.

CLASS lhc_zr_maintnotificationtp IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD setInitialStatus.
    READ ENTITIES OF ZR_MaintNotificationTP IN LOCAL MODE
      ENTITY MaintNotification FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(notifs).
    MODIFY ENTITIES OF ZR_MaintNotificationTP IN LOCAL MODE
      ENTITY MaintNotification UPDATE FIELDS ( Status )
      WITH VALUE #( FOR n IN notifs WHERE ( Status IS INITIAL )
                    ( %tky = n-%tky  Status = '101' ) ).
  ENDMETHOD.

  METHOD setSlaFromPriority.
    READ ENTITIES OF ZR_MaintNotificationTP IN LOCAL MODE
      ENTITY MaintNotification FIELDS ( Priority ) WITH CORRESPONDING #( keys )
      RESULT DATA(notifs).
    MODIFY ENTITIES OF ZR_MaintNotificationTP IN LOCAL MODE
      ENTITY MaintNotification UPDATE FIELDS ( SlaHours )
      WITH VALUE #( FOR n IN notifs
                    ( %tky    = n-%tky
                      SlaHours = SWITCH #( n-Priority
                                   WHEN '1' THEN 4
                                   WHEN '2' THEN 8
                                   WHEN '3' THEN 24
                                   WHEN '4' THEN 72
                                   ELSE 72 ) ) ).
  ENDMETHOD.

  METHOD validatePlant.
    READ ENTITIES OF ZR_MaintNotificationTP IN LOCAL MODE
      ENTITY MaintNotification FIELDS ( PlantId ) WITH CORRESPONDING #( keys )
      RESULT DATA(notifs).

    " 1) ALWAYS clear this validation's state area first — removes stale messages
    LOOP AT notifs ASSIGNING FIELD-SYMBOL(<n>).
      APPEND VALUE #( %tky        = <n>-%tky
                      %state_area = 'VALIDATE_PLANT' ) TO reported-maintnotification.
    ENDLOOP.

    TYPES: BEGIN OF ty_plant,
             plant_id TYPE zmaint_plant-plant_id,
           END OF ty_plant.
    DATA plants TYPE SORTED TABLE OF ty_plant WITH UNIQUE KEY plant_id.

    IF notifs IS NOT INITIAL.
      SELECT plant_id FROM zmaint_plant
        FOR ALL ENTRIES IN @notifs
        WHERE plant_id = @notifs-PlantId
        INTO TABLE @plants.
    ENDIF.

    LOOP AT notifs INTO DATA(n).
      IF n-PlantId IS INITIAL OR NOT line_exists( plants[ plant_id = n-PlantId ] ).
        APPEND VALUE #( %tky = n-%tky ) TO failed-maintnotification.
        APPEND VALUE #( %tky             = n-%tky
                        %state_area      = 'VALIDATE_PLANT'      " ← same area as the reset
                        %msg             = new_message_with_text(
                                             severity = if_abap_behv_message=>severity-error
                                             text     = |Plant { n-PlantId } is not valid| )
                        %element-PlantId = if_abap_behv=>mk-on ) TO reported-maintnotification.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
