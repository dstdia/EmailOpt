/**
 * Trigger Handler for Account Standard Object
 *
 * @see         AccountTrigger.cls
 *
 * @version     2017-04-27 kevin.kolditz@die-interaktiven.de      first version
 * 			    
 */	


public class AccountTriggerHandler extends TriggerHandler {
    
    private Map<Id, Account> newMap;
    private Map<Id, Account> oldMap;
    private List<Account> newTrigger;
    private List<Account> oldTrigger;

    /**
     * Constructor sets trigger values to make them accessable for other methods
     */
    public AccountTriggerHandler() {
    
        this.newMap = (Map<Id, Account>) Trigger.newMap;
        this.oldMap = (Map<Id, Account>) Trigger.oldMap;
        this.oldTrigger = (List<Account>) Trigger.old;
        this.newTrigger = (List<Account>) Trigger.new;
    }

    protected override void afterInsert() {
    	fillMD5field();
    }

    protected override void beforeUpdate() {
    	fillMD5fieldUpdate();
    }


    public void fillMD5field() {

        List<Id> idsToUpdate = new List<Id>();

    	for( Account acc : this.newTrigger) {

    		if(acc.PersonEmail != null) {

    			idsToUpdate.add(acc.Id);
    		}
    	}

        setHash(idsToUpdate);
    }

    public void fillMD5fieldUpdate() {

    	for( Account acc : this.newTrigger) {

    		Account oldAcc = this.oldMap.get(acc.Id);

    		if(acc.PersonEmail == null) {

    			acc.MD5Hash__c = '';
    		} else if(oldAcc.PersonEmail != acc.PersonEmail  || acc.MD5Hash__c == null){

    			acc.MD5Hash__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(acc.Id + acc.PersonEmail)));
    		}
    	}
    }

    @future
    public static void setHash(List<Id> accIds) {

        List<Account> accList = [   SELECT  Id, 
                                            PersonEmail 
                                    FROM    Account 
                                    WHERE   Id IN :accIds];

        for( Account acc : accList) {

            acc.MD5Hash__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(acc.Id + acc.PersonEmail)));
        }

        update accList;
    }
}