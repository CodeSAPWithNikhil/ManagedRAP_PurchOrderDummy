@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Po header root'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_PO_HEADER_NR
  as select from zpo_header_nr
  composition [*] of ZR_PO_ITEM_NR as _PurchaseOrderItems
  association [1] to ZPo_Statuses  as _StatusText on $projection.OverallProcessingStatus = _StatusText.status
{
  key po_no                    as PurchasingDocument,
      vendor_id                as Supplier,
      po_date                  as PurchasingDocumentDate,
      currency                 as TransactionCurrency,
      status                   as OverallProcessingStatus,
      @Semantics.amount.currencyCode: 'currency'    
      total_amount             as TotalNetAmount,
      currency,
      @Semantics.systemDateTime.createdAt: true
      created_at               as CreationDateTime,
      @Semantics.user.createdBy: true
      created_by               as CreatedByUser,
      @Semantics.systemDateTime.lastChangedAt: true
      last_change_at           as LastChangeDateTime,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_local_change_at     as LastLocalChangeAt,

      @Semantics.user.lastChangedBy: true
      last_change_by           as LastChangedByUser,
      
       _StatusText.status_text as StatusText,
      vendor.vendor_name as VendorName,

      //0   None    -
      //1   Red Cross   ❌
      //2   Orange  Exclamation mark    ⚠️
      //3   Green   Check   ✅
      //5   Blue    Info    ℹ️


      //   ( status = 'O' status_text = 'Open' )
      //   ( status = 'X' status_text = 'Rejected' )
      //   ( status = 'A' status_text = 'Approved' )
      //   ( status = 'C' status_text = 'Closed' )
      //   ( status = 'R' status_text = 'Released' )

      case $projection.OverallProcessingStatus when 'O' then 2
                  when  'X' then 1
                  when  'A' then 3
                  when 'C' then 2
                  when 'R' then 3
                  else  0  end as StatusCriticality,
      /* Associations */
      _PurchaseOrderItems,
      vendor,
      _StatusText
}
