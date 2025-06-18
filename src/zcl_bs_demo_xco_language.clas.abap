CLASS zcl_bs_demo_xco_language DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS output_configuration
      IMPORTING !out      TYPE REF TO if_oo_adt_classrun_out
                !language TYPE REF TO if_xco_language.
ENDCLASS.


CLASS zcl_bs_demo_xco_language IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(language) = xco_cp=>language( 'D' ).

    output_configuration( out      = out
                          language = language ).

    language = xco_cp=>language( 'E' ).

    output_configuration( out      = out
                          language = language ).
  ENDMETHOD.


  METHOD output_configuration.
    out->write( language->value ).
    out->write( language->get_long_text_description( ) ).
    out->write( language->get_name( ) ).
    out->write( language->as( xco_cp_language=>format->iso_639 ) ).
  ENDMETHOD.
ENDCLASS.
