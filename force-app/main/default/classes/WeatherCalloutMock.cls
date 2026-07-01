@isTest
global class WeatherCalloutMock implements HttpCalloutMock {
    // This method is mandatory for the HttpCalloutMock interface
    global HTTPResponse respond(HTTPRequest req) {
        
        // 1. Optionally verify we are hitting the correct endpoint
        System.assertEquals('GET', req.getMethod());
        
        // 2. Create a fake response object
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        // 3. Provide a hardcoded JSON payload that perfectly matches what Open-Meteo normally sends
        String fakeJsonResponse = '{"current": {"temperature_2m": 72.5, "apparent_temperature": 75.0}}';
        res.setBody(fakeJsonResponse);
        
        res.setStatusCode(200);
        return res;
    }
}