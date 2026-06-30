@RestResource(urlMapping='/sap/inventory/*')
global class SAPInventoryService {
    
    @InvocableMethod(
        label='Get SAP Inventory'
        description='Fetches live inventory data from SAP for a given product SKU'
    )
    global static List<InventoryResult> getInventory(List<InventoryRequest> requests) {
        List<InventoryResult> results = new List<InventoryResult>();
        
        for(InventoryRequest req : requests) {
            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint('callout:SAP_Mock_API/inventory/' + req.sku);
            httpReq.setMethod('GET');
            httpReq.setHeader('Content-Type', 'application/json');
            
            Http http = new Http();
            HttpResponse res = http.send(httpReq);
            
            InventoryResult result = new InventoryResult();
            
            if(res.getStatusCode() == 200) {
                Map<String,Object> body = (Map<String,Object>) 
                    JSON.deserializeUntyped(res.getBody());
                    
                result.availableQty    = (Integer) body.get('availableQty');
                result.warehouse       = (String)  body.get('warehouse');
                result.leadTimeDays    = (Integer) body.get('leadTimeDays');
                result.productName     = (String)  body.get('productName');
                result.status          = (String)  body.get('status');
                result.success         = true;
            } else {
                result.success         = false;
                result.errorMessage    = 'SAP callout failed: ' + res.getStatus();
            }
            
            results.add(result);
        }
        return results;
    }
    
    global class InventoryRequest {
        @InvocableVariable(
            label='Product SKU'
            description='The SAP product SKU to look up e.g. IPX-200'
            required=true
        )
        global String sku;
    }
    
    global class InventoryResult {
        @InvocableVariable(label='Product Name')
        global String productName;
        
        @InvocableVariable(label='Available Quantity')
        global Integer availableQty;
        
        @InvocableVariable(label='Warehouse Location')
        global String warehouse;
        
        @InvocableVariable(label='Lead Time Days')
        global Integer leadTimeDays;
        
        @InvocableVariable(label='Stock Status')
        global String status;
        
        @InvocableVariable(label='Success')
        global Boolean success;
        
        @InvocableVariable(label='Error Message')
        global String errorMessage;
    }
}