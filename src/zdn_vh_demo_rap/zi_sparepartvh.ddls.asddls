@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Spare Part Value Help'
@Search.searchable: true
@Consumption.valueHelpDefault.fetchValues: #AUTOMATICALLY_WHEN_DISPLAYED
define view entity ZI_SparePartVH
  as select from zmaint_sparepart
{
      @UI.lineItem: [{ position: 10 }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key spare_part_id   as SparePartId,

      @UI.lineItem: [{ position: 20 }]
      @Search.defaultSearchElement: true
      spare_part_text  as SparePartText,

      @UI.lineItem: [{ position: 30 }]
      part_category    as PartCategory,
      
      @UI.lineItem: [{ position: 40 }]
      base_uom         as BaseUom
}

