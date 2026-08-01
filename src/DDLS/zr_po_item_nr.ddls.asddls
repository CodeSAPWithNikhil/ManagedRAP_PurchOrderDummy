@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO item NR'
@Metadata.ignorePropagatedAnnotations: false
define view entity ZR_PO_ITEM_NR
  as select from ZPO_ITEM_NR
  association to parent ZR_PO_HEADER_NR as _PurchasingOrder on $projection.PurchasingDocument = _PurchasingOrder.PurchasingDocument
{
  key po_no                as PurchasingDocument,
  key item_no              as PurchasingDocumentItem,
      material_id          as Material_Id,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      qty                  as OrderQuantity,
      uom                  as OrderQuantityUnit,
      @Semantics.amount.currencyCode: 'NetPriceCurrency'
      price                as NetPriceAmount,
      currency             as NetPriceCurrency,
      @Semantics.amount.currencyCode: 'NetPriceCurrency'
      total_price_qty      as TotalPrice,
      @Semantics.systemDateTime.createdAt: true
      created_at           as CreatedAt,
      @Semantics.user.createdBy: true
      created_by           as CreatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_change_at       as LastChangeAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_change_local_at as LastChangeLocalAt,

      @Semantics.user.lastChangedBy: true
      last_change_by       as LastChangeBy,
      /* Associations */
      material,
      _PurchasingOrder
}
