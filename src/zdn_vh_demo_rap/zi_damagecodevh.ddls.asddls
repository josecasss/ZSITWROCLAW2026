@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Damage Code Value Help'
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZI_DamageCodeVH as select from zmaint_dmgc {
      @UI.lineItem: [{ position: 10 }]
      @UI.selectionField: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key damage_code  as DamageCode,
      @UI.lineItem: [{ position: 20 }]
      @Search.defaultSearchElement: true
      damage_text  as DamageText,
      @UI.lineItem: [{ position: 30 }]
      @UI.selectionField: [{ position: 20 }]
      damage_group as DamageGroup
}
