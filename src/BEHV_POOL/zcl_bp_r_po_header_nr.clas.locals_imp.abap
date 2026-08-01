CLASS lhc_zr_po_item_nr DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateTotalNetItem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_po_item_nr~calculateTotalNetItem.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_po_item_nr~calculatetotalprice.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zr_po_item_nr RESULT result.

ENDCLASS.

CLASS lhc_zr_po_item_nr IMPLEMENTATION.
  METHOD calculateTotalPrice.
    DATA(lt_keys) = keys.
    SORT lt_keys BY PurchasingDocument.
    DELETE ADJACENT DUPLICATES FROM lt_keys COMPARING PurchasingDocument.
    MODIFY ENTITIES OF zr_po_header_nr IN LOCAL MODE
    ENTITY zr_po_header_nr
    EXECUTE recalctotalPrice
    FROM CORRESPONDING #( lt_keys ).
  ENDMETHOD.


  METHOD calculateTotalNetItem.
    READ ENTITIES OF zr_po_header_nr IN LOCAL MODE
     ENTITY zr_po_header_nr BY \_PurchaseOrderItems
     FIELDS ( PurchasingDocument PurchasingDocumentItem NetPriceAmount TotalPrice NetPriceCurrency OrderQuantity OrderQuantityUnit  )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_item).

    LOOP AT lt_item REFERENCE INTO DATA(ls_item).

      ls_item->TotalPrice = ls_item->OrderQuantity * ls_item->NetPriceAmount.


    ENDLOOP.

    MODIFY ENTITIES OF zr_po_header_nr IN LOCAL MODE
    ENTITY zr_po_item_nr
    UPDATE FIELDS ( TotalPrice NetPriceCurrency )
    WITH CORRESPONDING #( lt_item ).
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zr_po_header_nr IN LOCAL MODE
ENTITY zr_po_header_nr FIELDS ( PurchasingDocument overallProcessingStatus )
WITH CORRESPONDING #( keys )
RESULT DATA(lt_header).

    LOOP AT keys INTO DATA(ls_key).
      READ TABLE lt_header WITH TABLE KEY id COMPONENTS %tky-PurchasingDocument = ls_key-%tky-PurchasingDocument INTO DATA(ls_header).
      IF ls_header-OverallProcessingStatus = 'X' OR ls_header-OverallProcessingStatus = 'O'.
        result = VALUE #( BASE result ( %tky = ls_key-%tky %features-%update = if_abap_behv=>fc-o-enabled ) ).
      ELSE.
        result = VALUE #( BASE result ( %tky = ls_key-%tky %features-%update = if_abap_behv=>fc-o-disabled ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZR_PO_HEADER_NR DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS recalctotalprice FOR MODIFY
      IMPORTING keys FOR ACTION zr_po_header_nr~recalctotalprice.

    METHODS initializestatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR zr_po_header_nr~initializestatus.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zr_po_header_nr RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zr_po_header_nr RESULT result.
    METHODS approvepo FOR MODIFY
      IMPORTING keys FOR ACTION zr_po_header_nr~approvepo.

    METHODS rejectpo FOR MODIFY
      IMPORTING keys FOR ACTION zr_po_header_nr~rejectpo.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zr_po_header_nr.

    METHODS earlynumbering_cba_purchaseord FOR NUMBERING
      IMPORTING entities FOR CREATE zr_po_header_nr\_purchaseorderitems.

ENDCLASS.

