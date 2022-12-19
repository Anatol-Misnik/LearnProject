![autotest status badge](https://github.com/awst-global/qa-feature-tests/actions/workflows/engine.yml/badge.svg?branch=master)
![autotest status badge](https://github.com/awst-global/qa-feature-tests/actions/workflows/storefront.yml/badge.svg?branch=master)

## Behavioral/Feature
Behavioral tests are run against infrastructure that is defined in docker-compose.yml
Client library `./clients` is tested `indirectly`, blackboxed. 


## Architecture
### Root of the project
Here lays everything, that is needed to run whole repository with all of its features.

### ./clients
Client implementation ideally will be imported from AWSt repository.
Its intended usage is implementing testing clients for various microservices, e.g. awst-engine.

## Configuration
To run those test you first need to copy data from .env.dist to .env in project root and fill it with proper data:
- `AE_ENDPOINT` - this value is fine as it is
- `AUTH0_CLIENT` - ID of Auth0 application used to retrieve access tokens
- `AUTH0_CLIENT_SECRET` - Application secret can be found in Auth0 application configuration
- `AUTH0_CALLBACK_URL` - Callback URL that needs to be specified in Auth0 application callback URLs
- `ECDSA_SIGNING_KEY` - Signing key that will be used to provide X-Signature header to secured endpoints on AE. 
  Needed for V1 endpoints 
  [FinishSale, GetCollectionMerchant, CreateCollection, MintNFT, LockNFT, UnLockNFT]
- `STRIPE_COUNTRY_CODE` -> Fill this to change country phone code from  +48 (PL) GSMs that is used as default.
- `STRIPE_2FA_GSM` -> Fill this to receive the 2FA code from STRIPE to your mobile phone.
  
- `GODOG_MODE` env variable introduced in order to handle multiple testing methods.
  Options:
  - ENGINE_MODE (Default)
  - STOREFRONT_MODE
    Usage:
```
GODOG_MODE="STOREFRONT_MODE" godog run
```
- `AUTH0_BASE_EMAIL` - `youremail+%d@domain.com` %d will append the test suffix to the env when fresh suite will start from scratch to cover register flow.
- `AUTH0_PASSWORD` - password that will be used in registration flow
- `AUTH0_BASE_EMAIL_EXISTING` - this email should belong to existing account of merchant with KYC in testing (`staging`) environment to cover creating collection flow without initial registration
- `AUTH0_PASSWORD_EXISTING` - password that will be used in creating collection flow
- `UTILITY_CODE_LIMITED_REDEMTION` - utility code that is used inside url link for redeeming benefit once (available only on `dev` env)
- `UTILITY_CODE_UNLIMITED_REDEMTION` - utility code that is used inside url link for unlimited redeeming benefit (available only on `dev` env)
- `ACCESS_TOKEN` [For Automation Purpose] - token that will be used in testing flow (should be either empty or generated and retrieved manually with help of `cmd/auth0/jwt/auth0_jwt.go`)

### Testing the Claims
System is based on AUTH0 claims which that are inserted into JWT token. In order to have proper access tokens you must
login into Auth0 with particular roles. How to achieve that?
- Collector -> Create new account in Storefront, and login into the Storefront, that's it.
- Merchant without KYC -> After receiving Collector role, go to `Onboarding` button and fill everything from Auth0 until you are redirected and you see KYC button.
- Merchant with KYC -> After becoming merchant without KYC hit KYC and complete the process, after this you are full-merchant.

You can find information regarding filling those values in official Auth0 documentation here:
- About [applications](https://auth0.com/docs/get-started/applications) in Auth0
- [Client credentials](https://auth0.com/docs/get-started/applications/application-settings#basic-information)


## Run
Before running tests, [please check all requirements](#Requirements) and [configuration](#Configuration)

There are 2 available options to run tests.

Run all tests:
- `go run cmd/auth0/jwt/auth0_jwt.go` and `godog run` in project root.
- `make all-tests`

Run tagged tests by typing: 
- `go run cmd/auth0/jwt/auth0_jwt.go` and `godog run -t @list_your_tags_here ./features/$CLIENT` in project root. 
- `make awst-engine-tests-tagged`

Remember, that you are able to run FE tests:
- `GODOG_MODE="STOREFRONT_MODE" godog run ./features/storefront -t @list_your_tags_here` (Check [configuration](#Configuration) for details and available modes)
- `make awst-storefront-tests` OR `make awst-storefront-tests-tagged`

To find relations between tags and features take a look into files in subdirectories in [`features`](./features).
Supported clients:
- [`ENGINE`](features/engine)
- [`STOREFRONT`](features/storefront)

### Requirements
#### Go get
`GOPRIVATE=github.com/awst-global go get -u github.com/awst-global/awst-engine`

#### Godog install
`go install github.com/cucumber/godog/cmd/godog@latest`

#### ENV
1. Fill env file with proper configuration parameters: [configuration](#Configuration)
2. COPY .env.dist to .env file and fill it with proper data: `cp .env.dist .env`

#### PlayWright
This module intention is to test the e2e flow with web driver. Under .env `AUTH0_BASE_EMAIL` you should add email in this format:
`youremail+%d@domain.com`
It will add data to %s based on the suite after, so you will be able to differentiate between accounts that were registered.

#### Automation
This module starts ...
22
