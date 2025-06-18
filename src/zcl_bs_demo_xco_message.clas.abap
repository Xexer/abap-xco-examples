CLASS zcl_bs_demo_xco_message DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bs_demo_xco_message IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(message) = xco_cp=>message( VALUE #( msgid = 'ZBS_DEMO_XCO'
                                              msgno = '001'
                                              msgty = 'W'
                                              msgv1 = 'Message'
                                              msgv2 = 'Placeholder' ) ).

    DATA(compare) = xco_cp=>message( VALUE #( msgid = 'ZBS_DEMO_XCO'
                                              msgno = '001'
                                              msgty = 'W'
                                              msgv1 = 'Test'
                                              msgv2 = 'Compare' ) ).

    out->write( message->value ).
    out->write( message->get_text( ) ).

    DATA(type) = message->get_type( ).
    out->write( type->value ).
    out->write( type->occurs_in( compare ) ).
    out->write( xco_cp_message=>type->warning->occurs_in( message ) ).

    DATA(overwrite) = message->overwrite( iv_msgv2 = 'New' ).
    out->write( overwrite->get_text( ) ).

    DATA(short) = message->get_short_text( ).
    out->write( short->if_xco_text~get_lines( )->value ).

    DATA(new_place) = message->place_string( iv_string = `Place me`
                                             iv_msgv2  = abap_true ).
    out->write( new_place->get_text( ) ).

    DATA(message_container) = xco_cp=>messages( VALUE #( ( message ) ( compare ) ) ).

    LOOP AT message_container->value INTO DATA(local_message).
      out->write( local_message->get_text( ) ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