CLASS lhc_ZR_PO_HEADER_NR IMPLEMENTATION.
  METHOD recalctotalPrice.
    READ ENTITIES OF zr_po_header_nr IN LOCAL MODE
    ENTITY zr_po_header_nr FIELDS ( PurchasingDocument TotalNetAmount TransactionCurrency )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

    READ ENTITIES OF zr_po_header_nr IN LOCAL MODE
    ENTITY zr_po_header_nr BY \_PurchaseOrderItems
    FIELDS ( PurchasingDocument PurchasingDocumentItem NetPriceAmount TotalPrice NetPriceCurrency  )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).

    LOOP AT lt_header REFERENCE INTO DATA(ls_header).

      LOOP AT lt_item REFERENCE INTO DATA(ls_item).
        ls_item->TotalPrice = ls_item->OrderQuantity * ls_item->NetPriceAmount.
        ls_header->TotalNetAmount = ls_header->TotalNetAmount + ls_item->TotalPrice.
      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zr_po_header_nr IN LOCAL MODE
    ENTITY zr_po_header_nr
    UPDATE FIELDS ( TotalNetAmount TransactionCurrency )
    WITH CORRESPONDING #( lt_header ).

  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE PurchasingDocument IS NOT INITIAL.

    SELECT SINGLE MAX( PurchasingDocument ) FROM zc_po_header_nr INTO @DATA(lv_max_po).
    LOOP AT lt_entities INTO DATA(ls_entity).
      lv_max_po = lv_max_po + 1.
      APPEND VALUE #( %cid = ls_entity-%cid
                      %key = lv_max_po
                      %tky = lv_max_po ) TO mapped-zr_po_header_nr.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Purchaseord.

    READ ENTITIES OF zr_po_header_nr IN LOCAL MODE
    ENTITY zr_po_header_nr BY \_PurchaseOrderItems
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_link).

    LOOP AT entities INTO DATA(ls_entity_group) GROUP BY ls_entity_group-%tky.

      SELECT FROM @ls_entity_group-%target AS ent FIELDS MAX( purchasingdocumentitem  )
      AS max_item INTO @DATA(lv_max_item_entity).

      DATA(max_item) = REDUCE #(  INIT max = VALUE zpo_item_nr-item_no( )
                                  FOR link IN lt_link
                                  NEXT max = COND #( WHEN link-target-PurchasingDocumentItem > max THEN link-target-PurchasingDocumentItem
                                                     ELSE max ) ).

      DATA(lv_max_item) = COND #( WHEN lv_max_item_entity > max_item THEN lv_max_item_entity ELSE max_item ).

      LOOP AT GROUP ls_entity_group INTO DATA(ls_entity).

        LOOP AT ls_entity-%target INTO DATA(ls_target).
          lv_max_item = lv_max_item + 1.
          APPEND CORRESPONDING #( ls_target  ) TO mapped-zr_po_item_nr ASSIGNING FIELD-SYMBOL(<fs_item>).
          <fs_item>-PurchasingDocumentItem = lv_max_item.
        ENDLOOP.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.



  METHOD initializeStatus.

    READ ENTITIES OF zr_po_header_nr IN LOCAL MODE
    ENTITY zr_po_header_nr
    FIELDS ( PurchasingDocument OverallProcessingStatus )
    WITH CORRESPONDING #(  keys )
    RESULT DATA(lt_header).

    LOOP AT keys INTO DATA(key).

      DATA(ls_header) = VALUE #(  lt_header[ KEY id %tky = key-%tky ] OPTIONAL ).

      IF ls_header-OverallProcessingStatus IS INITIAL.

        MODIFY ENTITIES OF zr_po_header_nr IN LOCAL MODE
        ENTITY ZR_PO_HEADER_nr
        UPDATE FIELDS ( OverallProcessingStatus )
         WITH VALUE #( FOR ls_key IN keys
                       ( %tky = ls_key-%tky
                         OverallProcessingStatus = 'O' ) ).
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zr_po_header_nr IN LOCAL MODE
  	ENTITY zr_po_header_nr FIELDS ( PurchasingDocument overallProcessingStatus )
  	WITH CORRESPONDING #( keys )
  	RESULT DATA(lt_header).

    LOOP AT keys INTO DATA(ls_key).
      READ TABLE lt_header WITH TABLE KEY id COMPONENTS %tky = ls_key-%tky INTO DATA(ls_header).
      APPEND VALUE #( %tky = ls_key-%tky ) TO result ASSIGNING FIELD-SYMBOL(<lfs_feature>).
      <lfs_feature>-%features-%update            = if_abap_behv=>fc-o-enabled.
      <lfs_feature>-%features-%action-approvePo  = if_abap_behv=>fc-o-enabled.
      <lfs_feature>-%features-%action-rejectPo   = if_abap_behv=>fc-o-enabled.

      IF ls_header-OverallProcessingStatus = 'X'.
        <lfs_feature>-%features-%action-rejectPo = if_abap_behv=>fc-o-disabled.

      ELSEIF ls_header-OverallProcessingStatus = 'A'.
        <lfs_feature>-%features-%update           = if_abap_behv=>fc-o-disabled.
        <lfs_feature>-%features-%action-approvePo = if_abap_behv=>fc-o-disabled.
      ELSEIF ls_header-OverallProcessingStatus <> 'O'.
        <lfs_feature>-%features-%action-approvePo  = if_abap_behv=>fc-o-disabled.
        <lfs_feature>-%features-%action-rejectPo   = if_abap_behv=>fc-o-disabled.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD approvePo.
    READ ENTITIES OF zr_po_header_nr IN LOCAL MODE
  ENTITY zr_po_header_nr FIELDS ( PurchasingDocument overallProcessingStatus )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_header).

    LOOP AT keys INTO DATA(ls_key).
      READ TABLE lt_header WITH TABLE KEY id COMPONENTS %tky = ls_key-%tky INTO DATA(ls_header).
      IF ls_header-OverallProcessingStatus = 'X' OR ls_header-OverallProcessingStatus = 'O'.

        mapped-zr_po_header_nr = VALUE #( BASE mapped-zr_po_header_nr (  %tky  = ls_key-%tky
                                                                          %cid = ls_key-%cid_ref ) ).

        reported-zr_po_header_nr = VALUE #( BASE reported-zr_po_header_nr ( %tky  = ls_key-%tky
                                                                          %cid = ls_key-%cid_ref
                                                                           %action-approvePo = if_abap_behv=>fc-o-enabled
                                                                           %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                                                    text     = |Purchase order { ls_key-%tky-PurchasingDocument } has been approved|  ) )  ).
        MODIFY ENTITIES OF zr_po_header_nr IN LOCAL MODE
        ENTITY zr_po_header_nr UPDATE FIELDS ( OverallProcessingStatus )
        WITH VALUE #( ( %tky = ls_key-%tky
                      OverallProcessingStatus = 'A' ) ).

      ELSE.
        failed-zr_po_header_nr = VALUE #( BASE failed-zr_po_header_nr ( %action-approvePo = if_abap_behv=>fc-o-enabled
                                                                        %fail-cause       =  if_abap_behv=>cause-readonly
                                                                        %tky               = ls_key-%tky
                                                                        %cid = ls_key-%cid_ref  ) ).
        reported-zr_po_header_nr = VALUE #( BASE reported-zr_po_header_nr ( %tky  = ls_key-%tky
                                                                            %cid = ls_key-%cid_ref
                                                                             %action-approvePo = if_abap_behv=>fc-o-enabled
                                                                             %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                                      text     = |Purchase order { ls_key-%tky-PurchasingDocument } can't be approved|  ) )  ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD rejectPo.
    READ ENTITIES OF zr_po_header_nr IN LOCAL MODE
