public with sharing class OpportunityDataController {

    @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> getOpportunitiesForAccount(Id accountId) {
        
       
        List<Opportunity> opps = [
            SELECT Id, Name, StageName, Amount, AccountId,
                (SELECT Id, Name, TotalPrice FROM Quotes)
            FROM Opportunity
            WHERE AccountId = :accountId AND IsClosed = FALSE
        ];

        
        Set<Id> quoteIds = new Set<Id>();
        for (Opportunity opp : opps) {
            for (Quote q : opp.Quotes) {
                quoteIds.add(q.Id);
            }
        }

        
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        if (!quoteIds.isEmpty()) {
            quoteLineItems = [
                SELECT Id, Quantity, UnitPrice, TotalPrice, QuoteId
                FROM QuoteLineItem
                WHERE QuoteId IN :quoteIds
            ];
        }

       
        List<AccountWrapper> accountData = new List<AccountWrapper>();
        for (Opportunity opp : opps) {
            AccountWrapper wrapper = new AccountWrapper();
            wrapper.Opportunity = opp;
            wrapper.Quotes = new List<QuoteWrapper>();
            
            for (Quote q : opp.Quotes) {
                QuoteWrapper quoteWrapper = new QuoteWrapper();
                quoteWrapper.Quote = q;
                quoteWrapper.QuoteLineItems = new List<QuoteLineItem>();
                for (QuoteLineItem item : quoteLineItems) {
                    if (item.QuoteId == q.Id) {
                        quoteWrapper.QuoteLineItems.add(item);
                    }
                }
                wrapper.Quotes.add(quoteWrapper);
            }
            accountData.add(wrapper);
        }
        System.debug('accountData==>'+accountData);
        return accountData;
    }

    // Wrapper classes
    public class AccountWrapper {
        @AuraEnabled public Opportunity Opportunity { get; set; }
        @AuraEnabled public List<QuoteWrapper> Quotes { get; set; }
    }

    public class QuoteWrapper {
        @AuraEnabled public Quote Quote { get; set; }
        @AuraEnabled public List<QuoteLineItem> QuoteLineItems { get; set; }
    }
}