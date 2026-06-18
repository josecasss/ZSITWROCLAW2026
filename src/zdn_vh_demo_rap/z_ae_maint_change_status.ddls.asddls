@EndUserText.label: 'Maint change Stat - Abstract Entity'
define abstract entity Z_AE_MAINT_CHANGE_STATUS
{
    @EndUserText.label: 'New Priority'                     
    @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_DN_Priority_VH', element: 'PriorityCode' } } ]
    priority : zdn_priority; // Here i have a one button to introduce the discount percentage, its like forms
}
