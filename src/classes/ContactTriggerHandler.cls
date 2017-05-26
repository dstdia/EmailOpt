/**
 * Trigger Handler for Lead Standard Object
 *
 * @see         ContactTrigger.cls
 *
 * @version     2017-04-27 kevin.kolditz@die-interaktiven.de      first version
 * 			    
 */	


public class ContactTriggerHandler extends TriggerHandler {
    
    private Map<Id, Contact> newMap;
    private Map<Id, Contact> oldMap;
    private List<Contact> newTrigger;
    private List<Contact> oldTrigger;

    /**
     * Constructor sets trigger values to make them accessable for other methods
     */
    public ContactTriggerHandler() {
    
        this.newMap = (Map<Id, Contact>) Trigger.newMap;
        this.oldMap = (Map<Id, Contact>) Trigger.oldMap;
        this.oldTrigger = (List<Contact>) Trigger.old;
        this.newTrigger = (List<Contact>) Trigger.new;
    }

    protected override void afterInsert() {
    	fillMD5field();
    }

    protected override void beforeUpdate() {
    	fillMD5fieldUpdate();
    }


    public void fillMD5field() {
        List<Id> idsToUpdate = new List<Id>();

    	for( Contact con : this.newTrigger) {
    		if(con.Email != null) {

                idsToUpdate.add(con.Id);
    		}
    	}
        setHash(idsToUpdate);

    }  

    public void fillMD5fieldUpdate() {

    	for( Contact con : this.newTrigger) {

    		Contact oldcon = this.oldMap.get(con.Id);

    		if(con.Email == null) {

    			con.MD5Hash__c = '';
    		} else if(oldcon.Email != con.Email || con.MD5Hash__c == null){

    			con.MD5Hash__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(con.Id + con.Email)));
    		}
    	}
    }

    @future
    public static void setHash(List<Id> contactIdList) {

        List<Contact> conList = [   SELECT  Id, 
                                            Email 
                                    FROM    Contact 
                                    WHERE   Id IN :contactIdList];

        for( Contact con : conList) {

            con.MD5Hash__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(con.Id + con.Email)));
        }

        update conList;
    }      
}