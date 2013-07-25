public class PackagesController 
{

    public String responseStr { get; set; }
    
    String packageid = null;
    
    public PackagesController() {}
    
    public void setSelectedPackage(String s) {
        packageid = s;
    }
    
    public String getSelectedPackage() {
        return packageid;
    }

    
    public List<selectOption> getItems() {
        
        List<selectOption> unsignedPackages = new List<selectOption>();
    
        for(Package__c p : [select id, Name, Shipper__c from package__c where Signed__c = false limit 10 ])
        {
            System.debug('ADDING OPTION:'+p.Shipper__c);
            unsignedPackages.add(new selectOption(p.id, p.Shipper__c));
        }
        return unsignedPackages;
    }
    
    
    public PageReference packageSigned() {
        Package__c pkg = [select Id, signed__c from Package__c where id =:ApexPages.currentPage().getParameters().get('pid')];
        pkg.signed__c = true;
        update pkg;
        
        return null;
    }
    
    public PageReference signWithDocuSign() 
    {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        String email = 'docusignsfdemo@gmail.com';
        String uniqueId = getSelectedPackage();        
        String signerName = 'John Doe';
        //String signerName = 'Bob Jones';
        String userPassword = 'demo1234';
        String accountId = '301424';
        String integratorKey = 'DOCU-978d4674-977c-4019-86d1-80fc67a622d8';
        String templateId = '7B3D98EE-CF14-4E24-9793-3C7B24346340';        
        String templateRoleName = 'Signer1';
        String documentName = 'test_document.pdf';
        String authHeader = '<DocuSignCredentials><Username>' +
                              email +
                              '</Username><Password>' + 
                              userPassword +
                              '</Password><IntegratorKey>' +
                              integratorKey +
                              '</IntegratorKey></DocuSignCredentials>';
                              
        String requestBody = '{"accountId":"' + accountId + '",' +
                               '"emailSubject":"Please sign this document",' +
                               '"emailBlurb":"Salesforce + DocuSign demo",' +
                               '"templateId":"' + templateId + '",' +
                               '"templateRoles":[{' +
                                   '"email":"' + email + '",' +
                                   '"name":"' + signerName + '",' +                                 
                                   '"clientUserId":"' + uniqueId + '",' +
                                   '"signInEachLocation":"true",' + 
                                   '"roleName":"' + templateRoleName + '"}],' +
                               '"status":"sent"' +                                         
                              '}';
        
        responseStr = requestBody;
                         
        String returnUrl = 'https://cloudcable.secure.force.com/DemoApp/apex/DocusignEnd';
        String urlParam = 'pid='+getSelectedPackage();
        
        // set the request method
        req.setMethod('POST');
 
        // set the yahoo maps url with address
        String url = 'https://demo.docusign.net/restapi/v2/accounts/' + accountId + '/envelopes';
 
        // add the endpoint to the request
        req.setEndpoint(url);
        
        // add authorization header
        req.setHeader('X-DocuSign-Authentication', authHeader);
        req.setHeader('Content-Type', 'application/json');        
        req.setHeader('Accept', 'application/xml');
 
        // set the request body
        req.setBody(requestBody);       
 
        // create the response object
        HTTPResponse resp = http.send(req);
        
        // grab the response
        responseStr = resp.getBody();

        // create the xml doc that will contain the results of the REST operation
        XmlDom doc = new XmlDom(resp.getBody());

        // parse the envelope uri
        XmlDom.Element[] elements = doc.getElementsByTagName('uri');
        String uri = elements[0].textContent();
        
        //*** Start the embedded signing process:
        
        requestBody = '{"returnUrl":"' + returnUrl + '?' + urlParam + '",' +
                               '"authenticationMethod":"none",' +
                               '"email":"' + email + '",' +
                               '"userName":"' + signerName + '",' +
                               '"clientUserId":"' + uniqueId + '"' +
                              '}';
 
        // set the request method
        req.setMethod('POST');
 
        // set the yahoo maps url with address
        url = 'https://demo.docusign.net/restapi/v2/accounts/' + accountId + uri + '/views/recipient';
 
        responseStr = url;
 
        // add the endpoint to the request
        req.setEndpoint(url);
        
        // add authorization header
        req.setHeader('X-DocuSign-Authentication', authHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/xml');
 
        // set the request body
        req.setBody(requestBody);       
 
        // create the response object
        resp = http.send(req);
        
        //debug
        responseStr = resp.getBody();
        
        doc = new XmlDom(resp.getBody());
        
        // parse the envelope uri
        elements = doc.getElementsByTagName('url');
        String viewUrl = elements[0].textContent();
        
        responseStr = viewUrl;
        
        PageReference pageRef = new PageReference(viewUrl);
        
        return pageRef;
    }

}