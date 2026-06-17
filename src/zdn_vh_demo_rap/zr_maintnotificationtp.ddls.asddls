@AccessControl.authorizationCheck: #NOT_ALLOWED

@EndUserText.label: ' Core Data Service Entity'

@Metadata.allowExtensions: true

@ObjectModel.sapObjectNodeType.name: 'ZMAINT_NOTIFA'

define root view entity ZR_MaintNotificationTP
  as select from zmaint_notifa as MaintNotification

  composition [0..*] of ZR_MaintItemTP    as _MaintItem
  association [0..1] to ZI_DN_Priority_VH as _Priority  on $projection.Priority = _Priority.PriorityCode
  association [0..1] to ZI_DN_Status_VH   as _Status    on $projection.Status = _Status.StatusCode

{
  key notif_uuid            as NotifUUID,

      plant_id              as PlantID,
      equipment_id          as EquipmentID,
      damage_code_id        as DamageCodeID,
      technician_id         as TechnicianID,
      funcloc_id            as FuncLocId,
      priority              as Priority,
      status                as Status,

      case status
        when '101' then 1
        when '102' then 2
        when '103' then 3
        else 0
      end                   as StatusCriticality,

      description           as Description,
      sla_hours             as SlaHours,

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

      _MaintItem,
      _Priority,
      _Status
}
