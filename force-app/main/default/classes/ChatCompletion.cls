public class ChatCompletion {

    public class ResponseWrapper { 
        // @invocableVariable 
    	//public String summary;
        @invocableVariable
        public string summaryFormat ;
        
        
    }
    

    // Method to interact with ChatGPT API and return serialized ResponseWrapper objects as JSON strings
    @InvocableMethod(label='Process ChatGPT' description='Calls ChatGPT API to generate a response')
    public static List<List<String>> processChatGPT(List<List<String>> messageTexts) {
        List<List<String>> responseListJSON = new List<List<String>>();
        List<ResponseWrapper> newListOfResponse = new List<ResponseWrapper>();
       

        // ChatGPT API endpoint and API key
        String chatGPTAPIEndpoint = 'https://api.openai.com/v1/chat/completions';
        String chatGPTAPIKey = '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';
        String responseText;
        object responseTextEmail;
        String fields;
        
        for (List<String> messageText : messageTexts) {
            for(String messText : messageText){
                if (messText != null && messText != ' '){
                    fields+= messText;
                }
            }
            
            HttpRequest chatGPTRequest = new HttpRequest();
            chatGPTRequest.setEndpoint(chatGPTAPIEndpoint);
            chatGPTRequest.setMethod('POST');
            chatGPTRequest.setHeader('Content-Type', 'application/json');
            chatGPTRequest.setHeader('Authorization', 'Bearer ' + chatGPTAPIKey);
                    chatGPTRequest.setTimeout(40000); 
            
            Map<String, Object> requestData = new Map<String, Object>();
            requestData.put('role', 'user');
            requestData.put('content', 'can give the summary of this opportunity for mentioned values ' + fields);
                    
            List<Object> lstPrompts = new List<Object>();
            lstPrompts.add(requestData);

            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody.put('messages', lstPrompts);
            requestBody.put('model', 'gpt-3.5-turbo');
            chatGPTRequest.setBody(JSON.serialize(requestBody));

            Http http = new Http();
            HttpResponse chatGPTResponse = http.send(chatGPTRequest);
                    
            if (chatGPTResponse.getStatusCode() == 200) {
                system.debug('inside code 200');
                Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(chatGPTResponse.getBody());
                      List<Object> choices = (List<Object>) responseData.get('choices');
                     Map<String, Object> choice = (Map<String, Object>) choices.get(0);
                  system.debug('choice'+choice);
                    Map<String, Object> mpMessages = (Map<String, Object>) choice.get('message');
                     responseText = (String) mpMessages.get('content');
                    responseText = responseText != null ? responseText.trim() : '';
                  System.debug('responseText: ' + responseText);
                ResponseWrapper responseWrapperClass = new ResponseWrapper();
                responseWrapperClass.summaryFormat = (string)mpMessages.get('content');
                newListOfResponse.add(responseWrapperClass);
                responseListJSON.add(new List<String>{(string)mpMessages.get('content')});
         
            }else {
                System.debug('Error: Unable to generate response from ChatGPT.'+ chatGPTResponse.getStatusCode());
            }

        }
        return responseListJSON;
    }
}