Improvements:

## ViewModels are not agnostic to Core Data Framework.
Issue: ViewModels like ConversationListViewModel are heavily reliant on Core Data. If ever we want to change CoreData in the future it won't be possible with the architecture provided. Also making ConversationListViewModel untestable because of dependencies.
Resolution: Separated out CoreDataConversationStore class and its protocol,  ConversationStore is created that takes input of FetchedResults. The CoreDataConversationStore is then passed to ConversationListViewModel.

## Background NSManagedObjectContext missing
Issue: Background NSManagedObjectContext is missing resulting in UI blocking when sending a message in a conversation.
Resolution:  Included backgroundContext property in Persistence Class which is passed when conversationContentViewModel Is created in the ModuleFactory class, then it is used in ConversationContentViewModel appendmessage method.
Initialising it as .privateQueueConcurrencyType and setting it as parent of viewContext.


## Service Layer Missing
Issue: ConversationContentViewModel directly interacting with the TransportSession. The project can have API calls in the future or can have other persistence frameworks. View Model should always call the service layer, service layer will decide and route to api calls or other persistence frameworks.
Resolution:  Added the ConversationService layer. ConversationContentViewModel appendMessage method now calling ConversationService method.
