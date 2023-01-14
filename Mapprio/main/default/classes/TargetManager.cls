public with sharing class TargetManager {
  string surveyId;
  List<Id> contactIds = new List<Id>();

  public TargetManager(String surveyId, List<Contact> contacts) {
    if (contacts.isEmpty()) {
      return;
    }

    this.surveyId = surveyId;

    for (Contact contact : contacts) {
      this.contactIds.add(contact.Id);
    }
  }

  Boolean sendRequst() {
    MapprioApi__c apiAuth = [SELECT ApiKey__c, Name FROM MapprioApi__c LIMIT 1];

    string apiKey = apiAuth.ApiKey__c;
    string user = apiAuth.Name;

    List<string> formatArgs = new List<string>{ user, apiKey };
    string authHeader = String.format('Bearer %s:%s', formatArgs);
    string body = JSON.serialize(this);

    HttpRequest request = new HttpRequest();
    request.setMethod('POST');
    request.setEndpoint('https://app.mapprio.ai/api/v1/sf-target/');
    request.setHeader('Authorization', authHeader);
    request.setHeader('Content-Type', 'application/json');
    request.setBody(body);

    Http http = new Http();
    HttpResponse response = http.send(request);

    Integer status = response.getStatusCode();
    return status >= 200 && status < 400;
  }
}
