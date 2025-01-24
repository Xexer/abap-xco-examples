CLASS zcl_bs_demo_xco_string DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    CONSTANTS c_string      TYPE string  VALUE `This is my new string class.`.
    CONSTANTS c_long_string TYPE string  VALUE `If you want to have a longer string for validation and to test, you have to create it for youself.`.
    CONSTANTS c_xstring     TYPE xstring VALUE `54686973206973206D79206E657720737472696E6720636C6173732E`.
    CONSTANTS c_part        TYPE string  VALUE `ABAP`.
    CONSTANTS c_point       TYPE string  VALUE `.`.
    CONSTANTS c_seperator   TYPE string  VALUE ` `.
    CONSTANTS c_regex       TYPE string  VALUE `\w*is\w*`.

    METHODS split_performance
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS get_random_strings
      IMPORTING id_lines         TYPE i
      RETURNING VALUE(rt_result) TYPE string_table.

    METHODS operations_with_string
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS operations_with_strings
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS operations_with_xstring
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS ZCL_BS_DEMO_XCO_STRING IMPLEMENTATION.


  METHOD get_random_strings.
    DATA(lt_parts) = VALUE string_table( ( `Apple` )
                                         ( `Banana` )
                                         ( `Mango` )
                                         ( `Kiwi` )
                                         ( `Ananas` )
                                         ( `Orange` )
                                         ( `Citron` )
                                         ( `Lime` )
                                         ( `Cherry` )
                                         ( `Apricot` )
                                         ( `Plum` )
                                         ( `Pear` )
                                         ( `Blueberry` )
                                         ( `Grapes` )
                                         ( `Salmonberry` )
                                         ( `Raspberry` )
                                         ( `Honeydew` ) ).

    DATA(lo_rand_strings) = NEW zcl_bs_demo_random( id_min = 1
                                                    id_max = lines( lt_parts ) ).
    DATA(lo_rand_parts) = NEW zcl_bs_demo_random( id_min = 5
                                                  id_max = 10 ).

    DO id_lines TIMES.
      INSERT INITIAL LINE INTO TABLE rt_result REFERENCE INTO DATA(lr_line).

      DO lo_rand_parts->rand( ) TIMES.
        lr_line->* &&= | { lt_parts[ lo_rand_strings->rand( ) ] }|.
      ENDDO.
    ENDDO.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    operations_with_string( out ).
    operations_with_strings( out ).
    operations_with_xstring( out ).
    split_performance( out ).
  ENDMETHOD.


  METHOD operations_with_string.
    " TODO: variable is assigned but never used (ABAP cleaner)
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA ld_xstring TYPE xstring.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(ld_string) = c_string.

    " Classic
    TRANSLATE ld_string TO UPPER CASE.

    " Modern
    ld_string = to_upper( c_string ).

    " XCO
    ld_string = xco_cp=>string( c_string )->to_upper_case( )->value.

    " Classic
    ld_string = c_string.
    TRANSLATE ld_string TO LOWER CASE.

    " Modern
    ld_string = to_lower( c_string ).

    " XCO
    ld_string = xco_cp=>string( c_string )->to_lower_case( )->value.

    " Classic
    ld_string = c_string+11(3).

    " Modern
    ld_string = substring( val = c_string
                           off = 11
                           len = 3 ).

    " XCO
    ld_string = xco_cp=>string( c_string )->from( 11 + 1 )->to( 3 )->value.

    " Classic
    " TODO: variable is assigned but never used (ABAP cleaner)
    SPLIT c_string AT c_seperator INTO TABLE DATA(lt_parts).

    " Modern

    " XCO
    lt_parts = xco_cp=>string( c_string )->split( c_seperator )->value.

    " Classic
    CONCATENATE c_string c_part INTO ld_string.

    " Modern
    ld_string = c_string && c_part.

    " XCO
    ld_string = xco_cp=>string( c_string )->append( c_part )->value.

    " Classic
    DATA(ld_start) = strlen( c_string ) - strlen( c_point ) - 1.
    DATA(ld_length) = strlen( c_point ).

    IF c_string+ld_start(ld_length) = c_point.
    ENDIF.

    " Modern
    IF substring( val = c_string
                  off = strlen( c_string ) - strlen( c_point ) - 1
                  len = strlen( c_point ) ) = c_point.
    ENDIF.

    " XCO
    IF xco_cp=>string( c_string )->ends_with( c_point ).
    ENDIF.

    CLEAR lt_parts.

    " Classic
    FIND ALL OCCURRENCES OF PCRE c_regex IN c_string RESULTS DATA(lt_found).
    LOOP AT lt_found INTO DATA(ls_found).
      INSERT c_string+ls_found-offset(ls_found-length) INTO TABLE lt_parts.
    ENDLOOP.

    CLEAR lt_parts.

    " Modern
    ld_start = 0.
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

    " XCO
    lt_parts = xco_cp=>string( c_string )->grep( iv_regular_expression = c_regex
                                                 io_engine             = xco_cp_regular_expression=>engine->pcre( )
                                )->value.

    lt_parts = xco_cp=>string( `MyNameIsPascal` )->decompose( xco_cp_string=>decomposition->pascal_case )->value.

