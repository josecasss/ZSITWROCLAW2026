@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Maintenance Notification Analytics'
@Metadata.allowExtensions: true
@OData.applySupportedForAggregation: #FULL

define view entity ZC_MaintNotifAnalTP
  as select from ZR_MaintNotifAnalTP

  association [0..1] to ZI_DN_Status_VH     as _Status      on $projection.Status       = _Status.StatusCode
  association [0..1] to ZI_DN_Priority_VH   as _Priority    on $projection.Priority     = _Priority.PriorityCode
  association [0..1] to ZI_PlantVH          as _Plant       on $projection.PlantID      = _Plant.PlantID
  association [0..1] to ZI_DN_TECHNICIANSVH as _Technician  on $projection.TechnicianID = _Technician.TechnicianId

{
  key NotifUUID,

      @ObjectModel.text.element: ['PlantName']
      PlantID,
      _Plant.PlantName          as PlantName,

      @ObjectModel.text.element: ['PriorityText']
      Priority,
      _Priority.PriorityText    as PriorityText,

      @ObjectModel.text.element: ['StatusText']
      Status,
      _Status.StatusText        as StatusText,

      TechnicianID,
      _Technician.FirstName     as TechFirstName,
      _Technician.LastName      as TechLastName,

      @Aggregation.default: #SUM
      SlaHours,

      _Status,
      _Priority,
      _Plant,
      _Technician
}
