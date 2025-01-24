CLASS zcl_bs_demo_xco_uuid DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS operation_for_uuid_x16
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

    METHODS operation_for_uuid_c22
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

    METHODS operation_for_uuid_formatter
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

    METHODS operation_convert_uuid
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.


CLASS zcl_bs_demo_xco_uuid IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    operation_for_uuid_x16( out ).
    operation_for_uuid_c22( out ).
    operation_for_uuid_formatter( out ).
    operation_convert_uuid( out ).
  ENDMETHOD.


  METHOD operation_for_uuid_x16.
    DATA uuid TYPE sysuuid_x16.

    " Classic
*    CALL FUNCTION 'GUID_CREATE'
*      IMPORTING
*        ev_guid_16 = ld_uuid.

    " Modern
    TRY.
        uuid = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
    ENDTRY.

    " XCO
    uuid = xco_cp=>uuid( )->value.
  ENDMETHOD.


  METHOD operation_for_uuid_c22.
    DATA char_uuid TYPE c LENGTH 22.

    " Classic
*    CALL FUNCTION 'GUID_CREATE'
*      IMPORTING
*        ev_guid_22 = char_uuid.

    " Modern
    TRY.
        char_uuid = cl_system_uuid=>create_uuid_c22_static( ).
      CATCH cx_uuid_error.
    ENDTRY.

    " XCO
    char_uuid = xco_cp=>uuid( )->as( xco_cp_uuid=>format->c22 )->value.
  ENDMETHOD.


  METHOD operation_for_uuid_formatter.
    DATA(uuid_c22) = xco_cp=>uuid( )->as( xco_cp_uuid=>format->c22 )->value.
    out->write( uuid_c22 ).

    DATA(uuid_c32) = xco_cp=>uuid( )->as( xco_cp_uuid=>format->c32 )->value.
    out->write( uuid_c32 ).

    DATA(uuid_c36) = xco_cp=>uuid( )->as( xco_cp_uuid=>format->c36 )->value.
    out->write( uuid_c36 ).
  ENDMETHOD.


  METHOD operation_convert_uuid.
    DATA(uuid) = xco_cp_uuid=>format->c36->to_uuid( `BAF0A1E7-5FB0-1EDF-B5E8-89F53894CA3A` ).
    out->write( uuid->value ).
  ENDMETHOD.
ENDCLASS.
