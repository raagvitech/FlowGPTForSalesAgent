@isTest
global class GptForEmailMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a mock response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"choices": [{"message": {"content": "Mocked response from ChatGPT API"}}]}');
        res.setStatusCode(200);
        return res;
    }
}