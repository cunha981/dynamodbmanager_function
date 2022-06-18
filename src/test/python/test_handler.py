import unittest
import boto3
import json
from moto import mock_dynamodb2
import src.main.python.main as main

class MyTest(unittest.TestCase):
  
    @mock_dynamodb2
    def test_write_into_table(self):
        "Test the write_into_table with a valid input data"
        dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
        table_name = 'anything'
        table = dynamodb.create_table(
            TableName = table_name, 
            KeySchema = [{'AttributeName': 'id', 'KeyType': 'HASH'}],
            AttributeDefinitions = [{'AttributeName': 'id', 'AttributeType': 'S'}],
            ProvisionedThroughput={'ReadCapacityUnits': 10,'WriteCapacityUnits': 10})
            
        event = {
            "body": {
                "operation": "create",
                "payload": {
                    "Item": {"id": "1", "organization": "Test"}
                }
            }
        }
        event["body"] = json.dumps(event["body"])
       
        main.lambda_handler(event, None)

        response = table.get_item(Key={'id': '1'})
        actual_output = response["Item"]["organization"]
        self.assertEqual(actual_output, 'Test')