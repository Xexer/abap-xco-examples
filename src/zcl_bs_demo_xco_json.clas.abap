CLASS zcl_bs_demo_xco_json DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    TYPES td_decimal TYPE p LENGTH 16 DECIMALS 2.
    TYPES td_char    TYPE c LENGTH 10.

    TYPES: BEGIN OF ts_element,
             text2   TYPE string,
             number2 TYPE i,
           END OF ts_element.

    TYPES tt_element TYPE STANDARD TABLE OF ts_element WITH EMPTY KEY.

    TYPES tt_data    TYPE STANDARD TABLE OF td_char WITH EMPTY KEY.

    TYPES: BEGIN OF ts_dummy_data,
             text           TYPE string,
             number_integer TYPE i,
             number_decimal TYPE td_decimal,
             boolean        TYPE abap_bool,
             array_element  TYPE tt_element,
             array_data     TYPE tt_data,
             dynamic_list   TYPE REF TO data,
           END OF ts_dummy_data.

    TYPES: BEGIN OF ts_internal,
             camel_string TYPE string,
             singlestring TYPE string,
             camel_number TYPE td_decimal,
             singlenumber TYPE td_decimal,
             camel_int    TYPE i,
             singleint    TYPE i,
             camel_bool   TYPE abap_bool,
             singlebool   TYPE abap_bool,
           END OF ts_internal.
    TYPES tt_internal TYPE STANDARD TABLE OF ts_internal WITH EMPTY KEY.

    METHODS get_dummy_json
      RETURNING VALUE(rd_result) TYPE string.

    METHODS get_internal_data
      RETURNING VALUE(rt_result) TYPE tt_internal.

    METHODS convert_json_with_ui2
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS convert_json_with_xco
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS convert_int_to_json_with_ui2
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS convert_dynamic_data
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS convert_int_to_json_with_xco
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS ZCL_BS_DEMO_XCO_JSON IMPLEMENTATION.


  METHOD convert_dynamic_data.
    DATA ls_dummy TYPE ts_dummy_data.

    DATA(ld_json) = get_dummy_json( ).

    /ui2/cl_json=>deserialize( EXPORTING json = ld_json
                               CHANGING  data = ls_dummy ).

    ASSIGN ls_dummy-dynamic_list->* TO FIELD-SYMBOL(<ls_dynamic>).
    DATA(lo_description) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( <ls_dynamic> ) ).

    LOOP AT lo_description->components ASSIGNING FIELD-SYMBOL(<ls_componenent>).
      ASSIGN COMPONENT <ls_componenent>-name OF STRUCTURE <ls_dynamic> TO FIELD-SYMBOL(<ld_value>).
      io_out->write( |Currency: { <ls_componenent>-name } with value: { CONV td_decimal( <ld_value>->* ) }| ).
    ENDLOOP.
  ENDMETHOD.


  METHOD convert_int_to_json_with_ui2.
    DATA(ls_internal) = get_internal_data( ).

    DATA(ld_json) = /ui2/cl_json=>serialize( data = ls_internal ).

    io_out->write( `Build raw:` ).
    io_out->write( ld_json ).

    ld_json = /ui2/cl_json=>serialize( data          = ls_internal
                                       format_output = abap_true ).

    io_out->write( `Format output:` ).
    io_out->write( ld_json ).

    ld_json = /ui2/cl_json=>serialize( data          = ls_internal
                                       pretty_name   = /ui2/cl_json=>pretty_mode-low_case
                                       format_output = abap_true ).

    io_out->write( `Pretty low-case:` ).
    io_out->write( ld_json ).

    ld_json = /ui2/cl_json=>serialize( data          = ls_internal
                                       pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                       format_output = abap_true ).

    io_out->write( `Pretty camel-case:` ).
    io_out->write( ld_json ).

    ld_json = /ui2/cl_json=>serialize( data             = ls_internal
                                       conversion_exits = abap_true ).

    io_out->write( `Test:` ).
    io_out->write( ld_json ).
  ENDMETHOD.


  METHOD convert_int_to_json_with_xco.
    DATA(lt_internal) = get_internal_data( ).

    DATA(ld_json) = xco_cp_json=>data->from_abap( lt_internal )->to_string( ).

    io_out->write( `Raw output:` ).
    io_out->write( ld_json ).

    ld_json = xco_cp_json=>data->from_abap( lt_internal )->apply(
        VALUE #( ( xco_cp_json=>transformation->underscore_to_pascal_case ) )
    )->to_string( ).

    io_out->write( `Apply underscore_to_pascal_case:` ).
    io_out->write( ld_json ).

    ld_json = xco_cp_json=>data->from_abap( lt_internal )->apply(
        VALUE #( ( xco_cp_json=>transformation->underscore_to_camel_case ) )
    )->to_string( ).

    io_out->write( `Apply underscore_to_camel_case:` ).
    io_out->write( ld_json ).
  ENDMETHOD.


  METHOD convert_json_with_ui2.
    DATA ls_dummy TYPE ts_dummy_data.

    DATA(ld_json) = get_dummy_json( ).

    /ui2/cl_json=>deserialize( EXPORTING json = ld_json
                               CHANGING  data = ls_dummy ).
  ENDMETHOD.


  METHOD convert_json_with_xco.
    DATA ls_dummy TYPE ts_dummy_data.

    DATA(ld_json) = get_dummy_json( ).

    xco_cp_json=>data->from_string( ld_json )->apply( VALUE #( ( xco_cp_json=>transformation->boolean_to_abap_bool ) ) )->write_to(
        REF #( ls_dummy ) ).
  ENDMETHOD.


  METHOD get_dummy_json.
    rd_result = |\{| &&
                | "text": "My text",| &&
                | "number_integer": 37,| &&
                | "number_decimal": 10.12,| &&
                | "boolean": true,| &&
                | "array_element": [| &&
                |   \{| &&
                |     "text2": "A",| &&
                |     "number2": 1| &&
                |   \},| &&
                |   \{| &&
                |     "text2": "B",| &&
                |     "number2": 2| &&
                |   \},| &&
                |   \{| &&
                |     "text2": "C",| &&
                |     "number2": 3| &&
                |   \}| &&
                | ],| &&
                | "array_data": [| &&
                |   "A-A",| &&
                |   "A-B",| &&
                |   "B-A"| &&
                | ],| &&
                | "dynamic_list": \{| &&
                |   "AED": 12.50,| &&
                |   "EUR": 5.20,| &&
                |   "USD": 9.96| &&
                | \}| &&
                |\}|.
  ENDMETHOD.


  METHOD get_internal_data.
    rt_result = VALUE #( ( camel_string = 'String 1'
                           singlestring = 'String 2'
                           camel_number = '9.95'
                           singlenumber = '5.59'
                           camel_int    = 2
                           singleint    = 12
                           camel_bool   = abap_true
                           singlebool   = abap_false ) ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    convert_json_with_ui2( out ).
*    convert_json_with_xco( out ).

    convert_int_to_json_with_ui2( out ).
*    convert_int_to_json_with_xco( out ).

    convert_dynamic_data( out ).
  ENDMETHOD.
ENDCLASS.
