##  Ben Brouhard
#Script to check sandbox and shutdown all EC2 and Send email. 

import json
import boto3
ec2 = boto3.resource('ec2')
client = boto3.client('ses')




BODY_HTML=""
Subject_Email="AWS Sandbox EC2 Status Report"
EmailAddress="brouhard@un.org"
vmcount = 0



#power off running EC2
stoppedvms=[]
instances = ec2.instances.filter(
    Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
for instance in instances:
    instanceid=instance.id
    print("checking:",instance.id, instance.instance_type)
    print("\nstopping ", instanceid)
    #print(instanceid )
    #ec2.instances.filter(InstanceIds=[instanceid]).stop()
    #stoppedvms.append(instanceid)
    vmcount +=1


### Get list of all EC2s
for instance in ec2.instances.all():
     print(
     "Id: {0}\nPlatform: {1}\nType: {2}\nPublic IPv4: {3}\nAMI: {4}\nState: {5}\n\n".format(
     instance.id, instance.platform, instance.instance_type, instance.public_ip_address, instance.image.id, instance.state
        )
     )
     BODY_HTML+=("<b>Id:</b> {0} <brPlatform: {1} <br>Type: {2} <br>Public IPv4: {3} <br>AMI: {4}<br> State: {5}<p>".format(
     instance.id, instance.platform, instance.instance_type, instance.public_ip_address, instance.image.id, instance.state
        )
     )
if vmcount >= 1:
    #send Email
    response = client.send_email(
        Destination={
        # 'BccAddresses': [
        # ],
        # 'CcAddresses': [
            
        # ],
        'ToAddresses': [EmailAddress]
        },
        Message={
            'Body': {
                'Html': {
                    'Charset': 'UTF-8',
                    'Data':BODY_HTML,
                },
                'Text': {
                    'Charset': 'UTF-8',
                    'Data': BODY_HTML,
                },
            },
            'Subject': {
                'Charset': 'UTF-8',
                'Data': Subject_Email,
            },
        },
        Source=EmailAddress,
    
    )

print(vmcount)

# response = client.send_raw_email(
#     Destinations=[
#     ],
#     FromArn='',
#     RawMessage={
#         'Data': 'From: brouhard@un.org\nTo: brouhard@un.org\nSubject: Lambda Shutdown Function \nMIME-Version: 1.0\nContent-type: Multipart/Mixed; boundary="NextPart"\n\n--NextPart\nContent-Type: text/plain\n\nThis is the message body.', stoppedvms,'\n\n--NextPart\nContent-Type: text/plain;\nContent-Disposition: attachment; filename="attachment.txt"\n\nThis is the text in the attachment.\n\n--NextPart--',
#     },
# #    ReturnPathArn='',
# #    Source='',
# #    SourceArn='',
# )

# print(response)

#comment added from cloud9

def lambda_handler(event, context):
 

     return {
        'statusCode': 200,
        'body': print(instance)
    }
