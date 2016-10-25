# Project 2 - *YelpSearch*

**YelpSearch** is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: **12** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height.
   - [x] Custom cells should have the proper Auto Layout constraints.
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] You can use the default UISwitch for on/off states.
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

The following **optional** features are implemented:

- [ ] Search results page
   - [ ] Infinite scroll for restaurant results.
   - [ ] Implement map view of restaurant results.
- [ ] Filter page
   - [ ] Implement a custom switch instead of the default UISwitch.
   - [ ] Distance filter should expand as in the real Yelp app
   - [ ] Categories should show a subset of the full list with a "See All" row to expand. Category list is [here](http://www.yelp.com/developers/documentation/category_list).
- [ ] Implement the restaurant detail page.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Better ways to implement Filter data. As you can see, I mocked all data, and some parts are actually redundant, but wasn't able to put more time on researching and refactoring it.
2. Using radio button in Filter view. I used radio button for all filterCells, but it would have been better if `Distance` and `Sort By` rows were in radio button, because it doesn't make sense to select multiple distance options for filtering.
3. Expandable table view. I wasn't able to implement optional features, but I'd love to learn how to implement expandable table view.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='Yelp_demo.gif' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

- AutoLayout was interesting. In Android, it has multiple layout types that allows developers to organize UI components, and it’s very quick and easy to set up. It might be because I’m used to Android and new to iOS, but with AutoLayout, it took more time, and it seems like it might hard to refactor the UI components in the future if there’s any requirement changes. 
- For me, sectioned tableview was the most difficult/tricky part in this assignment. I was following instructions in tutorial page, but for some reason `numberOfSections` method was not being called. I wasn’t sure if it was swift 3 syntax issue or if I was missing something that made callback doesn’t get invoked, but it turned out I need to put `in` in parameter definition.
- Delegate pattern was cool. It feels very similar to interface and callback methods in Java. I wasn’t able to decouple my delegate logics in different classes or modules, but saw some good examples while I was googling it, and I look forward to learning more about it.
- Thanks for providing great walkthrough videos and tutorials, it really helped me to pick things up quickly and was able to learn a lot in short amount of time.

## License

    Copyright 2016 Nari Shin

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
