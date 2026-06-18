@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'STATUS ITEM VALUE HELP'
@Metadata.ignorePropagatedAnnotations: true
@Consumption.valueHelpDefault.fetchValues: #AUTOMATICALLY_WHEN_DISPLAYED
@Search.searchable: true
define view entity ZI_DN_STATUS_ITEM_VH
  as select from zmaint_itemstat
{
      @UI.lineItem: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key item_status as ItemStatus,
      @UI.lineItem: [{ position: 20 }]
      @Search.defaultSearchElement: true
      status_text as StatusText
}
