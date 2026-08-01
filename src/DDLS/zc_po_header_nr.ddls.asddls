@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection header'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity ZC_PO_HEADER_NR
  provider contract transactional_query
 //provider contract transactional_interface
  as projection on ZR_PO_HEADER_NR
{
  key PurchasingDocument,
  //    @ObjectModel.text.element: ['VendorName']
      Supplier,
      PurchasingDocumentDate,
      TransactionCurrency,
      @ObjectModel.text.element: ['StatusText']
//@ObjectModel.text.association: '_StatusText'
      OverallProcessingStatus,
      TotalNetAmount,
      CreationDateTime,
      CreatedByUser,
      LastChangeDateTime,
      LastChangedByUser,
      StatusCriticality,
      currency,
       StatusText,
      VendorName,
      
      /* Associations */
      vendor,
      _StatusText,
      _PurchaseOrderItems : redirected to composition child ZC_PO_ITEM_NR
}
