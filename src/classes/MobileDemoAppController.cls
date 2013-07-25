public with sharing class MobileDemoAppController {
	public static List<Showcase__c> showcases {get;set;}

	public MobileDemoAppController(ApexPages.StandardController controller) {}

	@RemoteAction
	public static List<Showcase__c> getShowcases(String appId) {
		String queryString = 'SELECT id, Customer_Name__c, Use_Case_Description__c, (SELECT id FROM attachments) FROM Showcase__c WHERE DemoApp__c = \''+appId+'\' ORDER BY name ASC';
		showcases = Database.query(queryString);

		return showcases;
	}

	@RemoteAction
	public static List<AppPageSpringboard> getAppPages(String appId) {
		List<AppPageSpringboard> aps = new List<AppPageSpringboard>();
		String queryString = 'SELECT id, Title__c, Description__c FROM Apppage__c WHERE DemoApp__c = \''+appId+'\' ORDER BY name ASC';
		List<Apppage__c> appPages = Database.query(queryString);

		for (AppPage__c ap: appPages) {
			aps.add(new AppPageSpringboard(ap));
		}

		return aps;
	}

	public class AppPageSpringboard {
		Apppage__c appPage;
		List<Springboard_Pages__c> springboards;

		public AppPageSpringboard(Apppage__c ap) {
			appPage = ap;
			springboards = [SELECT Springboard__r.Action_Name__c, Springboard__r.Visualforce_Page_Name__c FROM Springboard_Pages__c WHERE App_Page__c =: appPage.id];
		}
	}
}