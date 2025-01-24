CLASS zcl_bs_demo_xco_pcre_test DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    CONSTANTS c_string TYPE string VALUE `This is my new string class.`.
    CONSTANTS c_regex  TYPE string VALUE `\w*is\w*`.
ENDCLASS.



CLASS ZCL_BS_DEMO_XCO_PCRE_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA lt_parts TYPE string_table.

    " Classic
    FIND ALL OCCURRENCES OF PCRE c_regex IN c_string RESULTS DATA(lt_found).
    LOOP AT lt_found INTO DATA(ls_found).
      INSERT c_string+ls_found-offset(ls_found-length) INTO TABLE lt_parts.
    ENDLOOP.

    out->write( `Classic:` ).
    out->write( lt_parts ).

    CLEAR lt_parts.

    " Modern
    DATA(ld_start) = 0.
    DO.
      DATA(ld_position) = find( val  = c_string
                                pcre = c_regex
                                off  = ld_start ).
      IF ld_position = -1.
        EXIT.
      ENDIF.

      DATA(ld_to) = find_end( val  = c_string
                              pcre = c_regex
                              off  = ld_start ).

      INSERT substring( val = c_string
                        off = ld_position
                        len = ld_to - ld_position ) INTO TABLE lt_parts.
      ld_start = ld_to.
    ENDDO.

    out->write( `Modern:` ).
    out->write( lt_parts ).

    " XCO
    lt_parts = xco_cp=>string( c_string )->grep( iv_regular_expression = c_regex
                                                 io_engine             = xco_cp_regular_expression=>engine->pcre( )
                                )->value.

    out->write( `XCO:` ).
    out->write( lt_parts ).
  ENDMETHOD.
ENDCLASS.
