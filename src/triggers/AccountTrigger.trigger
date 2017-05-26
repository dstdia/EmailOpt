/**
 * Trigger for Account Standard Object
 *
 * @see         AccountTriggerHandler.cls
 *
 * @version     2017-04-27 kevin.kolditz@die-interaktiven.de      first version
 * 			    
 */	

trigger AccountTrigger on Account (after insert, before update) {

	new AccountTriggerHandler().run();
}