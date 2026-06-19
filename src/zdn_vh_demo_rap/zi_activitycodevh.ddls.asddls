@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Activity Code Value Help'
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_ActivityCodeVH
  as select from zmaint_actcode
{
      @UI.lineItem: [{ position: 10 }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key activity_code  as ActivityCode,

      @UI.lineItem: [{ position: 20 }]
      @Search.defaultSearchElement: true
      activity_text  as ActivityText,

      @UI.lineItem: [{ position: 30 }]
      activity_group as ActivityGroup
}
      
      

