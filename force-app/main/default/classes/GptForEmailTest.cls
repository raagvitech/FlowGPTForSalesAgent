@isTest
public class GptForEmailTest {

    @isTest
    public static void testProcessChatGPT() {
        // Create a test Opportunity record
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            Amount = 10000,
            CloseDate = System.today().addDays(30),
            StageName = 'Prospecting',
            Description = 'This is a test opportunity description',
            Type = 'New Business'
        );
        insert testOpp;

        // Set up mock response from ChatGPT API
        Test.setMock(HttpCalloutMock.class, new GptForEmailMock());

        // Call the method to be tested
        Test.startTest();
        String result = GptForEmail.processChatGPT(testOpp.Id);
        Test.stopTest();

        // Perform assertions
        System.assertNotEquals('', result);
        System.assertNotEquals('Error: Unable to generate response from ChatGPT.', result);

        // You may add more specific assertions based on the expected format of the result
    }
}