@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Priority Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_DN_Priority_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name: 'ZDN_PRIORITY'  )  as values

    inner join   DDCDS_CUSTOMER_DOMAIN_VALUE_T(  p_domain_name: 'ZDN_PRIORITY') as texts

    on  values.domain_name = texts.domain_name
    and values.value_low   = texts.value_low
    and texts.language     = $session.system_language
{
      @ObjectModel.text.element: ['PriorityText']
  key cast( values.value_low as zdn_priority ) as PriorityCode,
      texts.text       as PriorityText
}