ENTITY zr_po_header_nr FIELDS ( PurchasingDocument overallProcessingStatus )
WITH CORRESPONDING #( keys )
RESULT DATA(lt_header).

    LOOP AT keys INTO DATA(ls_key).
      READ TABLE lt_header WITH TABLE KEY id COMPONENTS %tky = ls_key-%tky INTO DATA(ls_header).
      IF ls_header-OverallProcessingStatus = 'A' OR ls_header-OverallProcessingStatus = 'O'.

        mapped-zr_po_header_nr = VALUE #( BASE mapped-zr_po_header_nr (  %tky  = ls_key-%tky
                                                                          %cid = ls_key-%cid_ref ) ).

        reported-zr_po_header_nr = VALUE #( BASE reported-zr_po_header_nr ( %tky  = ls_key-%tky
                                                                          %cid = ls_key-%cid_ref
                                                                           %action-approvePo = if_abap_behv=>fc-o-enabled
                                                                           %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                                                    text     = |Purchase order { ls_key-%tky-PurchasingDocument } has been rejected|  ) )  ).
        MODIFY ENTITIES OF zr_po_header_nr IN LOCAL MODE
ENTITY zr_po_header_nr UPDATE FIELDS ( OverallProcessingStatus )
WITH VALUE #( ( %tky = ls_key-%tky
              OverallProcessingStatus = 'X' ) ).

      ELSE.
        failed-zr_po_header_nr = VALUE #( BASE failed-zr_po_header_nr ( %action-approvePo = if_abap_behv=>fc-o-enabled
                                                                        %fail-cause       =  if_abap_behv=>cause-readonly
                                                                        %tky               = ls_key-%tky
                                                                        %cid = ls_key-%cid_ref  ) ).
        reported-zr_po_header_nr = VALUE #( BASE reported-zr_po_header_nr ( %tky  = ls_key-%tky
                                                                            %cid = ls_key-%cid_ref
                                                                             %action-approvePo = if_abap_behv=>fc-o-enabled
                                                                             %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                                      text     = |Purchase order { ls_key-%tky-PurchasingDocument } can't be rejected|  ) )  ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
