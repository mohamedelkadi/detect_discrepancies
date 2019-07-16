# DetectDiscrepancies

The Service is implemented as ruby gem because gem can have similar structure to the described in the task and also it's  easier to be added to rails app if needed. 
      
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'detect_discrepancies'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install detect_discrepancies

## Usage

The gem expose one method `call` in the main module DetectDiscrepancies 

```
DetectDiscrepancies.call(local_campaign:, remote_api_url:)

# local_campaign: is array of Campaign model objects (ex: Campaign.where(job_id: 1).to_a)

# remote_api_url: is the url to the remote campaign api as the provided in the example
```
**output format**
 the same as suggested but one more case is introduced when there is no ad has the required remote_reference
 ```
           {
             'remote_reference': '2',
             'error': 'Not exist'
           }
 ```
 
## Internals 

**files structure:**
```
├── lib
│   ├── detect_discrepancies
│   │   ├── detect_campaign_discrepancies.rb
│   │   ├── detect_single_ad_discrepancies.rb
│   │   ├── remote_campaign.rb
│   │   └── version.rb
│   └── detect_discrepancies.rb
```

**Errors**

`DetectDiscrepancies::ServiceNotAvailable` : this error is raised when the remote api does not return success code. it raised to be handled from the higher level. as an example retrying the call after a while when this error is raised

## Testing      

**running specs**
`bundle exec rspec` can be used to run all the specs 

**notes**
- webmock gem is used to mock the calls to external api.
- every class has it's own specs that test it in isolation from the other classes and doubles are used to mock the dependencies 
- the tests for `DetectDiscrepancies.call` method mocks only the external http api and test the real code and the interactions between all the components   