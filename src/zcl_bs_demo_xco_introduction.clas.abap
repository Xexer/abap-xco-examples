CLASS zcl_bs_demo_xco_introduction DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bs_demo_xco_introduction IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(ld_string) = `This is my new text string`.

    out->write( xco_cp=>string( ld_string )->to_upper_case( )->append( ` with addition` )->split( ` ` )->value ).
    out->write( xco_cp=>string( ld_string )->value ).
  ENDMETHOD.
ENDCLASS.
