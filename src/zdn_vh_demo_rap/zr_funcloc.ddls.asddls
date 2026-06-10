@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Functional Location'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_FuncLoc
  as select from zmaint_funcloca
  association of many to one ZR_FuncLoc as _ParentNode
    on $projection.ParentFuncLocId = _ParentNode.FuncLocId
{
  key funcloc_id           as FuncLocId,
      parent_funcloc_id    as ParentFuncLocId,
      plant_id             as PlantId,
      fl_category          as FLCategory,
      _ParentNode
}
