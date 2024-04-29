## Intro
Hello and welcome! If you're reading this then we are curious about your skills and want to see how you apply them. This code challenge is a small, extremely simple messenger app. It uses Core Data and Swift UI. To make things easier, the database will be pre-populated with some dummy data the first time the app is launched.

The current functionality of the app includes:
- Creating a new conversation with a specified name (all known users are participants)
- Select a conversation from the conversation list
- Send a message in a conversation.  

It's simple for now, but assume we have big plans to make it a fully-featured messenger app.

## Your tasks
While we're pretty happy so far with the app, there are some issues that we'd like you to fix:

1. There are a couple bugs that need squishing, see "Known bugs" below.
2. We have a performance problem when sending a message. Every time we send a message, the UI freezes for a few seconds. Make the necessary changes to ensure that while a message is being sent the UI is not blocked. See `ConversationContentViewModel.appendMessage(content: String)`.
3. While the app is simple now, we recognized that it may not scale well. We want to structure the code so that it ensures good separation of concerns and is made up of reuseable and highly testable components. Your job is to design and implement a suitable architecture. We expect you to document it thoroughly so that other people can understand how it works, why it is suitable, and how to implement and maintain it in the future.


You can make any changes to the source code (except for `TransportSession.swift`, see the comment there), especially any improvements, whether they improve the product or the developer experience. We encourage you to make some notes of the improvements that you'll make.

## Known bugs
- When creating a new conversation, the conversation is created but the modal is not dismissed.
- When creating a new conversation, or sending a message, it doesn't appear in the list. If the app is relaunched, it appears.

## Quality requirements
Write some tests. We do not expect full test coverage, so prioritize the tests that you think are most important and leave some comments for further test scenarios you'd like to test.

## Time expectations
We think you should spend 4 to 8 hours on this task. If you find yourself spending more hours on this task, you are probably creating something that is too complicated for the scope of this test.

Prioritize what's important for you, and leave TODOs about the rest. We will evaluate how you decided to prioritize. Please write down a summary of what you prioritized and what you left in NOTES.md, e.g. "For a production application, I would have done X, because of Y, if I had more time".

## Delivery
For the delivery, you can just ZIP the entire project and email it to us, with source control metadata (e.g. git commits).

Please don't pass this test or your solution to third parties, and do not publish it under a public repository.
And finally, good luck!
