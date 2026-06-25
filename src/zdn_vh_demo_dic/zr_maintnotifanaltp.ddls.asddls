@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Maintenance Notification Analytics'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define view entity ZR_MaintNotifAnalTP
  as select from zmaint_notifa

  association [0..1] to ZI_DN_Status_VH     as _Status      on $projection.Status       = _Status.StatusCode
  association [0..1] to ZI_DN_Priority_VH   as _Priority    on $projection.Priority     = _Priority.PriorityCode
  association [0..1] to ZI_PlantVH          as _Plant       on $projection.PlantID      = _Plant.PlantID
  association [0..1] to ZI_DN_TECHNICIANSVH as _Technician  on $projection.TechnicianID = _Technician.TechnicianId

{
  key notif_uuid    as NotifUUID,

      plant_id      as PlantID,
      priority      as Priority,
      status        as Status,
      technician_id as TechnicianID,

      @Aggregation.default: #SUM
      sla_hours     as SlaHours,

      _Status,
      _Priority,
      _Plant,
      _Technician
}
