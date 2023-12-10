@isTest
public class chatCompletionTest {

    @isTest
    public static void testProcessChatGPT() {
        // Mocking input data
        List<List<String>> messageTexts = new List<List<String>>();
        messageTexts.add(new List<String>{'Test message'});

        // Set up mock response from ChatGPT API
        HttpCalloutMock mock = new ChatGPTMock();
        Test.setMock(HttpCalloutMock.class, mock);

        // Call the method to be tested
        Test.startTest();
        List<List<String>> result = ChatCompletion.processChatGPT(messageTexts);
        Test.stopTest();

        // Perform assertions
        System.assertEquals(1, result.size());
        System.assertEquals('Mocked response from ChatGPT API', result[0][0]);
    }
}