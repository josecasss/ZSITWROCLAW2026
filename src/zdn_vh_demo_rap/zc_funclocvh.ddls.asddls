@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Functional Location Hierarchical VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.supportedCapabilities: [ #VALUE_HELP_PROVIDER ]          
@Metadata.allowExtensions: true
@UI.presentationVariant: [{
  recursiveHierarchyQualifier: 'ZR_FuncLoc_HRVH',
  initialExpansionLevel: 1,
  qualifier: 'HIERARCHY'
}]
@OData.hierarchy.recursiveHierarchy: [{ entity.name: 'ZR_FuncLoc_HRVH' }]
define root view entity ZC_FuncLocVH
   provider contract transactional_query
  as projection on ZR_FuncLoc
  association of many to one ZC_FuncLocVH as _ParentNode      
    on $projection.ParentFuncLocId = _ParentNode.FuncLocId
{
      @UI.lineItem: [{ position: 10 }]     
  key FuncLocId,
      ParentFuncLocId,

      @UI.lineItem: [{ position: 30 }]
      PlantId,
      @UI.lineItem: [{ position: 40 }]
      FLCategory,
      _ParentNode
}
