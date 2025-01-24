CLASS zcl_bs_demo_xco_classrun DEFINITION
  PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS
      main REDEFINITION.

  PRIVATE SECTION.
    TYPES: BEGIN OF person,
             user_id    TYPE c LENGTH 12,
             name       TYPE string,
             birthday   TYPE d,
             size_in_cm TYPE i,
           END OF person.
    TYPES persons TYPE STANDARD TABLE OF person WITH EMPTY KEY.

    METHODS output_with_write
      IMPORTING !out TYPE REF TO if_xco_adt_classrun_out.

    METHODS output_with_write_text
      IMPORTING !out TYPE REF TO if_xco_adt_classrun_out.

    METHODS output_with_write_news
      IMPORTING !out TYPE REF TO if_xco_adt_classrun_out.

    METHODS use_plain_object
      IMPORTING !out TYPE REF TO if_xco_adt_classrun_out.

    METHODS get_persons
      RETURNING VALUE(result) TYPE persons.

    METHODS crash_me.

ENDCLASS.


CLASS zcl_bs_demo_xco_classrun IMPLEMENTATION.
  METHOD main.
    output_with_write( out ).
    output_with_write_text( out ).
    output_with_write_news( out ).
    use_plain_object( out ).
    crash_me( ).
  ENDMETHOD.


  METHOD get_persons.
    RETURN VALUE persons( ( user_id = 'P01' name = `Phillipp Kohl` birthday = '19850522' size_in_cm = 174 )
                          ( user_id = 'P02' name = `Ruth Z. Robinson` birthday = '19850107' size_in_cm = 168 )
                          ( user_id = 'P03' name = `James S. Richardson` birthday = '19921102' size_in_cm = 186 ) ).
  ENDMETHOD.


  METHOD output_with_write.
    DATA(simple_date) = CONV d( '20250228' ).
    DATA(my_string) = `ABAP can handle long texts as string!`.
    DATA(my_strings) = VALUE string_table( ( `ABAP can` ) ( `handle` ) ( `long texts` ) ( `as string!` ) ).
    DATA(persons) = get_persons( ).

    out->write( simple_date ).
    out->write( my_string ).
    out->write( my_strings ).
    out->write( persons[ 1 ] ).
    out->write( persons ).
  ENDMETHOD.


  METHOD output_with_write_text.
    DATA(xco_string) = xco_cp=>string( `ABAP can handle long texts as string!` ).
    DATA(xco_strings) = xco_cp=>strings( VALUE #( ( `ABAP can` ) ( `handle` ) ( `long texts` ) ( `as string!` ) ) ).
    DATA(xco_date) = xco_cp=>sy->date( ).
    DATA(xco_moment) = xco_cp=>sy->moment( ).

    out->write( xco_string ).
    out->write( xco_strings ).
    out->write( xco_date ).
    out->write( xco_moment ).
    out->write( xco_date->as( xco_cp_time=>format->abap ) ).
    out->write( xco_moment->as( xco_cp_time=>format->abap ) ).
  ENDMETHOD.


  METHOD output_with_write_news.
    MESSAGE w001(zbs_demo_xco) WITH 'Method' 'Message' INTO DATA(dummy_message).
    DATA(xco_message) = xco_cp=>sy->message( ).

    out->write_news( xco_message ).
  ENDMETHOD.


  METHOD use_plain_object.
    out->plain->write( get_persons( ) ).

*    DATA(console_output_raw) = out->plain->get( ).
  ENDMETHOD.


  METHOD crash_me.
    DATA(result_in_error) = 12 / 0.
  ENDMETHOD.
ENDCLASS.
