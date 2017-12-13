/**
 * Visualforce Page Controller Handles matchId Requests
 *
 * @see         EmailOptin.page
 *
 * @version     2017-04-27 kevin.kolditz@die-interaktiven.de      first version
 * 			    
 */	


public without sharing class EmailOptInController {


    /**
     * Method is able to redirect to standard view if user in not in console view.
     *
     * @return     Page Redirect for standard view or lot tagging editor
     */
    public PageReference updateObjects () {

	    String md5Hash = ApexPages.currentPage().getParameters().get('matchId');

        // String sfId = matchId.subString(0,18);
        // String objectType = getObjectType(sfId);

        URL_Setting__mdt urlSettings = [    SELECT  Email_Opt_Out_Error_URL__c, 
                                                    Email_Opt_Out_Success_URL__c 
                                            FROM    URL_Setting__mdt
                                            WHERE   MasterLabel = 'Default' 
                                            LIMIT   1];

        List<Contact> contactList = new List<Account>();
        List<Lead> leadList = new List<Lead>();
        Boolean hashIsValid; 
        String theEmail; 

        if(String.isBlank(md5Hash)) {

            return new PageReference(urlSettings.Email_Opt_Out_Error_URL__c);
        } 

        md5Hash = String.escapeSingleQuotes(md5Hash);

        //firstly search for a contact matching the hash
        contactList = [SELECT Id, Email FROM Email WHERE MD5Hash__c = :md5Hash];

        if(!accList.isEmpty()) {

            hashIsValid = true;
            theEmail = contactList[0].Email;
        } else {

            //firstly if an account was not found search for a lead matching the hash code
            leadList = [SELECT Id, Email FROM Lead WHERE MD5Hash__c = :md5Hash];

            if(!leadList.isEmpty()) {

                hashIsValid = true;
                theEmail = leadList[0].Email;
            }
        }

        if(!hashIsValid) {

            return new PageReference(urlSettings.Email_Opt_Out_Error_URL__c);
        } else {

            List<Lead> leadsToModifyList = [SELECT Id FROM Lead WHERE Email = :theEmail];
            List<Contact> contactsToModifyList = [SELECT Id FROM Contact WHERE Email = :theEmail];

            for(Lead l : leadsToModifyList) {

                l.OptinEmail__c = false;
                l.HasOptedOutOfEmail = true;
            }

            for(Contact c : contactsToModifyList) {

                c.OptinEmail__c = false;
                c.PersonHasOptedOutOfEmail = true;
            }

            update leadsToModifyList; 
            update contactsToModifyList;
	       
            return new PageReference(urlSettings.Email_Opt_Out_Success_URL__c);
        }

    }

    public static String getObjectType(String sfId) {

        Id parsedId = Id.valueOf(sfId);
        return String.valueOf(parsedId.getSobjectType());
    }
}