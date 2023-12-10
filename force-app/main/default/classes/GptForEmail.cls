public class GptForEmail {

    // Apex class to integrate ChatGPT with Salesforce
    
        // Method to interact with ChatGPT API and update Salesforce record
        @AuraEnabled
        public static string processChatGPT(String recordId) {
            system.debug('apexID--->'+recordId);
            
            Opportunity opp = [SELECT Id, Name, Amount,Description,StageName,CloseDate,Type,Notes__c
            FROM Opportunity
            WHERE Id = :recordId];
            // ChatGPT API endpoint and API key
            String chatGPTAPIEndpoint = 'https://api.openai.com/v1/chat/completions';
            String chatGPTAPIKey = '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';
            
    // Assuming you already queried the Opportunity record and stored it in the 'opp' variable
            String messageText = 'Name of recipients: ' + opp.Name + ', Description: ' + opp.Description +
            ', Amount: ' + String.valueOf(opp.Amount) + ', Close Date: ' + String.valueOf(opp.CloseDate);

            // Make the HTTP request to ChatGPT API
            HttpRequest chatGPTRequest = new HttpRequest();
            chatGPTRequest.setEndpoint(chatGPTAPIEndpoint);
            chatGPTRequest.setMethod('POST');
            chatGPTRequest.setHeader('Content-Type', 'application/json');
            chatGPTRequest.setHeader('Authorization', 'Bearer ' + chatGPTAPIKey);
            chatGPTRequest.setTimeout(30000);
                    
                // Prepare data for ChatGPT API request
            Map<String, Object> requestData = new Map<String, Object> ();
                requestData.put('role','user');
                requestData.put('content','can give Email Body without subject of this value'+messageText);
                
                list<Object> lstPrompts = new list<Object>();
                lstPrompts.add(requestData);
                
                Map<string,Object> requestBody= new Map<String, Object>();
                
                requestBody.put('messages',lstPrompts);
                requestBody.put('model','gpt-3.5-turbo');
                    chatGPTRequest.setBody(JSON.serialize(requestBody));
                
    
            Http http = new Http();
            HttpResponse chatGPTResponse = http.send(chatGPTRequest);
    
            if (chatGPTResponse.getStatusCode() == 200) {
                // Parse ChatGPT response
                system.debug('inside 200');
                Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(chatGPTResponse.getBody());
                List<Object> choices = (List<Object>) responseData.get('choices');
                
                if (choices.size() > 0) {
                    Map<String, Object> choice = (Map<String, Object>) choices.get(0);
                    Map<String, Object> mpMessages = (Map<String, Object>) choice.get('message');
                    String emailFormat = (String) mpMessages.get('content');
                    emailFormat = emailFormat != null ? emailFormat.trim() : '';
                    System.debug('Email Format: ' + emailFormat);
                    String[] values = emailFormat.split(',');
                    String result = String.join( values, '\n' );
                    system.debug('result--->'+ result);
                    return result; // Return the obtained email format
                }
            } else {
                System.debug('Error: Unable to generate response from ChatGPT.'+ chatGPTResponse.getStatusCode());
                return 'Error: Unable to generate response from ChatGPT.';
            }
            
            return ''; // Return an empty string if no email format is retrieved
        }
    }