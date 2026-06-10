@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for ZR_MAINTITEMTP'
@Metadata.ignorePropagatedAnnotations: false
define view entity ZC_MaintItemTP as projection on ZR_MaintItemTP
{
    key NotifUUID,
    key ItemUUID,
    ItemNo,
    ActivityCode,
    SparePartId,    
    RequiredQty,
    QtyUom,
    ItemStatus,
//    ItemStatusCriticality,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    
    /* Associations */
    _Notification : redirected to parent ZC_MaintNotificationTP
}
