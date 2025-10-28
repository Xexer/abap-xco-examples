CLASS zcl_bs_demo_xco_pcre_test DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    CONSTANTS search_string TYPE string VALUE `This is my new string class.`.
    CONSTANTS regex         TYPE string VALUE `\w*is\w*`.

  PRIVATE SECTION.
    METHODS extract_string
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

    METHODS validate_string
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.


CLASS zcl_bs_demo_xco_pcre_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    extract_string( out ).
*    validate_string( out ).
  ENDMETHOD.


  METHOD extract_string.
    DATA search_results TYPE string_table.

    " Classic
    FIND ALL OCCURRENCES OF PCRE regex IN search_string RESULTS DATA(found_parts).
    LOOP AT found_parts INTO DATA(found_part).
      INSERT search_string+found_part-offset(found_part-length) INTO TABLE search_results.
    ENDLOOP.

    out->write( `Classic:` ).
    out->write( search_results ).

    CLEAR search_results.

    " Modern
    DATA(ld_start) = 0.
    DO.
      DATA(ld_position) = find( val  = search_string
                                pcre = regex
                                off  = ld_start ).
      IF ld_position = -1.
        EXIT.
      ENDIF.

      DATA(ld_to) = find_end( val  = search_string
                              pcre = regex
                              off  = ld_start ).

      INSERT substring( val = search_string
                        off = ld_position
                        len = ld_to - ld_position ) INTO TABLE search_results.
      ld_start = ld_to.
    ENDDO.

    out->write( `Modern:` ).
    out->write( search_results ).

    " XCO
    search_results = xco_cp=>string( search_string )->grep(
        iv_regular_expression = regex
        io_engine             = xco_cp_regular_expression=>engine->pcre( )
        )->value.

    out->write( `XCO:` ).
    out->write( search_results ).
  ENDMETHOD.


  METHOD validate_string.
    DATA(regex) = xco_cp=>regular_expression( iv_value  = `^[A-Z0-9_]+$`
                                              io_engine = xco_cp_regular_expression=>engine->pcre( ) ).

    IF regex->matches( `MY_CONTENT` ).
      out->write( 'Match!' ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
