[![Build Status](https://secure.travis-ci.org/intuit/aws-alert-monitor.png)](http://travis-ci.org/intuit/aws-alert-monitor)

## AWS Alert Monitor

AWS Alert Monitor listenting to an SQS queue for alarms and sends email via SES based on rules applied in ~/.aws-alert-monitor.yml to those alerts.

## Installation
```text
gem install aws-alert-monitor
```

## Usage

Add ~/.aws-alert-monitor.yml with the following syntax:

```yaml
app1:
  access_key: Key
  secret_key: Secret
  sqs_endpoint: https://sqs.us-west-1.amazonaws.com/123456789012/app1
  events:
    'autoscaling:EC2_INSTANCE_LAUNCH':
      email:
        source: admin@example.com
        destination: user@escalation.com
    'autoscaling:EC2_INSTANCE_TERMINATE':
      email:
        source: admin@example.com
        destination: problem@escalation.com
app2:
  access_key: Key
  secret_key: Secret
  sqs_endpoint: https://sqs.us-west-1.amazonaws.com/123456789012/app2
  events:
    'autoscaling:EC2_INSTANCE_FAILED_LAUNCH':
      email:
        source: admin@example.com
        destination: user@escalation.com
```

### Supported Event Types
Currently, this gem supports the following event types:

#### Auto Scaling
* autoscaling:EC2_INSTANCE_LAUNCH
* autoscaling:EC2_INSTANCE_LAUNCH_ERROR
* autoscaling:EC2_INSTANCE_TERMINATE
* autoscaling:EC2_INSTANCE_TERMINATE_ERROR

#### CloudWatch
Cloud watch support is somewhat generic. The event pattern is:
```text
cloudwatch:$metric_namespace-$metric_name
```

For example:
```text
cloudwatch:AWS/SQS-ApproximateNumberOfMessagesVisible
```

#### Process Down
There is basic support for reporting that a process is not running.

The event type for this is `process_down`.

The schema for this type of event is:
```json
{
  "Subject": "process_down",
  "Message": "{ \"body\": \"Your message about process down\", \"created_at\": \"2013-04-03T20:30:36Z\", \"process\": \"httpd\", \"required_count\": 5, \"running_count\": 2, \"environment\": \"dev\", \"host\": \"wwwdev1.example.com\"}"
}
```

Unfortunately that is JSON inside JSON (as that is what AWS sends in many of their messages).


#### Unknown
If a message does not match one of the above types, then it will be classified as unknown.

You can control the notification of these messages with:
```text
unknown
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
