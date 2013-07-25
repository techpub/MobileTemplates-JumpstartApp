trigger appointmentChangeNotification on Appointment__c (after update) {

    for(Appointment__c a : Trigger.New)  
    {
             //appt time has changed. We need to inform the field agent
             if((a.Requested_Appointment_Time_Hour__c != Trigger.oldMap.get(a.id).Requested_Appointment_Time_Hour__c)  || 
                (a.Requested_Appointment_Date__c != Trigger.oldMap.get(a.id).Requested_Appointment_Date__c) )
             {
               //for this demo, we are just going to set a single badge number  
              //Need to convert to Integer for use in the notification
                Integer badge  = 1;                         
               
                //Instantiating a notfication
                MobilePNS.MobilePushNotification msg = new MobilePNS.MobilePushNotification();                         
                         
            //Using the optional helper funciton to assemble the necessary payload parameters for Apple 
            //Apple params (<alert text>, <alert sound>, <badge count>, <free-form data>)                         
                         
             Map<String, Object> payload = MobilePNS.MobilePushPayload.apple('Appointment ' + a.Name+ ' time changed to: ' + a.Requested_Appointment_Date__c+ ' '+a.Requested_Appointment_Time_Hour__c, '', badge, null);
                         
            //Adding the assembled payload to the notification                          
                         
                msg.setPayload(payload);
               
            //Adding recipient users to list
                Set<String> users = new Set<String>();
                users.add(a.Field_Technician__c);
          
                         
            //Sending the notification to the specified app & users
            
            // follow these steps to create p12 cert for push notifications
            // http://quickblox.com/developers/How_to_create_APNS_certificates
              System.debug('SENDING PUSH NOTIFICATION');
               msg.send('QuintonWall', users); 
              }
      }
 }