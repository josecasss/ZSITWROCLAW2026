@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Maintenance item'

@Metadata.ignorePropagatedAnnotations: true

define view entity ZR_MaintItemTP
  as select from zmaint_itema as MaintItem

  association        to parent ZR_MaintNotificationTP as _Notification on $projection.NotifUUID = _Notification.NotifUUID
  association [0..1] to ZI_DN_STATUS_ITEM_VH          as _ItemStatusVH on $projection.ItemStatus = _ItemStatusVH.ItemStatus

{
  key notif_uuid            as NotifUUID,
  key item_uuid             as ItemUUID,

      item_no               as ItemNo,
      activity_code         as ActivityCode,
      spare_part_id         as SparePartId,


//      @Semantics.valueRange.minimum: '0'
//      @Semantics.valueRange.maximum: '10000'
      @Semantics.quantity.unitOfMeasure: 'QtyUom'
      required_qty          as RequiredQty,

      qty_uom               as QtyUom,

      item_status           as ItemStatus,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      last_changed_by       as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      // Make association public
      _Notification,
      _ItemStatusVH
}
