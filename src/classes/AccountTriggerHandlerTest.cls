@isTest
private class AccountTriggerHandlerTest {
	
	@isTest static void test_method_one() {
		Account testAccount = new Account(	LastName = 'test' , 
											PersonEmail = 'test@test.de');
		insert testAccount;

		testAccount.PersonEmail = '';
		update testAccount;
		
		testAccount.PersonEmail = 'test2@test.de';
		update testAccount;
	}
	
}