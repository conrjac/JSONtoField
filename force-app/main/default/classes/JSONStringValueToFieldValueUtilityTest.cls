@isTest
private class JSONStringValueToFieldValueUtilityTest {
    
    @isTest
    private static void testSingleRecordAndField()
    {
        Account a = new Account();
        a.Description = '{"Name":"Connor","Colour":"Blue"}';
        
        List<Account> accounts = new List<Account>{a};
        
        accounts = JSONStringValueToFieldValueUtility.convertValuesForRecords('Account', accounts, 'Description');
        
        System.assertEquals('Connor', a.Name);
        
    }
    
    @isTest
    private static void testSingleWrongType()
    {
        Account a = new Account();
        a.Description = '{"Name":"Connor","Colour":"Blue"}';
        
        List<Account> accounts = new List<Account>{a};
        
        accounts = JSONStringValueToFieldValueUtility.convertValuesForRecords('Contact', accounts, 'Description');
        
    }
    
    @isTest
    private static void testSingleBlankJSON()
    {
        Account a = new Account();
        a.Description = '';
        
        List<Account> accounts = new List<Account>{a};
        
        accounts = JSONStringValueToFieldValueUtility.convertValuesForRecords('Account', accounts, 'Description');

    }
    
}