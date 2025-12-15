CLASS zcl_bs_demo_xco_bal DEFINITION
  PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS
      main REDEFINITION.

  PRIVATE SECTION.
    METHODS create_log
      IMPORTING external_id   TYPE if_xco_cp_bal_log_header=>tv_external_id
      RETURNING VALUE(result) TYPE REF TO if_xco_cp_bal_log.

    METHODS get_message
      RETURNING VALUE(result) TYPE REF TO if_xco_message.

    METHODS get_strings
      RETURNING VALUE(result) TYPE REF TO if_xco_strings.

    METHODS read_log
      IMPORTING !out    TYPE REF TO if_xco_adt_classrun_out
                !handle TYPE sxco_bal_log_handle.

    METHODS search_log
      IMPORTING !out TYPE REF TO if_xco_adt_classrun_out.
ENDCLASS.


CLASS zcl_bs_demo_xco_bal IMPLEMENTATION.
  METHOD main.
    DATA(log) = create_log( 'TEST_H01' ).
    create_log( 'TEST_H02' ).
    create_log( 'TEST_H03' ).
    create_log( 'TEST_L01' ).
    create_log( 'TEST_L02' ).
    create_log( 'TEST_L03' ).

    out->write( log ).
    out->write( log->handle ).

    read_log( out    = out
              handle = log->handle ).

    search_log( out ).
  ENDMETHOD.


  METHOD create_log.
    DATA(log) = xco_cp_bal=>for->database( )->log->create( iv_object      = 'ZBS_XCO_LOG'
                                                           iv_subobject   = 'TEST'
                                                           iv_external_id = external_id ).

    log->add_message( get_message( )->value ).
    log->add_exception( NEW cx_sy_itab_line_not_found( ) ).
    log->add_news( get_strings( ) ).
    log->add_text( get_strings( ) ).

    result = log.
  ENDMETHOD.


  METHOD get_message.
    MESSAGE w001(zbs_demo_xco) WITH 'Method' 'Message' INTO DATA(dummy_message) ##NEEDED.
    RETURN xco_cp=>sy->message( ).
  ENDMETHOD.


  METHOD get_strings.
    RETURN xco_cp=>strings( VALUE #( ( CONV #( xco_cp=>uuid( )->value ) )
                                     ( CONV #( xco_cp=>uuid( )->value ) ) ) ).
  ENDMETHOD.


  METHOD read_log.
    DATA(log) = xco_cp_bal=>for->database( )->log->load( handle ).

    LOOP AT log->messages->all->get( ) INTO DATA(message).
      out->plain->write( message->value-message->get_text( ) ).
      out->plain->write( message->value-level_of_detail->value ).
      out->plain->write( message->value-timestamp->value ).
    ENDLOOP.
  ENDMETHOD.


  METHOD search_log.
    DATA(filter_external_id) = xco_cp_bal=>log_filter->external_id(
        xco_cp_abap_sql=>constraint->contains_pattern( '*02*' ) ).

    DATA(found_logs) = xco_cp_bal=>for->database( )->logs->where( VALUE #( ( filter_external_id ) ) )->get( ).

    LOOP AT found_logs INTO DATA(log).
      out->write( log->handle ).
      out->write( log->header->get_external_id( ) ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
