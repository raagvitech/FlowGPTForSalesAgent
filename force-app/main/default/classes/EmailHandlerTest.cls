@isTest
public class EmailHandlerTest {

  
    
        @isTest
        static void testSendEmail() {
            // Test data
            List<String> toAddresses = new List<String>{ 'test@example.com' };
            String subject = 'Test Subject';
            String body = 'This is a test email body.';
    
            // Perform the test
            Test.startTest();
            EmailHandler.sendEmail(toAddresses, subject, body);
            Test.stopTest();
    
            // Perform assertions here, if necessary
            // For example, verify email sending status or log messages
        }
    }