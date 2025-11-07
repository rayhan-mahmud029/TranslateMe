# Project 6 - TranslateMe

Submitted by: **Rezwan Mahmud**

**TranslateMe** is an iOS app that allows users to translate text from one language to another, save their translation history, and view or clear past translations. Built using **SwiftUI** and **Firebase**, it demonstrates user authentication (anonymous sign-in), data persistence with Firestore, and real-time updates using the Observation API.

Time spent: **12** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] Users open the app to a TranslationMe home page with a place to enter a word, phrase or sentence, a button to translate, and another field that should initially be empty
- [x] When users tap translate, the word written in the upper field translates in the lower field. The requirement is only that you can translate from one language to another.
- [x] A history of translations can be stored (in a scroll view in the same screen, or a new screen)
- [x] The history of translations can be erased
 
The following **optional** features are implemented:

- [x] Add a variety of choices for the languages
- [x] Add UI flair

The following **additional** features are implemented:

- [x] Anonymous Firebase Authentication (users are signed in automatically)
- [x] Realtime Firestore updates for translation history
- [x] Offline retry option if translation fails
- [x] Smooth SwiftUI layout transitions and Observation API integration

## Video Walkthrough
<div>
    <a href="https://www.loom.com/share/9a29aa43253f4644aea86b0ae11c482d">
    </a>
    <a href="https://www.loom.com/share/9a29aa43253f4644aea86b0ae11c482d">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/9a29aa43253f4644aea86b0ae11c482d-26f34bfd470cad2a-full-play.gif#t=0.1">
    </a>
  </div>

## Notes

Challenges encountered:
- Debugging Firebase initialization issues (required calling FirebaseApp.configure() early)
- Handling Observation API changes in Swift 5.9 (replacing EnvironmentObject usage)
- Fixing simulator “Preparing…” hang caused by offline Firebase Auth

## License

    Copyright 2025 Rezwan Mahmud

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
