# AcmeTrading
A mobile application demo

![acme-corp](https://github.com/jw0451/AcmeTrading/blob/main/AcmeDemo.gif)

This gif demonstrates the happy path of logging in, viewing a list of profiles and logging out. Password entry is obscured due to secure entry field handling.

## Testing

I haven't implemented a full suite of tests for this. An example set of tests were made for the login process. The response parser is tested with the example response json, and all expected responses are tested with the APIService.

There is a basic UI test implemented that goes through the happy path of the app.

## Design Notes

The Register button should be moved below the "don't have an account?" test and enlarged for bettter accessibility. 

In addition to the error box, I would highlight the offending text field in a red outline to better pinpoint where to address the issue. For an authorisation issue, both boxes would be highlighted.

While it was popular in the past, the hamburger menu design pattern is no longer widely used in iOS because many find it confusing or counter-intuitive as a navigation flow. [This article](https://medium.muz.li/3-good-reason-why-you-might-want-to-remove-that-hamburger-menu-from-your-product-69b9499ba7e2) does a good job of explaining some of the issues. I've instead used an action sheet to present users with the ability to log out.

## Extras

I added a drag to refresh to the profile list.
Selecting a test field on the login page will scroll the view up to account for keyboard height. I added a log out action to return to the login page.

## Room for improvement

I didn't build out all the tests in the interest of time. I also haven't check to see if the textfield will be covered by the keyboard before scrolling up.
