public with sharing class contactListViewHelper {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        return [SELECT Id, FirstName, LastName, AccountId, account.name, MailingStreet, 
                        MailingCity, MailingState, MailingPostalCode, MailingCountry, Email  
                FROM Contact
                ];
    }

    @AuraEnabled(cacheable=True)
    public static List<Contact> searchContact(String searchString){
        List<List<SObject>> contacts = [FIND :searchString IN ALL FIELDS RETURNING Contact(FirstName, LastName, Email, mailingStreet,
                                        mailingCity, mailingCountry, mailingPostalCode, account.Name)];
                                        
        return (List<Contact>) contacts[0];
                                        
        
    }

    @AuraEnabled
    public static void deleteContacts(List<Id> contactIds){
        if (contactIds.size() >0 ) {
            delete [SELECT Id FROM Contact WHERE Id in: contactIds];
        }

    }

    @AuraEnabled
    public static Boolean matchloginDetails(String userName, String pwd){
        Boolean isLogindetailsMatched = false;
        
        List<Contact> conList = [Select id, FirstName, Password__c from Contact where FirstName =: userName];
        if(conList.Size() > 0 && conList[0].Password__c.equals(pwd)){
            isLogindetailsMatched = true;
        }
        return isLogindetailsMatched;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<DataListWrapper> getDataList(String selectedObject) {
        List<DataListWrapper> dataList = new List<DataListWrapper>();

        if(selectedObject == 'Account') {
            for(Account a:[SELECT Id, Name, Phone  FROM Account]) {
                DataListWrapper dl = new DataListWrapper();
                dl.dataId = a.Id;
                dl.name = a.Name;
                dl.phone = a.Phone;
                dataList.add(dl);

            }

        }else if(selectedObject =='Contact') {
            for(Contact c:[SELECT Id, Name, Phone FROM Contact]) {
                DataListWrapper dl = new DataListWrapper();
                dl.dataId = c.Id;
                dl.name = c.Name;
                dl.phone = c.Phone;
                dataList.add(dl);
                
            }

        }else if(selectedObject =='Lead') {
            for(Lead l:[SELECT Id, Name, Phone FROM Lead]) {
                DataListWrapper dl = new DataListWrapper();
                dl.dataId = l.Id;
                dl.name = l.Name;
                dl.phone = l.Phone;
                dataList.add(dl);
            }

        }

        return dataList;
    }
    
    class DataListWrapper{

        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String phone{get;set;}
        @AuraEnabled public String dataId{get;set;}        

    }
}
