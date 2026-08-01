@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_PO_ITEM_NR
  as projection on ZR_PO_ITEM_NR
{
  key PurchasingDocument,
  key PurchasingDocumentItem,
  //   @ObjectModel.text.element: [ 'material.material_name' ]
      Material_Id,
     @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      OrderQuantity,
      OrderQuantityUnit,
      @Semantics.amount.currencyCode: 'NetPriceCurrency'
      NetPriceAmount,
      NetPriceCurrency,
      @Semantics.amount.currencyCode: 'NetPriceCurrency'
      TotalPrice,
      CreatedAt,
      CreatedBy,
      LastChangeAt,
      LastChangeBy,
      /* Associations */
      material,
      _PurchasingOrder : redirected to parent ZC_PO_HEADER_NR
}
