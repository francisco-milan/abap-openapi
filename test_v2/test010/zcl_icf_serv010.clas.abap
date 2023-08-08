CLASS zcl_icf_serv010 DEFINITION PUBLIC.
* Auto generated by https://github.com/abap-openapi/abap-openapi
  PUBLIC SECTION.
    INTERFACES if_http_extension.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_icf_serv010 IMPLEMENTATION.
  METHOD if_http_extension~handle_request.
    DATA li_handler TYPE REF TO zif_interface010.
    DATA lv_method  TYPE string.
    DATA lv_path    TYPE string.

    CREATE OBJECT li_handler TYPE zcl_icf_impl010.
    lv_path = server->request->get_header_field( '~path' ).
    lv_method = server->request->get_method( ).

    TRY.
        IF lv_path = '/user' AND lv_method = 'POST'.
          DATA r_createuser TYPE zif_interface010=>r_createuser.
          r_createuser = li_handler->createuser( ).
          IF r_createuser-_default_app_json IS NOT INITIAL.
            server->response->set_content_type( 'application/json' ).
            server->response->set_cdata( /ui2/cl_json=>serialize( r_createuser-_default_app_json ) ).
            server->response->set_status( code = 200 reason = 'successful operation' ).
            RETURN.
          ENDIF.
        ENDIF.
      CATCH cx_static_check.
        server->response->set_content_type( 'text/plain' ).
        server->response->set_cdata( 'exception' ).
        server->response->set_status( code = 500 reason = 'Error' ).
    ENDTRY.

    server->response->set_content_type( 'text/plain' ).
    server->response->set_cdata( 'no handler found' ).
    server->response->set_status( code = 500 reason = 'Error' ).
  ENDMETHOD.
ENDCLASS.