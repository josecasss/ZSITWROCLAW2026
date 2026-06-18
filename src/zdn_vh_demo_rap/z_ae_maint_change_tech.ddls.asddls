@EndUserText.label: 'Maint change Tech - Abstract Entity'
define abstract entity Z_AE_MAINT_CHANGE_TECH
{
    @EndUserText.label: 'New Technician'               // This is a label for the discount percentage field   *BUTTON*       
    
    @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_DN_TECHNICIANSVH', element: 'TechnicianId' } } ]  
    new_technician : zdn_technician; // Here i have a one button to introduce the discount percentage, its like forms
    @EndUserText.label: 'Reason'
    reason : abap.char(50);
}
