@AccessControl.authorizationCheck: #MANDATORY

@EndUserText.label: 'Core Data Service Entity'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.sapObjectNodeType.name: 'ZMAINT_NOTIFA'

define root view entity ZC_MaintNotificationTP
  provider contract transactional_query
  as projection on ZR_MaintNotificationTP

{
  key NotifUUID,

      PlantID,
      EquipmentID,
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

      _MaintItem : redirected to  composition child ZC_MaintItemTP,

      _Status,
      _Priority
}
