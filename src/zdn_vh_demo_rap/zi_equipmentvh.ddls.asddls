@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Equipment - Value Help (Plant-dependent)'
//@Consumption.valueHelpDefault.fetchValues: #ON_EXPLICIT_REQUEST // avoid auto load
@Search.searchable: true
define view entity ZI_EquipmentVH as select from zmaint_equip {
      @UI.lineItem: [{ position: 10 }]
      @UI.selectionField: [{ position: 10 }]
      @EndUserText.label: 'Equipment Id'       
      @Search.defaultSearchElement: true
  key equipment_id  as EquipmentId,
      @UI.lineItem: [{ position: 20 }]
      @EndUserText.label: 'Description'    
      @Search.defaultSearchElement: true
      equip_text    as EquipText,
      @UI.lineItem: [{ position: 30 }]
      @UI.selectionField: [{ position: 20 }]
      @EndUserText.label: 'Plant'
      plant_id      as PlantId,         
      @UI.lineItem: [{ position: 40 }]
      @EndUserText.label: 'Category'
      equip_category as EquipCategory
}
