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

  DELETE FROM zmaint_itemstat.
  DELETE FROM zmaint_techns.


    insert zmaint_itemstat from table @( value #(
                                           ( item_status = 'OP' status_text = 'Open'       )
                                           ( item_status = 'IP' status_text = 'In Process'        )
                                           ( item_status = 'WP' status_text = 'Waiting Parts'        )
                                           ( item_status = 'CO' status_text = 'Completed' )
                                           ( item_status = 'CA' status_text = 'Canceled'  ) ) ).

    if sy-subrc = 0.
      out->write( 'Damage codes inserted successfully.' ).
    else.
      out->write( 'Error inserting damage codes.' ).
    endif.

    insert zmaint_techns from table @( value #(
          ( technician_id = 'T_SWINDSLAND'
            sap_user      = 'SWINDSLAND'
            first_name    = 'Stian'
            last_name     = 'Windsland'
            email         = 'stian@edu.cdv.pl'
            phone         = '+47 912 34 567'
            is_available  = 'Available' )

          ( technician_id = 'T_SOWINDSLAN'
            sap_user      = 'SOWINDSLAND'
            first_name    = 'Solve'
            last_name     = 'Windsland'
            email         = 'solve@edu.cdv.pl'
            phone         = '+47 415 88 234'
            is_available  = 'Busy' )

          ( technician_id = 'T_FCASAS'
            sap_user      = 'FCASAS'
            first_name    = 'Freddy'
            last_name     = 'Casas'
            email         = 'freddy@edu.cdv.pl'
            phone         = '+47 988 12 345'
            is_available  = 'Unavailable' )

          ( technician_id = 'T_PSOBIK'
            sap_user      = 'PSOBIK'
            first_name    = 'Paulina'
            last_name     = 'Sobik'
            email         = 'paulina@edu.cdv.pl'
            phone         = '+47 905 43 210'
            is_available  = 'Busy' )

          ( technician_id = 'T_SUWINDSLAN'
            sap_user      = 'SUWINDSLAND'
            first_name    = 'Susan'
            last_name     = 'Windsland'
            email         = 'susan@edu.cdv.pl'
            phone         = '+47 481 99 876'
            is_available  = 'Available' )
    ) ).

  endmethod.

endclass.
