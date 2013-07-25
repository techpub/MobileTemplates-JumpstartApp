trigger geocodeConferenceRoom on ConferenceRoom__c (after insert) {

 for(ConferenceRoom__c c : Trigger.New)  
 {
     GeocodingHelper.forwardGeocodeConferenceRoomAddress(c.Id, c.Street_Address__c, c.City__c, c.State__c, c.Zip__c);
 }

}