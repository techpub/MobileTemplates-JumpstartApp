public class showcasesController {

	@RemoteAction
	public static List<Showcase__c> getShowcases(String appId) {
		String queryString = 'SELECT id, Customer_Name__c, Use_Case_Description__c, (SELECT id FROM attachments) FROM Showcase__c WHERE DemoApp__c = \''+appId+'\' ORDER BY name ASC';
		List<Showcase__c> showcases = Database.query(queryString);

		return showcases;
	}
}