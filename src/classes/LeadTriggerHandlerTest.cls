@isTest
private class LeadTriggerHandlerTest {
	
	@isTest static void test_method_one() {
		Lead testLead = new Lead(	LastName = 'test' , 
									Email = 'test@test.de');
		insert testlead;

		testLead.Email = '';
		update testLead;

		testLead.Email = 'test2@test.de';
		update testLead;

	}
	
}