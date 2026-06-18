@AccessControl.authorizationCheck: #NOT_ALLOWED

@EndUserText.label: 'Core Data Service Entity'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.sapObjectNodeType.name: 'ZMAINT_NOTIFA'
@Search.searchable: true
define root view entity ZC_MaintNotificationTP
  provider contract transactional_query
  as projection on ZR_MaintNotificationTP

{
  key NotifUUID,

      @ObjectModel.text.element: [ 'PlantName' ]
      PlantID,
      _Plant.PlantName as PlantName,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element: [ 'EquipmentText' ]
      EquipmentID,
      _Equipment.EquipText as EquipmentText,

      DamageCodeID,
      TechnicianID,
      FuncLocId,

      @ObjectModel.text.element: [ 'PriorityText' ]
      Priority,
      _Priority.PriorityText as PriorityText,

      @ObjectModel.text.element: [ 'StatusText' ]
      Status,
      _Status.StatusText     as StatusText,

      StatusCriticality,

      Description,
      SlaHours,

      _Technician.FirstName     as TechFirstName,
      _Technician.LastName      as TechLastName,

      @Semantics.eMail.address: true
      _Technician.Email         as TechEmail,

      @Semantics.telephone.type: [#CELL]
      _Technician.Phone         as TechPhone,

      _Technician.Availability  as TechAvailability,

      @Semantics.user.createdBy: true
      CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      _MaintItem : redirected to composition child ZC_MaintItemTP,

      _Status,
      _Priority,
      _Technician,
      _Plant,
      _Equipment
}
