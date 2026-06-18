@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant  Value Help'
@Consumption.valueHelpDefault.fetchValues: #AUTOMATICALLY_WHEN_DISPLAYED
define view entity ZI_PlantVH as select from zmaint_plant {
      @UI.lineItem: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key plant_id   as PlantID,
      @UI.lineItem: [{ position: 20 }]
      @Search.defaultSearchElement: true
      plant_name as PlantName,
      @UI.lineItem: [{ position: 30 }]
      @Consumption.valueHelpDefinition: [{ 
        entity: { 
          name: 'I_Country', 
          element: 'Country' 
        } 
      }]
      country    as Country
}
