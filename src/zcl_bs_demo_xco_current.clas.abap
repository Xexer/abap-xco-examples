CLASS zcl_bs_demo_xco_current DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS abap_call_stack
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

    METHODS tenant_info
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.


CLASS zcl_bs_demo_xco_current IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    abap_call_stack( out ).
    tenant_info( out ).
  ENDMETHOD.


  METHOD abap_call_stack.
    DATA(stack) = xco_cp=>current->call_stack.

    DATA(full_stack) = stack->full( ).
    DATA(format_adt) = xco_cp_call_stack=>format->adt( ).
    DATA(format_source) = xco_cp_call_stack=>format->adt( )->with_line_number_flavor(
        xco_cp_call_stack=>line_number_flavor->source ).

    out->write( '### Callstack ADT Format Default (All)' ).
    LOOP AT full_stack->as_text( format_adt )->get_lines( )->value INTO DATA(text).
      out->write( text ).
    ENDLOOP.

    out->write( ` ` ).
    out->write( '### Callstack ADT Format with Source (All)' ).
    LOOP AT full_stack->as_text( format_source )->get_lines( )->value INTO text.
      out->write( text ).
    ENDLOOP.

    DATA(stack_part) = stack->up_to( 8 ).

    out->write( ` ` ).
    out->write( '### Callstack ADT Format (Up To)' ).
    LOOP AT stack_part->as_text( format_adt )->get_lines( )->value INTO text.
      out->write( text ).
    ENDLOOP.

    out->write( ` ` ).
    out->write( '### Callstack ADT Format (To)' ).
    LOOP AT full_stack->to->position( 2 )->as_text( format_adt )->get_lines( )->value INTO text.
      out->write( text ).
    ENDLOOP.

    DATA(pattern) = xco_cp_call_stack=>line_pattern->method( )->where_class_name_equals( 'ZCL_BS_DEMO_XCO_CURRENT' ).

    out->write( ` ` ).
    out->write( '### Callstack ADT Format with Source (Last)' ).
    LOOP AT full_stack->to->last_occurrence_of( pattern )->as_text( format_source )->get_lines( )->value INTO text.
      out->write( text ).
    ENDLOOP.
  ENDMETHOD.


  METHOD tenant_info.
    DATA(tenant_info) = xco_cp=>current->tenant( ).

    DATA(global_account_id) = tenant_info->get_global_account_id( )->as_string( ).
    DATA(subaccount_id) = tenant_info->get_subaccount_id( )->as_string( ).
    DATA(system_guid) = tenant_info->get_guid( )->value.
    DATA(system_id) = tenant_info->get_id( ).
    DATA(system_host_ui) = tenant_info->get_url( xco_cp_tenant=>url_type->ui )->get_host( ).
    DATA(system_host_api) = tenant_info->get_url( xco_cp_tenant=>url_type->api )->get_host( ).

    out->write( global_account_id ).
    out->write( subaccount_id ).
    out->write( system_guid ).
    out->write( system_id ).
    out->write( system_host_ui ).
    out->write( system_host_api ).
  ENDMETHOD.
ENDCLASS.
