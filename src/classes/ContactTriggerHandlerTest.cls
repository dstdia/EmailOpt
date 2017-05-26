@isTest
private class ContactTriggerHandlerTest {
	
	
	@isTest static void test_method_one() {
		Contact testContact = new Contact(	LastName = 'test' , 
											Email = 'test@test.de');
		insert testContact;

		testContact.Email = '';
		update testContact;

		testContact.Email = 'test2@test.de';
		update testContact;
	}
	
}