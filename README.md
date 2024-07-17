# settle

Date: 22nd August, 2023

    - Implemented Dark / Light Mode 
    - Created App Theme
    - Updated previous Screens to match Theme
    - Created Login UI

Date: 23rd August, 2023

    - Created Forgot Password UI
    - Created Reset Password UI
    - Created OTP Verification UI

Date 25th August, 2023

    - updated login to include login using fingerprint
    - Fixed Navigation buttons
    - Created Select account type onboard page for personal & individual account registration
    - created step 1 for business account
    - created step 2 for business account.

Date 26th August, 2023

    - Fixed Splash Screen Displaying twice and added "by insolify" to the splashscreen footer
    - Fixed Sign up link not working on login page
    - Enabled password visibility toggle for sign in page
    - Implemented Email / Phone Number toggle for sign in page
    - Reordered input fields for Step 1 business signup and included password section
    - implemented email, phone number toggle for forgot password page
    - fixed max length for email and phone verification codes input field.

Date 27th August, 2023

    - Implemented phone codes selection for phone number input on forgot password page
    - implemented client side form validation for forgot password page
    - Implemented phone codes selection for phone number input on sign in page
    - implemented client side form validation for sign in page
    - implemented phone codes selection for phone number input on step 1 create business account
    - implemented client side validation on step 1 create business account & step 2

Date 28th August, 2023

    - Implemented Business Account step 3 sign up and client side validation
    - Implemented Personal Account Step 1 Sign up and client side validation
    - implemented Personal Account Step 2 Sign up and client side validation

Date 30th August, 2023

    - fixed change color of all placeholder texts to reduce contrast
    - fixed #Personal account
        - change fields to: 
        PAGE 1
            => Phone number
            => Fullname
            => Gender (Select gender, Female, Male, Rather not say) (align field to left)
                (!gender field should have none selected by default. use "Select" as default)
            => Password
            => Confirm password (!remove toggle)
    - fixed PAGE 2
            => Phone verification code (!inset button should have the text SEND CODE, remove the send icon)
                (!remove email verification code).
    - fixed #Business account
        - change fields to:
        PAGE 1
            => Phone number
            => Business name
            => Business type
            => Password
            => Confirm password (!remove toggle)
        PAGE 2
            => Phone verification code (!inset button should have the text SEND CODE instead, remove the send icon)
                (!remove email verification code)
        PAGE 3
            => (!fix layout- select field for business identification is overflowing)
            => (!fix styling for the fields, Country, State, City)
            => (!field for file select should match others)

    - fixed SIGN IN

        - change the "Already have an account" text to "Don't have an account yet?"

Date 31st August, 2023

    - Complete Personal account sign up and client side validtion for Step 3, 4 and 5
    - removed toggle for forgot password page
    - removed toggle for sign in page
    - updated typo errors and styling
    - update welcome slides and onboarding page dummy text
    - updated welcome slides images
    
Date 2nd September, 2023

    - Created overall Dashboard UI
    - Created General Account settings page
    - created fund account page

Date 4th September, 2023

    - Made Corrections to Welcome screen 1
    - Fixed D.O.B validation Logic
    - Corrected Typo error on Personal registration step 3
    - created dummy data for preview on transactions layout
    - created contact us page with form. 

Date 5th September, 2023

    - Created View all added Cards Screen
    - Created modal for add new cards
    - Created Account profile page

Date 6th September, 2023

    - fixed change section anchor texts to "All", "Transfers", "Deposits" instead.

    - fixed Fund account popup menu should follow dashboard theme.

    - fixed change Contact form button text from "Proceed" to "Submt"

    - fixed Cards page: fix bottom overflow

    - fixed Use sentence case for all menu options. Eg. Cards, Download transactions, Contact us....

    - Created a send money page.
   
Date 7th September, 2023

    - fixed select field heights and border radius
    - update personal account registration step_one DOB validation
    - updated change personal account field stages as follow
    - updated business account field stages and steps
    - removed fund account button from dashboard
    - added complete verification notification/button to dashboard

Date 8th September, 2023 

    -  Updated Dashboard screen and added toggle for total transactions
    -  Added date range for transactions alongside dummy data
    -  added preview for each transaction selected
    -  updated business account verification from account settings.

Date 11th September, 2023

    - Updated Spash screen

    - Updated Personal account signup step 1
        * Add 'State/Region' field after Country field before Address
        * Make password field visible initially

    - Updated Business signup step 1
        * Add 'State/Region' field after Country field before Address
        * make password field visible initially
        * Add the following fields beneath password field
            - Select business identfication document
            - Upload business identfication document

    - Updated Forgot password
        * step 2 - Add the following fields:
            - Email verification code 
            - New password
            - Verify password
    - Fixed Make the dashboard header card 
    - Fixed transaction list overflowing 
    - Updated Transaction Preview Pane to include download receipt

Date 13th September, 2023

    - included notifications page to menu, with red-dot hint 
    - created dummy data for notifications page
    - fixed date range picker for transaction history.

Date 15th September, 2023

    - Fixed Transactio Range style on dashboard
    - Added  page for business owner information
    - Fixed select currency, select bank and select operator not working on send money page
    - added red dot int to dashboard notifications
    - fixed error showing after selecting country on personal account sign up

Date 13th October, 2023

    - Fixed
       # Create Personal account
         Date picker color (dark theme)

       # Create Business account

          # Reorder steps
            - Business info page
            --- Business name
            --- Business identification document

            - Business Owner page
            --- Phone number
            --- Fullname
            --- Date of birth
            --- Country
            --- State/Region
            --- Address
            --- Password
            - Phone verification

       # Forgot Password
            - Remove phone code

       # Dashboard
            -  Transaction date range pickers display.
            -  'Complete verification' notification linked to the signup completion page.
            -  Hint (red dot) does not look the same with that on the Menu icon.

Date 17th October, 2023

        - Implemented Biometrics Authentication
        - updated Notifications display screen
        - Updated account settings screen
        - implemeted device notifications

Date 19th October, 2023

        - Implemented Multi language selection alongside ltr for arabic


Date 18th January, 2024

        - implemented Forgot password Endpoint
        - implemented send OTP for reset password 
        - implemented resend OTP for reset password 
        - implemented send otp for registration confirmation
        - implemented resend otp for registration confirmation
        - implemented cities fetch for personal account registration
        - implemented cities fetch for business account registration
        - fixed fetch all transactions on dashboard screen
        - implemented funds transfer screen and account number validation for funds transfer.
        
Date 24th January, 2024

        - Fixed Enable and disable User Authentication Using Biometrics.
        - Implemented User Logout.
        - Fixed disable welcome slides on app launch after user has logged in for first time
        - Updated Contact Us Screen
        - Updated activity indicator on Network request.

Dated 26th January, 2024

        - Updated Activity Indicator Display
        - Updated Dropdown display to include Select option Field.




    


