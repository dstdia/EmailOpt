/**
 * Trigger Handler for Contact Standard Object
 *
 * @see         ContactTriggerHandler.cls
 *
 * @version     2017-04-27 kevin.kolditz@die-interaktiven.de      first version
 * 			    
 */	

trigger ContactTrigger on Contact (after insert, before update) {

	new ContactTriggerHandler().run();
}