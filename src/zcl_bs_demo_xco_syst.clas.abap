CLASS zcl_bs_demo_xco_syst DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS user_name
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

    METHODS language
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

    METHODS date
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

    METHODS time
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

    METHODS system_message
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

    METHODS moment
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.


CLASS zcl_bs_demo_xco_syst IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    user_name( out ).
    language( out ).
    date( out ).
    time( out ).
    system_message( out ).
    moment( out ).
  ENDMETHOD.


  METHOD user_name.
    " Classic
    DATA(user_id) = sy-uname.
    out->write( user_id ).

    " XCO
    user_id = xco_cp=>sy->user( )->name.
    out->write( user_id ).
  ENDMETHOD.


  METHOD language.
    " Classic
    DATA(language_sap) = sy-langu.
    out->write( language_sap ).

    " XCO
    language_sap = xco_cp=>sy->language( )->value.
    out->write( language_sap ).

    DATA(short_name) = xco_cp=>sy->language( )->get_name( ).
    out->write( short_name ).

    DATA(long_name) = xco_cp=>sy->language( )->get_long_text_description( ).
    out->write( long_name ).

    DATA(language_iso) = xco_cp=>sy->language( )->as( xco_cp_language=>format->iso_639 ).
    out->write( language_iso ).
  ENDMETHOD.


  METHOD date.
    " Classic
    DATA(system_date) = sy-datum.
    out->write( system_date ).

    " XCO
    system_date = xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value.
    out->write( system_date ).

    DATA(iso_8601_basic) = xco_cp=>sy->date( )->as( xco_cp_time=>format->iso_8601_basic )->value.
    out->write( iso_8601_basic ).

    DATA(iso_8601_extended) = xco_cp=>sy->date( )->as( xco_cp_time=>format->iso_8601_extended )->value.
    out->write( iso_8601_extended ).

    DATA(date_year) = xco_cp=>sy->date( )->year.
    DATA(date_month) = xco_cp=>sy->date( )->month.
    DATA(date_day) = xco_cp=>sy->date( )->day.

    out->write( date_year ).
    out->write( date_month ).
    out->write( date_day ).

    DATA(last_week) = xco_cp=>sy->date( )->subtract( iv_day = 7 )->as( xco_cp_time=>format->abap )->value.
    out->write( last_week ).

    DATA(year_2000) = xco_cp=>sy->date( )->overwrite( iv_year = 2000 )->as( xco_cp_time=>format->abap )->value.
    out->write( year_2000 ).
  ENDMETHOD.


  METHOD time.
    " Classic
    DATA(system_time) = sy-uzeit.
    out->write( system_time ).

    " XCO
    system_time = xco_cp=>sy->time( )->as( xco_cp_time=>format->abap )->value.
    out->write( system_time ).
  ENDMETHOD.


  METHOD system_message.
    MESSAGE w001(zbs_demo_xco) WITH 'Method' 'Message' INTO DATA(dummy_message).

    " Classic
    DATA(message_id) = sy-msgid.
    DATA(message_number) = sy-msgno.
    DATA(message_type) = sy-msgty.
    DATA(message_v1) = sy-msgv1.

    out->write( message_id ).
    out->write( message_number ).
    out->write( message_type ).
    out->write( message_v1 ).

    " XCO
    DATA(xco_message) = xco_cp=>sy->message( ).
    message_id = xco_message->value-msgid.
    message_number = xco_message->value-msgno.
    message_type = xco_message->value-msgty.
    message_v1 = xco_message->value-msgv1.

    out->write( message_id ).
    out->write( message_number ).
    out->write( message_type ).
    out->write( message_v1 ).
  ENDMETHOD.


  METHOD moment.
    DATA(moment_user) = xco_cp=>sy->moment( xco_cp_time=>time_zone->user ).
    DATA(moment_utc) = xco_cp=>sy->moment( xco_cp_time=>time_zone->utc ).

    DATA(output_format_abap) = moment_user->as( xco_cp_time=>format->abap )->value.
    DATA(output_format_basic) = moment_user->as( xco_cp_time=>format->iso_8601_basic )->value.
    DATA(output_format_extended) = moment_user->as( xco_cp_time=>format->iso_8601_extended )->value.

    out->write( output_format_abap ).
    out->write( output_format_basic ).
    out->write( output_format_extended ).

    DATA(future) = xco_cp=>sy->moment( )->add( iv_day = 1 ).

    IF moment_user->is_before( future ).
      out->write( `The future is not here ...` ).
    ENDIF.

    DATA(from_moment_to_future) = moment_user->interval_to( future ).
    out->write( from_moment_to_future->contains( moment_utc ) ).
  ENDMETHOD.
ENDCLASS.