*    " Classic
*    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
*      EXPORTING
*        text   = c_string
*      IMPORTING
*        buffer = ld_xstring
*      EXCEPTIONS
*        failed = 1
*        OTHERS = 2.
*    IF sy-subrc <> 0.
*    ENDIF.
*
*    " Modern
*    ld_xstring = cl_abap_codepage=>convert_to( source = c_string ).

    " XCO
    ld_xstring = xco_cp=>string( c_string )->as_xstring( xco_cp_character=>code_page->utf_8 )->value.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(ls_message) = xco_cp=>string( c_long_string )->as_message( xco_cp_message=>type->error )->value.

    DATA(lo_message) = NEW cx_abap_context_info_error( ).
    xco_cp=>string( c_long_string )->as_message( )->write_to_t100_dyn_msg( lo_message ).
  ENDMETHOD.


  METHOD operations_with_strings.
    DATA ld_string TYPE string.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lt_parts  TYPE string_table.
    DATA ld_result TYPE string.
    DATA ld_index  TYPE if_xco_strings=>tv_index.

    DATA(lt_strings) = VALUE string_table( ( `This` )
                                           ( `is` )
                                           ( `the` )
                                           ( `strings` )
                                           ( `class` ) ).

    " Classic
    READ TABLE lt_strings INDEX 5 INTO ld_string.

    " Modern
    ld_string = lt_strings[ 5 ].

    " XCO
    ld_string = xco_cp=>strings( lt_strings )->get( 5 )->value.

    " Classic
    LOOP AT lt_strings INTO ld_string.
      IF sy-tabix >= 2 AND sy-tabix <= 3.
        APPEND ld_string TO lt_parts.
      ENDIF.
    ENDLOOP.

    CLEAR lt_parts.

    " Modern
    LOOP AT lt_strings INTO ld_string FROM 2 TO 3.
      INSERT ld_string INTO TABLE lt_parts.
    ENDLOOP.

    " XCO
    lt_parts = xco_cp=>strings( lt_strings )->from( 2 )->to( 2 )->value.

    CLEAR ld_result.

    " Classic
    LOOP AT lt_strings INTO ld_string.
      DATA(ld_field) = ld_string+0(1).
      TRANSLATE ld_field TO UPPER CASE.
      CONCATENATE ld_result ld_field ld_string+1 INTO ld_result.
    ENDLOOP.

    CLEAR ld_result.

    " Modern
    LOOP AT lt_strings INTO ld_string.
      ld_result &&= to_upper( substring( val = ld_string
                                         len = 1 ) ) && substring( val = ld_string
                                                                   off = 1 ).
    ENDLOOP.

    " XCO
    ld_result = xco_cp=>strings( lt_strings )->compose( xco_cp_string=>composition->pascal_case )->value.

    DATA(lt_index) = VALUE if_xco_strings=>tt_indices( ( 3 ) ( 4 ) ( 5 ) ( 2 ) ( 1 ) ).
    CLEAR lt_parts.

    " Classic
    LOOP AT lt_index INTO ld_index.
      READ TABLE lt_strings INTO ld_string INDEX ld_index.
      APPEND ld_string TO lt_parts.
    ENDLOOP.

    CLEAR lt_parts.

    " Modern
    LOOP AT lt_index INTO ld_index.
      INSERT lt_strings[ ld_index ] INTO TABLE lt_parts.
    ENDLOOP.

    " XCO
    lt_parts = xco_cp=>strings( lt_strings )->reorder( lt_index )->value.

    CLEAR lt_parts.

    " Classic
    LOOP AT lt_strings INTO ld_string.
      INSERT ld_string INTO lt_parts INDEX 1.
    ENDLOOP.

    CLEAR lt_parts.

    " Modern
    LOOP AT lt_strings INTO ld_string STEP -1.
      INSERT ld_string INTO TABLE lt_parts.
    ENDLOOP.

    " XCO
    lt_parts = xco_cp=>strings( lt_strings )->reverse( )->value.
  ENDMETHOD.


  METHOD operations_with_xstring.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA ld_string TYPE string.

    " Classic
*    CALL FUNCTION 'ECATT_CONV_XSTRING_TO_STRING'
*      EXPORTING
*        im_xstring = c_xstring
*      IMPORTING
*        ex_string  = ld_string.

    " Modern
*    ld_string = cl_abap_codepage=>convert_from( source = c_xstring ).

    " XCO
    ld_string = xco_cp=>xstring( c_xstring )->as_string( xco_cp_character=>code_page->utf_8 )->value.
  ENDMETHOD.


  METHOD split_performance.
    DATA lo_run    TYPE REF TO zcl_bs_demo_runtime.
    DATA lr_string TYPE REF TO string.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lt_split  TYPE string_table.

    DATA(lt_strings) = get_random_strings( 5000 ).

    lo_run = NEW zcl_bs_demo_runtime( ).
    LOOP AT lt_strings REFERENCE INTO lr_string.
      SPLIT lr_string->* AT c_seperator INTO TABLE lt_split.
    ENDLOOP.
    io_out->write( |Native SPLIT     : { lo_run->get_diff( ) }| ).

    lo_run = NEW zcl_bs_demo_runtime( ).
    LOOP AT lt_strings REFERENCE INTO lr_string.
      lt_split = xco_cp=>string( lr_string->* )->split( c_seperator )->value.
    ENDLOOP.
    io_out->write( |XCO String Split : { lo_run->get_diff( ) }| ).
  ENDMETHOD.
ENDCLASS.
