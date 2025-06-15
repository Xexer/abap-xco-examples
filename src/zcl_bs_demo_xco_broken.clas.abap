CLASS zcl_bs_demo_xco_broken DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS c_empty TYPE string VALUE ``.

    CLASS-METHODS static_access.

  PRIVATE SECTION.
    METHODS private_stuff.

ENDCLASS.


CLASS zcl_bs_demo_xco_broken IMPLEMENTATION.
  METHOD private_stuff.
    DATA(output) = `Hi from the method`.
  ENDMETHOD.


  METHOD static_access.
*    if method.
*    endif.
  ENDMETHOD.
ENDCLASS.
