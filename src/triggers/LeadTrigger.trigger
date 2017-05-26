/**
 * Trigger for Lead Standard Object
 *
 * @see         LeadTriggerHandler.cls
 *
 * @version     2017-04-27 kevin.kolditz@die-interaktiven.de      first version
 * 			    
 */	

trigger LeadTrigger on Lead (after insert, before update) {

	new LeadTriggerHandler().run();
}