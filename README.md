[![Build Status](https://secure.travis-ci.org/intuit/aws-alert-monitor.png)](http://travis-ci.org/intuit/aws-alert-monitor)

## AWS Alert Monitor

AWS Alert Monitor listenting to an SQS queue for alarms and sends email via SES based on rules applied in ~/.aws-alert-monitor.yml to those alerts.

## Installation
```
gem install aws-alert-monitor
```

## Usage

Add ~/.aws-alert-monitor.yml with the following syntax:

```
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
```
cloudwatch:$metric_namespace-$metric_name
```

For example:
```
cloudwatch:AWS/SQS-ApproximateNumberOfMessagesVisible
```

#### Unknown
If a message does not match one of the above types, then it will be classified as unknown.

You can control the notification of these messages with:
```
unknown
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
