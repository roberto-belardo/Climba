![Climba Logo](http://i.imgur.com/1swYljB.png)

Climba
======

Italy is a country where rock climbing is spreading like wildfire. So many great places where you can climb and a great community of passionate people growing day by day with veterans helping newbie climbing higher and higher. But until now climbers have had to rely on word of mouth, printed guides or old style incomplete websites.

Climba is here to change all that. Our aim is to build a free community driven database of italian climbing spot.

## Table of contents
- [Version History](#version-history)
- [What is Climba](#what-is-climba)
- [Why Climba](#why-climba)
- [What can you do with Climba](#what-can-you-do-with-climba)
- [Technology](#technology)
- [The Climba Database](#the-climba-database)
 - [How to suggest a revision](#how-to-suggest-a-revision)
- [Contributors](#contributors)
- [Credits](#links)
- [License](#license)

## Version History
- [**1.0**](https://github.com/backslash451/climba)   (10/22/2014): Initial release

## What is Climba
Climba is an iOS app made by rock climbers for rock climbers. It is based on the [Parse](http://www.parse.com) cloud backend and it allows you to:
 - search for italian climbing spots with map, description, access, weather infos, sectors and routes
 - add climbing spots to favorites
 - look for other people routes repetitions
 - add your repetitions with comment, personal grade, beauty
 - Facebook login and Facebook sharing
 - personal profile page

## Why Climba
Climba comes from the need of today's climbers of a way to discover new climbing spots and to share their achievements. Until yesterday climbers have had to rely on paper books written by veteran climbers, printed pdfs downloaded by some proprietary old fashioned web site or the same old fashioned web sites resized to fit on smartphones... Recently some apps have been published on this matter but they use expensive business models.

When i decided to write Climba i had nothing on this in mind, i just wanted to experiment with [Parse](http://www.parse.com) and iOS programming. But during the development of Climba i felt that i was building something more than a simple app. 

Climba is more than this. Climba wants to be a community driven database of italian climbing spots where everyone can suggest or add new spots, new routes, correct wrong description and do whatever he wants with it. Do you want to build an Android app similar to Climba? You can, and you can use Climba's database.

## What can you do with Climba
 - [Download]() the app from the [App Store]() and use it!
 - [Fork](https://github.com/backslash451/climba/fork) this repository and experiment with it.
 - Tell me about a particular issue on the app.
 - Submit a Pull Request for a feature you would like to add to Climba.
 - Collaborate on the Climba open database. [More on this](#the-climba-database).

## Technology
Climba is based essentially on the [Parse](https://www.parse.com) Backend as a service. Here you can find a list of all the third party technologies or libraries used by Climba:

 - [Mantle](https://github.com/Mantle/Mantle)
 - [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
 - [AsyncImageView](https://github.com/nicklockwood/AsyncImageView)
 - [AFNetworking](https://github.com/AFNetworking/AFNetworking)
 - [TSMessages](https://github.com/toursprung/TSMessages)
 - [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
 - [Reachability](https://github.com/tonymillion/Reachability)
 - [Facebook-iOS-SDK](https://developers.facebook.com)
 - [Parse](https://www.parse.com)
 - [MarqueeLabel](https://github.com/cbpowell/MarqueeLabel)

### The Climba Database
The Climba database is hosted on the [Parse](https://www.parse.com) cloud backend with free plan which include as of now, among other contraints, a limit of 30 request/sec and 20GB of database storage.

If you want to [Fork](https://github.com/backslash451/climba/fork) Climba to experiment you should:
 - sign up to Parse and set up a database that is the same as the one we use with Climba;
 - obtain your API keys;
 - put your API keys in the source code you forked;
 - start experimenting...

In order to set up a database like the one we use with Climba here you can find the tables and the field we use:

#### "Users" table
| Field name | Field type |
|:-----------|:------------|
|objectId|String|
|username|String|
|password|String|
|authData|authData|
|following|Relation<_User>|
|emailVerified|Boolean|
|email|String|
|createdAt|Date|
|updatedAt|Date|
|ACL|ACL|
|profile|Object|
|facebookId|String|
|bestRouteGrade|String|

#### "Activity" table
| Field name | Field type |
|:-----------|:------------|
|objectId|String|
|fromUser|Pointer<_User>|
|toUser|Pointer<_User>|
|type|String|
|content|String|
|repetition|POinter<Repetition>|
|createdAt|Date|
|updatedAt|Date|
|ACL|ACL|

#### "Region" table
| Field name | Field type |
|:-----------|:------------|
|objectId|String|
|nome|String|
|falesie|Number|
|createdAt|Date|
|updatedAt|Date|
|ACL|ACL|

#### "Repetition" table
| Field name | Field type |
|:-----------|:------------|
|objectId|String|
|user|Pointer<_User>|
|via|Pointer<via>|
|type|String|
|stars|Number|
|comment|String|
|gradoProposto|String|
|settore|String|
|falesia|String|
|createdAt|Date|
|updatedAt|Date|
|ACL|ACL|

#### "UserPhoto" table
| Field name | Field type |
|:-----------|:------------|
|objectId|String|
|imageFile|File|
|user|Pointer<_User>|
|createdAt|Date|
|updatedAt|Date|
|ACL|ACL|

#### "falesia" table
| Field name | Field type |
|:-----------|:------------|
|objectId|String|
|createdAt|Date|
|updatedAt|Date|
|ACL|ACL|
|lat|String|
|long|String|
|nome|String|
|descrizione|String|
|accesso|String|
|regione|String|
|provincia|String|
|provinciaShort|String|
|id|Number|
|numSettori|Number|
|oldID|Number|
|numVie|Number|
|available|Boolean|

#### "settore" table
| Field name | Field type |
|:-----------|:------------|
|objectId|String|
|createdAt|Date|
|updatedAt|Date|
|ACL|ACL|
|id|Number|
|nome|String|
|oldID|Number|
|falesia|Pointer<falesia>|
|numVie|Number|

#### "via" table
| Field name | Field type |
|:-----------|:------------|
|objectId|String|
|createdAt|Date|
|updatedAt|Date|
|ACL|ACL|
|id|Number|
|nome|String|
|oldID|Number|
|grado|String|
|settore|Pointer<settore>|
|frazioneGrado|String|
|numeroValutazioni|Number|
|votiBellezza|Number|
|bellezza|String|

#### How to suggest a revision
The community driven database of Climba is hosted on Github here: [Climba-data](https://github.com/backslash451/Climba-data).

Another way to suggest a revision for an existing climbing spot (falesia) or to add a new one is sending an email to [Climba email address](mailto:climba.app@gmail.com).

## Contributors
<a href="https://twitter.com/robertobelardo" target="_blank"><img src="https://avatars3.githubusercontent.com/u/43101?v=2&s=96" alt="Roberto Belardo"></a>  
**Roberto Belardo** — Author 
<a href="https://twitter.com/robertobelardo" target="_blank">@robertobelardo</a>

## Links
 - [App Store]()
 - [Website](http://climba.parseapp.com)
 - [Facebook](https://www.facebook.com/climba.app.page)
 - [Twitter](https://twitter.com/climba_app)
 - [Blog](http://backslash451.github.io)

## License
This work is licensed under a **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License**. 

![Creative Commons License Logo](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png "License")
