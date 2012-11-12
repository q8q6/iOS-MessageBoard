iOS-MessageBoard
=================

Simple iOS app that allows you to view and add messages to a class-wide API. The
API is [accessible at this url](http://cis195-messages.herokuapp.com/messages).

![Preview](http://f.cl.ly/items/083W103n3e3F3u0k2A42/Screen%20Shot%202012-11-12%20at%204.25.22%20AM.png)

## Design Decisions

- Stored notes as NSDictionaries, as this was the easiest way to deal with the
  JSON serialized data returned from the server.
- Only used the default master-detail application views. The detail view serves
  to compose messages as well as to read them - this is accomplished with
  a `is_new` key that is set in the NSDictionaries for messages that haven't
  been posted to the server yet.
- The "New Message" button on the master view does the same thing that
  `insertNewObject` does by default - then it also goes on to segue to the
  detail view to compose a message.
- Used 2 `NSDateFormatter`s: one to parse the ISO-formatted `created_at` 
  timestamps from the server, and another to display the timestamp on the UI.
  _Note: currently lacking timezone support_
