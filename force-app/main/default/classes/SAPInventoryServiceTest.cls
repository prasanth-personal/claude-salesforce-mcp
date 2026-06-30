@isTest
class SAPInventoryServiceTest {
    
    @isTest
    static void testGetInventory() {
        Test.setMock(HttpCalloutMock.class, new SAPMockCallout());
        
        SAPInventoryService.InventoryRequest req = 
            new SAPInventoryService.InventoryRequest();
        req.sku = 'IPX-200';
        
        List<SAPInventoryService.InventoryResult> results = 
            SAPInventoryService.getInventory(
                new List<SAPInventoryService.InventoryRequest>{req}
            );
        
        System.assertEquals(true, results[0].success);
        System.assertEquals(850, results[0].availableQty);
        System.assertEquals('Mumbai WH-1', results[0].warehouse);
    }
    
    class SAPMockCallout implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"sku":"IPX-200","productName":"Industrial Pump X200","availableQty":850,"warehouse":"Mumbai WH-1","leadTimeDays":3,"status":"In Stock"}');
            return res;
        }
    }
}