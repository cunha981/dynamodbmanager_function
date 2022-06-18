from __future__ import print_function

import boto3
import json

print('Loading function')

def respond(err, res=None):
    return {
        'statusCode': '400' if err else '200',
        'body': str(err) if err else json.dumps(res),
        'headers': {
            'Content-Type': 'application/json',
        },
    }


def lambda_handler(event, context):
    print("Received event: " + str(event))

    body = json.loads(event['body'])
    operation = body['operation']

    dynamo = boto3.resource('dynamodb', region_name='us-east-1').Table('anything')

    operations = {
        'create': lambda x: dynamo.put_item(**x),
        'read': lambda x: dynamo.get_item(**x),
        'update': lambda x: dynamo.update_item(**x),
        'delete': lambda x: dynamo.delete_item(**x),
        'list': lambda x: dynamo.scan(**x)
    }

    if operation in operations:
        try:
            return respond(None, operations[operation](body.get('payload')))
        except Exception as e:
            return respond(e)
    else:
        raise ValueError('Unrecognized operation "{}"'.format(operation))