global with sharing class PropertyInspectionController{    
  
    public PropertyInspectionController() {} 
        
    @RemoteAction
    global static string addPropertyPicture(string imageData, String recordId) {
        
        //Add the picture as an Attachment to the InspectionReport record
        Attachment a = new Attachment (ParentId = recordId,
                                       Body = EncodingUtil.base64Decode(imageData),                                        
                                       ContentType = 'image/jpg',
                                       Name = 'PropertyPhoto');
        insert a;  
         
        return a.Id;    
    }
 
    @RemoteAction  
    global static String saveInspectionReport(String street, String city, String state, String zip, String description, Decimal lat, Decimal lng) {  
         
        Property_Inspection__c pi = new Property_Inspection__c();
        pi.Street_Address__c = street;    
        pi.City_Address__c = city;
        pi.State_Address__c = state;
        pi.Zip_Address__c = zip;
        pi.Description__c = description;
        pi.Property_Location__Latitude__s = lat;
        pi.Property_Location__Longitude__s = lng;
        insert pi;
        
        return pi.Id;
                   
    }  
}