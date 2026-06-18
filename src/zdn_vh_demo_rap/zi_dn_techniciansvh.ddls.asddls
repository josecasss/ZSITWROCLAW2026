@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Techinicians Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZI_DN_TECHNICIANSVH
  as select from zmaint_techns
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
  key technician_id as TechnicianId,
      sap_user      as SapUser,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      first_name    as FirstName,
      last_name     as LastName,

      @Semantics.eMail.address: true
      email         as Email,

      @Semantics.telephone.type: [#CELL]
      phone         as Phone,

      is_available  as Availability
}
