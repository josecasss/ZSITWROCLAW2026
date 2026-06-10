@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Functional Location Hierarchy'

define hierarchy ZR_FuncLoc_HRVH
  as parent child hierarchy(
    source ZR_FuncLoc
    child to parent association _ParentNode
    start where
      ParentFuncLocId is initial
    siblings order by
      FuncLocId
    multiple parents not allowed
  )

{
  key FuncLocId,

      ParentFuncLocId,
      PlantId,
      FLCategory
}
