INTERFACE zif_dn_data_generator PUBLIC.

  TYPES: BEGIN OF ty_counts,
           plants        TYPE i,
           damage_codes  TYPE i,
           equipment     TYPE i,
           funclocs TYPE i,
           notifications TYPE i,
           items         TYPE i,
         END OF ty_counts.

  TYPES: BEGIN OF ty_notif_map,
           name       TYPE string,
           notif_uuid TYPE sysuuid_x16,
         END OF ty_notif_map,
         tt_notif_map TYPE SORTED TABLE OF ty_notif_map WITH UNIQUE KEY name.

  METHODS reset.
  METHODS seed RETURNING VALUE(rs_counts) TYPE ty_counts.

ENDINTERFACE.
