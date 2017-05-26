/**
 * Trigger Handler for Lead Standard Object
 *
 * @see         LeadTrigger.cls
 *
 * @version     2017-04-27 kevin.kolditz@die-interaktiven.de      first version
 * 			    
 */	


public class LeadTriggerHandler extends TriggerHandler {
    
    private Map<Id, Lead> newMap;
    private Map<Id, Lead> oldMap;
    private List<Lead> newTrigger;
    private List<Lead> oldTrigger;

    /**
     * Constructor sets trigger values to make them accessable for other methods
     */
    public LeadTriggerHandler() {
    
        this.newMap = (Map<Id, Lead>) Trigger.newMap;
        this.oldMap = (Map<Id, Lead>) Trigger.oldMap;
        this.oldTrigger = (List<Lead>) Trigger.old;
        this.newTrigger = (List<Lead>) Trigger.new;
    }

    protected override void afterInsert() {
    	fillMD5field();
    }

    protected override void beforeUpdate() {
    	fillMD5fieldUpdate();
    }


    public void fillMD5field() {

        List<Id> idsToUpdate = new List<Id>();

    	for( Lead leadRecord : this.newTrigger) {
            
    		if(leadRecord.Email != null) {

                idsToUpdate.add(leadRecord.Id);
    		}
    	}      

        setHash(idsToUpdate);

    }

    public void fillMD5fieldUpdate() {

    	for( Lead leadRecord : this.newTrigger) {

    		Lead oldleadRecord = this.oldMap.get(leadRecord.Id);

    		if(leadRecord.Email == null) {

    			leadRecord.MD5Hash__c = '';
    		} else if(oldleadRecord.Email != leadRecord.Email || leadRecord.MD5Hash__c == null){

    			leadRecord.MD5Hash__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(leadRecord.Id + leadRecord.Email)));
    		}
    	}
    }

    @future
    public static void setHash(List<Id> leadIdList) {

        List<Lead> leadRecList = [  SELECT  Id, 
                                            Email 
                                    FROM    Lead 
                                    WHERE   Id IN :leadIdList];

        for( Lead leadRec : leadRecList) {

            leadRec.MD5Hash__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(leadRec.Id + leadRec.Email)));
        }

        update leadRecList;
    }    
}