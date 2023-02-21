public without sharing class JSONStringValueToFieldValueUtility {
    
    //  TODO: Support for single records, and do we remove the sObjectType variable and detect from the records automatically?
    public static List<sObject> convertValuesForRecords(string sObjectType, List<sObject> records, string rawJSONField)
    {
        // Get the field mappings (stored as custom metadata) for objects invovled
        Map<String, String> fieldMappings = fieldMappingsForObject(sObjectType);
        
        for(sObject record : records)
        {
            // If the record(s) are not the correct type (not matching the sObjectType variable) then skip to the next record - this prevents mixed records being passed.
            if(record.getSObjectType().getDescribe().getName() == sObjectType)
            {
                // If the JSON Field on the objecft is blank, then skip the rest of the processing
                if(!String.isBlank((String)record.get(rawJSONField)))
                {
                    // Using the JSON class, take the JSON field and deserialise into Map<String, Object>
                    Map<String, Object> jsonAsMap = (Map<String, Object>) JSON.deserializeUntyped((String)record.get(rawJSONField)); // See: https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_System_Json.htm#apex_System_Json_deserializeUntyped
                    for(string jsonKeyValueMapping : fieldMappings.keySet())
                    {
                        Object jsonValue = jsonAsMap.get(jsonKeyValueMapping);
                        // TODO: Validate data types
                        record.put(fieldMappings.get(jsonKeyValueMapping), (String)jsonValue);
                    }   
                }
                else
                {
                    // TODO: More error handling...
                    System.debug('The JSON Field is empty - nothing to process');
                } 
            }
            else
            {
                // TODO: More error handling...
                System.debug('The record in the list does not match the sObject type specified in the method');
            }
        }

        return records;
    }
    
    private static Map<String,String> fieldMappingsForObject(string sObjectType)
    {
        Map<String, String> fieldMappings = new Map<String, String>();
        
        List<JSON_to_Field_Mapping__mdt> rawMappings = [
            SELECT Object__c, JSON_Key__c, sObject_Field__c, Id 
            FROM JSON_to_Field_Mapping__mdt 
            WHERE Object__c = :sObjectType
            WITH SECURITY_ENFORCED
            LIMIT 555];
        
        for(JSON_to_Field_Mapping__mdt rawMapping : rawMappings)
        {
            fieldMappings.put(rawMapping.JSON_Key__c, rawMapping.sObject_Field__c);
        }

        return fieldMappings;
    }
}