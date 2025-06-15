CLASS zcl_bs_demo_xco_generated DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    TYPES name TYPE c LENGTH 60.

    METHODS say_hello
      IMPORTING !name TYPE name DEFAULT 'Herbert'
                !out  TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.


CLASS zcl_bs_demo_xco_generated IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    say_hello( name = 'Bernd'
               out  = out ).
  ENDMETHOD.


  METHOD say_hello.
    out->write( |Hello { name }| ).
  ENDMETHOD.
ENDCLASS.
