global with sharing class TicketHelper{
    
    public TicketHelper() {}
    
    @RemoteAction
    global static List<String> getTicketCategories() {
        List<String> vals = new List<String>();
        
        for (Schema.PicklistEntry a : IT_Ticket__c.Category__c.getDescribe().getPicklistValues()) {
      		vals.add(a.getValue());
   		}
        return vals;
    }
    
   @RemoteAction
    global static List<String> getTicketPriorities() {
        List<String> vals = new List<String>();
        
        for (Schema.PicklistEntry a : IT_Ticket__c.Priority__c.getDescribe().getPicklistValues()) {
      		vals.add(a.getValue());
   		}
        return vals;
    }
}