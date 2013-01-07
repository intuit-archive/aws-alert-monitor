require 'spec_helper'

describe AwsAlertMonitor::Alert do
  before do
    @message = "{\n  \"Type\" : \"Notification\",\n  \"MessageId\" : \"3c784ce1-22ec-5eec-9040-05d0b0c63fb8\",\n  \"TopicArn\" : \"arn:aws:sns:us-west-1:187130254137:lc-pod-2-qa-1-app-1-SnsTopic-A2LI3FXD37V1\",\n  \"Subject\" : \"Auto Scaling: launch for group \\\"lc-pod-2-qa-1-app-1-Instances-XCYGCEQC0H02\\\"\",\n  \"Message\" : \"{\\\"StatusCode\\\":\\\"InProgress\\\",\\\"Service\\\":\\\"AWS Auto Scaling\\\",\\\"AutoScalingGroupName\\\":\\\"lc-pod-2-qa-1-app-1-Instances-XCYGCEQC0H02\\\",\\\"Description\\\":\\\"Launching a new EC2 instance: i-d6a2cb8f\\\",\\\"ActivityId\\\":\\\"840ac52b-36a7-419f-8378-f29bc8d477e8\\\",\\\"Event\\\":\\\"autoscaling:EC2_INSTANCE_LAUNCH\\\",\\\"Details\\\":{},\\\"AutoScalingGroupARN\\\":\\\"arn:aws:autoscaling:us-west-1:187130254137:autoScalingGroup:c96912e4-0633-4e9b-8060-f0a92b1f4fb1:autoScalingGroupName/lc-pod-2-qa-1-app-1-Instances-XCYGCEQC0H02\\\",\\\"Progress\\\":50,\\\"Time\\\":\\\"2012-11-29T16:40:10.204Z\\\",\\\"AccountId\\\":\\\"187130254137\\\",\\\"RequestId\\\":\\\"840ac52b-36a7-419f-8378-f29bc8d477e8\\\",\\\"StatusMessage\\\":\\\"\\\",\\\"EndTime\\\":\\\"2012-11-29T16:40:10.204Z\\\",\\\"EC2InstanceId\\\":\\\"i-d6a2cb8f\\\",\\\"StartTime\\\":\\\"2012-11-29T16:39:05.602Z\\\",\\\"Cause\\\":\\\"At 2012-11-29T16:39:05Z an instance was started in response to a difference between desired and actual capacity, increasing the capacity from 0 to 1.\\\"}\",\n  \"Timestamp\" : \"2012-11-29T16:40:10.246Z\",\n  \"SignatureVersion\" : \"1\",\n  \"Signature\" : \"vVWFMUbWyfBSfo8vPCBDdrdXB1ocGZz+n4cO4FEIoczOTHgrcNY8tqYLojlTQuQZCdk7f5qPI1XJxfGS1NIs2LmsBq6oEow2qXrBQlvUXxUDMIvoWoqj6a+yjM4ICbmStdlcFVREW/0u/YO7l/se5q6KUqol4q6Vb+c+xohwR78=\",\n  \"SigningCertURL\" : \"https://sns.us-west-1.amazonaws.com/SimpleNotificationService-f3ecfb7224c7233fe7bb5f59f96de52f.pem\",\n  \"UnsubscribeURL\" : \"https://sns.us-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-west-1:187130254137:lc-pod-2-qa-1-app-1-SnsTopic-A2LI3FXD37V1:1e723d7a-abf4-46a7-b73e-d6d3d3a90959\"\n}"
    @options = {:name => 'test app', :message=>@message, :events=>{"autoscaling:EC2_INSTANCE_LAUNCH"=>{"email"=>{"source"=>"brett_weaver@intuit.com", "destination"=>"brett_weaver@intuit.com"}}}}
    @logger_stub = stub 'logger', :debug => true,
                                  :info  => true,
                                  :error => true
    @config_stub = stub 'config', :logger => @logger_stub
    @ses_mock = mock 'ses'
    AwsAlertMonitor::AWS::SES.stub :new => @ses_mock
    AwsAlertMonitor::Config.stub :new => @config_stub
    @alert = AwsAlertMonitor::Alert.new :config => @config_stub
  end

  it "should process the given message against known events" do
    @ses_mock.should_receive(:send_email)
             .with({:source=>"brett_weaver@intuit.com", :destination=>{:to_addresses=>["brett_weaver@intuit.com"]}, :message=>{:subject=>{:data=>"Alert: Auto Scaling: launch for group \"lc-pod-2-qa-1-app-1-Instances-XCYGCEQC0H02\""}, :body=>{:text=>{:data=>"test app received alert: \n\n Launching a new EC2 instance: i-d6a2cb8f \n\n At 2012-11-29T16:39:05Z an instance was started in response to a difference between desired and actual capacity, increasing the capacity from 0 to 1."}}}})
    @alert.process @options
  end

  it "should return false if the given message is invalid JSON" do
    @ses_mock.should_receive(:send_email).never
    @options[:message] = 'invalid stuff'
    @alert.process(@options).should be_false
  end

  it "should not send the message if the destination is nil" do
    @ses_mock.should_receive(:send_email).never
    @options = {:name => 'test app', :message=>@message, :events=>{"autoscaling:EC2_INSTANCE_LAUNCH"=>{"email"=>{"source"=>"brett_weaver@intuit.com"}}}}
    @alert.process(@options).should be_true
  end

end
