@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Techinicians Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZI_DN_TECHNICIANSVH
  as select from zmaint_techns
{
      @Search.defaultSearchElement: true     // Default search element for the TravelID
      @Search.fuzzinessThreshold: 0.8       // Fuzziness threshold for better search results     *Umbral 0.0 .. 1.0 to allow searchs according to exact match
      @Search.ranking: #MEDIUM //  Ranking for search results
  key technician_id as TechnicianId,
      sap_user      as SapUser,
      @Search.defaultSearchElement: true     // Default search element for the TravelID
      @Search.fuzzinessThreshold: 0.8       // Fuzziness threshold for better search results     *Umbral 0.0 .. 1.0 to allow searchs according to exact match
      @Search.ranking: #MEDIUM //  Ranking for search results
      first_name    as FirstName,
      last_name     as LastName,
      email         as Email,
      phone         as Phone,
      is_available  as Availability
}
