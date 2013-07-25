public class DemoAppController {
	
	@RemoteAction
	public static List<Showcase__c> getShowcases(String appId) {
		//String queryString = 'SELECT id, Customer_Name__c, Use_Case_Description__c, (SELECT id FROM attachments) FROM Showcase__c WHERE DemoApp__c = \''+appId+'\' ORDER BY name ASC';
		String queryString = 'SELECT id, Customer_Name__c, Use_Case_Description__c, Background_Image__c, (SELECT id, Name FROM attachments) FROM Showcase__c WHERE DemoApp__c = \'a0Ci0000001Y3qF\' ORDER BY name ASC';
		List<Showcase__c> showcases = Database.query(queryString);

		return showcases;
	}

	@RemoteAction
	public static List<AppPageSpringboard> getAppPages(String appId) {
		List<AppPageSpringboard> aps = new List<AppPageSpringboard>();
		//String queryString = 'SELECT id, Title__c, Description__c, Background_Color__c, (SELECT id FROM attachments) FROM Apppage__c WHERE DemoApp__c = \''+appId+'\' ORDER BY name ASC';
		String queryString = 'SELECT id, Title__c, Description__c, Background_Color__c, Background_Image__c, Icon__c, (SELECT id, Name FROM attachments) FROM Apppage__c WHERE DemoApp__c = \'a0Ci0000001Y3qF\' ORDER BY name ASC';
		List<Apppage__c> appPages = Database.query(queryString);

		for (AppPage__c ap: appPages) {
			aps.add(new AppPageSpringboard(ap));
		}

		return aps;
	}

	public class AppPageSpringboard {
		Apppage__c appPage;
		List<Springboard__c> springboards;

		public AppPageSpringboard(Apppage__c ap) {
			appPage = ap;
			springboards = [SELECT id, Action_Name__c, Visualforce_Page_Name__c, Full_URL__c, Requires_Login__c, (SELECT id, Name FROM attachments), Button_Icon__c
							FROM  Springboard__c WHERE id in 
								(SELECT Springboard__c FROM Springboard_Pages__c WHERE App_Page__c=: appPage.id)];
		}
	}

}