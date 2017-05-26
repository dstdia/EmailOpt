/**
 * Unit test for Email Opt In Controller
 *
 * @see         EmailOptInController.cls
 *
 * @version     2017-05-04 kevin.kolditz@die-interaktiven.de      first version
 * 			    
 */	

@isTest
private class EmailOptInControllerTest {
	
	@isTest static void testFromAccount() {

		Test.startTest();
		Account testAccount = new Account(	LastName = 'test' , 
											PersonEmail = 'test@test.de');
		insert testAccount;	
			
		Lead testLead = new Lead(	LastName = 'test' , 
									Email = 'test@test.de');
		insert testlead;
		Test.stopTest();

		String testId = [SELECT MD5Hash__c FROM Account WHERE Id = :testAccount.Id LIMIT 1].MD5Hash__c;

        PageReference pageRef = Page.EmailOptIn;
        pageRef.getParameters().put('matchId',testId);
        Test.setCurrentPage(pageRef);

		EmailOptInController ctr = new EmailOptInController();
		ctr.updateObjects();        
	}

	@isTest static void testFromLead() {

		Account testAccount = new Account(	LastName = 'test' , 
											PersonEmail = 'test@test.de');
		insert testAccount;	
			
		Lead testLead = new Lead(	LastName = 'test' , 
									Email = 'test@test.de');
		insert testlead;

		String testId = [SELECT MD5Hash__c FROM Lead WHERE Id = :testLead.Id LIMIT 1].MD5Hash__c;

        PageReference pageRef = Page.EmailOptIn;
        pageRef.getParameters().put('matchId',testId);
        Test.setCurrentPage(pageRef);

		EmailOptInController ctr = new EmailOptInController();
		ctr.updateObjects();        
	}
	
}