global class TDMDemoPortalHandler implements Auth.RegistrationHandler{
    global User createUser(Id portalId, Auth.UserData data){
        
        
        //fetch the profile image from facebook as a blog, and add it as an attachment
        //NOTE: we need to do the callout first, before any inserts
        HttpRequest r = new HttpRequest();
		r.setMethod('GET');
		r.setEndpoint('http://graph.facebook.com/'+data.username+'/picture');
		Http http = new Http();
		HttpResponse res = http.send(r);
        //fb responsed with a 302 redirect that points to the actual final url.
        HttpRequest r2 = new HttpRequest();
		r2.setMethod('GET');
		r2.setEndpoint(res.getHeader('Location'));
		HttpResponse res2 = http.send(r2);
		blob pimage = res2.getBodyAsBlob();
        System.debug('STATUS2:'+res2.toString());
        
        
        //create an account
        Account a = [SELECT Id FROM account WHERE name='TDM Demo Mobile App'];
        Contact c = new Contact();
        c.accountId = a.Id;
        //for privacy, lets not use the real email
        //c.email = data.email;
        c.email = 'hidingmy@realemail.com';
        c.firstName = data.firstName;
        c.lastName = data.lastName;
        c.Facebook_ID__c = data.username;
        insert(c);
        
        Attachment attach=new Attachment();  
      	attach.Body=pimage;  
      	attach.Name='fbprofilepic.jpg';  
      	attach.ContentType='image/jpg';  
      	attach.ParentID=c.id;
        insert(attach);
        
        //now create the user
        List<User> users = [select Id, Username from User where username = :data.email];
        if(!users.isEmpty())
        {
              System.debug('Returning existing user record for '+data.email);
            return users[0];
        }
        else
        {
            User u = new User();
            Profile p = [SELECT Id FROM profile WHERE name='API Portal User'];
            
            // Use incoming email for username, since we're creating a portal user
            u.username = data.email;
            u.email = data.email;
            u.lastName = data.lastName;
            u.firstName = data.firstName;
            u.alias = (data.username != null) ? data.username : data.identifier;
            
            if (u.alias.length() > 8) {
                u.alias = u.alias.substring(0, 8);
            }
            
            u.languagelocalekey = UserInfo.getLocale();
            u.localesidkey = UserInfo.getLocale();
            u.emailEncodingKey = 'UTF-8';
            u.timeZoneSidKey = 'America/Los_Angeles';
            u.profileId = p.Id;
            u.contactId = c.Id;
            
            System.debug('Returning new user record for '+data.username);
        
            return u;
         }
    }

    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        User u = new User(id=userId);
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
 
        String contactId = [SELECT contactId FROM user WHERE Id= :userId].contactId;
        
        Contact c = new Contact(Id=contactId);
        c.Facebook_ID__c = data.username;
        
        System.debug('Updating user record for '+data.username);        
        System.debug('Updating contact ID is '+contactId);
        
        update(u);
        update(c);
        
    }

}